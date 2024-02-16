# shellcheck disable=SC2148
# vim:ft=sh

op_fzf() {
	function zle-op-fzf() {
		# we have to use op.exe in wsl (if it exists)
		op=$(if command -v op.exe &>/dev/null; then echo "op.exe"; else echo "op"; fi)

		fzf_args=(
			--header-lines=1
			"--with-nth=2,3,4,5,6,7"
		)

		item=$($op items list | fzf "${fzf_args[@]}")
		item_uuid=$(echo "$item" | awk '{print $1}')

		# open it in nvim readonly
		$op item get "$item_uuid" | nvim -R
	}

	zle -N zle-op-fzf
	bindkey '^o' zle-op-fzf
}

op_fzf
