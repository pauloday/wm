#!/bin/bash
### battery.sh n
### Outputs colorized battery percentage every n seconds

source $wm/style.sh

icons="$tools/bar/icons"
while true; do
	battery=$(acpi -b | cut -d" " -f4 | tr -d "%,")
	charging=$(acpi -b | cut -d" " -f3 | tr -d ',')
	style="^i($icons/bat_full_02.xbm)$battery"
	case "$charging" in
		Charging)
			style="^i($icons/ac_01.xbm)"
			;;
		Unknown)
			style="^i($icons/ac_01.xbm)"
			;;
		Discharging)
			if [ "$battery" -lt "50" ]; then
				style="^fg(${colors[yellow]})^i($icons/bat_low_02.xbm)"
			elif [ "$battery" -lt "15" ]; then
				style="^fg(${colors[red]})^ i($icons/bat_empty_02.xbm)"
			fi
			;;
	esac
	echo "^fg()$style $battery% ^fg(${colors[grey]})|"
	sleep $1
done
