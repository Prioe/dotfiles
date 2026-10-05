function update_nvim --description 'Sync nvim plugins and re-add config to chezmoi'
    nvim --headless "+Lazy! sync" ":MasonToolsUpdateSync" +qa
    chezmoi re-add $HOME/.config/nvim
end
