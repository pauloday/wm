#!/bin/bash
### bar.sh [dzen options]
### runs the default information bar

source $wm/style.sh

trap "kill 0" EXIT
right_width=300
right_x=$(expr $screen_width - $right_width)

$tools/multiplexer.sh left_bar -ta l -x 0 -w "$right_x" $@ &
$tools/multiplexer.sh right_bar -ta r -x "$right_x" -w "$right_width" $@ &
sleep 0.5 # wait for the bars to finish initializing
## left bar
$tools/controller.sh list | $tools/bar/desktops.sh | $tools/multiplexer.sh left_bar 0 &

## right bar
$tools/bar/volume.sh | $tools/multiplexer.sh right_bar 0
$tools/bar/wireless.sh 30 | $tools/multiplexer.sh right_bar 1 &
$tools/bar/battery.sh 60 | $tools/multiplexer.sh right_bar 2 &
$tools/bar/date.sh 10 | $tools/multiplexer.sh right_bar 3
