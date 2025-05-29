# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a **chezmoi dotfiles repository** that manages personal configuration files across different systems. The repository uses chezmoi's templating system to handle cross-platform differences and personal customizations.

### Key Structure

- `dot_config/` - Contains all configuration files that will be symlinked to `~/.config/`
- Templates use `.tmpl` extension and support Go templating with chezmoi variables
- `Dockerfile` provides a containerized environment for testing dotfile application

### Core Components

- **Shell Environment**: zsh with custom configuration, aliases, and plugins
- **Development Tools**: mise for runtime management, starship prompt, atuin for shell history
- **Editors**: Neovim with Lua configuration using lazy.nvim
- **Desktop Environment**: Hyprland wayland compositor with waybar and related tools
- **Terminal**: Ghostty and Kitty terminal emulators with Catppuccin theme

## Common Commands

### Chezmoi Operations

```bash
# Apply all dotfiles to system
chezmoi apply

# Apply with force (overwrite existing files)
chezmoi apply --force

# Preview changes before applying
chezmoi diff

# Add a new file to chezmoi management
chezmoi add ~/.config/newfile

# Edit a managed file
chezmoi edit ~/.config/somefile

# Update chezmoi repository
chezmoi git pull && chezmoi apply
```

### Development Environment

```bash
# Install runtime versions defined in mise config
mise install

# Update all mise tools
mise upgrade

# Sync shell environment after changes
source ~/.zshenv && source ~/.zshrc
```

### Container Testing

```bash
# Build and test dotfiles in container
docker build -t dotfiles-test .
docker run --rm -it dotfiles-test
```

## Templating System

Files with `.tmpl` extension use Go templating with chezmoi data:

- `.chezmoi.os` - Operating system (linux, darwin, etc.)
- `.chezmoi.osRelease.id` - Distribution ID (arch, ubuntu, etc.)
- `.chezmoi.kernel.osrelease` - Kernel release info
- WSL detection via kernel release containing "microsoft"

## Tool Ecosystem

The dotfiles configure an integrated development environment:

- **Package Management**: paru (Arch), homebrew (macOS)
- **Shell**: zsh with oh-my-zsh plugins, syntax highlighting, autosuggestions
- **Navigation**: zoxide for smart directory jumping, eza for enhanced ls
- **Development**: mise for runtime versions, tmux for multiplexing
- **Editor**: Neovim with LSP, copilot, and extensive plugin ecosystem
