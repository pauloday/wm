#!/bin/bash
### log.sh
### Asks the user for a line, and adds that line to a log file at ~/log

log_message="Write line to log file:"
log_line=$($base/menu.sh -noinput -y 200 -p "$log_message")
now=$(date +"%D %_I:%M %p")
echo "$now: $log_line" >> ~/log
