#!/bin/bash
### multiplex_bar.sh [barname sep [dzen2_opts]] | barname/section_name]
### Either creates a multiplexed bar, or adds a partition to that bar
### Be careful that the information length does not exceed the bar length
### To add a section showing the output of "info" to bar "bar" call this like
###	info | multiplex_bar.sh bar/n   (note that this command will not exit)
### where n is the section named, which will be used for sorting.
### Sections are displayed alphanumerically sorted left to right
### The bar updates whenever a section changes

dir="/tmp/multiplex_$1"
shift
sep_file="$dir/.sep"
dzen_pipe="$dir/.dzen"

## gather_strings dir sep
## Multiplexes the last line of each file in dir with sep
gather_strings() {
	files_left=$(ls -w 1 $dir | wc -l)
	for file in $dir/* ; do
		((files_left--))
		string="$string $(tail -1 $file)"
		if [ ! "$files_left" == "0" ]; then
			string="$string $sep"
		fi
	done 
	echo $string
}

if [ ! -d "$dir" ]; then
	sep=$1
	shift
	mkdir $dir
	touch $dzen_pipe
	trap "rm -rf $dir $dzen_pipe $sep_file" EXIT
	echo $sep > $sep_file
	tailf $dzen_pipe | dzen2 $@
else
	section_file="$dir/$1"
	shift
	sep=$(cat $sep_file)
	touch $section_file
	while read line; do
		echo $line > $section_file
		echo $(gather_strings $dir $sep) > $dzen_pipe
	done
fi
