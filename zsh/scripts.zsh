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

dotfiles() {
	ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook $HOME/.dotfiles/ansible/dotfiles.yml "$@" --ask-become-pass
}

# Aliases to run programs in docker containers as if they were avalable on the host
gitlab-runner() {
	docker run -d --name gitlab-runner --restart always \
		-v /srv/gitlab-runner/config:/etc/gitlab-runner \
		-v /var/run/docker.sock:/var/run/docker.sock \
		docker.io/gitlab/gitlab-runner:latest
}

get_idf() {
	export IDF_PATH="$HOME/code/github.com/espressif/esp-idf"
	. "$IDF_PATH"/export.sh
}

idf_shell() {
	sh -c '. "$HOME/code/github.com/espressif/esp-idf/export.sh" &> /dev/null; exec zsh -i'
}

idf_nvim() {
	sh -c '. "$HOME/code/github.com/espressif/esp-idf/export.sh" &> /dev/null; exec zsh -i -c nvim'
}

idf_bfm() {
	sh -c '. "$HOME/code/github.com/espressif/esp-idf/export.sh" &> /dev/null; exec zsh -i -c "idf.py build flash monitor"'
}

idf() {
	echo "Running idf $@"
	sh -c '. "$HOME/code/github.com/espressif/esp-idf/export.sh" &> /dev/null; exec zsh -i -c "idf.py '"$@"'"'
}

PRE_COMMIT_CONTAINER="reg.implen.net/it/cicd/containers/validate"
# PRE_COMMIT_CONTAINER="docker.io/kiwicom/pre-commit"
pre-commit() {
	GIT_REPO="$(git rev-parse --show-toplevel)"
	podman run --rm -t \
		-v "${GIT_REPO}:/app:z" \
		-v "pre-commit-podman-cache:/.cache/pre-commit:z" \
		-w "/app" \
		"${PRE_COMMIT_CONTAINER}" \
		"pre-commit" "$@"
}
pre-commit-print-log() {
	podman container create \
		--name pre-commit-log-getter \
		-v "pre-commit-podman-cache:/.cache/pre-commit" \
		"${PRE_COMMIT_CONTAINER}" >/dev/null
	podman cp "pre-commit-log-getter:/.cache/pre-commit/pre-commit.log" "/tmp/pre-commit.log"
	podman rm pre-commit-log-getter >/dev/null
	printf "%s" "$(<"/tmp/pre-commit.log")"
	rm "/tmp/pre-commit.log"
}
