#!/bin/bash
### multiplexer.sh barname [section]
### Barname is a identifier provided by the user for a particular bar
### Section is a identifier provided by this script for a section of a bar
### This script either creates a bar:
###	multiplexer.sh name [dzen options]
### Or outputs to a section of an existing bar
###	pwd | multiplexer.sh name section (output to a specific section)
###	pwd | multiplexer.sh name 	  (ouput to the next section)
### Sections are always identified by a number, starting at 0

dir="/tmp/multiplex_$1"
dzen_pipe="$dir/.dzen"
shift

## gather_strings dir
## multiplexes the last line of each file in dir
gather_strings() {
	string=" "
	for file in $1/* ; do
		string="$string $(cat $file | tail -1)"
	done 
	echo $string
}

## get_section dir arg
## If arg exists and is a number, return it
## Else return the next section id from dir
get_section() {
	if [ "$2" -eq "$2" ] 2>/dev/null; then # arg is a number
		echo $2
		exit
	fi
	last_section=$(ls -w 1 $1 | tail -1)
	if [ "$last_section" -eq "$last_section" ] 2>/dev/null; then
		echo $(expr $last_section + 1)
		exit
	fi
	echo 0
}

if [ -d "$dir" ]; then
	if ! ps -p $(cat $dir/.pid); then
		tail -f $dzen_pipe | dzen2 $@ &
		echo $! > $dir/.pid
	fi
	section=$(get_section $dir $1)
	while read line; do
		echo $line > "$dir/$section"
		gather_strings $dir > $dzen_pipe
	done
	echo $section
else
	mkdir $dir
	mkfifo $dzen_pipe
	touch $dir/0
	trap "kill 0" EXIT
	tail -f $dzen_pipe | dzen2 $@ &
	echo $! > $dir/.pid
	wait $(cat $dir/.pid)
fi
