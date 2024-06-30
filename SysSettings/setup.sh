#!/bin/bash

# Set default folder for storing screenshots
# Create the directory if it doesn't exist
mkdir -p ~/Screenshots 
# Sets it as default location for screenshots
sudo defaults write com.apple.screencapture location ~/Screenshots

# Use plain text mode for new TextEdit documents
sudo defaults write com.apple.TextEdit RichText -int 0

# Show the ~/Library folder
sudo chflags nohidden ~/Library

# Disable the warning when changing a file extension
sudo defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Set the default view mode to List view
sudo defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable tap to click for the current user and the login screen
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true && \
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 && \
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable the Guest User account
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Show hidden files in Finder
sudo defaults write com.apple.finder AppleShowAllFiles TRUE

# Set default Finder location to your home directory
sudo defaults write com.apple.finder NewWindowTarget -string "PfHm"
sudo defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show all filename extensions in Finder
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Turn on reduce motion
sudo defaults write com.apple.universalaccess reduceMotion -bool true

# Turn on increase contrast
sudo defaults write NSGlobalDomain AppleDisplayIncreaseContrast -bool true

# Hide desktop files on desktop but show in stage manager
sudo defaults write com.apple.finder CreateDesktop -bool false
sudo killall Finder

# Set the timezone to Geneva (Europe/Zurich)
sudo systemsetup -settimezone "Europe/Zurich"

# Automatically hide and show the Dock
sudo defaults write com.apple.dock autohide -bool true && killall Dock

# Remove the auto-hiding Dock delay
sudo defaults write com.apple.dock autohide-delay -float 0
sudo defaults write com.apple.dock autohide-time-modifier -float 0

# Show the battery percentage in the menu bar
sudo defaults write com.apple.menuextra.battery ShowPercent -string "YES" && killall SystemUIServer

# Don’t show recent applications in Dock
sudo defaults write com.apple.dock show-recents -bool false && killall Dock

# Show Path bar in Finder
sudo defaults write com.apple.finder ShowPathbar -bool true

# Show Status bar in Finder
sudo defaults write com.apple.finder ShowStatusBar -bool true

# Restart Finder to apply changes
sudo killall Finder

# Show all filename extensions
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Only use UTF-8 in Terminal.app
sudo defaults write com.apple.terminal StringEncodings -array 4

# Set a blazingly fast keyboard repeat rate
sudo defaults write NSGlobalDomain KeyRepeat -int 1

# Set default browser to the application with bundle identifier id1607635845
sudo /usr/sbin/dseditgroup -o edit -a id1607635845 -t group com.apple.private.internet.services

echo "Default browser set to the specified application."

# Disable Gatekeeper (allows installation of apps from anywhere)
sudo spctl --master-disable

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Empty Trash securely by default
sudo defaults write com.apple.finder EmptyTrashSecurely -bool true

# Use a modified version of the Solarized Dark theme by default in Terminal.app
sudo osascript <<EOD
tell application "Terminal"
    local allOpenedWindows
    local initialOpenedWindows
    local windowID
    set themeName to "Solarized Dark xterm-256color"
    (* Store the IDs of all the open terminal windows. *)
    set initialOpenedWindows to id of every window
    (* Open the custom theme so that it gets added to the list
       of available terminal themes (note: this will open two
       additional terminal windows). *)
    do shell script "open '$HOME/init/" & themeName & ".terminal'"
    (* Wait a little bit to ensure that the custom theme is added. *)
    delay 1
    (* Set the custom theme as the default terminal theme. *)
    set default settings to settings set themeName
    (* Get the IDs of all the currently opened terminal windows. *)
    set allOpenedWindows to id of every window
    repeat with windowID in allOpenedWindows
        (* Close the additional windows that were opened in order
           to add the custom theme to the list of terminal themes. *)
        if initialOpenedWindows does not contain windowID then
            close (every window whose id is windowID)
        (* Change the theme for the initial opened terminal windows
           to remove the need to close them in order for the custom
           theme to be applied. *)
        else
            set current settings of tabs of (every window whose id is windowID) to settings set themeName
        end if
    end repeat
end tell
EOD

# Enable dark mode
sudo defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Disable keyboard light
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Keyboard Dim" -bool false
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool false
osascript -e 'tell application "System Events" to key code 144 using control down'



# Install fonts
# Copy fonts to the Fonts directory
cp -a ./fonts/. ~/Library/Fonts 



# Logout
osascript -e 'tell application "System Events" to keystroke "q" using {command down, shift down}'
