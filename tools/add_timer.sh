#!/bin/bash
### provides a gui to add a timer to the bar

event=$($tools/menu.sh -noinput -p "Count down until: ")
time=$($tools/menu.sh -noinput -p "Minutes until $event: ")

$tools/bar/timer.sh $time "$event" | $tools/multiplexer.sh left_bar
