# Environment variables (port of zsh/.zshenv)
# Sourced for every fish shell, interactive or not.

set -gx DOTFILES $HOME/.local/share/chezmoi

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER nvimpager

# Man pages
set -gx MANPAGER nvimpager

# XDG
# See: https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# Move as many config files as possible to XDG_CONFIG_HOME
set -gx ASDF_CONFIG_FILE $XDG_CONFIG_HOME/asdf/asdfrc
set -gx ASDF_DATA_DIR $XDG_DATA_HOME/asdf
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx ANSIBLE_HOME $XDG_CONFIG_HOME/ansible
set -gx ANSIBLE_CONFIG $XDG_CONFIG_HOME/ansible.cfg
set -gx ANSIBLE_GALAXY_CACHE_DIR $XDG_CACHE_HOME/ansible/galaxy_cache
set -gx DOCKER_CONFIG $XDG_CONFIG_HOME/docker
set -gx MACHINE_STORAGE_PATH $XDG_DATA_HOME/docker-machine
set -gx CLAUDE_CONFIG_DIR $XDG_CONFIG_HOME/claude # TODO: the support for this from claude-code keeps changing, keep this until it is stable
set -gx CODEX_HOME $XDG_CONFIG_HOME/codex

set -gx TMUX_PLUGIN_MANAGER_PATH $XDG_CONFIG_HOME/tmux/plugins

# Add all directories in ~/.local/bin to $PATH
if test -d ~/.local/bin
    fish_add_path --path (find ~/.local/bin -type d)
end

# Homebrew
for prefix in /home/linuxbrew/.linuxbrew ~/.linuxbrew /opt/homebrew
    if test -d $prefix
        $prefix/bin/brew shellenv fish | source
        break
    end
end

if type -q brew
    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_BUNDLE_NO_LOCK 1
end
