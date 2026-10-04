if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

if [[ -f "$HOME/.swiftly/env.sh" ]]; then
	. "$HOME/.swiftly/env.sh"
fi
