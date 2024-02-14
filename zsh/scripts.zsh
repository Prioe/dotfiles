#!/usr/bin/env bash
# vim:ft=sh

# this pushes my local obsidian vault to a remote git repo
push_notes() {
	# format: 12.02.2024, 16:06
	T="$(date +'%d.%m.%Y, %H:%M')"
	H="$(hostname)"
	cd ~/notes || exit
	git add .
	git commit -m "Pushing notes from $H at $T"
	git push
	cd - || exit
}

pull_notes() {
	cd ~/notes || exit
	git pull
	cd - || exit
}

sync_notes() {
	pull_notes
	push_notes
}
