#!/usr/bin/env bash
# Install the Claude Code config from one or more chezmoi source repos into a
# Claude Code cloud session (claude.ai/code), where chezmoi does not run.
#
# Usage: claude-cloud-install.sh [SOURCE_REPO...]
#   SOURCE_REPO  chezmoi source root(s) containing dot_config/claude/.
#                Later repos override earlier ones (e.g. dotfiles, then a work
#                layer). Default: the repo this script lives in.
#
# Files land in ~/.config/claude (same paths as locally, so skills that call
# ~/.config/claude/skills/... keep working) and are linked into ~/.claude,
# which is the config dir cloud sessions read. CLAUDE_CONFIG_DIR is left alone
# on purpose: the cloud harness owns ~/.claude.
#
# Env:
#   NOTES_DIR  notes checkout to link as ~/notes (default: /home/user/notes,
#              where cloud sessions clone the prioe/notes repo).
#
# Example environment setup script:
#   git clone --depth 1 https://github.com/Prioe/dotfiles /tmp/dotfiles
#   /tmp/dotfiles/tools/claude-cloud-install.sh /tmp/dotfiles
set -euo pipefail

log() { printf '\033[1;34m[claude-cloud]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[claude-cloud]\033[0m %s\n' "$*" >&2; }

if [[ $# -eq 0 ]]; then
	set -- "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

TARGET="$HOME/.config/claude"
CLAUDE_HOME="$HOME/.claude"
NOTES_DIR="${NOTES_DIR:-/home/user/notes}"

# Translate one chezmoi source path component to its target name.
# Prints nothing for components this script can't reproduce without chezmoi.
target_name() {
	local name="$1"
	case "$name" in
	create_* | modify_* | remove_* | symlink_* | run_* | encrypted_* | *.tmpl) return ;;
	esac
	local changed=1
	while ((changed)); do
		changed=0
		for prefix in exact_ private_ readonly_ empty_ executable_; do
			if [[ "$name" == "$prefix"* ]]; then
				name="${name#"$prefix"}"
				changed=1
			fi
		done
	done
	[[ "$name" == dot_* ]] && name=".${name#dot_}"
	printf '%s' "$name"
}

# Copy SRC/dot_config/claude into $TARGET, translating chezmoi attributes.
install_source() {
	local root="$1/dot_config/claude"
	if [[ ! -d "$root" ]]; then
		warn "skipping $1: no dot_config/claude"
		return
	fi
	log "installing from $1"
	local src rel out part name skipped
	while IFS= read -r -d '' src; do
		rel="${src#"$root"/}"
		out="$TARGET"
		skipped=0
		IFS=/ read -ra parts <<<"$rel"
		for part in "${parts[@]}"; do
			name="$(target_name "$part")"
			if [[ -z "$name" ]]; then
				skipped=1
				break
			fi
			out="$out/$name"
		done
		if ((skipped)); then
			warn "  skipped (needs chezmoi): $rel"
			continue
		fi
		mkdir -p "$(dirname "$out")"
		cp -f "$src" "$out"
		if [[ "${src##*/}" == *executable_* ]]; then
			chmod +x "$out"
		fi
	done < <(find "$root" -type f -print0)
}

# Link $TARGET/<entry> into $CLAUDE_HOME without clobbering harness files.
link_into_claude_home() {
	local src="$1" dest="$2"
	if [[ -e "$dest" && ! -L "$dest" ]]; then
		warn "  not linking $dest: exists and is not a symlink"
		return
	fi
	ln -sfn "$src" "$dest"
}

mkdir -p "$TARGET" "$CLAUDE_HOME/skills" "$CLAUDE_HOME/commands"

for repo in "$@"; do
	install_source "$repo"
done

shopt -s nullglob
for dir in "$TARGET"/skills/*/; do
	link_into_claude_home "${dir%/}" "$CLAUDE_HOME/skills/$(basename "$dir")"
done
for file in "$TARGET"/commands/*.md; do
	link_into_claude_home "$file" "$CLAUDE_HOME/commands/$(basename "$file")"
done
for file in "$TARGET"/CLAUDE*.md; do
	link_into_claude_home "$file" "$CLAUDE_HOME/$(basename "$file")"
done
log "linked $(find "$CLAUDE_HOME/skills" -maxdepth 1 -type l | wc -l) skills"

# Skills expect the vault at ~/notes. The link may dangle until the notes repo
# is cloned; it resolves as soon as the checkout appears.
if [[ -e "$HOME/notes" && ! -L "$HOME/notes" ]]; then
	warn "not linking ~/notes: exists and is not a symlink"
else
	ln -sfn "$NOTES_DIR" "$HOME/notes"
	log "linked ~/notes -> $NOTES_DIR"
fi
