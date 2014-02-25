#!/bin/bash
### style.sh
### this defines things like font and color
### by default it tries to get as many things as it can from xrdb

source $wm/saved_settings

color_vals=( $(xrdb -query | grep -P "color[0-9]*" | sort | cut -f 2-) )
count=0
declare -A colors
for name in black brightgreen brightyellow brightblue brightmagenta brightcyan brightwhite red green yellow blue magenta cyan white grey brightred; do
	#echo "pre; count: $count color_vals[count]: ${color_vals[$count]} name: ${name}"
	colors[${name}]=${color_vals[$count]}
	#echo "post; colors[name]: ${colors[${name}]}"
	((count++))
done
colors[fg]=$(xrdb -query | grep -P "dzen2[\.\*]foreground:" | awk '{print $NF}')
colors[bg]=$(xrdb -query | grep -P "dzen2[\.\*]background:" | awk '{print $NF}')

font=$(xrdb -query | grep -P "dzen2[\*\.]font:" | sed 's/dzen2[\*\.]font:\(.*\)/\1/' | tr -d "[:blank:]")

resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')
screen_width=$(echo $resolution | awk -Fx '{print $1}')
screen_height=$(echo $resolution | awk -Fx '{print $2}')
