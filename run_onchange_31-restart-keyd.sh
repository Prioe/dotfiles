#!/usr/bin/env bash

set -euo pipefail

if [[ "$(systemctl is-enabled keyd)" != "enabled" ]]; then
  sudo systemctl enable keyd
fi

sudo systemctl restart keyd
