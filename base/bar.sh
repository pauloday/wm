#!/bin/bash
### bar
### Usage: bar.sh [top|bottom|n] [options]
### Displays a bar at the top, bottom, or nth pixel down
### Options are dzen2 options

source $wm/style.sh

side=$1
shift

case $side in
	top)
		dzen2_opts="-y 0"
		;;
	bottom)
		dzen2_opts="-y $screen_height"
		;;
	*)
		dzen2_opts="-y $side"
esac

dzen2 $dzen2_opts $@
