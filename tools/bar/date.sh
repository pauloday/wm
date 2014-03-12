#!/bin/bash
### date.sh n
### Outputs time every n seconds

source $wm/style.sh

while true; do
	time=$(date +"%_I:%M %p")
	date=$(date +"%D")
	echo "$date $time"
	sleep $1
done
