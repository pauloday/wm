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
else
	help_string="cmd+d: add desktop, cmd+shift+d: delete desktop, cmd+a: add autorun command, cmd+[0-9]: switch to desktop [0-9], cmd+shift+[0-9]: move window to desktop [0-9], cmd+tab: switch to last used desktop"
	echo $help_string | dzen2 -y $(expr $screen_height / 3) -p -bg ${colors[grey]} &
	echo $! > $pidfile
fi
