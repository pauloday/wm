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
## <string> comes from running "$base/controller.sh list"
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

output_stats() {
	while true; do
		time=$(date +"%D %_I:%M %p")
		battery=$(acpi -b | awk '{print $4}' | tr -d ",%")
		if [ "$battery" -lt 65 ]; then
			battery=$(colorize_fg "$battery%" ${colors[yellow]})
		elif [ "$battery" -lt 20 ]; then
			battery=$(colorize_fg "$battery%" ${colors[red]})
		elif [ "$battery" -lt 6 ]; then
			battery=$(colorize_string "$battery%" ${colors[bg]} ${colors[red]})
		else
			battery="$battery%"
		fi
		separator=$(colorize_fg "|" "${colors[grey]}")
		wireless=$(cat /proc/net/wireless | tail -1 | cut -f4 | tr -d.)
		btc=$(curl --connect-timeout 10 http://data.mtgox.com/api/2/BTCUSD/money/ticker |\
			grep -Po '"display":"\$[0-9]*\.[0-9][0-9]"' | cut -d: -f2 | tr -d '"' | head -1)
		echo "$wireless $separator $battery $separator $time"
		sleep 20
	done
}

## main
info_pipe="/tmp/info_pipe"

desktops_width=300
stats_width=300
info_width=$(expr $screen_width - $desktops_width - $stats_width)

stats_x=$(expr $screen_width - $stats_width)

$base/controller.sh list | colorize_desktop_strings |
	dzen2 -y $screen_height -ta l -w $desktops_width -x 0 &
$tools/piped_bar.sh $info_pipe -y $screen_height -ta l -w $info_width -x $desktops_width &
output_stats | dzen2 -y $screen_height -ta r -w $stats_width -x $stats_x
