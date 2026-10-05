# Apply all chezmoi layers
function chezmoi-apply-all --description 'Apply main and work chezmoi layers'
    chezmoi apply $argv
    if test -d $HOME/.local/share/chezmoi-work
        chezmoi apply --source $HOME/.local/share/chezmoi-work $argv
    end
end
