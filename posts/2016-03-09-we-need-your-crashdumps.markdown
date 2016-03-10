---
title: We need your crashdumps!
author: Tama
---

It has come to our attention that some players are experiencing a lot of crashes.

While the dev team is still working on getting steam's automatic crashdump system up-and-running, here are instructions on how to get crashdump files which you can send through the [support forum](https://forums.empiresmod.com/index.php?forums/support.34/). If you send us a crashdump file, we can fix the bug. Without it, it is nigh impossible. The steps below only need to be done once, after which crashdump files will appear whenever Empires crashes.

If you're reading this from in-game, first open a browser and view this on empiresmod.com so that you can follow the links.

1) [Install DebugDiag](https://www.microsoft.com/en-us/download/details.aspx?id=49924)
2) Start up "DebugDiag 2 Collection"
3) Start up Empires
4) Alt-tab back to DebugDiag
5) Click "Add Rule...", select Crash, then "A specific process"
 
6) Select "hl2.exe" from the list of processes; it is only present if Empires is running when the window opens

7) In Advanced Configuration, select "Action type for unconfigured first change exceptions: Mini Userdump" and in both fields below it ("Action limit ..." and "Maximum number of userdumps ...", put 100. (Mini dump files are about 200 KB, so that's about 20 MB)

8) Select a name, e.g. "Empires crash dumps" and a location; you will visit this folder whenever you want to send a crash report.
 
9) Select "Activate the rule now" and click finish
10) To the popup you get about Symbol Search path debugging, choose "Yes"



After these steps, whenever Empires crashes, you can open the mini dump directory you submitted, zip up and remove all the files ( so that you don't submit the same crash logs twice ), and [start a thread in the support forum](https://forums.empiresmod.com/index.php?forums/support.34/create-thread) with the zip file attached. The only thing we really need is the .dmp file that contains the crash report, but there may be multiple files generated, and the .log also contains some useful information, so it is best to just submit everything. If there is too much to send, sort by last modified, send us the most recent stuff and discard the rest.

Note: there seem to be some false positives. When you start up Empires, 4 log files are generated for exception 0X406D1388, which is apparently thrown and handled by the engine. Don't worry about them for now, just send everything for every crash report.

These instructions were based on [this Microsoft blog](https://blogs.msdn.microsoft.com/chaun/2013/11/12/steps-to-catch-a-simple-crash-dump-of-a-crashing-process/). If you have any problems following the instructions above, [please ask in the forum thread.](https://forums.empiresmod.com/index.php?threads/how-to-submit-crashdumps.20062/)