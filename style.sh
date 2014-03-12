#!/bin/bash
### style.sh
### this defines things like font and color
### by default it tries to get as many things as it can from xrdb

source $wm/saved_settings

## invert_colors string
## prints string with a inverted color scheme
invert_colors() {
	echo "^fg($bg)^bg($fg)$1\
		 ^fg($fg)^bg($bg)"
 }

colors=( $(xrdb -query | grep -P "color[0-9]*" | sort | cut -f 2-) )
color_names=(
	black
	brightgreen 
	brightyellow
	brightblue
	brightmagenta
	brightcyan
	brightwhite
	red
	green
	yellow
	blue
	magenta
	cyan
	white
	grey
	brightred )
count=0

for name in ${colors[@]}; do
	eval "${color_names[$count]}=$name"
	((count++))
done

fg=$(xrdb -query | grep -P "dzen2[\.\*]foreground:" | awk '{print $NF}')
bg=$(xrdb -query | grep -P "dzen2[\.\*]background:" | awk '{print $NF}')

font=$(xrdb -query | grep -P "dzen2[\*\.]font:" | sed 's/dzen2[\*\.]font:\(.*\)/\1/' | tr -d "[:blank:]")

resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')
screen_width=$(echo $resolution | awk -Fx '{print $1}')
screen_height=$(echo $resolution | awk -Fx '{print $2}')
