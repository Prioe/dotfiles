#!/usr/bin/env zsh

# this pushes my local obsidian vault to a remote git repo
push_notes () {
  # format: 12.02.2024, 16:06
  T="$(date +'%d.%m.%Y, %H:%M')"
  H="$(hostname)"
  cd ~/notes
  git add .
  git commit -m "Pushing notes from $H at $T"
  git push
  cd -
}

pull_notes () {
  cd ~/notes
  git pull
  cd -
}

sync_notes () {
  pull_notes
  push_notes
}
