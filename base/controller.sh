#!/bin/bash
### desktops.sh [list|add|remove] <desktop>
### Control or query desktops
### list prints information to stdout formatted like:
###	":[O|o|F|f] <desktop1> [...] <desktop2>"
### 	where a o means occupied, f means free, and a capital letter means focused

## get_simple_name desktop
## removes the n/ from the front of a desktop name
get_simple_name() {
	echo $1 | sed 's/^[0-9]*\/\(.*\)/\1/'
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

## add_desktop name
## adds and focuses a desktop called n/name, where n is it's shortcut
##   (i.e. mod+n switches to it)
## desktop names shouldn't have the characters: ^ :
add_desktop() {
	name=$1
	num_desks=$(bspc query -D | wc -l)
	name="$(expr $num_desks + 1)/$1"
	bspc monitor -a $name
	bspc desktop -f $name
}

## remove_desktop name
## removes the named desktop and renames the others so their names match their shortcuts
## does not work if desktop is occupied
remove_desktop() {
	name=$1
	bspc monitor -r $name
	desktops=( $(bspc query -D) )
	index=1
	for desktop in "${desktops[@]}"; do
		simple_name=$(get_simple_name $desktop)
		bspc desktop $desktop -n "$index/$simple_name"
		((index++))
	done
}

### main

case $1 in
	list)
		bspc control --subscribe | format_desktop_strings
		bspc_pid=$!
		trap "kill $bspc_pid" EXIT
		;;
	add)
		add_desktop $2
		;;
	remove)
		remove_desktop $2
		;;
esac
