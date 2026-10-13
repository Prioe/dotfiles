// Places the first window of each autostart app according to X-Placement-* keys:
//
//   X-Placement-Monitor=DP-2              connector name of the target monitor
//   X-Placement-Rect=0,0,1,0.3333         x,y,w,h as fractions of the monitor work area
//   X-Placement-Match=crx_foo;brave-foo   optional extra window classes / app ids to match
//
// Windows are matched (case-insensitive) against StartupWMClass, the desktop file name and
// X-Placement-Match. Gaps are taken from Tiling Shell so windows line up with its tiles.

import GLib from "gi://GLib";
import Gio from "gi://Gio";
import Meta from "gi://Meta";
import Shell from "gi://Shell";
import St from "gi://St";

import { Extension } from "resource:///org/gnome/shell/extensions/extension.js";

const GROUP = "Desktop Entry";
const TILING_SHELL_SCHEMA = "org.gnome.shell.extensions.tilingshell";
// Electron and Firefox apply their own saved geometry shortly after mapping.
const REAPPLY_DELAYS_MS = [250, 1000];

// Module scope survives disable/enable (e.g. screen lock), so apps are only placed once per session.
const placed = new Set();

function loadRules() {
  const dir = GLib.build_filenamev([GLib.get_user_config_dir(), "autostart"]);
  let names;
  try {
    names = GLib.Dir.open(dir, 0);
  } catch {
    return [];
  }

  const rules = [];
  let name;
  while ((name = names.read_name()) !== null) {
    if (!name.endsWith(".desktop")) continue;

    const file = new GLib.KeyFile();
    try {
      file.load_from_file(GLib.build_filenamev([dir, name]), GLib.KeyFileFlags.NONE);
    } catch (e) {
      console.warn(`autoplace: failed to read ${name}: ${e.message}`);
      continue;
    }

    const get = (key) => {
      try {
        return file.get_string(GROUP, key).trim();
      } catch {
        return null;
      }
    };

    const monitor = get("X-Placement-Monitor");
    const rect = get("X-Placement-Rect")?.split(",").map(Number);
    if (!monitor || !rect) continue;
    if (get("Hidden") === "true" || get("X-GNOME-Autostart-enabled") === "false") continue;
    if (rect.length !== 4 || rect.some(Number.isNaN)) {
      console.warn(`autoplace: invalid X-Placement-Rect in ${name}`);
      continue;
    }

    const ids = [name.replace(/\.desktop$/, ""), get("StartupWMClass"), ...(get("X-Placement-Match") ?? "").split(";")];
    rules.push({
      id: name,
      ids: new Set(ids.filter(Boolean).map((id) => id.toLowerCase())),
      monitor,
      rect: { x: rect[0], y: rect[1], width: rect[2], height: rect[3] },
    });
  }
  names.close();
  return rules;
}

function loadGaps() {
  const source = Gio.SettingsSchemaSource.get_default();
  if (!source.lookup(TILING_SHELL_SCHEMA, true)) return { inner: 0, outer: 0 };

  const settings = new Gio.Settings({ schema_id: TILING_SHELL_SCHEMA });
  return { inner: settings.get_uint("inner-gaps"), outer: settings.get_uint("outer-gaps") };
}

function windowIds(win) {
  const app = Shell.WindowTracker.get_default().get_window_app(win);
  return [
    win.get_wm_class(),
    win.get_wm_class_instance(),
    win.get_gtk_application_id(),
    win.get_sandboxed_app_id(),
    app?.get_id()?.replace(/\.desktop$/, ""),
  ]
    .filter(Boolean)
    .map((id) => id.toLowerCase());
}

// Same geometry as Tiling Shell: outer gaps on work area borders, half inner gaps between tiles.
function targetRect(rule, monitorIndex, gaps) {
  const area = global.workspace_manager.get_active_workspace().get_work_area_for_monitor(monitorIndex);
  const scale = St.ThemeContext.get_for_stage(global.stage).scale_factor;
  const { rect } = rule;
  const eps = 0.001;
  const margin = (onBorder) => (onBorder ? gaps.outer : gaps.inner / 2) * scale;

  const top = margin(rect.y < eps);
  const left = margin(rect.x < eps);
  const bottom = margin(rect.y + rect.height > 1 - eps);
  const right = margin(rect.x + rect.width > 1 - eps);

  const x = Math.round(area.x + area.width * rect.x);
  const y = Math.round(area.y + area.height * rect.y);
  const width = Math.round(area.width * rect.width);
  const height = Math.round(area.height * rect.height);
  return {
    x: x + left,
    y: y + top,
    width: width - left - right,
    height: height - top - bottom,
  };
}

export default class AutoplaceExtension extends Extension {
  enable() {
    this._rules = loadRules();
    this._gaps = loadGaps();
    this._pending = new Map();
    this._timeouts = new Set();
    this._windowCreatedId = global.display.connect("window-created", (_display, win) => this._onWindowCreated(win));
  }

  disable() {
    global.display.disconnect(this._windowCreatedId);
    for (const [actor, id] of this._pending) actor.disconnect(id);
    for (const id of this._timeouts) GLib.source_remove(id);
    this._rules = this._gaps = this._pending = this._timeouts = null;
  }

  _onWindowCreated(win) {
    if (this._rules.every((rule) => placed.has(rule.id))) return;

    const actor = win.get_compositor_private();
    if (!actor) return;

    // Wait for the first frame so the app id is set and the window has its initial size.
    const id = actor.connect("first-frame", () => {
      actor.disconnect(id);
      this._pending.delete(actor);
      this._onFirstFrame(win);
    });
    this._pending.set(actor, id);
    actor.connect("destroy", () => this._pending?.delete(actor));
  }

  _onFirstFrame(win) {
    // Skip dialogs and splash screens (e.g. the Discord updater) without consuming the rule.
    if (win.get_window_type() !== Meta.WindowType.NORMAL || win.get_transient_for() || !win.allows_resize()) return;

    const ids = windowIds(win);
    const rule = this._rules.find((r) => !placed.has(r.id) && ids.some((id) => r.ids.has(id)));
    if (!rule) return;

    const monitorIndex = global.backend.get_monitor_manager().get_monitor_for_connector(rule.monitor);
    if (monitorIndex < 0) {
      console.warn(`autoplace: monitor ${rule.monitor} for ${rule.id} not found`);
      return;
    }

    placed.add(rule.id);
    this._place(win, rule, monitorIndex);
    for (const delay of REAPPLY_DELAYS_MS) {
      const timeoutId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, delay, () => {
        this._timeouts.delete(timeoutId);
        this._place(win, rule, monitorIndex);
        return GLib.SOURCE_REMOVE;
      });
      this._timeouts.add(timeoutId);
    }
  }

  _place(win, rule, monitorIndex) {
    if (!win.get_compositor_private()) return;

    if (win.is_fullscreen()) win.unmake_fullscreen();
    if (win.is_maximized()) win.unmaximize();

    if (win.get_monitor() !== monitorIndex) win.move_to_monitor(monitorIndex);

    const { x, y, width, height } = targetRect(rule, monitorIndex, this._gaps);
    win.move_resize_frame(true, x, y, width, height);
  }
}
