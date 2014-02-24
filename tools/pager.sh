#!/bin/bash
### pager.sh [add|remove|rename]
### GUI for controller.sh

mode=$1

case $mode in
	add)
		name=$(ls -w 1 $wm/init_files | $tools/menu.sh -p "Add Desktop:")
		if [ $name ]; then
			$tools/controller.sh add $name
		fi
		;;
	remove)
		name=$(bspc query -D | $tools/menu.sh -p "Remove Desktop:")
		if [ $name ]; then
			$tools/controller.sh remove $name
		fi
		;;
	rename)
		current_desk=$(bspc query -d focused -D)
		name=$($tools/menu.sh -noinput -p "New name:")
		if [ $name ]; then
			$tools/controller.sh rename $name $current_desk
		fi
		;;
esac
