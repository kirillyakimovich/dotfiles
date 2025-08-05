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
