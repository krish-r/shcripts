#!/usr/bin/env bash

# colors
c_cyan='\033[0;36m'
c_green='\033[0;32m'
c_red='\033[0;31m'
c_clear='\033[0m'

# variables
gitignore_language_api="https://api.github.com/gitignore/templates"
output_file="$PWD/.gitignore"
fzf_bin=fzf
fzf_bin_alt="$HOME/Apps/.fzf/bin/fzf"
line_break="#########################"

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

# fetch the language list from the api and get the user input
language=$(curl -sS $gitignore_language_api | jq -r ".[]" | $fzf_bin --header='Select a Language:' --no-multi --height 40% --reverse)
_check_if_empty "Language" "$language"
printf "%bSelected Language%b: %b%s%b\n\n" "$c_cyan" "$c_clear" "$c_green" "$language" "$c_clear"

# fetch the gitignore contents
gitignore_content=$(curl -sS "$gitignore_language_api/$language" | jq -r ".source")
_check_if_empty ".gitignore content" "$gitignore_content"

# print the .gitignore contents to screen
printf "%b.gitignore contents%b:\n" "$c_cyan" "$c_clear"
printf "%b%s%b\n" "$c_green" "$line_break" "$c_clear"
printf "%s\n" "$gitignore_content"
printf "%b%s%b\n\n" "$c_green" "$line_break" "$c_clear"

# check if a .gitignore file already exists in the current directory
line_prefix=""
if [[ -f "$output_file" ]]; then
	printf "%b.gitignore file found in the current directory%b\n" "$c_cyan" "$c_clear"
	line_prefix=$'\n'
fi

# write the contents to file
write_confirmation=$(printf "(%bY%b)es\n(%bN%b)o" "$c_green" "$c_clear" "$c_red" "$c_clear" |
	$fzf_bin --ansi --header="Add the contents to '$output_file'?" --no-multi --height 20% --reverse)
if [[ $write_confirmation == "(Y)es" ]]; then
	printf "%b.gitignore contents%b appended to: %b%s%b\n" "$c_cyan" "$c_clear" "$c_green" "$output_file" "$c_clear"
	printf "%s%s\n\n" "$line_prefix" "$gitignore_content" >>"$output_file"
fi
