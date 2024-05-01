#!/usr/bin/env bash

fzf_bin="fzf"
fzf_bin_alt="$HOME/Apps/.fzf/bin/fzf"
tldr_bin="tldr"
cargo_binaries="$HOME/.cargo/bin"
tldr_bin_alt="$cargo_binaries/tldr"

if ! command -v "$fzf_bin" &>/dev/null; then
	# Check for fzf binary in alternate directory
	fzf_bin="$fzf_bin_alt"
	if [[ ! -x "$fzf_bin" ]]; then
		printf "fzf command not found\n"
		exit 0
	fi
fi

if ! command -v "$tldr_bin" &>/dev/null; then
	printf "tldr not found under PATH. Searching under cargo binary directory.\n"
	tldr_bin="$tldr_bin_alt"
	if ! command -v "$tldr_bin" &>/dev/null; then
		printf "tldr not found under %s\n" "$cargo_binaries"
		exit 0
	fi
fi

_check_if_empty() {
	if [[ -z $2 ]]; then
		echo "$1 cannot be empty"
		# sleep 1
		exit 0
	fi
}

option=$($tldr_bin --list | $fzf_bin --preview "$tldr_bin {1} --color=always" --height 40% --reverse --preview-window=right,75%)
_check_if_empty "option" "$option"

"$tldr_bin" "$option"
