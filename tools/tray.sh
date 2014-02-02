#!/bin/bash
### tray.sh
### Toggles stalonetray

source $wm/style.sh

pid_file="/tmp/stalonetray_pid"
if [ -f $pid_file ]; then
	kill -9 $(cat $pid_file)
	rm -rf $pid_file
	exit
fi
stalonetray -bg "${colors[bg]}" &
echo $! > $pid_file
