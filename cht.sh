#!/usr/bin/env bash

## Format
# curl https://cht.sh/{language}/query+string
# curl https://cht.sh/{core-util}~{operation}

url="https://cht.sh"
fzf_bin=fzf
fzf_bin_alt="$HOME/Apps/.fzf/bin/fzf"

if ! command -v "$fzf_bin" &>/dev/null; then
	# Check for fzf binary in alternate directory
	fzf_bin="$fzf_bin_alt"
	if [[ ! -x "$fzf_bin" ]]; then
		printf "fzf command not found\n"
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

echo "Select an option: "
option=$(echo "1. Language;2. Core-Util" | tr ";" "\n" | $fzf_bin --height 40% --reverse)
_check_if_empty "option" "$option"

if [ "$option" == "1. Language" ]; then
	read -r -p "Language: " param1
	param1=$(echo "$param1" | xargs)
	_check_if_empty "Language" "$param1"

	read -r -p "Query: " param2
	param2=$(echo "$param2" | xargs | tr " " "+")
	if [[ -z $param2 ]]; then separator=""; else separator="/"; fi
elif [ "$option" == "2. Core-Util" ]; then
	read -r -p "Core-Util: " param1
	param1=$(echo "$param1" | xargs)
	_check_if_empty "Core-Util" "$param1"

	read -r -p "Operation: " param2
	param2=$(echo "$param2" | xargs | tr " " "+")
	if [[ -z $param2 ]]; then separator=""; else separator="~"; fi
fi
query="$param1$separator$param2"

echo "curl \"$url/$query"\"
curl "$url/$query"

# echo ""
# read -r -s -p "Press Enter key to Exit... "
# printf "\n"
