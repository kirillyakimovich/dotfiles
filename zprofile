typeset -U path PATH

if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

export PATH="$HOME/.bin:$HOME/.local/bin:$PATH"

if [[ -f "$HOME/.swiftly/env.sh" ]]; then
	. "$HOME/.swiftly/env.sh"
fi
