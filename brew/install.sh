#!/bin/bash

# Install Homebrew
echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Remove quarantine
echo "Removing quarantine"

# Configuration file path
config_file="$HOME/.config/homebrew/cask.conf"

# Check if the config file exists
if [ ! -f "$config_file" ]; then
  # Create the file if it doesn't exist
  mkdir -p "$(dirname "$config_file")"
  touch "$config_file"
fi

# Check if the setting is already present
if grep -q "cask.no_quarantine = true" "$config_file"; then
  echo "Quarantine is already disabled for Homebrew Cask installations."
else
  # Append the setting to the file if not present
  echo "cask.no_quarantine = true" >> "$config_file"
  echo "Quarantine has been disabled for future Homebrew Cask installations."
fi

# Install packages using the Brewfile
brew bundle --file=./brew/Brewfile

# Configure zsh autocomplete

# Create the .zshrc file if it doesn't exist
touch ~/.zshrc

# Append this line to the end of the ~/.zshrc file
echo 'source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' > ~/.zshrc