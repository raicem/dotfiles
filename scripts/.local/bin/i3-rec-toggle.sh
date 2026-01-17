#!/bin/bash

# This script is designed to be used with i3blocks
#
# It displays the recording status and allows you to start/stop
# recording by clicking on the block in your i3bar.

RECORD_PID_FILE="/tmp/screenrec.pid"

# The command that i3blocks sends to refresh this block
# (must match the 'signal' in your i3blocks.conf)
REFRESH_SIGNAL=10

# Left-click action
if [ "${BLOCK_BUTTON:-0}" -eq 1 ]; then
    if [ -f "$RECORD_PID_FILE" ]; then
        # If recording, stop it
        ~/.local/bin/rec-stop.sh
    else
        # If not recording, check if we are already in the selection phase
        if pgrep -x "slop" > /dev/null; then
            notify-send "Already selecting region"
        else
            # Start recording in background
            nohup ~/.local/bin/rec-start.sh > /tmp/rec-start.log 2>&1 &
        fi
    fi
    # Tell i3blocks to refresh this block immediately after the action
    pkill -SIGRTMIN+$REFRESH_SIGNAL i3blocks
fi

# Display logic: This runs on every interval and after a click
if [ -f "$RECORD_PID_FILE" ]; then
    # Recording is in progress
    echo "<span color='#FF6347'>⏹</span>"
    echo "⏹"
else
    # Not recording
    echo "⏺"
fi
