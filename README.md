## Fix Windows 7 - AHK Script

AutoHotkey script to put Windows 7 under control and optimize UX workflow.

I also recommend to use this along AltDrag and 7+TaskbarTweaker, and obviously ClassicShell.

**File Explorer**
*   Disable Ctrl+W to avoid Explorer closing by mistake
*   Disable file deletion with Ctrl+D, Undo with Ctr+Z and F1 (help)
*   Disable F11 (Full Screen) for FileExplorer
*   F3 for New Folder
*   Ctrl+F for Search (With FileSearchEX)
*   Ctrl+I for Invert Selection
*   Alt+D for Detail View
*   Alt+V for Thumbnail View


**General**
*   Disable Capslock
*   Disable Ctrl+Wheel (Resize Icons) when on Desktop
*   Disable Alt+F4 (Shutdown) when taskbar is in focus
*   Disable Alt+Shift (taskbar language switch) while in Photoshop and Blender
*   Disable Win+F (Windows Search)
*   Alt+T for Always on Top on Active Window
*   MMB for Closing Window
*   Win+MMB for Minimizing Window



## Multidepth Multifilename Renamer (GUI)

Rename filenames included in a folder and subfolders by a string or Regular Expression.

![](https://github.com/Dogway/AutoHotkey-Scripts/blob/master/screenshots/Multidepth%20Multifilename%20Renamer%20\(GUI\).png)


## Multiline Multifile Text Replacer (GUI)

Single line/multiline, single depth/multidepth text replacer.
You can replace a static block of text or use a Regular Expression.
For more advanced features you might want to look at [grepWin](https://github.com/stefankueng/grepWin).


## Text Line to Text File or Folder (AutoExecute)

Convert every line in the copied-to-clipboard text file to a %line%.txt file. It helps to manage list of files and sorting.


## Music Videos NFO creator (GUI)
Utility to create Music Videos NFO files for Kodi to parse.
Simply point to a subfolder with all your videos, set Genre, and a placeholder year.
Might want to further edit the files though.

![](https://github.com/Dogway/AutoHotkey-Scripts/blob/master/screenshots/Music%20Videos%20NFO%20creator%20\(GUI\).png)


## PAR2+PAR3 Generator (GUI)

Scans a folder recursively to create recovery files of files matching the preset extensions (Video, Software, eBooks, etc)
Useful to recover files when an HDD is dying and starts to corrupt blocks with reading CRC errors (bitrot).
Recovery files represent only about 7% of source size so you save quite a bit of HDD space were you to backup the whole file,
while being safer as a plain old file duplication can also be subject of block corruption.
* [par2cmdline-turbo](https://github.com/animetosho/par2cmdline-turbo)
* [par3cmdline](https://github.com/Parchive/par3cmdline)

![](https://github.com/Dogway/AutoHotkey-Scripts/blob/master/screenshots/PAR2+PAR3%20Generator%20\(GUI\).png)

## MP3 Batch Encoder (GUI)

Takes the labourious and complex task of encoding, tagging and adding ReplayGain2 tags for audio files into a one click solution.
It also works for audio tracks in video files, downmixing when necessary and normalizing to EBU R128 Loudness Target if chosen,
or alternatively a Night mode with a more compressed Loudness Range and adding more weight to the center dialog channel.
* [ffmpeg](https://www.gyan.dev/ffmpeg/builds/)
* [rsgain](https://github.com/complexlogic/rsgain)
* [lame](https://sourceforge.net/projects/lame/files/)

![](https://github.com/Dogway/AutoHotkey-Scripts/blob/master/screenshots/MP3%20Batch%20Encoder%20\(GUI\).png)

## Make Folder and Move clipboard content over (F4)

Creates a folder and moves files in the clipboard to the folder.



## Timer Alarm (GUI)

Simple Visual and Audio alarm.



## Train Sets Alarm (GUI)

Audio alarm for an exercise series of X sets and Y reps, with rest time.



## EditList fcpxml to Trims

Converts DaVinci Resolve .fcpxml cut edit file to Avisynth legible Trims()
It works for cuts, but not for logos, and probably either for Fades.
