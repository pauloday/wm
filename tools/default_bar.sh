#!/bin/bash
### default_bar
### Displays the default system panel

source $wm/style.sh

## colorize_fg <string> <color>
## Returns string colorized for dzen2
## color is foreground color
colorize_fg() {
	echo "^fg($2)$1^fg(${colors[fg]})"
}

## same as colorize_fg, but for background color
colorize_bg() {
	echo "^bg($2)$1^bg(${colors[bg]})"
}

## colorize_string <string> <fg> <bg>
## outputs the string colorized for dzen2
colorize_string() {
	echo "$(colorize_bg $(colorize_fg $1 $2) $3)"
}

## colorize_desktop_string <string>
## formats <string> to be colored for dzen2
## <string> comes from running "$tools/controller.sh list"
colorize_desktop_string() {
	echo $1 |
	sed "s/:O/^fg(${colors[bg]})^bg(${colors[fg]})/g" |
	sed "s/:F/^fg(${colors[grey]})^bg(${colors[fg]})/" |
	sed "s/:f/^fg(${colors[grey]})^bg(${colors[bg]})/g" |
	sed "s/:o/^fg(${colors[fg]})^bg(${colors[bg]})/g" |
	sed 's/$/ /'
}

colorize_desktop_strings() {
	while read line; do
		colorize_desktop_string "$line"
	done
}

output_time() {
	while true; do
		echo $(date +"%D %_I:%M %p")
		sleep 10
	done
}

## main
info_pipe="/tmp/info_pipe"

right_width=300
left_width=$(expr $screen_width - $right_width) 

$tools/multiplex_bar.sh left_bar "	" -ta l -w $left_width &
$tools/multiplex_bar.sh right_bar "|" -ta r -w $right_width -x $left_width &
$tools/controller.sh list | colorize_desktop_strings | $tools/multiplex_bar.sh left_bar 1 &
output_time | $tools/multiplex_bar.sh right_bar 1
