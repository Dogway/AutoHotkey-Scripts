; #NoEnv
SetWorkingDir %A_ScriptDir%
#singleInstance, Force
#persistent


Gui, +AlwaysOnTop
Gui, Add, Text,, Enter Subfolder Name:
Gui, Add, Edit, vsub w200
Gui, Add, Text,, Enter Genre:
Gui, Add, Edit, vgen w200
Gui, Add, Text,, Enter Default Year:
Gui, Add, Edit, vyear w200
Gui, Add, Button, Default w+100, OK
Gui, Add, Button, x+20 w+100, Cancel
Gui, Show,, Music Videos NFO Creator
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


Loop, %Path%\*.*,1,0 ; loop through all folder in emuPath
{

SplitPath, A_LoopFileFullPath, name, Path, ext, name_no_ext,

MyArray := StrSplit(name_no_ext, " - ")

Var1 := % MyArray[1]
Var2 := % MyArray[2]

TextBlock =
(
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<musicvideo>
	<track></track>
	<title>%Var2%</title>
	<artist>>%Var1%</artist>
	<album></album>
	<genre>%gen%</genre>
	<year>%year%</year>
</musicvideo>
)

if ext in mkv,avi,mp4,mpg,mpeg,m2v,ts,ogm,wmv,mov,asf,ram,rm,flv
FileAppend, %TextBlock%, %Path%\%name_no_ext%.nfo, CP65001

}

MsgBox, 4096, ,Finished!
Return

GuiClose:
ButtonCancel:
ExitApp