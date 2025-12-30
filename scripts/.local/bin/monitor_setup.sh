#!/bin/bash

# Define the internal monitor
INTERNAL="eDP-1"

# Check if an external monitor is connected
# We grep for " connected" lines, exclude the internal monitor, and count lines.
EXTERNAL_COUNT=$(xrandr --query | grep " connected" | grep -v "$INTERNAL" | wc -l)

if [ "$EXTERNAL_COUNT" -gt 0 ]; then
    # External monitor(s) connected.
    # Turn off the internal monitor.
    xrandr --output "$INTERNAL" --off
    
    # Ensure external monitors are on (optional but good practice)
    # Get names of external monitors
    EXTERNALS=$(xrandr --query | grep " connected" | grep -v "$INTERNAL" | cut -d" " -f1)
    for mon in $EXTERNALS; do
        xrandr --output "$mon" --auto
    done
else
    # No external monitor. Ensure internal is on.
    xrandr --output "$INTERNAL" --auto
fi
