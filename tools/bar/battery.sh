#!/bin/bash
### battery.sh n
### Outputs colorized battery percentage every n seconds

source $wm/style.sh

while true; do
	battery=$(acpi -b | cut -d" " -f4 | tr -d "%,")
	charging=$(acpi -b | cut -d" " -f3 | tr -d ',')
	case "$charging" in
		Charging)
			battery="^fg(${colors[green]})$battery"
			;;
		Unknown)
			battery="^fg(${colors[green]})$battery"
			;;
		Discharging)
			if [ "$battery" -lt "50" ]; then
				battery="^fg(${colors[yellow]})$battery"
			elif [ "$battery" -lt "15" ]; then
				battery="^fg(${colors[red]})$battery"
			fi
			;;
	esac
	echo "^fg()$battery% ^fg(${colors[grey]})|"
	sleep $1
done
