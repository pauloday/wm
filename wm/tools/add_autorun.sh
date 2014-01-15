#!/bin/bash
### add_autorun.sh
### adds a line to an autorun file

menu1_help="Name of the desktop to add a autorun command for"
name=$(ls -w 1 $wm/autorun_files | $tools/helped_menu.sh "$menu1_help")
if [ ! "$name" ]; then
	exit
fi

menu2_help="Line to run everytime desktop $name is started"
line=$(ls -w 1 /usr/bin | $tools/helped_menu.sh "$menu2_help")
file="$wm/autorun_files/$name"
if [ ! -a $file ]; then
	echo "#!/bin/bash" > $file
	chmod +x $file
fi
echo $line >> $file
