#!/usr/bin/env bash
# vim:ft=sh

if [[ ! -f "/proc/sys/fs/binfmt_misc/WSLInterop" && ! -f "/proc/sys/fs/binfmt_misc/WSLInterop-late" ]]; then
	echo "WSLInterop not found, skipping WSL specific setup"
	return 0
fi

add_winget_package_path() {
	local -r package_name="$1"
	local -r winget_dir="$windows_root/Users/$windows_user/AppData/Local/Microsoft/WinGet/Packages"
	# Array needed for proper glob expansion - simple variable assignment doesn't expand globs the same way
	local package_paths=("$winget_dir"/${package_name}_*)
	if [[ -d "${package_paths}" ]]; then
		export PATH="$PATH:${package_paths}"
		return 0
	else
		echo "Could not find $package_name in WinGet packages"
		return 1
	fi
}

add_utf16_wrapper() {
	local exe="$1"
	local name="$2"

	eval "$name() {
    if [ -t 1 ]; then
      command $exe \"\$@\"
    else
      command $exe \"\$@\" | iconv -f utf-16le -t utf-8 
    fi
  }"
}

# We set appendWindowsPath=false in /etc/wsl.conf to avoid Windows paths in $PATH
# Some programs are very helpful and we add them to our path here
# add Microsoft's OpenSSH to the path, so we can use 1password as authentication helper

if ! grep -q "appendWindowsPath=false" /etc/wsl.conf; then
	echo "⚠️  /etc/wsl.conf does not have appendWindowsPath=false, this may cause issues!"
fi

# Assume Windows is installed in C:
windows_root="${WINDOWS_ROOT:-/mnt/c}"
windows_user="${WINDOWS_USER:-$USER}"

export PATH="$PATH:$windows_root/Windows"

# Assure our username is the same as in Windows and user dir lives in C:
windows_apps_path="$windows_root/Users/$windows_user/AppData/Local/Microsoft/WindowsApps"

if [ -d "$windows_apps_path" ]; then
	export PATH="$PATH:$windows_apps_path"
	alias winget='winget.exe'
	add_utf16_wrapper 'wsl.exe' 'wsl'
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
		# See: https://developer.1password.com/docs/ssh/integrations/wsl/#optional-add-an-alias-for-ssh-commands
		# See: ./dot_local/bin/wsl/executable_{scp,ssh}
	fi
fi

# win32yank
if add_winget_package_path 'GDRETools.gdsdecomp'; then
	alias gdre_tools='gdre_tools.exe'
fi

# Docker
docker_path="$windows_root/Program Files/Docker/Docker/resources/bin"

if [[ -d "$docker_path" ]]; then
	export PATH="$PATH:$docker_path"

	local docker_comp_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/docker_completion.zsh"

	if [[ -S /var/run/docker.sock ]]; then
		local docker_comp_tmp="$(mktemp)"
		if docker completion zsh >"$docker_comp_tmp" 2>/dev/null; then
			mkdir -p "${docker_comp_cache:h}"
			mv "$docker_comp_tmp" "$docker_comp_cache"
		else
			rm -f "$docker_comp_tmp"
		fi
	fi

	if [[ -f "$docker_comp_cache" ]]; then
		source "$docker_comp_cache"
	fi
fi
