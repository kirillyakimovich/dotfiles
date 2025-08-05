#!/usr/bin/env bash

# ~/.osx — http://mths.be/osx

# Disable dock jumping
defaults write com.apple.dock no-bouncing -bool TRUE
killall Dock

killall System\ Preferences

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until '.osx' has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#
# Dock
#

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Disable dock magification
defaults write com.apple.dock magnification -bool false

# Put the dock on right side
defaults write com.apple.dock orientation -string "right"

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Change the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0.0
defaults write com.apple.dock autohide-time-modifier -float 0.0

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Dock tweaks
defaults write com.apple.dock mouse-over-hilte-stack -bool true

# Don't show recents
defaults write com.apple.dock show-recents -bool false

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

#
# Keyboard
#

# Remapping Caps Lock with Escape
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}'

#
# Keyboard
#

# Set a pretty fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

#
# iTerm
#

# Don't display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

#
# Xcode
#

# Trim trailing whitespace
defaults write com.apple.dt.Xcode DVTTextEditorTrimTrailingWhitespace -bool true

# Trim whitespace only lines
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true

# Don't show completion on escape
defaults write com.apple.dt.Xcode DVTTextShowCompletionsOnEsc -bool false

# Show line numbers
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true

# Hide the code folding ribbon
defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool false

# Enable automatic updates
defaults write com.apple.dt.Xcode DVTDownloadableAutomaticUpdate -bool true

# Live issues
defaults write com.apple.dt.Xcode IDEEnableLiveIssues -bool true

# Setup page guide
defaults write com.apple.dt.Xcode DVTTextShowPageGuide -bool true
defaults write com.apple.dt.Xcode DVTTextPageGuideLocation -int 110

# Max number of lines
defaults write com.apple.dt.Xcode IDEIssueNavigatorDetailLevel -int 10
defaults write com.apple.dt.Xcode IDESearchNavigatorDetailLevel -int 10

# Enable internal debug menu
defaults write com.apple.dt.Xcode ShowDVTDebugMenu -bool true

# Source control local revision side
defaults write com.apple.dt.Xcode DVTComparisonOrientationDefaultsKey -int 0

# Stack assitant editors vertically
defaults write com.apple.dt.Xcode AssistantEditorsLayout -int 1

# Use open quickly to open in the focused pane
defaults write com.apple.dt.Xcode IDEEditorCoordinatorTarget_Click -string FocusedEditor

# Use custom derived data location
defaults write com.apple.dt.Xcode IDECustomDerivedDataLocation -string DerivedData

# Show build times in toolbar
# http://cocoa.tumblr.com/post/131023038113/build-speed
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true

# Add more information to Xcode's build output about why specific commands are being run
# https://twitter.com/bdash/status/661742266487205888
# http://www.openradar.me/27516128
defaults write com.apple.dt.Xcode ExplainWhyBuildCommandsAreRun -bool true

# Stop Xcode from reopening files (specifically storyboards) on launch.
# I also have a `xcuser` shell command to wipe this state so you don't reopen
# storyboards and dirty the diff, or just take 30 seconds to launch
defaults write com.apple.dt.Xcode IDEDisableStateRestoration -bool true

# Write detailed build system info into derived data
# If you don't enable this but `mkdir /tmp/xcode_dependency_logs` the logs will
# be created there instead
defaults write com.apple.dt.Xcode EnableBuildSystemLogging -bool true

# Disable the print keyboard shortcut in Xcode. I accidentally hit this a lot
defaults write com.apple.dt.Xcode NSUserKeyEquivalents -dict-add "Print..." "nil"

# Enable extra logging for XCBuild
defaults write com.apple.dt.XCBuild EnableBuildDebugging -bool true
defaults write com.apple.dt.XCBuild EnableDebugActivityLogs -bool true

# Make the tab key actually be a tab key
defaults write com.apple.dt.Xcode DVTTextTabKeyIndentBehavior -string Never

# Set the keybindings to my customizations (see $DOTFILES/xcode)
# Stored in ~/Library/Developer/Xcode/UserData/KeyBindings
defaults write com.apple.dt.Xcode IDEKeyBindingCurrentPreferenceSet -string custom.idekeybindings

# Set custom colorscheme
defaults write com.apple.dt.Xcode XCFontAndColorCurrentTheme -string SolarizedLightFira.xccolortheme
defaults write com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme -string SolarizedDarkFira.xccolortheme

# Show indexing progress
# https://twitter.com/dmartincy/status/1034930612543676418
defaults write com.apple.dt.Xcode IDEIndexerActivityShowNumericProgress -bool true

# Make command click jump to definition instead of showing the menu
defaults write com.apple.dt.Xcode IDECommandClickNavigates -bool true

# https://gist.github.com/tkersey/6b6c1d91415c785a10560ae564288a65
defaults write com.apple.dt.Xcode ShowDVTDebugMenu -bool true

# Hide the Xcode 11 minimap
defaults write com.apple.dt.Xcode DVTTextShowMinimap -bool false

# Disable Source Control
defaults write com.apple.dt.Xcode IDESourceControlEnableSourceControl_10_0 -bool false

# Show all file extensions
defaults write com.apple.dt.Xcode IDEFileExtensionDisplayMode -int 1


echo "Done. Note that some of these changes require a logout/restart to take effect."
