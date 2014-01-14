#!/bin/bash
### bar
### Display a bar on the top or bottom of the screen, adjusting the padding
## Usage: bar [top|bottom] [options]
## Top and bottom set the bar to display on the top or bottom of the screen
## Options are dzen2 options, if you want to use the -y option use dzen2 instead

source $wm/style.sh

side=$1

## update_gap_file
## updates $gaps_file
update_gaps_file() {
	case $side in
		top)
			new_gaps_file="$current_gap:$current_bottom_gap"
			;;
		bottom)
			new_gaps_file="$current_bottom_gap:$current_gap"
			;;
	esac
	echo $new_gaps_file > $gaps_file
}

## add_rows n
## Adds n bar-sized rows
## n can be negative to remove a row 
add_rows() {
	current_gap=$(expr $current_gap + $bar_height \* $1)
	bspc config "$bspc_opt" "$current_gap"
	return $current_gap
}

# main
bar_height=20
gaps_file="/tmp/current_gaps" # format is top_gap:bottom_gap
if [ ! -f $gaps_file ]; then
	echo -e "0:0" > $gaps_file
fi
current_top_gap=$(cat $gaps_file | cut -d: -f 1)
current_bottom_gap=$(cat $gaps_file | cut -d: -f 2)

case $side in
	top)
		current_gap=$current_top_gap
		bspc_opt="top_padding"
		dzen2_opt="-y 0"
		;;
	bottom)
		current_gap=$current_bottom_gap
		bspc_opt="bottom_padding"
		dzen2_opts="-y $screen_height"
		;;
esac

if [ $current_gap -lt $bar_height ]; then
	add_rows 1
	trap "add_rows -1; update_gaps_file" EXIT
	update_gaps_file
fi

shift
dzen2 $dzen2_opts $@
