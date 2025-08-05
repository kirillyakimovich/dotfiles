#!/bin/bash

files=(\
    zshrc \ 
    git_template \
    gitconfig \
)

die() {
	echo "Usage: ./manage.sh {create|remove}"
	exit 1
}

new_path() {
	echo "$HOME/.$1"
}

create_link() {
	local filename="$1"

	if [[ ! -e "$filename" ]]; then
		echo "$filename doesn't exist"
		return
	fi

	target="$(new_path "$filename")"
	if [[ ! -e "$target" ]]; then
		echo "Linking $filename to $target"
		ln -s "$PWD/$filename" "$target"
	fi
}

create_links() {
	for file in "${files[@]}"
	do
		create_link "$file"
	done
}

remove_link() {
	target="$(new_path "$1")"

	if [ -e "$target" ]; then
		echo "Removing $target"
		rm "$target"
	fi
}

remove_links() {
	for file in "${files[@]}"
	do
		remove_link "$file"
	done
}

if [[ $# != 1 ]]; then
	die
fi

if [[ $1 == "create" ]]; then
	create_links
elif [[ $1 == "remove" ]]; then
	remove_links
fi

