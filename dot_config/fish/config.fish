# Fish port of the zsh setup in this repo.
# Environment variables: conf.d/env.fish, aliases: conf.d/aliases.fish,
# functions: functions/*.fish (autoloaded).

# No greeting
set -g fish_greeting

if status is-interactive
    # +---------+
    # | VI MODE |
    # +---------+

    set -g fish_key_bindings fish_vi_key_bindings
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block

    # +----------+
    # | BINDINGS |
    # +----------+

    # Clear screen with Ctrl-g (as in zsh)
    bind --mode default ctrl-g clear-screen
    bind --mode insert ctrl-g clear-screen

    # +-----------+
    # | DIRCOLORS |
    # +-----------+

    # Strip the heavy highlighting from special file types (same perl trick as zsh)
    if type -q dircolors
        set -gx LS_COLORS (dircolors -p | perl -pe 's/^((CAP|S[ET]|O[TR]|M|E)\w+).*/$1 00/' | dircolors -b - | string match -rg "LS_COLORS='(.*)';")
    end

    # +-------+
    # | TOOLS |
    # +-------+

    type -q zoxide; and zoxide init --cmd cd fish | source
    type -q starship; and starship init fish | source
    type -q mise; and mise activate fish | source
    type -q atuin; and atuin init fish | source
    type -q chezmoi; and chezmoi completion fish | source
end
