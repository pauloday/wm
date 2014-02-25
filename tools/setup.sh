#!/bin/bash
### config.sh file
### reads values from the user into variables in file.

file=$1

## update_file file
## iterates through a list of var=val and queries the user for a new val
update_vars() {
	for line in $@; do
		val=$(echo $line | cut -d'=' -f2)
		var=$(echo $line | cut -d'=' -f1)
		if [ "$val" ]; then
			prompt="Change $var from $val to: "
		else
			prompt="Set $var: "
		fi
		val=$($tools/menu.sh -noinput -p "$prompt")
		echo $var=$val
	done 
}

update_vars $(cat $1) > $1
