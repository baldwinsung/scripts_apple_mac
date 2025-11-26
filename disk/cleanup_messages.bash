#!/bin/bash

# Source directory
SRC_DIR="$HOME/Library/Messages/Attachments"

# Destination directory
DEST_DIR="/some-other-disk"

# Create destination folder if it doesn't exist
mkdir -p "$DEST_DIR"

# Find all files >100MB and move them
find "$SRC_DIR" -type f -size +100M -print0 | while IFS= read -r -d '' file; do
    # Preserve directory structure inside DEST_DIR (optional)
    REL_PATH="${file#$SRC_DIR/}"
    DEST_PATH="$DEST_DIR/$REL_PATH"
    
    # Create subdirectories if needed
    mkdir -p "$(dirname "$DEST_PATH")"
    
    # Move the file
    mv "$file" "$DEST_PATH"
    echo "Moved: $file → $DEST_PATH"
done

echo "All large files moved to $DEST_DIR."
