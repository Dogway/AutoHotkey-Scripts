; Resolve fcpxml EditList to AVS Trims - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway


#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir%

; Converts DaVinci Resolve .fcpxml cut edit file to Avisynth legible Trims()
; It works for cuts, but not for logos, and probably either for Fades

FileSelectFolder,EditList
if EditList=
   return

FPS := 60

loop
		{
FileReadLine, line, %EditList%, %A_Index%
	if ErrorLevel
		break
	if inStr(line, "`<clip name") {
		RegExMatch(line, "`<clip name=""(.*?)""" , name)
		RegExMatch(line, " start=""(.*?)s""" , trimIN)
		RegExMatch(line, " duration=""(.*?)s""" , durat)
		trimINf := % Split(trimIN1, "/", FPS)
		duratf := % Split(durat1, "/", FPS)
		trimOUTf := % duratf + trimINf
		trimINf := % Format("{:d}", trimINf)
		trimOUTf := % Format("{:d}", trimOUTf)
		FileAppend, ffvideosource`(`"%name1%`"`).trim`(%trimINf%`,%trimOUTf%`)`n, %A_ScriptDir%\Avisynth-Trims.txt
	}
}

Split(InputV, Sep, FPS) {
	StringArray := StrSplit(InputV, Sep)
	Num := StringArray[1]
	Div := StringArray[2]
	Return % Num / Div * FPS
}

Return