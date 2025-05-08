#!/usr/bin/env bash

set -euo pipefail

# Check if keyd is installed
if ! command -v keyd &>/dev/null; then
  echo "keyd not installed, skipping."
  exit 0
fi

if [[ "$(systemctl is-enabled keyd)" != "enabled" ]]; then
  sudo systemctl enable keyd
fi

sudo systemctl restart keyd
