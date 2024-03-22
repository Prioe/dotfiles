#!/usr/bin/env bash
set -e

echo "[i] Ask for sudo password"
sudo -v

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

case "$(uname -s)" in
Darwin)
	# install Command Line Tools
	if [[ ! -x /usr/bin/gcc ]]; then
		echo "[i] Install macOS Command Line Tools"
		xcode-select --install
	fi

	# install homwbrew
	if [[ ! -x /opt/homebrew/bin/brew ]]; then
		echo "[i] Install Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	# install ansible
	if [[ ! -x /opt/homebrew/bin/ansible ]]; then
		echo "[i] Install Ansible"
		brew install ansible
	fi

	# set macos defaults
	echo "[i] Set some specific macOS settings"
	set +e
	./macos.bash
	set -e
	;;

Linux)
	if [ -f /etc/os-release ]; then
		. /etc/os-release

		case "$ID" in
		debian | ubuntu)
			if [[ ! -x /usr/bin/ansible ]]; then
				echo "[i] Install Ansible"
				sudo apt-get install -y ansible
			fi
			if [[ ! -x /usr/bin/git ]]; then
				echo "[i] Install Git"
				sudo apt-get install -y git
			fi
			;;

		arch)
			if [[ ! -x /usr/bin/ansible ]]; then
				echo "[i] Install Ansible"
				sudo pacman -S ansible --noconfirm
			fi
			if [[ ! -x /usr/bin/git ]]; then
				echo "[i] Install Git"
				sudo pacman -S git --noconfirm
			fi
			;;

		*)
			echo "[!] Unsupported Linux Distribution: $ID"
			exit 1
			;;
		esac
	else
		echo "[!] Unsupported Linux Distribution"
		exit 1
	fi
	;;

*)
	echo "[!] Unsupported OS"
	exit 1
	;;
esac

if [ -f "$HOME/.bashrc" ] && [ ! -h "$HOME/.bashrc" ]; then
	echo "[i] Move current ~/.bashrc to ~/bashrc_backup"
	mv "$HOME/.bashrc" "$HOME/bashrc_backup"
fi

if [ -f "$HOME/.bash_profile" ] && [ ! -h "$HOME/.bash_profile" ]; then
	echo "[i] Move current ~/.bash_profile to ~/bash_profile_backup"
	mv "$HOME/.bash_profile" "$HOME/bash_profile_backup"
fi

# Source zshenv
echo "[i] Source zshenv"
source "$SCRIPT_DIR/../zsh/zshenv"

# Install ansible requirements
echo "[i] Install requirements"
ansible-galaxy collection install -r ../ansible/requirements.yml

# Run main playbook
echo "[i] Run Playbook"
ansible-playbook ../ansible/dotfiles.yml --ask-become-pass

echo "[i] From now on you can use $ dotfiles to manage your dotfiles"
echo "[i] Done."