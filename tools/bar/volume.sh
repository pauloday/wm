#!/bin/bash
### volume.sh
### output volume information, formatted for dzen

source $wm/style.sh

volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)
icons="$tools/bar/icons"

if [ "$mute" == true ]; then
	style="^fg($red)^i($icons/spkr_02.xbm) "
else
	style="^fg($green)^i($icons/spkr_01.xbm) "
fi

echo "$style$volume% ^fg()|"
