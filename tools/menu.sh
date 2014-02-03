#!/bin/bash
### menu.sh
### Dmenu wrapper
## Usage:
## menu.sh OPTIONS
## OPTIONS are dmenu options

source $wm/style.sh

dmenu -f -i -dim 0.4 -nf "${colors[fg]}" -nb "${colors[bg]}" -sf "${colors[bg]}" -sb "${colors[fg]}" -fn "$font" "$@"
