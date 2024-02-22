#!/usr/bin/env bash

# bash strict mode
set -euo pipefail
IFS=$'\n\t'
op=$(if command -v op.exe &>/dev/null; then echo "op.exe"; else echo "op"; fi)

docker_run() {

	local -r docker_tag="ubuntu-dotfiles"
	local build_args=(
		--tag "$docker_tag"
		--build-arg build_mode="$1"
		--progress=plain
		--file "$DOTFILES/Dockerfile"
	)

	if [[ $1 == "remote" ]]; then
		local -r op_ssh_item=$($op item get gofn4ccf5ql3smskztmimuayfy --reveal --format=json)
		local -r ssh_public_key=$(echo "$op_ssh_item" | jq -r '.fields[] | select(.id == "public_key") | .value' | dos2unix)
		local -r ssh_private_key=$(echo "$op_ssh_item" | jq -r '.fields[] | select(.id == "private_key") | .ssh_formats.openssh.value' | dos2unix)

		build_args+=(
			--build-arg ssh_public_key="$ssh_public_key"
			--build-arg ssh_private_key="$ssh_private_key"
		)
	fi

	local -r run_args=(
		--rm
		--interactive
		--tty
	)

	docker build "${build_args[@]}" "$DOTFILES"
	docker run "${run_args[@]}" "$docker_tag"
}

help() {
	cat <<EOF
Usage: $0

Options:
	-h, --help						Show this help message and exit
	--mode=[local|remote]	Build mode (default: local)
EOF
}

main() {
	local mode="local"

	while [[ $# -gt 0 ]]; do
		case $1 in
		-h | --help)
			help
			exit 0
			;;
		--mode)
			mode=$2
			shift
			shift
			;;
		*)
			echo "Unknown option: $1"
			help
			exit 1
			;;
		esac
	done

	if [[ $mode == "local" ]] || [[ $mode == "remote" ]]; then
		docker_run "$mode"
	else
		echo "Unknown mode: $mode"
		help
		exit 1
	fi
}

main "$@"
