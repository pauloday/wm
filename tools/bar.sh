#!/bin/bash
### bar.sh [dzen options]
### runs the default information bar

source $wm/style.sh

trap "kill 0" EXIT
right_width=300
right_x=$(expr $screen_width - $right_width)

## left bar
$tools/multiplexer.sh left_bar -ta l -y 1440 -x 0 -w "$right_x" &
$tools/controller.sh list | $tools/bar/desktops.sh | $tools/multiplexer.sh left_bar 0 &

## right bar
$tools/multiplexer.sh right_bar -ta r -y 1440 -x "$right_x" -w "$right_width" &
$tools/bar/date.sh 10 | $tools/multiplexer.sh right_bar 0
