#!/bin/bash
# This script is meant for use with i3blocks.
# It shows the current power profile using powerprofilesctl.
# On left-click (BLOCK_BUTTON=1), it cycles to the next profile.

# Extract only the profile names (without extra info) by filtering the correct lines and removing the colon.
profiles=($(powerprofilesctl list \
    | grep -E '^(\*| {2}[^ ])' \
    | sed -e 's/^\* //' -e 's/^  //' -e 's/://'))

# Extract the current active profile, remove the asterisk and trailing colon.
current=$(powerprofilesctl list \
    | grep '^\*' \
    | sed -e 's/^\* //' -e 's/://')

# If the block was clicked (left-click), cycle to the next profile.
if [ "$BLOCK_BUTTON" = "1" ]; then
    next_index=0
    # Find the index of the current profile in the array.
    for i in "${!profiles[@]}"; do
        if [ "${profiles[$i]}" = "$current" ]; then
            next_index=$(( (i + 1) % ${#profiles[@]} ))
            break
        fi
    done
    next_profile="${profiles[$next_index]}"
    # Set the new profile.
    powerprofilesctl set "$next_profile"
    # Update the current variable immediately.
    current="$next_profile"
fi

# Output the current profile for i3blocks.
echo "$current"
