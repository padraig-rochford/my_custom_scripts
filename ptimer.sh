#!/bin/bash

# Check if espeak is installed
if ! command -v espeak &> /dev/null; then
    echo "espeak is not installed. Installing espeak..."
    sudo apt update && sudo apt install -y espeak
fi

# Check if notify-send is installed
if ! command -v notify-send &> /dev/null; then
    echo "notify-send is not installed. Installing notify-send..."
    sudo apt install -y libnotify-bin
fi

# Define the function to be called by the 'at' command
schedule_notification() {
    espeak "times up"
    notify-send "Time's Up" "Your timer has ended!"
}

# Set the timer
if [ -n "$1" ]; then
    # If a parameter is provided, use it as the scheduled time
    echo "Setting timer for $1"
    echo "$(declare -f schedule_notification); schedule_notification" | at "$1"
else
    # No parameter provided, add 45 minutes to the current time
    TIME=$(date -d "+45 minutes" +"%H:%M")
    echo "No time parameter provided. Setting a 45-minute timer (ends at $TIME)"
    echo "$(declare -f schedule_notification); schedule_notification" | at "$1"
fi

# Confirm the task has been scheduled
echo "Scheduled timers:"
atq
