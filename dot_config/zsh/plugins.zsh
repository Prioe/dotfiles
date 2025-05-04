#!/usr/bin/env zsh

local plugin_paths=(
  $ZDOTDIR/plugins
  /usr/share/zsh/plugins
  $HOME/.local/share/zsh-plugins
  $HOME/.local/share/oh-my-zsh
)

local plugin
for plugin in $plugins; do
  local found=false

  for plugin_path in $plugin_paths; do
    if [[ -f $plugin_path/$plugin ]]; then
      found=true
      # echo "Sourcing $plugin_path/$plugin"
      source $plugin_path/$plugin
      break
    fi
  done

  if [[ $found == false ]]; then
    echo "Plugin not found: $plugin"
  fi
done
