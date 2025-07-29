#!/bin/bash

# This script is designed to be used with i3blocks
#
# It displays the recording status and allows you to start/stop
# recording by clicking on the block in your i3bar.
#
# Make sure your rec-start and rec-stop scripts are in your $PATH
# (e.g., ~/.local/bin/)

RECORD_PID_FILE="/tmp/screenrec.pid"

# The command that i3blocks sends to refresh this block
# (must match the 'signal' in your i3blocks.conf)
REFRESH_SIGNAL=10

# Left-click action
if [ "$BLOCK_BUTTON" -eq 1 ]; then
    if [ -f "$RECORD_PID_FILE" ]; then
        # If recording, stop it
        /home/raicem/bin/rec-stop.sh
    else
        # If not recording, start it
        /home/raicem/bin/rec-start.sh
    fi
    # Tell i3blocks to refresh this block immediately after the action
    pkill -SIGRTMIN+$REFRESH_SIGNAL i3blocks
fi

# Display logic: This runs on every interval and after a click
if [ -f "$RECORD_PID_FILE" ]; then
    # Recording is in progress
    # Full text: Use a red color and a recording icon (🔴)
    echo "<span color='#FF6347'>🔴 REC</span>"
    # Short text (optional):
    echo "<span color='#FF6347'>REC</span>"
else
    # Not recording
    # Full text: Use a neutral color and a different icon (⚫️)
    echo "⚫️ REC"
fi
