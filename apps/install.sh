#!/bin/bash

# Define arrays for different file types
pkg_files=(
  'pkg_files/OPAutoClicker.pkg'
)

dmg_files=(
  # Add your .dmg files here
)

app_files=(
  # Add your .app files here
)

# Function to handle .pkg files
handle_pkg() {
  local pkg_file="$1"

  # Remove quarantine attribute
  sudo xattr -dr com.apple.quarantine "$pkg_file"

  # Install the package
  sudo installer -store -pkg "$pkg_file" -target /
}

# Function to handle .dmg files
handle_dmg() {
  local dmg_file="$1"

  # Mount the DMG
  MOUNTDEV=$(hdiutil mount "$dmg_file" | awk '/dev.disk/{print$1}')
  MOUNTDIR="$(mount | grep $MOUNTDEV | awk '{$1=$2="";sub(" [(].*","");sub("^  ","");print}')"

  # Find and install .pkg files within the DMG
  find "$MOUNTDIR" -name "*.pkg" -print0 | while IFS= read -r -d $'\0' pkg_file; do
    handle_pkg "$pkg_file"
  done

  # Find and install .app files within the DMG
  find "$MOUNTDIR" -name "*.app" -print0 | while IFS= read -r -d $'\0' app_file; do
    # Move .app to Applications folder
    mv "$app_file" "/Applications/"
  done

  # Unmount the DMG
  hdiutil unmount "$MOUNTDIR"
}

# Process .pkg files
for pkg_file in "${pkg_files[@]}"; do
  handle_pkg "$pkg_file"
done

# Process .dmg files
for dmg_file in "${dmg_files[@]}"; do
  handle_dmg "$dmg_file"
done

# Process .app files
for app_file in "${app_files[@]}"; do
  mv "$app_file" "/Applications/"
done
