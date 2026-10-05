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

### Template Data Variables

Template variables (`.email`, `.gui`, `.managePackages`, `.isWSL`, ...) are defined in `.chezmoi.toml.tmpl` - read it
for the full list and semantics.

### Key Subsystems

- **Neovim** (`dot_config/nvim/`): AstroNvim v4+ with lazy.nvim. See `dot_config/nvim/CLAUDE.md` for conventions.
- **Zsh** (`dot_config/zsh/`): oh-my-zsh with custom aliases, scripts, bindings, completion, vi-mode plugin. Supports
  work-layer extensions (`*-work` files).
- **Hyprland** (`dot_config/hypr/`): Wayland compositor with waybar, swaylock (GUI-only).

## Workflow Rules

- **Always edit files in this repository**, never directly in `~/`. After making changes, run `chezmoi apply` to deploy.
- When tasked to modify configuration that is **not yet tracked** by chezmoi, ask the user whether it should be added to
  the repository before making changes.

## Commands

```bash
# Lint (Prettier formatting check)
mise run lint

# Container testing
docker build -t dotfiles-test . && docker run --rm -it dotfiles-test
```
