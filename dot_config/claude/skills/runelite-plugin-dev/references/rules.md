# RuneLite Plugin Rules and Restrictions

Sources: RuneLite wiki "Rejected or Rolled Back Features", "Plugin Hub Review", example-plugin `AGENTS.md`, plugin-hub
packager `disallowed-apis.txt`, and Jagex's Third-Party Client Guidelines
(https://secure.runescape.com/m=news/third-party-client-guidelines?oldschool=1). Also check closed `wontfix`
issues/PRs on runelite/runelite.

**Rule of thumb from reviewers: if they cannot review every line your plugin executes, or cannot easily confirm it
is within the rules, it will not be merged.**

## Forbidden language features and APIs

- Non-Java JVM languages; anything beyond Java 11.
- Reflection, JNI/JNA, `Unsafe`/native memory, LWJGL direct access.
- Running external processes (`Process`, `ProcessBuilder`, `Runtime`).
- Downloading, generating or dynamically loading code; Java (de)serialization.
- `Desktop.open`, `Desktop.browse`, `LinkBrowser.open` (`LinkBrowser.browse` is fine).
- `Thread.sleep`, `Thread.interrupt`.
- `java.io` file APIs (use `Filepath`), `java.lang.Runtime`, `java.awt.KeyboardFocusManager`.
- Network clients other than the injected OkHttp; `new OkHttpClient()`, `new OkHttpClient.Builder()`.
- `new Gson()`, `new GsonBuilder()` (inject Gson, use `.newBuilder()`).
- `WidgetInfo`, `WidgetID` (use `InterfaceID` gamevals).
- `net.runelite` as your package.
- `Client.menuAction` (sole exception: collection log search toggle).

## Sensitive APIs (extra review on every change)

- Network IO.
- `Client.runScript` (scripts that send server actions throw by default).

Precedents (checked 2026-10): `client.runScript(ScriptID.UPDATE_SCROLLBAR, scrollbar, list, y)` to scroll a list
into view is used by core's ClueScrollPlugin and ~40 hub plugins (quest-helper, clue-details, bank-tag-layouts,
music plugins, ...). Other common hub uses: reading diary/CA data (dink, WikiSync), chatbox prompts
(inventory-setups). Highlighting world switcher rows via an overlay on its dynamic children: world-splitter.

## Restricted APIs (forces manual review, recommended not to use at all)

- `Client.hopToWorld`
- `Filepath.Unchecked`
- `ScriptEventBuilder.setCanSendPackets`

Hub plugins still using `hopToWorld` (runite-rocks, friend-finder, crab-scouter, forestry-spawn-helper, ...) were all
added before it became restricted on 2026-10-05 and are likely grandfathered; all trigger it from a single user click.

## Input and menus

- No injected mouse/keyboard events, no automation of any kind. One user action must map to at most one game action.
- No new menu entries that send actions to the server.
- No conditional menu entry removal based on NPC type, friend status, etc. (left/shift-click swaps are allowed).
- No autotyping into the chatbox, no modifying outgoing chat after send.

## Interface

- No unhiding hidden components (spec bar, minimap), no moving/resizing click zones (3D components, combat options,
  inventory, equipment, spellbook, prayer book), no spellbook resizing.
- No removing/making click-through the inventory background.
- No detached-camera world interaction. No camera yaw/pitch presets.
- No manipulating the OS window (focus, minimise).
- No manipulating the core RuneLite UI (other overlays/infoboxes, anchors, root frame, sidebar) or other plugins'
  configs.

## Boss, combat and minigames

Applies to bosses, raid sub-bosses, slayer bosses, demi-bosses and wave minigames:
no next-attack prediction, projectile landing indicators, prayer switch indicators, attack counters, automatic
stand/don't-stand indicators, extra visual/audio cues for mechanics (unless manually triggered), advance hazard
warnings, flinch helpers, prayer recommendations, NPC target identification, or content simulation.
New high-end PvM boss plugins are not accepted at all. Also: no AFK-agility abuse helpers, no Hallowed Sepulchre
trap prediction, no dynamic Puro-Puro spawns.

## PvP

No removing/deprioritising attack options, freeze timers, clan opponent identification, loot previews, opponent's
opponent, target scouting, group summaries, level-range highlighting, spell-target simplification, PK/skull warnings.

## Data and privacy

- No exposing player info over HTTP, no crowdsourcing data about other players (location, gear, names).
- No hiscores for data not on official hiscores (spoofable).
- No credential managers storing account credentials.
- Third-party server features: opt-in, with warning
  `"This feature submits your IP address to a 3rd-party server not controlled or verified by RuneLite developers"`,
  plus a `warning=` line in the plugin-hub manifest.
- No significant functionality behind paid external services (new plugins since 2026-10-14).

## Content

- No adult content; no plugins built entirely on player-provided IDs; no significant alteration of game assets;
  no Twitch/BTTV/FFZ/7TV emotes; no touchscreen/controller/mouse-keys plugins; no party auto-rejoin.
