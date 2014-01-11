#!/bin/bash
### piped_bar.sh pipe [top|bottom|manual] OPTIONS
### creates a bar that displays from a pipe
### pipe: FIFO to read from. If it doesn't exist it is created
### [top...]: Y position. Manual means specify with -y
### OPTIONS: dzen2 options

fifo=$1
mode=$2
if [ ! -e $fifo ]; then
	mkfifo $fifo
fi

shift
if [ "$mode" == "manual" ]; then
	shift
fi
tail -f $fifo | $base/bar.sh $@
