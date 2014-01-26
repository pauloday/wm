#!/bin/bash
### desktops.sh [list|add|new|remove|rename newname] <desktop>
### Control or query desktops
### For remove and rename, desktop can be either "n/name" or just "name"
### Add switches and executes autorun file, new simply adds
### list prints information to stdout formatted like:
###	":[O|o|F|f] <desktop1> [...] <desktop2>"
### 	where a o means occupied, f means free, and a capital letter means focused

## get_simple_name desktop
## removes the n/ from the front of a desktop name
get_simple_name() {
	echo $1 | cut -d/ -f2
}

## get_full_name name
## Gets the full desktop name for name
## name only has to be enough to uniquely identify the desktop
get_full_name() {
	bspc query -D | grep $1
}

## format_desktop_string string
## string is in the format from "bspc control --subscribe"
format_desktop_string() {
	desktops=$(echo $1 | tr ":" " " | awk '{for (i=2; i<NF; i++) print $i}')
	output=""
	for desktop in $desktops; do
		output="$output $(echo $desktop | sed 's/^\(.\)\(.*\)/:\1 \2/')"
	done
	echo $output
}

## echo <string> | format_desktop_strings
## formats a stream of newline separated strings with format_desktop_string
format_desktop_strings() {
	while read line; do
		format_desktop_string $line
	done
}

## new_desktop name
## creates a new desktop, name optional
## prints the full name of the new desk to stdout
new_desktop() {
	name=$1
	num_desks=$(bspc query -D | wc -l)
	name="$(expr $num_desks + 1)/$1"
	bspc monitor -a $name
	echo $name
}

## add_desktop name
## adds and focuses a desktop called n/name, where n is it's shortcut
##   (i.e. mod+n switches to it)
## desktop names shouldn't have the characters: ^ :
add_desktop() {
	if [ ! $name ]; then
		return 1
	fi
	name=$(new_desktop $1)
	bspc desktop -f $name
	$wm/autorun_files/$1
}

## remove_desktop name
## removes the named desktop and renames the others so their names match their shortcuts
## does not work if desktop is occupied
remove_desktop() {
	name=$(get_full_name $1)
	bspc monitor -r $name
	desktops=( $(bspc query -D) )
	index=1
	for desktop in "${desktops[@]}"; do
		simple_name=$(get_simple_name $desktop)
		bspc desktop $desktop -n "$index/$simple_name"
		((index++))
	done
}

## rename_desktop name new
## Renames named desktop to n/new
rename_desktop() {
	num=$(echo $(get_full_name $1) | cut -d/ -f1)
	bspc desktop $1 -n "$num/$2"
}

### main
name=$2
case $1 in
	list)
		( bspc control --subscribe & echo $! >&3 ) 3>pid | format_desktop_strings
		trap "kill $(<pid)" EXIT
		;;
	add)
		add_desktop $name
		;;
	new)
		new_desktop $name
		;;
		
	remove)
		remove_desktop $name
		;;
	rename)
		new=$2
		name=$3
		rename_desktop $name $new
		;;
esac
