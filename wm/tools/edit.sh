#!/bin/bash
### edit.sh [filename]
### Append a line to a file.
### If no filename is provided, the user is prompted for one
###   and a list of suggestions can be piped in through stdin

source $wm/style.sh

file=$1
if [ ! "$1" ]; then
	file=$(echo "" | $base/menu.sh -sb ${colors[bg]})
fi

$base/menu.sh >> $wm/autorun_files
