; Multiline Multifile Text Replacer - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway

SetWorkingDir %A_ScriptDir%
#singleInstance, Force
#persistent

; Change in all text files under subfolder a needle term and
; substitute by another single or multiline string


Gui, +AlwaysOnTop
Gui, Add, Text,, Enter Subfolder name:
Gui, Add, Edit, vsub w200
Gui, Add, Checkbox, y+-25 x+45 vRegex, RegEx
Gui, Add, Checkbox, x+25 Checked 1 vDepth, MultiDepth
Gui, Add, Checkbox, y+5 x+-152 Checked 1 vBackup, BackUp
Gui, Add, Text, y+2 x+-305, Enter text to replace:  (Remember \1 is $1 and use (.*?) for non multi-line matches)
Gui, Add, Edit, vNeedle R8 w500
Gui, Add, Text,, Enter replacement text:
Gui, Add, Edit, vReplacement R8 w500
Gui, Add, Button, Default w+100, OK 
Gui, Add, Button, x+20 w+100, Cancel
Gui, Show,, Replace Paragraphs
return

ButtonOK:
Gui, Submit, nohide

IF sub =
{
MsgBox, 4096, ,Sub Cant be Empty!

}

SubFolder := sub
Path := A_ScriptDir . "\" . SubFolder

IF Path = A_ScriptDir
{
MsgBox, 4096, ,Error Path! %path%	
ExitApp
}

; I need to refine a few things, avoid to change text file format (ANSI, UTF, etc)
StringCaseSense On
Loop, %Path%\*,0,%Depth%
{
	SplitPath, A_LoopFileName,,, ext, name_no_ext,
	if ext not in txt,text,md,slangp,glslp,slang,glsl,xml,yml,xaml,json,csv,nfo,c,cpp,py,pyc,frag,ini,reg,dat,cue,theme,m3u,dgi,fx,cg,cgp,hlsl,glsl,cfg,ibb,ibg,jobs,config,eml,dic,html,htm,xhtml,lua,srt,ass,php,avs,avsi,bat,cmd,ahk,js,vb,vbs,cs,css,java,jav,log,xpadderprofile,mel,mb,ma,gizmo,ies,chm,hlp
	goto reloop
	Path := % (Depth != true) ? Path : A_LoopFileDir
	FileRead, content, *t *m104857600 %Path%\%A_LoopFileName%

	if !RegEx
		{
		StringReplace, NewContent, content, `r`n,`n, All
		StringReplace, NewText, NewContent, %Needle%, %Replacement%, All
		}
		else
		NewText := RegExReplace("" . content . "", "" . Needle . "", "" . Replacement . "")

	if (NewContent == NewText) OR (Content == NewText)
	goto reloop
	if !RegEx
	StringReplace, NewText, NewText, `n, `r`n, All

	if Backup
	{
    ifExist, %Path%\%name_no_ext%-Old.%ext%
		{
		FileDelete, %Path%\%name_no_ext%-Old.%ext%
		}
    FileMove, %Path%\%A_LoopFileName%, %Path%\%name_no_ext%-Old.%ext%
	}
	else
		FileDelete, %Path%\%A_LoopFileName%

	FileAppend, %NewText%, %Path%\%A_LoopFileName%
	reloop:
}
Return

GuiClose:
ButtonCancel:
ExitApp