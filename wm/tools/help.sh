#!/bin/bash
### help.sh toggle
### Display some help in the middle of the screen
### Call it again to remove the help

source $wm/style.sh

mode=$1
pidfile="/tmp/help_pid"
if [ -f $pidfile ]; then
	kill -9 $(cat $pidfile)
	rm -rf $pidfile
	exit
fi
help_file="$wm/help.txt"
events="onstart=uncollapse;key_Escape=exit:0;key_Return=exit:0"
lines=$(expr $(cat $help_file | wc -l) - 1)
font="Droid Sans Mono :size=12"
cat $help_file | sed "s/c1/${colors[brightblue]}/g" |\
	dzen2 -p -y 0 -ta l -fn "$font" -l $lines -e "$events" &
echo $! > $pidfile
