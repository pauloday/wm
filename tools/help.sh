#!/bin/bash
### help.sh file [dzen2 options]
### toggles help display and exits
### takes a file with some pairs of lines like:
###	#H description
###	<single configuration line>
### concatenates them onto a single line
### each of these lines has a uniform width

token="#H"
pad_char=' '
file=$1
pid_file="/tmp/help.pid"
shift

if [ -f $pid_file ]; then
	kill -9 $(cat $pid_file)
	rm -rf $pid_file
	exit
fi

declare -a lines
readarray -t lines < $file
longest_line=$(wc -L $file | awk '{print $1}')
width=$(expr $longest_line + 4)

text=$(for line in "${lines[@]}"; do
	if [ "$(echo $line | head -c2)" = "$token" ]; then
		line=$(echo $line | sed "s/^$token //g")
		line2=$(grep -A1 "$token $line$" $file | tail -1)
		lines_width=$(expr ${#line} + ${#line2})
		pad_width=$(expr $width - $lines_width)
		pad=$(printf '%*s' "$pad_width" ' ' | tr ' ' "$pad_char")
		if [ -z "$(echo $line2 | tr -d [:space:])" ]; then
			half_pad=${pad:0:$(expr $width / 2)}
			echo "$half_pad$line"
		else
			echo " $line$pad$line2"
		fi
	fi
     done)

length=$(expr $(echo "$text" | wc -l) - 2)
events='onstart=uncollapse'

echo -n "$text" | dzen2 -ta l -p -l "$length" -e "$events" "$@" &
echo $! > $pid_file
