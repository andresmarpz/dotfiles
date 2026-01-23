#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dev Layout
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💻
# @raycast.packageName Window Management

# Documentation:
# @raycast.description Focus Kitty (left 1/3) + Zed (right 2/3)
# @raycast.author Andres

osascript <<'EOF'
use framework "AppKit"

set screen to current application's NSScreen's mainScreen()
set frame to screen's visibleFrame()
set screenWidth to (item 1 of item 2 of frame) as integer
set screenHeight to (item 2 of item 2 of frame) as integer

set thirdWidth to screenWidth div 3
set twoThirdsWidth to screenWidth - thirdWidth

tell application "System Events"
    tell process "kitty"
        set frontmost to true
        set position of window 1 to {0, 25}
        set size of window 1 to {thirdWidth, screenHeight}
    end tell
    tell process "Zed"
        set frontmost to true
        set position of window 1 to {thirdWidth, 25}
        set size of window 1 to {twoThirdsWidth, screenHeight}
    end tell
end tell
EOF
