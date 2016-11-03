---
title: A better chat client for Source games
author: Tama
---

By default, there's just a tiny little chat window that only shows up when you type T or Y to talk, has limited scrolling and no filtering options. Today I used some unix tools to build myself a proper chat client to use while playing Empires. It should work for any Source engine game, and gives you a fullscreen, scrollable window to put on a second screen, that gives you a notification popup when your name is mentioned in chat.

![](http://i.imgur.com/lAXbG7s.gif "The chat client (early version)")

# How it works

If -condebug is passed, Empires will output the console's output to the empires/console.log file. (To add -condebug, right click Empires in steam, click "Properties" and then "Set Launch Options") By 'tailing' this file, we can extract the chat and any mentions of us. 


To run emp_chat, copy the script below into a directory in your $PATH, and run it from the terminal while Empires is running. The first grep will select and print from the real beginning of a chat line (some of them begin with some garbage, hence the -o to suppress that), and if that doesn't match, ignore the rest of the loop. Then we do a similar grep using whatever parameters were passed to see if we got mentioned. If so, split up the line into sender name and message, so that notify-send can be invoked, which gives me a nice popup on the bottom of my screen with the message.

```
#!/bin/bash

# Outputs the chat lines from a source game's console.log file
# If given parameters, these are passed to grep; if it matches, 
# you get a notification of the message

LOGFILE=~/.steam/steam/steamapps/common/Empires/empires/console.log
tail -f $LOGFILE | (while read line; do 
	echo $line | grep "([^)]*)\ [^:]*:\ .*" -o; if [ $? -eq 1 ]; then continue; fi; 
	if (( $# == 0 )); then continue; fi;
	echo $line | grep $@ > /dev/null; 
	if [ $? -eq 0 ]; then 
		NAME=`echo $line | sed 's/.*([^)]*)\ \([^:]*\):.*/\1/'`; 
		MSG=`echo $line | sed 's/.*([^)]*)\ [^:]*:\ \(.*\)/\1/'`;
		notify-send "$NAME" "$MSG" --icon=dialog-information; 
	fi;
done)
```

# Tmux for scrolling and panes

In the first screenshot, you could see some numbers and names at the bottom of the screen. This is because I'm using tmux to allow me to scroll through any terminal output, such as the output of emp_chat, and allows you to add terminal windows and panes without opening another terminal window. To scroll, press "Cntrl-B \[" and then use shift j-k to move up and down. You can also use ? or / to search forwards and backwords, or read the [tmux manual](https://wiki.archlinux.org/index.php/Tmux).

Whenever there is new output on another window, it highlights in red. That means you could also just open a bunch of windows, each with a command running like:

```
tail -f ~/.steam/steam/steamapps/common/Empires/empires/console.log | grep "ref\|rax"
```

And name each one - the red highlighting will tell you to switch to that pane, and it will only list all the requests for refs and raxes.

# Expanding on this

There's a lot of useful information about what is happening in the game in the console.log file; below is an extract from one, showing a mapswitch. Currently, I am just looking at chat, but you could also feasibly create a fullscreen map with some extra information drawn on top, completely outside of the game. 

![](http://i.imgur.com/qU47KGt.gif "An example console log")

The script above is hosted in [my dotfiles repository](https://github.com/TamaHobbit/dotfiles), so you can comment there if you have useful additions, or [email tama@empiresmod.com](mailto:tama@empiresmod.com) if you have something way cooler I should be using.
