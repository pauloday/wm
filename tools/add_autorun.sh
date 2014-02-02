#!/bin/bash
### add_autorun.sh
### adds a line to an autorun file

name=$(ls -w 1 $wm/autorun_files | $base/menu.sh -p "Desktop:")
if [ ! "$name" ]; then
	exit
fi

line=$(ls -w 1 /usr/bin | $base/menu.sh -p "Command:")
file="$wm/autorun_files/$name"
if [ ! -a $file ]; then
	echo "#!/bin/bash" > $file
	chmod +x $file
fi
echo $line >> $file
