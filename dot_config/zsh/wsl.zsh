#!/usr/bin/env bash
# vim:ft=sh

if [ ! -f "/proc/sys/fs/binfmt_misc/WSLInterop" ]; then
	exit 1
fi

add_winget_package_path() {
	local -r package_name="$1"
	local -r package_path="$(fd "$package_name" -p -t d "$windows_root/Users/$windows_user/AppData/Local/Microsoft/WinGet")"

	if [ -d "$package_path" ]; then
		export PATH="$PATH:$package_path"
		return 0
	else
		echo "Could not find $package_name in WindowsApps"
	fi

	return 1
}

# We set appendWindowsPath=false in /etc/wsl.conf to avoid Windows paths in $PATH
# Some programs are very helpful and we add them to our path here
# add Microsoft's OpenSSH to the path, so we can use 1password as authentication helper

# Assume Windows is installed in C:
windows_root="${WINDOWS_ROOT:-/mnt/c}"
windows_user="${WINDOWS_USER:-$USER}"

export PATH="$PATH:$windows_root/Windows"

# Assure our username is the same as in Windows and user dir lives in C:
windows_apps_path="$windows_root/Users/$windows_user/AppData/Local/Microsoft/WindowsApps"

if [ -d "$windows_apps_path" ]; then
	export PATH="$PATH:$windows_apps_path"
	alias winget='winget.exe'
fi

# win32yank
if add_winget_package_path 'equalsraf.win32yank'; then
	alias win32yank='win32yank.exe'
fi

# Find the 1Password CLI winget install path
if add_winget_package_path 'AgileBits.1Password.CLI'; then
	alias op='op.exe'
	eval "$(op.exe completion zsh)"
	compdef _op op.exe

	ssh_path="$windows_root/Windows/System32/OpenSSH"

	if [ -d "$ssh_path" ]; then
		export PATH="$PATH:$ssh_path"

		# This is used for 1password support
		# See: https://developer.1password.com/docs/ssh/integrations/wsl/#optional-add-an-alias-for-ssh-commands
		alias ssh='ssh.exe'
		alias ssh-add='ssh-add.exe'
	fi
fi

# Docker
docker_path="$windows_root/Program Files/Docker/Docker/resources/bin"

if [ -d "$docker_path" ]; then
	export PATH="$PATH:$docker_path"
fi
