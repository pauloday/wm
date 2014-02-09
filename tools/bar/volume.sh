#!/bin/bash
### volume.sh
### output volume information, formatted for dzen

source $wm/style.sh

volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" == true ]; then
	style="^fg(${colors[red]})"
else
	style="^fg(${colors[green]})"
fi

echo "$style$volume% ^fg(${colors[grey]})|"
