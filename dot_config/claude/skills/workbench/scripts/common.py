"""Helpers shared by the workbench scripts: git, herdr and session-name state."""

import json
import os
import re
import subprocess
from pathlib import Path

PLUGIN_ROOT = Path(__file__).resolve().parent.parent
CLAUDE_DIR = Path(os.environ.get("CLAUDE_CONFIG_DIR", "~/.claude")).expanduser()


class Fail(Exception):
    pass


def run(cmd: list[str], cwd: str | Path | None = None, check: bool = True, timeout: int = 60) -> subprocess.CompletedProcess:
    try:
        proc = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout)
    except FileNotFoundError:
        raise Fail(f"required command not found: {cmd[0]}")
    except subprocess.TimeoutExpired:
        raise Fail(f"{' '.join(cmd[:3])} timed out")
    if check and proc.returncode != 0:
        raise Fail(f"{' '.join(cmd[:3])} failed: {(proc.stderr or proc.stdout).strip()}")
    return proc


def herdr_bin() -> str:
    return os.environ.get("HERDR_BIN_PATH") or "herdr"


def herdr(*args: str, check: bool = True) -> dict:
    """Run a herdr command and return its result object; herdr reports errors as JSON on stderr."""
    proc = run([herdr_bin(), *args], check=False, timeout=120)
    for line in (proc.stdout + "\n" + proc.stderr).splitlines():
        try:
            data = json.loads(line)
        except ValueError:
            continue
        if data.get("error"):
            if check:
                raise Fail(f"herdr {' '.join(args[:2])}: {data['error'].get('message', data['error'])}")
            return {"error": data["error"]}
        if "result" in data:
            return data["result"]
    if check and proc.returncode != 0:
        raise Fail(f"herdr {' '.join(args[:2])} failed: {(proc.stderr or proc.stdout).strip()}")
    return {}


def current_workspace() -> dict | None:
    """The herdr workspace of this pane, or of the pane under a popup."""
    # A moved pane keeps its old HERDR_* values, but herdr still resolves its old pane id.
    pane_id = os.environ.get("HERDR_PANE_ID") or os.environ.get("HERDR_ACTIVE_PANE_ID")
    if os.environ.get("HERDR_ENV") != "1" or not pane_id:
        return None
    try:
        workspace_id = herdr("pane", "get", pane_id).get("pane", {}).get("workspace_id")
        spaces = herdr("workspace", "list").get("workspaces", [])
    except Fail:
        return None
    return next((ws for ws in spaces if ws.get("workspace_id") == workspace_id), None)


def parse_remote(url: str) -> tuple[str, str]:
    m = re.match(r"^(?:[a-z+]+://)?(?:[^@/]+@)?([^/:]+)(?::\d+)?[:/](.+?)(?:\.git)?/?$", url)
    return (m.group(1), m.group(2)) if m else ("", "")


def git(repo: str | Path, *args: str, check: bool = True) -> str:
    return run(["git", *args], cwd=repo, check=check).stdout.strip()


def repo_root(cwd: str | Path) -> Path | None:
    """The main checkout, also when cwd is inside a linked worktree."""
    proc = run(["git", "rev-parse", "--path-format=absolute", "--git-common-dir"], cwd=cwd, check=False)
    if proc.returncode != 0:
        return None
    path = Path(proc.stdout.strip())
    return path.parent if path.name == ".git" else path


def data_dir() -> Path:
    # Outside a hook CLAUDE_PLUGIN_DATA is unset; this is the path Claude Code gives the hook.
    path = Path(os.environ.get("CLAUDE_PLUGIN_DATA") or CLAUDE_DIR / "plugins/data/workbench-skills-dir")
    (path / "sessions").mkdir(parents=True, exist_ok=True)
    return path


def state_path(session_id: str) -> Path:
    return data_dir() / "sessions" / f"{session_id}.json"


def load_state(session_id: str) -> dict:
    try:
        return json.loads(state_path(session_id).read_text())
    except (OSError, ValueError):
        return {"turns": 0}


def save_state(session_id: str, state: dict) -> None:
    state_path(session_id).write_text(json.dumps(state))


# Claude Code's own placeholder names look like "chezmoi-f3".
DEFAULT_NAME = re.compile(r"^[a-z0-9._-]+-[0-9a-f]{2}$")


def registry_name() -> str | None:
    """The name of the Claude session this process runs in, if any."""
    registry = CLAUDE_DIR / "sessions" / f"{os.environ.get('CLAUDE_PID')}.json"
    try:
        return json.loads(registry.read_text()).get("name")
    except (OSError, ValueError):
        return None


def stable_session_name() -> str | None:
    """The calling session's name when auto-rename will not change it: pinned or set by hand."""
    name = registry_name()
    session_id = os.environ.get("CLAUDE_CODE_SESSION_ID")
    if not name or not session_id or DEFAULT_NAME.match(name):
        return None
    return None if load_state(session_id).get("last_name") == name else name
