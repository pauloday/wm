#!/bin/bash
### labeled_menu.sh string [options]
### Displays a menu, with a string underneath
### Make sure string is quoted

menu_height=18

echo " $1" | dzen2 -ta l -y $menu_height -p &
trap "kill -9 $!" EXIT

$base/menu.sh
