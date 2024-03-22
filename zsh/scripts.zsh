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

clear_nvim_config() {
	nvim_dirs=(
		"$XDG_CACHE_HOME/nvim"
		"$XDG_DATA_HOME/nvim"
		"$XDG_STATE_HOME/nvim"
	)

	nvim_backup_dirs=(
		"$XDG_CACHE_HOME/nvim.bak"
		"$XDG_DATA_HOME/nvim.bak"
		"$XDG_STATE_HOME/nvim.bak"
	)

	if [[ -d "${nvim_backup_dirs[0]}" || -d "${nvim_backup_dirs[1]}" || -d "${nvim_backup_dirs[2]}" ]]; then
		echo "One or more backup directories already exist. Please remove them before running this script."
		echo "Run the following commands to remove the backup directories:"
		echo "rm -rf ${nvim_backup_dirs[*]}"
		echo "Exiting..."
		return 1
	fi

	for dir in "${nvim_dirs[@]}"; do
		if [[ -d "$dir" ]]; then
			echo "Backing up $dir to $dir.bak"
			mv "$dir" "$dir.bak"
		fi
	done
}
