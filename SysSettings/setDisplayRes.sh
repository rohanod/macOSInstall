#!/bin/bash

# Install displayplacer if not already installed
if ! command -v displayplacer &> /dev/null; then
    echo "Installing displayplacer..."
    brew install displayplacer
fi

# Get the ID of the main display
MAIN_DISPLAY_ID=$(displayplacer list | grep '(Main)' | awk '{print $1}')

# Check if MAIN_DISPLAY_ID is empty
if [ -z "$MAIN_DISPLAY_ID" ]; then
    echo "Main display ID not found. Exiting."
    exit 1
fi

# Set the display resolution to 1680x1050 using displayplacer on the main display
displayplacer "id:$MAIN_DISPLAY_ID mode:1680x1050"

# Restart the System UI Service for changes to take effect
killall SystemUIServer

echo "Display resolution set to 1680x1050 on the main display."
