#!/bin/bash
### brightness_change [screen|keys] [up|down]

if [ "$1" == "screen" ]; then
    sys_file="/sys/class/backlight/acpi_video0/brightness"
    delta=1
elif [ "$1" == "keys" ]; then
    sys_file="/sys/class/leds/smc::kbd_backlight/brightness"
    delta=17
fi

if [ "$2" == "down" ]; then
	delta=$(expr 0 - $delta)
fi

((val = $(cat $sys_file) + $delta))

if [[ $val -lt 0 ]]; then
    val=0
fi
echo $val > $sys_file
