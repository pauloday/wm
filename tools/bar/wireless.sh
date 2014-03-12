#!/bin/bash
### wireless.sh n
### Ouputs wireless link quality every n seconds

source $wm/style.sh

while true; do
	quality=$(cat /proc/net/wireless | tail -1 | awk '{print $3}' | tr '.' '%')

	if [ "$quality" = "tus" ]; then
		quality=NA
	fi

	echo "^fg()^i($tools/bar/icons/wifi_02.xbm) $quality ^fg()|"
	sleep $1
done
