#!/bin/bash
### date.sh n
### Outputs time every n seconds

while true; do
	echo $(date +"%D %_I:%M %p")
	sleep $1
done
