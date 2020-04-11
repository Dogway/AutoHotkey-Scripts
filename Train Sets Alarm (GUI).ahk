; Train Sets Alarm - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway


#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir%

; Add repeat everything again after a greater rest
; Add different sound at end of session

#persistent

Gui, Add, Text,, Time of set (secs):
Gui, Add, Edit, vsecs w150, 30
Gui, Add, Text,, Number of sets (times):
Gui, Add, Edit, vsets w150, 6
Gui, Add, Text,, Time for rest (secs):
Gui, Add, Edit, vrest w150, 0
Gui, Add, Text,, Repeat session (times):
Gui, Add, Edit, vrep w150, 2
Gui, Add, Button, Default w+50, OK 
Gui, Add, Button, x+20 w+50, Cancel
Gui, Show,, Train Sets Alarm
return

ButtonOK:
Gui, Submit 
Secs := (secs ? secs : 0) * 1000
Rest := (rest ? rest : 0) * 1000
Rep  := (rep == 0 ? 1 : rep)
Sets := sets * rep

ChangeSession := "C:\Windows\Media\Windows Hardware Fail.wav"
StartSet := "C:\Windows\Media\Windows Hardware Insert.wav"
EndSet := "C:\Windows\Media\Windows Hardware Remove.wav"
EndRoutine := "C:\Windows\Media\tada.wav"

loop, %sets%
{
; Show prep time initially
if ( A_Index = 1 )
	{
	SplashImage,,  b fs36 CTffffff CW75b800, 15 SECS PREP TIME
	sleep 1000
	}

SplashImage, Off
SplashImage,,  b fs36 CTffffff CW75b800, SET NUMBER %A_Index%
; Change sound at start of repeat cycle
if ( A_Index = sets/rep+1 )
SoundPlay, %ChangeSession%, wait
else
SoundPlay, %StartSet%, wait
sleep %secs%

; Do not show rest time at end
if ( A_Index != sets )
	{
	SplashImage, Off
	Rest2 := Floor(rest/1000)
	SplashImage,,  b fs36 CTffffff CW75b800, REST TIME: %Rest2% SECS
	if ( rest > 1000 ) {
		if ( A_Index = sets/rep ) {
		SoundPlay, %ChangeSession%, wait
		} else {
		SoundPlay, %EndSet%, wait
		} }
	sleep,% rest
	} else {
	SoundPlay, %EndRoutine%, wait
	}
}
ExitApp
Return


GuiClose:
ButtonCancel:
ExitApp
+esc::
ExitApp