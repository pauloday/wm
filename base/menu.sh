#!/bin/bash
### menu.sh
### Dmenu wrapper
## Usage:
## menu.sh OPTIONS
## OPTIONS are dmenu options

source $wm/style.sh

dmenu -nf "${colors[fg]}" -nb "${colors[bg]}" -sf "${colors[bg]}" -sb "${colors[fg]}" -fn "$font"
