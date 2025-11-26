#!/bin/bash

# =================================================
# Mac Display Reset Script (External Monitors Only)
# =================================================

# Detect connected displays
echo
echo "Detecting connected displays..."
system_profiler SPDisplaysDataType

# Count total number of displays
TOTAL_DISPLAY_COUNT=$(system_profiler SPDisplaysDataType | awk '/^[[:space:]]{8}[A-Za-z0-9]/ {count++} END {print count}')

if [ "$TOTAL_DISPLAY_COUNT" -eq 0 ]; then
    echo "Warning: No displays detected. All monitors will be reset."
else
    echo "Total displays detected: $TOTAL_DISPLAY_COUNT"
fi

# Remove user display configuration
echo
echo "Removing user display configuration..."
USER_PLISTS=$(find "${HOME}/Library/Preferences/ByHost/" -name "com.apple.windowserver.displays.*.plist")
if [ -n "$USER_PLISTS" ]; then
    echo "Found the following user plist files:"
    ls -ltrah $USER_PLISTS
    rm -v $USER_PLISTS
else
    echo "No user display plist files found."
fi

# Remove system display configuration
echo
echo "Removing system display configuration..."
if [ -f /Library/Preferences/com.apple.windowserver.displays.plist ]; then
    sudo rm -v /Library/Preferences/com.apple.windowserver.displays.plist
else
    echo "No system display plist found."
fi

# Check remaining plist files
echo
echo "Checking if display configuration files still exist..."
find "${HOME}/Library/Preferences/ByHost/" -name "com.apple.windowserver.displays.*.plist"
ls -l /Library/Preferences/com.apple.windowserver.displays.plist 2>/dev/null

echo
echo "Done."
echo
echo "Shutdown your Mac"
echo "Remove power from your Mac and external displays for 5 minutes"
echo
echo "Power on after 5 minutes. External monitors should reset automatically on next login."
