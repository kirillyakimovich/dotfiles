#!/usr/bin/env bash

# ~/.osx — http://mths.be/osx

# Disable dock jumping
defaults write com.apple.dock no-bouncing -bool TRUE
killall Dock

if [[ $# -ne 1 ]];then
  echo "Usage: ./$(basename "$0") COMPNAME"
  exit
fi

killall System\ Preferences

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until '.osx' has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set a pretty fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Don't display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Set computer name (as done via System Preferences → Sharing)
name=$1
sudo scutil --set ComputerName "$name"
sudo scutil --set HostName "$name.local"
sudo scutil --set LocalHostName "$name"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$name"

