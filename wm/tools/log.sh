#!/bin/bash
### log.sh file
### Asks the user for a line, adds that line with timestamp to file

now=$(date +"%D %_I:%M %p")
log_message="Write line for $now to $1"
log_line=$($base/menu.sh -noinput -y 200 -p "$log_message")
echo "$now: $log_line" >> ~/log
