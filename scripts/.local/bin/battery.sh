#!/bin/bash
# This script shows the battery with the highest charge percentage for i3blocks

# Get battery info using acpi
battery_info=$(acpi -b)
battery_health_info=$(acpi -i)

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
if [[ "$time_field" =~ ([0-9]{2}):([0-9]{2}):[0-9]{2} ]]; then
    hours=${BASH_REMATCH[1]}
    mins=${BASH_REMATCH[2]}
    total_minutes=$(( 10#$hours * 60 + 10#$mins ))
    time_val="${total_minutes} min"
else
    time_val="N/A"
fi

# Get battery index from the highest_bat string (e.g. "Battery 0: ...")
bat_index=$(echo "$highest_bat" | awk -F': ' '{print $1}' | awk '{print $2}')

# Calculate power in Watts
if [ -f "/sys/class/power_supply/BAT$bat_index/power_now" ]; then
    watts=$(awk '{printf "%.0f", $1/1000000}' "/sys/class/power_supply/BAT$bat_index/power_now")
elif [ -f "/sys/class/power_supply/BAT$bat_index/current_now" ] && [ -f "/sys/class/power_supply/BAT$bat_index/voltage_now" ]; then
    current=$(cat "/sys/class/power_supply/BAT$bat_index/current_now")
    voltage=$(cat "/sys/class/power_supply/BAT$bat_index/voltage_now")
    watts=$(awk -v c="$current" -v v="$voltage" 'BEGIN {printf "%.0f", (c * v) / 1000000000000}')
else
    watts="N/A"
fi

# Format the output depending on the battery status
case "$status" in
    "Discharging")
        echo " $percentage% (-$time_val) ($watts W)"
        ;;
    "Charging")
        echo " $percentage% (+$time_val) ($watts W)"
        ;;
    "Full")
        echo " $percentage% (Full) ($watts W)"
        ;;
    *)
        echo " $percentage% ($status) ($watts W)"
        ;;
esac
