# Set the path to the background picture
BACKGROUND_PICTURE_PATH="../images/wolf.jpeg"

# Check if the file exists
if [ -f "$BACKGROUND_PICTURE_PATH" ]; then
    # Set the desktop background for all monitors
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$BACKGROUND_PICTURE_PATH\""
else
    echo "File not found: $BACKGROUND_PICTURE_PATH"
fi
