DOTFILES="$(dirname "$(readlink "$HOME/.bashrc")")"
export DOTFILES

export PS1="____________________________    | \w @ \h (\u) \n| => "
export PS2="| => "

set -o vi

PATH=$PATH:~/.local/bin
PATH=$PATH:/usr/local/bin

vman() {
    vim -c "SuperMan $*"

    if [ "$?" != "0" ]; then
        echo "No manual entry for $*"
    fi
}

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

