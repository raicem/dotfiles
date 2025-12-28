#!/bin/bash
# Chronometer for i3blocks
# The timer counts when the script is running (system is awake)
# When system suspends/hibernates, the script terminates and stops counting
# Right-click (BLOCK_BUTTON == 3) resets the counter.

# Path to the file that stores the total elapsed seconds
FILE="$HOME/.cache/chronometer_total"
# Create directory if it doesn't exist
mkdir -p "$(dirname "$FILE")"

# Initialize the file if it doesn't exist
if [ ! -f "$FILE" ]; then
    echo "0" > "$FILE"
fi

# If right-click is detected, reset the timer
if [ "$BLOCK_BUTTON" = "3" ]; then
    echo "0" > "$FILE"
    exit 0
fi

# Read the current total time from the file
total=$(cat "$FILE")

# Check if the monitor is on - only increment if it is
if xset -q | grep -q "Monitor is On"; then
    # Increment the counter by the i3blocks refresh interval (typically 1 second)
    # This ensures we only count time while the script is actually running
    # When system suspends, the script stops running and stops counting
    total=$((total + 1))
    
    # Save the updated total
    echo "$total" > "$FILE"
fi

# Convert total seconds to hours, minutes, and seconds
hours=$((total / 3600))
minutes=$(((total % 3600) / 60))
seconds=$((total % 60))

# Check if we've reached 40 hours
if [ "$hours" -ge 40 ]; then
    printf "%02d:%02d:%02d ✓\n" "$hours" "$minutes" "$seconds"
else
    printf "%02d:%02d:%02d\n" "$hours" "$minutes" "$seconds"
fi
