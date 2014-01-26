#!/bin/bash
### switch_desks.sh [focus|window] n
### Switches focus or moves window to desk n
### If n > num_desks, and the last desk is not empty and unnamed, a unnamed desk is created
### If the last desk is unnamed and empty, it is deleted

num_desks=$(bspc query -D | wc -l)
last_desk=$(bspc query -D | tail -1)

## switch [window|focus] sel
## switches focus or window to desktop selector sel
switch() {
	case $1 in
		window)
			bspc window -d $2
			;;
		focus)
			bspc desktop -f $2
			;;
	esac
}

## name name
## returns the short name (name 2/name returns name)
name() {
	echo $1 | cut -d/ -f2
}

## windows sel 
## returns a list of windows for sel
windows() {
	echo $(bspc query -d $1 -W)
}

if [ "$2" -gt "$num_desks" ]; then
	if [ "$(name $last_desk)" -o "$(windows $last_desk)" ]; then
		name=$($base/controller.sh new)
		switch $1 "$name"
		exit
	fi
	switch $1 "^$num_desks"
	exit
fi

switch $1 "^$2"

if [ ! "$(name $last_desk)" -a ! "$(windows $last_desk)" ]; then
	if [ ! "$(bspc query -d focused -D)" = "$last_desk" ]; then
		$base/controller.sh remove $last_desk
	fi
fi
