; Make Folder and Move clipboard over - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway


#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir%

GroupAdd, FileExplorer, ahk_class EVERYTHING
GroupAdd, FileExplorer, ahk_class CabinetWClass
GroupAdd, FileExplorer, ahk_class ExploreWClass


Fldname = FolderName

; Makes a subfolder with a fixed name, if there are files in the clipboard
; they will be copied to the subfolder
#IfWinActive, ahk_group FileExplorer 
	F4::
	ControlGetText, currentPath, ToolbarWindow322, A
	Var := SubStr(currentPath, InStr(currentPath, ":\")-1)
	FileCreateDir, %Var%\%Fldname%
	Loop, Parse, clipboard, `n, `r
		{
		FileMove, %A_LoopField%, %Var%\%Fldname%
		}
	send {F5}
Return
#IfWinActive