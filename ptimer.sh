#!/bin/bash

# Check if espeak is installed
if ! command -v espeak &> /dev/null; then
    echo "espeak is not installed. Installing espeak..."
    sudo apt update && sudo apt install -y espeak
fi

# Set the timer
if [ -n "$1" ]; then
    # If a parameter is provided, use it as the scheduled time
    echo "Setting timer for $1"
    echo "espeak 'times up'" | at "$1"
else
    # No parameter provided, add 45 minutes to the current time
    TIME=$(date -d "+45 minutes" +"%H:%M")
    echo "No time parameter provided. Setting a 45-minute timer (ends at $TIME)"
    echo "espeak 'times up'" | at "$TIME"
fi

# Confirm the task has been scheduled
echo "Scheduled timers:"
atq
