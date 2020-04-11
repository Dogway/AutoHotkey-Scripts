; Time Alarm - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway

#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir%

#persistent

Gui, Add, Text,, Time until Alarm (mins):
Gui, Add, Edit, vmins
Gui, Add, Text,, Time until Alarm (secs):
Gui, Add, Edit, vsecs
Gui, Add, Button, Default w+50, OK
Gui, Add, Button, x+20 w+50, Cancel
Gui, Show,, Time Alarm
return 

ButtonOK:
Gui, Submit 
Mins := (mins ? mins : 0) * 60000
Secs := (secs ? secs : 0) * 1000
Time := Secs + Mins
settimer, alarm, %Time%
return

alarm:
SoundBeep, 261, 20
MsgBox,4096,, Visual Alarm is ON!!, % (Time/1000)/10
Return

GuiClose:
ButtonCancel:
ExitApp
+esc::
ExitApp