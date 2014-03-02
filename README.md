# Window Manager
This is the window manager I'm currently using. It is a core of bspwm with a bunch of custom bash scripts. The scripts use dmenu and dzen2 to interact with the user. Custom scripts are used to create a intuitive, minimal interface. Features include a intuitive dynamic pager, simple keyboard shortcuts, minimal easily extenseable configuration, easy to access help, and a unix based core designed to utilize the power of unix as much as possible.

[TOC]

## Basic Usage

The window manager is tiling (see [bspwm's](https://github.com/baskerville/bspwm) scheme). Desktops are referenced by numbers. Initially, there is one unnamed desktop.
    ![Inital desktop layout](/screenshots/1.png)
New desktops are added by switching to a desktop that doesn't exist, unless the last last desktop is empty and unnamed. For example, the initial configuration has one desktop called called "1/", and it contains no windows. The only way to create a new desktop is by adding a window, for example with <code>super + enter</code> to create a terminal.
    ![After adding a terminal](/screenshots/2.png)
After that, a empty unnamed desktop can be added with <code>super + 2</code>.
    ![Switch to a empty desktop](/screenshots/3.png)
Desktops can be renamed with <code>super + r</code>.
    ![Rename focused desktops](/screenshots/4.png)
After the desktop has a name, another empty desktop can be switched to:
    ![Third empty desktop](/screenshots/5.png)
Switching back to the first desktop (<code>super + 1</code>) removes the current empty one
    ![Trailing empty desks are removed](/screenshots/6.png)
Pressing <code>super + shift + 2</code> sends the focused window to desktop <code>2/sh</code>
    ![Send desktops to other desktops](/screenshots/7.png)
<code>super + shift + d</code> deletes all empty desktops (<code>super + alt +d</code> deletes a single desktop)
    ![Delete empty desktops](/screenshots/8.png)
Desktops can be saved by writing a script in <code>\$wm/init\_files</code>. <code>super + a</code> adds a line to a init script in <code>\$wm/init\_files</code>. A init script is named for the desktop it initializes:
    ![Add named desktop called walls](/screenshots/9.png)
    ![Run nitrogen on desktop start](/screenshots/a.png)
A desktop is added with <code>super + d</code>:
    ![Adding a named desktop](/screenshots/b.png)
This creates a desktop called <code>walls</code>, switches to it, and runs <code>~/init_files/walls</code>.
    ![New desktop](/screenshots/c.png)
<code>super + tab</code> switches back to the last focused desktop
    ![Switch to last desktop](/screenshots/d.png)
    
Open a new web browser window.
    ![New Chromium window](/screenshots/e.png)

The interface aims to be as simple as possible. It consists of keyboard shortcuts, all of which can be displayed with <code>super + F1</code>



## Inspiration

The idea behind the window manager is to compliment and enhance using a computer as a classic unix machine. I made it with the goal of being a simple window manager that has minimal  requirements and a minimal interface. Therefore I built it with a handful of programs and some bash scripts. This keeps the project focused - the goal is to provide powerful glue for powerful programs, and that is exactly what bash is. I also want a interface that can be customized to a degree that it is easy to use for generic browsing and quick work, but powerful enough to be useful for more in depth tasks.

## Structure

The window manager is structured as a series of bash scripts called tools. They are in the tools/ directory. There are also configuration files stored in the root of the repository. These are replaceable defaults. For example, the default configuration files for sxhkd and bspwm are here. There is also a default color and font file, xdefaults, and the initialization script, init.sh. Init.sh initializes sxhkd and bspwm, as well as loading xdefaults, setting global variables, and initializing programs (like compton). There are 2 global variables: \$wm and \$tools. \$wm is the path to the root of the repository, and \$tools is just \$wm/tools, provided for convenience. For example, to call the tool menu.sh, write \$tools/menu.sh. Tools follow the unix philosphy - do one thing and play well with others. Here is a list of tools:

*   <code>controller.sh</code> - controls desktop labels and order.
*   <code>switch_desks.sh</code> - switches windows or focus to desktops
*   <code>menu.sh</code> - a shim for dmenu
*   <code>pager.sh</code> - provides a gui for controller.sh
*   <code>add\_init.sh</code> - provides a gui to add lines to desktop init files
*   <code>multiplexer.sh</code> - provides a push based dzen2 multiplexer.sh
*   <code>bar.sh</code> - the default bar. Information scripts are in <code>bar/</code> . Uses <code>multiplexer.sh</code>
*   <code>toggle\_window\_title.sh</code> - toggles a window title display
*   <code>setup.sh</code> - runs a interactive setup for some user specific settings
*   <code>tray.sh</code> - runs trayer with some settings. Used for a keyboard shortcut
*   <code>volume_change.sh</code> - implements volume control behavior
*   <code>brightness_change.sh</code> - implements screen brightness changing behavior. Requires root.

    
## Tools
All tools are contained in <code>$tools/</code>. Generally, a tool provides a simple function that can be tuned by command line arguments. For example, the <code>volume_change.sh</code> takes a change in volume instead of hardcoding a value. Tools should also have a well-defined purpose, and be less than 100 lines. Before adding a tool, make sure it doesn't make more sense as a new feature in an existing one. The general idea with tools is to glue some programs into the window manager somehow. The glue should be as generic as makes sense - for example instead of having a tool that runs some program and displays the output, make a tool that runs any program and displays the output, then call it with a specific command with a keyboard shortcut. Tools also provide the logic for features such as the desktop switching and naming behavior. Features like this should be split into a command line interface, and a gui that calls the command line interface. A tool that uses <code>menu.sh</code> or dzen shouldn't do much else - the logic is in a separate tool.

This is a in depth review of each tool. It also serves as a in depth review of the logic of all of the features.

### Desktop and window behavior
The combination of the switching logic in <code>switch_desks.sh</code> with the naming logic of <code>controller.sh</code> ensures that desktop space is both compactly and intuitively organized, and trivial to create.

#### controller.sh
Controls the desktops. Syntax: <code>controller.sh [options] selector</code>. Options are described below, and <code>selector</code> is a selector that bspc takes (see <code>man bspc</code>). This script is in charge of the desktop labels. Specifically, keeping them accurate through renaming, reordering, insertion, and deletion. This script also preforms those actions. Because desktop navigation and management is so central to the interface, this is the core of the window manager. It is designed to be simple and minimal, making it as portable as possible.

Desktops are the main working areas. There can be a arbitrary amount of them. A desktop can be named or unnamed. Named desktops can be saved as tasks. A task is a set of programs, desktops and/or window manger configurations defined by a script. The script can do anything, but is intended to run programs, create desktops, and configure the window manager. For example, the saved desktop webdev might run your server, create a desktop called "test" and load a web browser with your website, then create a desktop called "webdev" and load an editor with the source of the site. This leaves the window manager focused on desktop "webdev" with desktop "test" last focused (use <code>alt + tab</code> to switch to the last focused desk).

Desktops are managed with numbered slots. Slots are populated by named or unnamed desktops. A specific desktop/slot combination is referenced with it's label, formatted as <code>n/name</code>, where <code>n</code> is the slot, and <code>name</code> is the desktop name. 

A desktop is inserted with <code>controller.sh [add|new] name</code>. Both insert a desktop called <code>name</code> in the next empty slot. A slot is considered empty if it contains a empty, unamed desktop. If no empty slot exists, one is created with the next unused number. <code>add</code> is used to create a saved desktop. It will run <code>$wm/init/name</code>. If that file doesn't exist, it'll insert a empty desktop called <code>name</code>. <code>new</code> differs in that it always inserts a empty desktop called <code>name</code>, making no attempt to run a init file. The other difference is <code>new</code> doesn't switch to the newly created desktop.

Desktops are removed with <code>controller.sh [remove|cleanup] selector</code>. <code>remove</code> simply removes a empty desktop and repacks the remaining desktops. <code>cleanup</code> removes all empty desktops.

Reordering or renaming desktops is accomplished with <code>controller.sh [rename newname|swap] selector</code>. Both change desktop labels, but not the number of desktops. <code>rename</code> renames selected desktop to <code>newname</code>, while <code>swap</code> switches the selected desktop with the focused desktop.

Finally, <code>controller.sh</code> also provides a way to continually output information about the desktops. Calling <code>controller.sh list</code> will print a string representing the status of the desktops, formatted like: <code>":state1 label1 :state2 label2 ..."</code>, where state is a lowercase letter if the desktop is unfocused, and a upper case letter for focused. The letter itself is either a <code>"o"ccupied</code> or <code>"f"ree</code>. A new string is outputted whenever the status of the desktops changes.

#### switch_desks.sh
The other half of the desktop management cake is the desktop switching behavior. <code>switch_desks.sh</code> is in charge of this behavior. This consists of managing the rules for adding empty desktops, and applying those rules to window or desktop switching behavior.

When the user switches to slot <code>n</code>, <code>switch_desks.sh</code> either: 

*   switches the window or focus to desktop <code>n</code>
*   If <code>n</code> is larger than the number of slots
    *   If the last slot is empty (no windows, unnamed desktop), switch window or focus to it.
    *   If the last slot is not empty, create a new empty slot and switch focus or window to that.

The syntax is: <code>switch_desks.sh [focus|window] selector</code>.

### GUI Tools
The gui are intended to ways for the user to observe and interact with their computer. They are based off dzen2 for display and dmenu for input.

#### menu.sh
A simple wrapper for dmenu to ensure that it is always called with certain options. All it does is run dmenu with the some options and whatever was passed to it on the command line.

#### pager.sh
Provides a graphical interface for <code>controller.sh</code>. Usage: <code>pager.sh [add|remove|rename]</code>. Each option calls <code>controller.sh</code> with the corresponding option. The user is prompted for the desktop name.

#### add_init.sh
Prompts the user for a name (autocomplete existing init files), then a line of text. The line of text is appended to the init script (meaning it's executed as bash). The interface is purposefuly limited to single line input; multiple line modifications should be done with a text editor, on the file <code>$wm/init_files/name</code>. If the init file does not exist, it is created with a line that creates the named desktop (since the init script is run in lieu of creating any desktops). This is how saved desktops are created.

#### multiplexer.sh
<code>multiplexer.sh</code> implements a partitioned, multiplexed dzen2 bar. It does two things: create and push. To create, call <code>multiplexer.sh id [dzen2 options]</code>, where id is the identifier used to push to the bar (so it must not exist already). This will create a dzen2 bar, and not exit. If a bar is already running with that id, add a new section, then pipe stdin to that section and return it's id. If the script is provided with both a bar and section id, pipe stdin to that section of that bar. Note that it should only be possible to get a section id when <code>multiplexer.sh</code> exits - if a non-exiting command is piped in, <code>multiplexer.sh</code> won't exit and no section id will be printed. The script does not automatically update. In order for the bar to be updated, <code>multiplexer.sh</code> must be called to update a bar section. This will update each section of the bar with the last line outputted to that section. 

Internally, a bar is a folder at <code>/tmp/id</code>, which contains a number of files. These files are named according to the section id (so sequential numbers). Whenever the bar is updated, it collects the last line of each file in this folder in order, concatenates them, and displays that string.

#### bar.sh and bar/*
A simple default info bar. <code>bar.sh</code> ties together the scripts in <code>$tools/bar</code> with <code>multiplexer.sh</code>. The script actually starts two multiplexed bar - one left aligned and one right aligned.

The scripts in <code>tools/bar</code> are fairly self-explanatory. Some highlights: <code>volume.sh</code> simply outputs the current volume formatted for dzen2 and exits. When piped into <code>multiplexer.sh</code>, this only updates if explicitly called. Therefore, in <code>$tools/volume_change.sh</code>, when the volume is changed, <code>volume.sh</code> is called piped to the partition. A differently structured script is <code>date.sh</code>. This script takes a number, n, and outputs a formatted date every n seconds.

#### toggle_window_title.sh
This just takes the output of <code>xtitle -s</code> - the title of the currently focused window. This script also adjusts the top_gap accordingly as well.

#### setup.sh
Interactively set up some minor configuration details. This includes the split ratio, the window gap, and the top and bottom gaps. <code>TODO: extend this to arbitrary variables</code>

#### tray.sh
A simple wrapper for a systray. Exists to be able to toggle whether or not the tray is running via a keyboard shortcut. Requires <code>trayer</code>.

#### volume_change.sh
This script implements my preferred logic for volume buttons. When the volume is muted, any change or mute unmutes it. Usage: <code>volume_change.sh n</code> where <code>n</code> is change in percentage points.

#### brightness_change.sh
Implements screen and keyboard brightness changes. Needs a rework
