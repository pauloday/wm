#!/bin/bash
### help.sh file [dzen2 options]
### toggles help display and exits
### takes a file with some pairs of lines like:
###	#H description
###	<single configuration line>
### and displays it

token="#H"
file=$1
shift 2

lines=$(grep -E -A1 "$token" $file)

echo "$lines"
