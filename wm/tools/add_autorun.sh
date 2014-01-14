#!/bin/bash

name=$(ls -w 1 $wm/autorun_files | $base/menu.sh)
line=$(ls -w 1 /usr/bin | $base/menu.sh)
file="$wm/autorun_files/$name"
if [ ! -a $file ]; then
	echo "#!/bin/bash" > $file
	chmod +x $file
fi
echo $line >> $file
