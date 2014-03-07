#!/bin/bash
### timer.sh time event
### outputs "$time until $event"
### where $time counts down to 0 by minute

time=$1; shift
event="minutes until $@"

# countdown event delay time
# outputs countdown event every $delay seconds, counting down $time
# event consists of $time $event
countdown() {
	time=$3
	delay=$2
	event=$1
	while [ $time -gt 1 ]; do
		echo $time $event
		((time--))
		sleep $delay
	done
}

trap "echo '
'" EXIT
countdown "$event" 60 $time

time=60
event="seconds until $@"

countdown "$event" 1 $time

prompt_string="It's time for $event! What are you going to do? "
log_event=$($tools/menu.sh -noinput -p "$prompt_string")
echo "$(date +"%_I:%M %p"): $event -> $log_event" >> ~/.log/timer_events
echo ""
