#!/usr/bin/env bash
# This is a script for bootstrapping macOS setup

set -euo pipefail

if [[ ! -e ./manage.sh ]]; then
  echo "error: script cd broken somehow" >&2
  exit 1
fi

./manage.sh install

# Fonts                                                                       
# FiraCode 2.6: https://github.com/tonsky/FiraCode/releases/tag/6.2
for font in ${PWD}/fonts/*; do
    if [[ ! -e "/Library/Fonts/$(basename "$font")" ]]; then
        printf "Copying %s to your Fonts folder\n" "$(basename "$font")"
        cp -a "$font"  /Library/Fonts
    fi
done

# Homebrew
if ! command -v brew &> /dev/null; then
  echo "error: you need to install homebrew" >&2
  exit 1
fi

brew bundle --file="./macos/Brewfile"

./bin/setup-dock
./macos/defaults.sh
