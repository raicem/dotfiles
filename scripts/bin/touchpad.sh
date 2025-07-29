#!/bin/bash
# Find the ID of the touchpad by its name
TOUCHPAD_ID=$(xinput list | grep "VEN_06CB:00 06CB:CE65 Touchpad" | grep -o "id=[0-9]*" | cut -d'=' -f2)
echo $TOUCHPAD_ID

if [ -n "$TOUCHPAD_ID" ]; then
    # Enable natural scrolling
    xinput set-prop "$TOUCHPAD_ID" "libinput Natural Scrolling Enabled" 1
    # Set click method (0 1 enables clickfinger behavior)
    xinput set-prop "$TOUCHPAD_ID" "libinput Click Method Enabled" 0 1
else
    echo "Touchpad not found!"
fi
