#!/bin/bash
### tray.sh
### Toggles stalonetray

pidfile="/tmp/trayer_pid"
if [ -f $pidfile ]; then
	kill -9 $(cat $pidfile)
	rm -rf $pidfile
	exit
fi
trayer --edge top --widthtype request --heighttype request --expand true &
echo $! > $pidfile
