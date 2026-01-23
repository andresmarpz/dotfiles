#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Kitty Here
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐱
# @raycast.packageName Dev Tools

# Documentation:
# @raycast.description Open Kitty tab in Zed's current project directory
# @raycast.author Andres

# Get the frontmost Zed window title (the one you're looking at)
zed_title=$(osascript -e '
tell application "Zed"
    if (count of windows) > 0 then
        return name of front window
    end if
end tell
' 2>/dev/null)

if [[ -z "$zed_title" ]]; then
    echo "No Zed window found"
    exit 1
fi

# Extract project name from title - Zed format: "filename — project_folder" or just project
if [[ "$zed_title" == *" — "* ]]; then
    project_name="${zed_title##* — }"
else
    project_name="$zed_title"
fi

# Try to find the actual path - check common locations
for base in "$HOME/development" "$HOME/projects" "$HOME/code" "$HOME"; do
    if [[ -d "$base/$project_name" ]]; then
        target_dir="$base/$project_name"
        break
    fi
done

# Fallback: home directory
target_dir="${target_dir:-$HOME}"

# Open new Kitty tab in target directory
if kitty @ --to unix:/tmp/kitty launch --type=tab --cwd="$target_dir" 2>/dev/null; then
    kitty @ --to unix:/tmp/kitty focus-window 2>/dev/null
    open -a kitty
else
    # Fallback: open new Kitty window if remote control fails
    open -a kitty "$target_dir"
fi

echo "Opened Kitty in: $target_dir"
