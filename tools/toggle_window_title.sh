#!/bin/bash
### toggle_window_title.sh
### displays a bar at the top of the screen with the window title

source $wm/style.sh
pidfile="/tmp/win_title_pid"

if [ -f $pidfile ]; then
	kill -9 $(cat $pidfile)
	bspc config top_padding 0
	rm -rf $pidfile
	exit
fi

xtitle -s | dzen2 -ta c -y 0 &
bspc config top_padding $(expr $bar_padding + $window_gap)
echo $! > $pidfile
