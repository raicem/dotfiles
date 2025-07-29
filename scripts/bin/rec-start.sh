#!/bin/bash

RECORD_PID_FILE="/tmp/screenrec.pid"
VIDEO_DIR=~/Videos

if [ -f "$RECORD_PID_FILE" ]; then
    notify-send "Recording already in progress"
    exit 1
fi

# Ensure the video directory exists
mkdir -p "$VIDEO_DIR"

FILENAME="$VIDEO_DIR/screen_$(date '+%Y-%m-%d_%H-%M-%S').mp4"
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

# Select region and start recording
# The 'eval' command is used to set the W, H, X, and Y variables from slop's output
if ! slop_geometry=$(slop -f 'W=%w H=%h X=%x Y=%y'); then
    # Exit if no region is selected (e.g., user presses Esc)
    exit 1
fi

eval "$slop_geometry"

ffmpeg -f x11grab -framerate 30 -video_size ${W}x${H} -i :0.0+${X},${Y} -preset ultrafast "$FILENAME" &
echo $! > "$RECORD_PID_FILE"

notify-send "Recording started" "Output file: $FILENAME"
