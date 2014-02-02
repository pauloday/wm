#!/bin/bash
### setup.sh [interactive]
### sets up window gap, bottom border, top border
### If the interactive flag is provided, give visual feedback

exit_if() {
	if [ "$?" = "1" ]; then
		$base/controller.sh remove Setup
	        exit
	fi
}

## add_window
## Adds a window to current workspace that closes on script exit
add_window() {
	xterm &
	trap "kill $!" EXIT
}

## change_setting setting start delta options
## Setting is a setting provided to bspc config
## start is the starting value, delta is the amount to adjust by
## Options are dzen2 options
## The string displayed on the bar is piped in
change_setting() {
	setting=$1
	start=$2
	delta=$3
	shift; shift; shift
	bspc config $setting $start
	echo $start > $setting_file
	cat_cmd=$(echo '$(cat' "$setting_file" ')')
	add_cmd=$(echo 'expr' $cat_cmd '+' $delta '>' $setting_file '&& bspc config' $setting $cat_cmd)
	sub_cmd=$(echo 'expr' $cat_cmd '-' $delta '>' $setting_file '&& bspc config' $setting $cat_cmd)
	gaps_events="$dzen2_events;key_Up=exec:$add_cmd;key_Down=exec:$sub_cmd"
	dzen2 -y 100 -p -e "$gaps_events" $@
}

## Main
setting_file="setup_setting"
trap "rm -rf $setting_file" EXIT
save_file="$wm/saved_settings"
if [ -f $save_file ]; then
	source $save_file
else
	window_gap=0
	top_gap=0
	bottom_gap=0
fi

dzen2_events="onstart=grabkeys;key_Escape=exit:1;key_Return=exit:0"
change_inst="Use up and down to"
bail_inst="Press Enter when done or ESC to exit setup"
interactive_message="or i to set interactivly:"

window_gap=$($base/menu.sh -noinput -p "Window gap $interactive_message")	
exit_if 1
if [ "$window_gap" = "i" ]; then
	echo "$change_inst set the window gap. $bail_inst" | change_setting window_gap 0 1
	exit_if 1
	window_gap=$(cat $setting_file)
fi
bspc config window_gap $window_gap

top_gap=$($base/menu.sh -noinput -p "Top gap $interactive_message")
exit_if 1
if [ "$top_gap" = "i" ]; then
	echo "$change_inst set the top gap. $bail_inst" | change_setting top_padding 0 1
	exit_if 1
	top_gap=$(cat $setting_file)
fi
bspc config top_padding $top_gap
	
bottom_gap=$($base/menu.sh -noinput -p "Bottom gap $interactive_message")
exit_if 1
if [ "$bottom_gap" = "i" ]; then
	echo "$change_inst set the bottom gap. $bail_inst" | change_setting bottom_padding 0 1
	exit_if 1
	bottom_gap=$(cat $setting_file)
fi
bspc config bottom_padding $bottom_gap
echo "top_gap=$top_gap; bottom_gap=$bottom_gap; window_gap=$window_gap" >  $save_file
