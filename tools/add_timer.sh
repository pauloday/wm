#!/bin/bash
### provides a gui to add a timer to the bar

event=$($tools/menu.sh -noinput -p "Count down until: ")
if [ "$event" ]; then
	echo h
	time=$($tools/menu.sh -noinput -p "Minutes until $event: ")
	if [ ! -z "$time" ]; then
		$tools/bar/timer.sh $time "$event" | $tools/multiplexer.sh left_bar
	fi
fi
