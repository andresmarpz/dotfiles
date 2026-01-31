#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dev Layout
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💻
# @raycast.packageName Window Management

# Documentation:
# @raycast.description Focus Kitty (left 40%) + Cursor (right 60%)
# @raycast.author Andres

osascript <<'EOF'
use framework "AppKit"

set screen to current application's NSScreen's mainScreen()
set frame to screen's visibleFrame()
set screenWidth to (item 1 of item 2 of frame) as integer
set screenHeight to (item 2 of item 2 of frame) as integer

set kittyWidth to (screenWidth * 40 / 100) as integer
set cursorWidth to screenWidth - kittyWidth

tell application "System Events"
    tell process "kitty"
        set frontmost to true
        set position of window 1 to {0, 25}
        set size of window 1 to {kittyWidth, screenHeight}
    end tell
    tell process "Cursor"
        set frontmost to true
        set position of window 1 to {kittyWidth, 25}
        set size of window 1 to {cursorWidth, screenHeight}
    end tell
end tell
EOF
