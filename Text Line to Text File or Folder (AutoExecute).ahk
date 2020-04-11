; Text Line to Text File or Folder - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway

SetWorkingDir %A_ScriptDir%
#singleInstance, Force
#persistent

; This script will convert every line in the copied-to-clipboard file text to a .txt file.
; if you supply a delimiter it will write the text after delimiter to each file content. You can add a prefix to this text.

; first you need to COPY to clipboard THE FILE that contains the text.
; I repeat, COPY THE FILE, not the text inside it.
; path and filename will be retrieved from clipboard. So simply execute this script after it.

if FileExist( clipboard )
{
Gui, Add, Checkbox, Checked 1 vFolder, to Folder?
Gui, Add, Text,, Delimiter Character:
Gui, Add, Edit, vDelimiter
Gui, Add, Text,, Append Prefix to Content:
Gui, Add, Edit, vPrefix
Gui, Add, Button, default, Accept
Gui, Show,, Delimiter
}
Return

; FAST WAY
ButtonAccept:
Gui, Submit
FileRead, NewText, %clipboard%
if Delimiter && !Folder
StringReplace, NewText, NewText, %A_Space%%Delimiter%%A_Space%, %Delimiter%, All

Loop, parse, NewText, `n, `r
	{
	if (Folder = True)
	FileCreateDir, %A_ScriptDir%\%A_loopfield%
	else {
	FileCreateDir, %A_ScriptDir%\file list
	line := A_loopfield
	if Delimiter
		{
	StringSplit, StringArray, line, %Delimiter%
	FileAppend,%Prefix%%StringArray2%, %A_ScriptDir%\file list/%StringArray1%.txt
		}
		else
		{
	FileAppend,%Prefix%, %A_ScriptDir%\file list/%line%.txt
		}
		}
	SendInput, {F5}
	}
Return

GuiClose:
ExitApp