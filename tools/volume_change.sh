#!/bin/bash
### volume_change.sh n
### Changes volume by n%. If n is 0, toggle mute

if [ "$1" -eq "0" ]; then
	pamixer --toggle-mute
else
	pamixer --unmute
	pamixer --increase $1
fi

$tools/bar/volume.sh | $tools/multiplexer.sh right_bar 0
