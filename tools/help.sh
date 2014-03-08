#!/bin/bash
### help.sh file [dzen2 options]
### toggles help display and exits
### takes a file with some pairs of lines like:
###	#H description
###	<single configuration line>
### concatenates them onto a single line
### each of these lines has a uniform width

token="#H"
file=$1
shift 2

## next_line line
## returns the line after $line in $file
next_file() {
	grep -E -A1 "$@" $file | tail -1
}

## format_line length char line
## puts enough padding $chars in place of sep to make line $goal long
format_lines() {
	length=$1
	char=$2
	shift 2
	line=$(next_file $line)
	length=$(echo $line | wc -c)
	padding=$(yes $char | head -n$length)
	echo $padding
}

lines=$(grep -E "$token" $file)
longest_line=$(echo "$lines" | wc -L)
let "longest_line += 3"

for line in "$lines"; do
	echo "$line"
done
