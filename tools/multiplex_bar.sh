#!/bin/bash
### multiplex_bar.sh pipes_dir sep [dzen2_opts]
### Multiplexes the last lines from each file in pipes_dir
### Be careful that the information length does not exceed the bar length
### The bar must be updated manually by calling multiplex_bar pipes_dir

dir=$1
sep=$2
shift; shift
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

if [ ! -f $dzen_pipe ]; then
	touch $dzen_pipe
	trap "rm -f $dzen_pipe" EXIT
	gather_strings $dir $sep > $dzen_pipe
	tailf $dzen_pipe | dzen2 $@
fi
gather_strings $dir $sep > $dzen_pipe
