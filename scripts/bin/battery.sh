#!/bin/bash
# This script shows the battery with the highest charge percentage for i3blocks

# Get battery info using acpi
battery_info=$(acpi -b)

# Check if we got any output
if [ -z "$battery_info" ]; then
    echo " No battery found"
    exit 0
fi

# Find the battery with the highest percentage
highest_bat=""
highest_percent=0

while IFS= read -r line; do
    # Extract percentage from the line
    percentage=$(echo "$line" | awk -F', ' '{print $2}' | tr -d '%')
    
    # Skip if percentage can't be parsed as a number
    if ! [[ "$percentage" =~ ^[0-9]+$ ]]; then
        continue
    fi
    
    # Update if this battery has a higher percentage
    if [ "$percentage" -gt "$highest_percent" ]; then
        highest_percent=$percentage
        highest_bat="$line"
    fi
done <<< "$battery_info"

# If no valid battery was found
if [ -z "$highest_bat" ]; then
    echo " No valid battery found"
    exit 0
fi

# Extract fields from the selected battery line
status=$(echo "$highest_bat" | awk -F', ' '{print $1}' | awk '{print $NF}')
percentage=$highest_percent
time_field=$(echo "$highest_bat" | awk -F', ' '{print $3}')

# If time_field contains a valid HH:MM:SS, extract it; otherwise, set to "N/A"
if [[ "$time_field" =~ [0-9]{2}:[0-9]{2}:[0-9]{2} ]]; then
    time_val=$(echo "$time_field" | awk '{print $1}')
else
    time_val="N/A"
fi

# Format the output depending on the battery status
case "$status" in
    "Discharging")
        echo " $percentage% (-$time_val)"
        ;;
    "Charging")
        echo " $percentage% (+$time_val)"
        ;;
    "Full")
        echo " $percentage% (Full)"
        ;;
    *)
        echo " $percentage% ($status)"
        ;;
esac
