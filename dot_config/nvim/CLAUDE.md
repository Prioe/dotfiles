# Neovim configuration

AstroNvim v6 with lazy.nvim. Plugins live in `lua/exact_plugins/` (the `exact_` prefix means chezmoi removes unmanaged
plugin files).

- **New plugins**: Before setting up a new plugin, check `~/.local/share/nvim/lazy/astrocommunity` for a preconfigured
  community setup. Prefer using AstroCommunity imports over manual configuration.
- **Changes**: Prefer AstroNvim options and APIs. Reference `~/.local/share/nvim/lazy/astrocore` for available
  configuration patterns.

## Updating

```bash
nvim --headless -c "autocmd User AstroUpdateCompleted quitall" -c "AstroUpdate"
chezmoi re-add ~/.config/nvim/lazy-lock.json
```

- `AstroUpdate` syncs plugins, treesitter parsers and Mason tools in one go. Run it twice when AstroNvim itself gets a
  new release: plugins stay pinned to the old AstroNvim lockfile until the second run.
- Lazy writes the lockfile in `~/.config/nvim`, so pull it back into the repo with `chezmoi re-add` before
  `chezmoi apply` (otherwise apply prompts to overwrite it).
- Mason packages installed by hand (not in any `ensure_installed`) are not covered. Check `:Mason` for outdated entries
  and update them there (`U`).
