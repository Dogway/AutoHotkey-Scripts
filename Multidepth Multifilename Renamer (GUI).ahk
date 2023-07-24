; Multidepth Multifilename Renamer - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway


SetWorkingDir %A_ScriptDir%
#singleInstance, Force
#persistent

; example change extension:
; (.+)
; $1.m4a

Gui, +AlwaysOnTop
Gui, Add, Text,, Enter Subfolder name:
Gui, Add, Edit, vsub w200
Gui, Add, Checkbox, y+-20 x+15 vRegex, RegEx
Gui, Add, Checkbox, y+10 vExt, Incl. Extension
Gui, Add, Text, y+17 x+-305, Enter text to replace:  (Remember \1 is $1 and use (.+) or ^(.*)$ for full lines)
Gui, Add, Edit, vNeedle R8 w500
Gui, Add, Text,, Enter replacement text:
Gui, Add, Edit, vReplacement R8 w500
Gui, Add, Button, Default w+100, OK
Gui, Add, Button, x+20 w+100, Cancel
Gui, Show,, Multifilename Renamer
return

ButtonOK:
Gui, Submit, nohide

IF sub =
{
MsgBox, 4096, ,Sub Cant be Empty!
}

SubFolder := sub
Path := A_ScriptDir . "\" . SubFolder

IF Path = A_ScriptDir . "\"
{
MsgBox, 4096, ,Error Path! %path%	
ExitApp
}

; I need to refine a few things, avoid to change text file format (ANSI, UTF, etc)
StringCaseSense On
Loop, %Path%\*.*,0,1
{
	SplitPath, A_LoopFileName,,, ext, name_no_ext,

	if !RegEx
		{
		StringReplace, NewText, name_no_ext, %Needle%, %Replacement%, All
		}
		else
		NewText := RegExReplace("" . name_no_ext . "","" . Needle . "","" . Replacement . "")

	if (NewText == name_no_ext)
	goto reloop

	if ( Ext != true)
	FileMove, %A_LoopFileDir%\%name_no_ext%.%ext%, %A_LoopFileDir%\%NewText%.%ext%
	else
	FileMove, %A_LoopFileDir%\%A_LoopFileName%, %A_LoopFileDir%\%NewText%
	reloop:
}
Return

GuiClose:
ButtonCancel:
ExitApp