#!/bin/bash

# Fonts                                                                       #
for font in ${PWD}/fonts/*; do
    if [[ ! -e "/Library/Fonts/$(basename "$font")" ]]; then
        printf "Copying %s to your Fonts folder\n" "$(basename "$font")"
        sudo cp -a "$font"  /Library/Fonts
    fi
done

# Homebrew
if ! which brew &> /dev/null; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"	
else
	brew update --verbose
fi

#open "$DOTFILES/macos/defaults.sh"

brew tap Homebrew/bundle
brew bundle --file="$DOTFILES/macos/Brewfile"
brew bundle --file="$DOTFILES/macos/Brewfile.cask"

