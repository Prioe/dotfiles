# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a **chezmoi dotfiles repository** managing configuration files primarily for Arch Linux (including WSL). Fedora
is partially supported as a work OS. Chezmoi's templating system handles environment differences.

### Repository Layout

- `dot_config/` -> `~/.config/`, `dot_ssh/` -> `~/.ssh/`, `dot_local/` -> `~/.local/`, `dot_zshenv` -> `~/.zshenv`
- `.chezmoiscripts/` - Numbered hook scripts (run before/after `chezmoi apply`)
- `.chezmoidata/packages.yml` - Master package list per distribution
- `.chezmoitemplates/` - Reusable templates (`scriptLogging` for colored log output, `hashList` for change detection)
- `.chezmoi.toml.tmpl` - Chezmoi config with interactive prompts for email, gui, managePackages, notesRepoUrl

### Chezmoi Naming Conventions

- `dot_` prefix -> dot-prefixed target (e.g. `dot_config/` -> `.config/`)
- `exact_` prefix -> chezmoi removes files in the target directory not managed by chezmoi
- `executable_` prefix -> target file gets executable permission
- `private_` prefix -> target file gets restricted permissions (0600)
- `.tmpl` suffix -> processed as Go template before writing
- `run_onchange_before_` / `run_onchange_after_` -> hook scripts ordered by numeric prefix (04, 05, 10, 15, 20...)

### Template Data Variables

Defined in `.chezmoi.toml.tmpl` (prompted on first run):

| Variable          | Type   | Purpose                                                   |
| ----------------- | ------ | --------------------------------------------------------- |
| `.email`          | string | User email                                                |
| `.gui`            | bool   | Include GUI apps (Hyprland, Ghostty, Kitty, Waybar, etc.) |
| `.managePackages` | bool   | Let chezmoi install system packages                       |
| `.isWSL`          | bool   | Auto-detected WSL environment                             |
| `.isContainer`    | bool   | Auto-detected container (Docker/Podman)                   |
| `.hasOP`          | bool   | 1Password CLI available                                   |
| `.notesRepoUrl`   | string | Git URL for notes repository                              |

Chezmoi built-ins: `.chezmoi.os`, `.chezmoi.osRelease.id`, `.chezmoi.kernel.osrelease`, `.chezmoi.hostname`

### Key Subsystems

- **Neovim** (`dot_config/nvim/`): AstroNvim v4+ with lazy.nvim. Plugins in `lua/exact_plugins/` (the `exact_` prefix
  means chezmoi will remove unmanaged plugin files).
- **Zsh** (`dot_config/zsh/`): oh-my-zsh with custom aliases, scripts, bindings, completion, vi-mode plugin. Supports
  work-layer extensions (`*-work` files).
- **Hyprland** (`dot_config/hypr/`): Wayland compositor with waybar, swaylock (GUI-only).

## Workflow Rules

- **Always edit files in this repository**, never directly in `~/`. After making changes, run `chezmoi apply` to deploy.
- When tasked to modify configuration that is **not yet tracked** by chezmoi, ask the user whether it should be added to
  the repository before making changes.

## Commands

```bash
# Preview changes before applying
chezmoi diff

# Apply dotfiles to system
chezmoi apply

# Add a new file to chezmoi management
chezmoi add ~/.config/newfile

# Lint (Prettier formatting check)
mise run lint

# Container testing
docker build -t dotfiles-test . && docker run --rm -it dotfiles-test
```
