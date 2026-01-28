#!/bin/bash
# Workday Countdown for i3blocks
# Counts down from 8 hours (28800 seconds).
# Decrements when the script is running and Monitor is On.
# Right-click (BLOCK_BUTTON == 3) resets the counter to 8 hours.

# Path to the file that stores the remaining seconds
FILE="$HOME/.cache/work_countdown"
DATE_FILE="$HOME/.cache/work_countdown_date"
mkdir -p "$(dirname "$FILE")"

# 8 hours in seconds
START_SECONDS=28800
TODAY=$(date +%Y-%m-%d)

# Daily reset logic: If the date has changed, reset the timer to 8 hours.
if [ ! -f "$DATE_FILE" ] || [ "$(cat "$DATE_FILE")" != "$TODAY" ]; then
    echo "$START_SECONDS" > "$FILE"
    echo "$TODAY" > "$DATE_FILE"
fi

# Initialize the file if it doesn't exist
if [ ! -f "$FILE" ]; then
    echo "$START_SECONDS" > "$FILE"
fi

# If right-click is detected, reset the timer
# Handle Click Events
if [ -n "$BLOCK_BUTTON" ]; then
    # 30 minutes in seconds
    ADJUST_AMOUNT=1800
    
    # Read current value
    current=$(cat "$FILE")
    
    if [ "$BLOCK_BUTTON" = "1" ]; then
        # Left click: Decrease by 30 mins
        current=$((current - ADJUST_AMOUNT))
    elif [ "$BLOCK_BUTTON" = "3" ]; then
        # Right click: Increase by 30 mins
        current=$((current + ADJUST_AMOUNT))
    fi
    
    echo "$current" > "$FILE"
    
    # We want to display the time immediately after update, but skip the decrement logic below.
    # We can just skip to the display part.
    # However, since the variables below are calculated from $val which is set later, 
    # we need to make sure we don't execute the "monitor on" decrement block.
    # Easier to just set a flag or structure appropriately.
else
    # Normal execution (no click)
    
    # Read the current remaining time
    current=$(cat "$FILE")

    # Check if the monitor is on - only decrement if it is
    if xset -q | grep -q "Monitor is On"; then
        current=$((current - 1))
        echo "$current" > "$FILE"
    fi
fi

# Handle display logic (including negative values for overtime)
if [ "$current" -lt 0 ]; then
    sign="-"
    val=$(( -1 * current ))
else
    sign=""
    val=$current
fi

hours=$((val / 3600))
minutes=$(((val % 3600) / 60))

# Display formatted time
printf "%s%02d:%02d\n" "$sign" "$hours" "$minutes"
