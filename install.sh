#!/bin/bash

# Get the repository params
export GIT_USERNAME="rohanod"
export REPO_NAME="macOSInstall"

# Prompt for sudo password, as it will be required for the installation
echo 'Password required for installation:'
if ! sudo -v; then    
    echo "Failed to obtain sudo privileges. Exiting."    
    exit 1
fi

# Setup a temporary folder to download the repository, exit script if filesystem is not writable
mkdir -p "$HOME/SystemSetupTmp"
cd "$HOME/SystemSetupTmp" || exit

# Download and unzip repository, exit script if download failed
curl -L -o master.zip https://github.com/$GIT_USERNAME/$REPO_NAME/archive/refs/heads/main.zip
unzip -o master.zip
cd $REPO_NAME-main || exit

# Execute the install.sh file, which calls the brewfile and allows your mac to open 
# the programs without whining that it was downloaded from the internetz
sh brew/install.sh

# Install .app files
sh apps/install.sh

# Add items to startup
sh SysSettings/addToStartup.sh

# Set Background
sh SysSettings/setBackground.sh

# Set display resolution
sh SysSettings/setDisplayRes.s1

# Source the updated .zshrc file
source ~/.zshrc

# After everything is installed, tweak some system settings,
# and install some fonts
sh SysSettings/setup.sh

# Finally, remove the temporary directory and its contents recursively    
rm -rf "$HOME/SystemSetupTmp"    
echo "Temporary files removed successfully."
# echo "Restart your terminal for zsh-autosuggestions to take effect."

unset GIT_USERNAME
unset REPO_NAME