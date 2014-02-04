export wm="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export tools="$wm/tools"
setxkbmap -option ctrl:nocaps
xsetroot -cursor_name left_ptr
xrdb -load $wm/xdefaults
compton &
sxhkd -c $wm/sxhkdrc &
bspwm -c $wm/bspwmrc
