#!/bin/bash
### toggle_file.sh file
### Displays a file with dzen2, width and height are calculated automatically
### If a file is already being displayed, it will be replaced.
### If no arguments are provided, or file currently displayed, undisplay file

source $wm/style.sh

pidfile="/tmp/file_display_pid"
if [ -f $pidfile ]; then
	kill -9 $(cat $pidfile)
	rm -rf $pidfile
	exit
fi

file=$1
if [ -z "$file" ]; then
	exit
fi

events="onstart=uncollapse"
font="Droid Sans Mono:size=10"
lines=$(expr $(cat $file | wc -l) - 1)
cat $file | dzen2 -p -y 0 -ta l -sa l -fn "$font" -l $lines -e "$events" &
echo $! > $pidfile
