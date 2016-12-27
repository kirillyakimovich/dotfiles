#!/bin/bash

if ! which brew &> /dev/null; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"	
else
	brew update --verbose
fi

brew tap Homebrew/bundle
brew bundle --file="$DOTFILES/macos/Brewfile"
brew bundle --file="$DOTFILES/macos/Brewfile.cask"


