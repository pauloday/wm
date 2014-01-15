#!/bin/bash
### pager.sh [add|remove]
### GUI for controller.sh

mode=$1

case $mode in
	add)
		help_string="Name of desktop to add"
		name=$(ls -w 1 $wm/autorun_files | $tools/helped_menu.sh "$help_string")
		if [ $name ]; then
			$base/controller.sh add $name
		fi
		;;
	remove)
		help_string="Name of desktop to remove"
		name=$(bspc query -D | $tools/helped_menu.sh "$help_string")
		if [ $name ]; then
			$base/controller.sh remove $name
		fi
		;;
esac
