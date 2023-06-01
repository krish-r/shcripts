#!/usr/bin/env bash

# colors
c_cyan='\033[0;36m'
c_green='\033[0;32m'
c_red='\033[0;31m'
c_clear='\033[0m'

# variables
license_api="https://api.github.com/licenses"
output_file="$PWD/LICENSE"
fzf_bin=fzf
fzf_bin_alt="$HOME/Apps/.fzf/bin/fzf"
# line_break="#########################"

# check fzf
if ! command -v "$fzf_bin" &>/dev/null; then
	# Check for fzf binary in alternate directory
	fzf_bin="$fzf_bin_alt"
	if [[ ! -x "$fzf_bin" ]]; then
		printf "%bfzf command not found%b\n" "$c_red" "$c_clear"
		exit 0
	fi
fi

# helper function to check if the variable not empty
_check_if_empty() {
	if [[ -z $2 ]]; then
		printf "%b%s cannot be empty%b\n" "$c_red" "$1" "$c_clear"
		# sleep 1
		exit 0
	fi
}

# fetch the license list from the api and get the user input
data=$(curl -sS $license_api | jq -r '[.[] | {id: .spdx_id, name: .name, url: .url}]')
license=$(echo "$data" | jq -r '.[] | (.id + " (" + .name + ")")' | "$fzf_bin" --header='Select a License:' --no-multi --height 40% --reverse)

_check_if_empty "License" "$license"
printf "%bSelected License%b: %b%s%b\n\n" "$c_cyan" "$c_clear" "$c_green" "$license" "$c_clear"

# fetch the license content
key=$(echo "$license" | cut -d " " -f 1)
url=$(echo "$data" | jq -r ".[] | select(.id == \"$key\") | .url")

license_content=$(curl -sS "$url" | jq -r ".body")
_check_if_empty "license content" "$license_content"

# # print the license contents to screen
# printf "%blicense contents%b:\n" "$c_cyan" "$c_clear"
# printf "%b%s%b\n" "$c_green" "$line_break" "$c_clear"
# printf "%s\n" "$license_content"
# printf "%b%s%b\n\n" "$c_green" "$line_break" "$c_clear"

# check if a `LICENSE` file already exists in the current directory
if [[ -f "$output_file" ]]; then
	printf "%bLICENSE file found in the current directory%b\n" "$c_cyan" "$c_clear"
fi

# write the contents to file
write_confirmation=$(printf "(%bY%b)es\n(%bN%b)o" "$c_green" "$c_clear" "$c_red" "$c_clear" |
	$fzf_bin --ansi --header="Add the contents to '$output_file'?" --no-multi --height 20% --reverse)
if [[ $write_confirmation == "(Y)es" ]]; then
	printf "%bLICENSE contents%b added to: %b%s%b\n" "$c_cyan" "$c_clear" "$c_green" "$output_file" "$c_clear"
	printf "%s\n\n" "$license_content" >"$output_file"
fi
