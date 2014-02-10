#!/bin/bash
### desktops.sh
### Reads a line from controller.sh list and styles it for dzen

source $wm/style.sh
occupied_color=${colors[fg]}
free_color=${colors[brightcyan]}
bg_color=${colors[bg]}

while read line; do
	echo $line |
	sed "s/:O/^fg($bg_color)^bg($occupied_color)/g" |
	sed "s/:F/^fg($bg_color)^bg($free_color)/g" |
	sed "s/:f/^fg($free_color)^bg($bg_color)/g" |
	sed "s/:o/^fg($occupied_color)^bg($bg_color)/g" |
	sed "s/$/█/"
done
