#!/bin/bash
### menu.sh
### Dmenu wrapper
## Usage:
## menu.sh OPTIONS
## OPTIONS are dmenu options

source $wm/style.sh
dmenu -f -i -dim 0.4 -nf "$fg" -nb "$bg" -sf "$bg" -sb "$fg" -fn "$font" "$@"
