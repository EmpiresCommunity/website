---
title: Static analysis with PVS-Studio
author: Tama
---

For the past few weeks, I've been using [PVS-Studio](http://www.viva64.com/) to analyse the Empiresmod source code. In the process, I have found some horrendous bugs, memory leaks, and undefined behaviour that have hidden unseen for years, potentially causing crashes in unrelated parts of the code. I hope to convince you that static analysis is an indispensible tool for any developer, especially those coding in a language as permissive as C++. Many of the warnings indicated by PVS-Studio lead me to read C++ code I would not have thought was valid, and which definitely was not intended as it is written today. Sadly, it is often difficult to reconstruct the intent of the programmer writing code such as:

```c++
if ( itEntity->m_pRenderable )
	NULL; //
```

![](http://i.imgur.com/2rI6BT9.gif "Hire me! I'll work for bananas!")
	
It is tempting to think that some idiot must have caused this - someone who writes bad code. "This can't happen to our codebase, because we only employ good programmers." Unfortunately, I have found that the worst code occurs where many programmers make changes to the same piece. Design smells especially, which only become apparent after the originally very clear, simple class with a single responsibility has been modified and extended here and there, slowly emerge, turning good code into a mess. With static analysis, we can often spot symptoms of bad design, highlight the real problem and fix it.

![](http://i.imgur.com/6ExAu1v.jpg "Yuck!")

Before I get into the various problems I found, let me give you a quick intro to PVS-Studio, so that you can follow along with your own codebase [(PVS-Studio trial download)](http://www.viva64.com/en/pvs-studio-download/). Once installed, PVS-Studio integrates with Visual Studio (I'm using VS 2012 Community, but it works with versions 2005-2015), giving you a toolbar menu "PVS-STUDIO". To get started, you will want to select "Check > Current Project" to analyse all code in the project. For empiresmod, which is just over 1 million lines of .cpp and .h files - including the source SDK, this takes about 30 minutes. You only need to do this once, as long as you remember to click PVS-STUDIO > Open/Save > Save analysis report. A great feature of PVS-Studio is that you can use the results as they come in, so you can get started on the first defects while it is still analyzing the rest of your codebase.

As the results come in, the bottom panel of Visual Studio will show the warnings, and you can toggle options to show less severe warnings, or instances of pessimization. Individual "defects" can also be marked as false positives. Ideally, you would want every warning either fixed or marked as reviewed, so that with each new feature branch, the reviewer can easily verify that no new warnings have been introduced. However, taking a project that has never been tested and trying to fix all the warnings is a gargantuan task; for Empiresmod, PVS-Studio found 1160 High priority warnings, 4297 Medium, and 1866 of Low priority. Start early with static analysis. As an Empiresmod developer, I'm mostly interested in diving into the pile of old possible bugs and fixing whatever is necessary, but PVS-Studio also provides [Incremental code analysis](http://www.viva64.com/en/a/0077/#ID0EGPCI) in case you want to only see new warnings introduced by your changes.

![](http://i.imgur.com/dc30iVU.png "Poof!")

For each warning, you can double-click the entry to be taken straight to the offending code, or click the V[num] code on the left for more details on the warning. [Warning V2008](http://www.viva64.com/en/d/0279/print/) is a great example of a warning that can arise in any code base when many people edit the same thing. When the complexity of any function passes a threshold, you know your static analyzer will prompt you to refactor. By the way, the current highest cyclomatic complexity in the source sdk is CAI_BaseNPC::RunTask, with a staggering 213 paths through the function.

One warning I have seen crop up often is V595; The 'whatever' pointer was utilized before it was verified against nullptr. Check lines: 781, 800.
They are also often the easiest to fix; either line 800 has an unnessary nullcheck or it should be moved up before line 781. I have only ever seen one false positive, which involved freeing blocks of memory and (re)allocating. It was a false positive because in the case that the pointer was null, the earlier code would not execute.

![](http://i.imgur.com/Yj5sfah.png "Easiest way to get rid of them! W00t")

Another of my favourites is V501; There are identical sub-expressions to the left and to the right of the 'foo' operator. That one found this astonishing bug in the source SDK:

```c++
Vector2D vMaxSize( ( float )nScreenWidth / ( float )nScreenWidth / NUM_PYRO_SEGMENTS * 2.0f, ( float )nScreenHeight / ( float )nScreenHeight / NUM_PYRO_SEGMENTS * 2.0f );
```

So, the x param for the max size is actually always 2.0f / NUM_PYRO_SEGMENTS? This is quite likely a copy-paste error, which has been found and fixed in the source SDK a year ago (commit 53e78c503), but it is still present in our older copy. The trouble is, I don't want to make changes in this code at all; I should just update the source SDK, and in the mean-time, ignore these errors. PVS-Studio supports this in the form of file exclusions. 

By the way, [the Source SDK has been scanned with PVS-Studio before](http://www.viva64.com/en/b/0229/) (in 2014), so many errors were fixed and, naturally, haven't been detected this time. Anyway, the fresh analysis has shown that new bugs are still found, which proves the idea that static analysis ought to be used regularly.

![](http://i.imgur.com/v2HaSkp.jpg "I mean, what did you expect?")

Another advantage of static analysis is that it can teach your team new things about the language, using the code they just wrote as an example. For instance, if you have a team-member who does not know the Big Three rule in C++, and they write a class that violates this, they will see [Warning V690](http://www.viva64.com/en/d/0326/print/). If they do not know to make base class destructors virtual, they will see [V599](http://www.viva64.com/en/d/0210/). 



# Comparison with CppCheck; A poor man's static analyzer

I investigated another static analysis tool, CppCheck, which has the benefit of being completely free. [CppCheck](http://cppcheck.sourceforge.net/) is different from most static analyzers in that it can analyse individual files or folders of cpp files, but cannot check things that depend on multiple files. The advantage of is that it will also work if you only have part of a project.

CppCheck can be integrated with Visual Studio, allowing you to analyse the currently opened file. It took me a while to figure out how this should be configured - evidently much has changed since [this guide was written.](http://www.codeproject.com/Tips/472065/Poor-Man-s-Visual-Studio-Cppcheck-Integration) The correct arguments for your CppCheck external tool is currently; "--template "{file}({line}): {severity}: {message}" $(ItemPath) --force --verbose --enable=style --quiet" If this gives you incorrect output, [read the manual.](http://cppcheck.sourceforge.net/manual.pdf)

To compare CppCheck to PVS-Studio, I picked out the very worst defects PVS-Studio could find, and ran them through CppCheck to see what it found. Next, I picked files I know have a lot of ugly hacks, to see what the two analyzers find.

This line triggered [V650: Type casting operation twice in succession](http://www.viva64.com/en/d/0269/print/)

return (mstudioflexcontroller_t *)( ( char * ) this ) + *( &szindex0 + index );

Clearly there is something wrong here, because we first use a c-style cast which, after a whole bunch of unnecessary checks, will do a reinterpret-cast to char *, then more unnecessary checks, and another reinterpret-cast to mstudioflexcontroller_t, and finally add the value of either szindex0, or the following variables, szindex1 and szindex2, to the pointer value! In fact, index is checked a few lines earlier against the wrong bound, so it might end up adding random garbage that is interpreted as int to the pointer!

![](http://i.imgur.com/3SMjWba.jpg "Please don't kill any more kittens")

This file triggered V690, V550, V2009, V2006, V809 and V650 in PVS-Studio. CppCheck says nothing, even after suppressing the complaint that there are too many ifdefs to interpret the file by adding the --force parameter.

Next, I compared the outputs of each tool for the c_emp_player.cpp file, notorious amongst the Empiresmod team as the goto-place for hiding your bad code, apparently. Interestingly, there does not seem to be any overlap between the PVS-Studio and CppCheck outputs.

Here is some code CppCheck neglected to warn about:

```c++
if (x == 0)
{
	pMovedGrass[y] = pGrass[x*16+y];
	pMovedGrass[y]->bNeedsUpdate = true;
	pGrass[x*16+y] = pGrass[(x+1)*16+y];
}
```

And here is something PVS-Studio missed:

```c++
int iKey = -1;
iKey = CEmpKeyConfigPanel::GetKeyNum(key);
```

Even though both tools complain about assigning to a variable twice consequetively, they complain about different variables, and don't spot the error in the other case! This just goes to show that one should ideally have a suite of static analysis tools, rather than relying on just one.

![PVS-Studio's warnings for the c_emp_player class][pvswarnings]
![CppCheck's warnings for the c_emp_player class][cppcheck]

Clang also provides a free static analysis tool, but there is very little documentation on how to get it to work under Windows, so I have little hope of getting it to work with the custom build setup we need for Source SDK games.

[monkey]: http://i.imgur.com/2rI6BT9.gif "Hire me! I'll work for bananas!"
[yuck]: http://i.imgur.com/6ExAu1v.jpg "Yuck!"
[screenshot]: http://i.imgur.com/dc30iVU.png "Poof!"
[options]: http://i.imgur.com/Yj5sfah.png "Easiest way to get rid of them! W00t"
[meme]: http://i.imgur.com/v2HaSkp.jpg "I mean, what did you expect?"
[kittens]: http://i.imgur.com/3SMjWba.jpg "Please don't kill any more kittens"
[pvswarnings]: http://i.imgur.com/w5onXCU.png "My eyes bleed when I read this class - at least PVS-Studio agrees with me"
[cppcheck]: http://i.imgur.com/QWX7qRX.png "You get what you don't pay for, I guess"