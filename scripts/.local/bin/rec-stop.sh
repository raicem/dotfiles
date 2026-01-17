#!/bin/bash

RECORD_PID_FILE="/tmp/screenrec.pid"

if [ -f "$RECORD_PID_FILE" ]; then
    PID_TO_KILL=$(cat "$RECORD_PID_FILE")
    
    # Check if the process is actually running before trying to kill it
    if ps -p "$PID_TO_KILL" > /dev/null; then
        kill "$PID_TO_KILL"
        rm "$RECORD_PID_FILE"
        # Signal i3blocks to update the recording status
        pkill -SIGRTMIN+10 i3blocks
        notify-send "Recording stopped" "The video has been saved."
    else
        # The process is not running, but the PID file exists. Clean it up.
        rm "$RECORD_PID_FILE"
        notify-send "No active recording found" "Cleaned up stale PID file."
    fi
else
    notify-send "No active recording"
fi
