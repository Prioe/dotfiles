#!/usr/bin/env bash

pip_list=$(python3 -m pip list 2>/dev/null)

if ! echo "$pip_list" | grep libtmux -q; then
	tmux display "Install libtmux with 'pip install --user libtmux' to support tmux-window-name plugin. A restart might be required."
	python3 -m pip install --user libtmux
fi
