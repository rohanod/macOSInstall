#!/bin/bash

# List of applications installed via Homebrew Cask to add to startup
APPS=(
    "shottr"
    "maccy"
    "raycast"
    "alt-tab"
    "qlstephen"
    "keka"
    "keyclu"
    "karabiner-elements"
    "dropover"
    "rcmd"
)

# Function to add a cask application to startup items
add_cask_to_startup() {
    local app_name="$1"
    local app_path="/Applications/$app_name.app"

    # Check if the application exists in /Applications directory
    if [ -e "$app_path" ]; then
        # Check if the app is already in the login items list
        if ! osascript -e "tell application \"System Events\" to get the name of every login item" | grep -q "$app_name"; then
            # Add the app to the login items
            osascript -e "tell application \"System Events\" to make new login item at end with properties {path:\"$app_path\", hidden:false}"
            
            echo "Added $app_name to startup items."
        else
            echo "$app_name is already in startup items."
        fi
    else
        echo "Application $app_name not found at $app_path."
    fi
}

# Iterate over the list of cask applications and add each one to startup
for app in "${APPS[@]}"; do
    add_cask_to_startup "$app"
done
