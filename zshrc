# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

# Needed to properly support unicode symbols
export LANG=en_US.UTF-8

export EDITOR=vim

bindkey -v

vman() {
    vim -c "SuperMan $*"

    if [ "$?" != "0" ]; then
        echo "No manual entry for $*"
    fi
}

PATH=$PATH:~/.local/bin
PATH=$PATH:/usr/local/bin
### Adding support for custom brew installed zsh extensions

fpath+=("$(brew --prefix)/share/zsh/site-functions")
###

### Auto completion start
autoload -Uz compinit && compinit
### Auto completion end

### Prompt start
autoload -Uz promptinit; promptinit
prompt pure
### Prompt end

###History start

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

function h() {
    # check if we passed any parameters
    if [ -z "$*" ]; then
        # if no parameters were passed print entire history
        history 1
    else
        # if words were passed use it as a search
        history 1 | egrep --color=auto "$@"
    fi
}
### History end

### Navigation start
export cdpath=(. ~ ~/src/  ~/src/Lyft-iOS/Modules/)
setopt auto_cd
### Navigation end

### Functions from dedicated folder start
# https://unix.stackexchange.com/a/33898
fpath=($DOTFILES/zshfunctions $fpath)
autoload -Uz $DOTFILES/zshfunctions/*(:t)
### Functions from dedicated folder end

source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
