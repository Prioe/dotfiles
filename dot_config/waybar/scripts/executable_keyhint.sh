#!/usr/bin/env bash
set -euo pipefail

font="Iosevka"

yad --title="Sway keyhints" \
    --no-buttons \
    --geometry=980x620 \
    --list \
    --no-click \
    --no-selection \
    --column="Function" \
    --column="Binding" \
    --column-align=cc \
    --header-align=cc \
    "Launcher" "Super + d" \
    "Terminal" "Super + Enter" \
    "Power menu" "Super + Shift + e" \
    "Window switcher" "Super + p" \
    "Focus" "Super + arrows / h j k l" \
    "Move window" "Super + Shift + arrows / h j k l" \
    "Resize" "Super + Ctrl + arrows / h j k l" \
    "Fullscreen" "Super + f" \
    "Float toggle" "Super + Shift + Space" \
    "Scratchpad toggle" "Super + -" \
    "Scratchpad move" "Super + Shift + -" \
    "Screenshot area" "Print" \
    "Screenshot window" "Ctrl + Print" \
    "Screenshot display" "Shift + Print" \
    "Clipboard menu" "Super + Ctrl + v" \
    "Clipboard delete" "Super + Ctrl + x" \
    "Lock" "Super + Escape" \
    "Workspace 1..10" "Super + 1..0"
