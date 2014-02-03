#!/bin/bash
### tray.sh
### Toggles stalonetray

source $wm/style.sh

pid_file="/tmp/trayer_pid"
if [ -f $pid_file ]; then
	kill -9 $(cat $pid_file)
	rm -rf $pid_file
	exit
fi
trayer --edge top --widthtype request --heighttype request --expand true &
echo $! > $pid_file
