#!/bin/bash
### add_init.sh
### adds a line to an init file

name=$(ls -w 1 $wm/init_files | $tools/menu.sh -p "Desktop:")
if [ ! "$name" ]; then
	exit
fi

line=$(ls -w 1 /usr/bin | $tools/menu.sh -p "Command:")
file="$wm/init_files/$name"
if [ ! -a $file ]; then
	echo "#!/bin/bash" > $file
	chmod +x $file
fi
echo $line >> $file
