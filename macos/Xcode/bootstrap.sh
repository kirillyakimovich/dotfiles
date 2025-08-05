#!/bin/bash

set -euo pipefail

mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes/
cp "$DOTFILES/macos/Xcode/FontAndColorThemes/"*.xccolortheme "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/"
