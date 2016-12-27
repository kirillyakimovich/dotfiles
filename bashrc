export DOTFILES="$(dirname "$(readlink "$HOME/.bashrc")")"

export PS1="____________________________    | \w @ \h (\u) \n| => "
export PS2="| => "

set -o vi
