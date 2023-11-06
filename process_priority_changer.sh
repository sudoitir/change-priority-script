#!/bin/bash

# Get the top 10 processes sorted by CPU usage
top_processes=$(ps aux --sort=-%cpu | head -11 | tail -n +2)

# Define colors for formatting the table and errors
color_cyan="\e[36m"
color_green="\e[32m"
color_red="\e[31m"
color_reset="\e[0m"

# Center-align function
center_align() {
    local text="$1"
    local length="$2"
    local padding=$(( (length - ${#text}) / 2 ))
    local left_padding=$((padding))
    local right_padding=$((length - ${#text} - left_padding))
    printf "| %*s%s%*s " "$left_padding" "" "$text" "$right_padding"
}

# Display the chart header in cyan
center_align "PID" 8
center_align "App Name" 20
center_align "CPU Usage (%)" 18
center_align "RAM Usage (KB)" 15
center_align "Priority" 8
echo "|"

# Display the information for each process
while read -r line; do
    pid=$(echo "$line" | awk '{print $2}')
    command=$(echo "$line" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}')
    full_app_name=$(basename "$command" | awk '{print $1}')
    app_name=$(echo "$full_app_name" | cut -c -15) # Truncate to 15 characters
    cpu_usage=$(echo "$line" | awk '{print $3}')
    ram_usage=$(echo "$line" | awk '{print $6}')
    priority=$(ps -o ni= -p "$pid") # Get current priority

    center_align "$pid" 8
    center_align "$app_name" 20
    center_align "$cpu_usage" 18
    center_align "$ram_usage" 15
    center_align "$priority" 8
    echo "|"  # Reset color after each row
done <<< "$top_processes"

# Prompt the user to enter the PID to change CPU priority
read -p "Enter the PID to change CPU priority (e.g., 123): " pid

# Check if the entered PID is valid
if ps -p "$pid" &> /dev/null; then
    # Prompt the user to enter the new priority level
    echo -e "Enter the new CPU priority level (e.g., 10 for low priority, -10 for high priority):"
    read -p "New Priority: " new_priority

    # Attempt to change the priority (niceness) for the specified PID to the user-specified level
    renice "$new_priority" "$pid" 2>/dev/null

    # Check the exit status to determine if 'sudo' is needed
    if [ $? -eq 0 ]; then
        echo "Changed priority for PID $pid to $new_priority"
    else
        echo -e "${color_red}Permission denied. Attempting to run with sudo...${color_reset}"
        sudo renice "$new_priority" "$pid"
        if [ $? -eq 0 ]; then
            echo "Changed priority for PID $pid to $new_priority with sudo"
        else
            echo -e "${color_red}Failed to change priority for PID $pid${color_reset}"
        fi
    fi
else
    echo -e "${color_red}Invalid PID or process not found for PID $pid${color_reset}"
fi
