#!/bin/bash
### bar
### Display a bar on the top or bottom of the screen, adjusting the padding
## Usage: bar [top|bottom] [options]
## Top and bottom set the bar to display on the top or bottom of the screen
## Options are dzen2 options, if you want to use the -y option use dzen2 instead

source $wm/style.sh
bar_height=20

## change_gap [top|bottom] n
## increases/decreases the gap at top/bottom of screen according to n*$bar_height
change_gap() {
	case $1 in
		top)
			bspc_opt="top_padding"
			current_top_gap=$(expr $current_top_gap + $bar_height \* $2)
			new_gap=$current_top_gap
			;;
		bottom)
			bspc_opt="bottom_padding"
			current_bottom_gap=$(expr $current_bottom_gap + $bar_height \* $2)
			new_gap=$current_bottom_gap
			;;
	esac
	bspc config "$bspc_opt" "$new_gap"
}

## main
case $1 in
	top)
		change_gap top 1
		dzen2_opts="-y 0"
		trap "change_gap top -1" EXIT
		;;
	bottom)
		change_gap bottom 1
		dzen2_opts="-y $screen_height"
		trap "change_gap bottom -1" EXIT
		;;
esac

shift
dzen2 $dzen2_opts $@
