#!/bin/bash
### pager.sh [add|remove]
### GUI for controller.sh

mode=$1

case $mode in
	add)
		name=$(ls -w 1 $wm/autorun_files | $base/menu.sh)
		if [ $name ]; then
			$base/controller.sh add $name
		fi
		;;
	remove)
		name=$(bspc query -D | $base/menu.sh)
		if [ $name ]; then
			$base/controller.sh remove $name
		fi
		;;
esac
