; PAR2+PAR3 Generator - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway
;
; Scans "Scan Folder" path (and its subfolders) for files matching the "Preset" extensions
; and creates PAR2 and/or PAR3 recovery files on the "Save Folder" path.
;
; Suggested PAR2 and PAR3 builds:
; https://github.com/animetosho/par2cmdline-turbo
; https://github.com/Parchive/par3cmdline


SetWorkingDir %A_ScriptDir%
#SingleInstance, Force
#Persistent


Gui, +AlwaysOnTop
Gui, Add, Text, x72, PAR2 executable path:
Gui, Add, Checkbox, x15 y25 vcpar2 Checked, Incl`.
Gui, Add, Edit, -Wrap r1 x+15 y25 w445 vepar2, %A_ScriptDir%\par2.exe
Gui, Add, Text,, PAR3 executable path:
Gui, Add, Checkbox, x15 y70 vcpar3 Checked, Incl`.
Gui, Add, Edit, -Wrap r1 x+15 y70 w445 vepar3, %A_ScriptDir%\par3.exe
Gui, Add, Text, x15 , Enter Scan Folder Path (Recursive):
Gui, Add, Edit, -Wrap r1 x15 vsub w500
Gui, Add, Text,, Enter Save Folder Path:
Gui, Add, Edit, -Wrap r1 x15 vgen w500
Gui, Add, Button, Default w+100, OK
Gui, Add, Button, x+20 w+100, Cancel
Gui, Add, DropDownList, x+30 y190 w90 h20 gPresets vEntry w100 h200, Video||Games|Software|eBooks|Archives|
Gui, Add, Checkbox, x+15 y195 vnm Checked, Excl`. '`.nomedia' folders
Gui, Show,, PAR2+PAR3 Batch Recovery File Generator


Presets:
Gui, Submit, NoHide
If (Entry = "Video")
    Fmt := { mkv: 1, avi: 1, mp4: 1, mpg: 1, mpeg: 1, mpe: 1, m2v: 1, m2ts: 1, ts: 1, ogm: 1, wmv: 1, mov: 1, asf: 1, ram: 1, rm: 1, flv: 1, vob: 1 }
If (Entry = "Games")
    Fmt := { 3ds: 1, iso: 1, chd: 1, zip: 1, 7z: 1, wua: 1, wad: 1, rvz: 1, cso: 1, cdi: 1, xci: 1, nsp: 1 }
If (Entry = "Software")
    Fmt := { exe: 1, msi: 1, elf: 1, bin: 1, deb: 1, rpm: 1, pkg: 1, app: 1, apk: 1, ipa: 1, jar: 1, ahk: 1 }
If (Entry = "eBooks")
    Fmt := { cbr: 1, cbz: 1, cbt: 1, cb7: 1, pdf: 1, djvu: 1, djv: 1, epub: 1, epub3: 1, azw: 1, azw3: 1, mobi: 1, kfx: 1, prc: 1, fb2: 1, warc: 1, wacz: 1 }
If (Entry = "Compressed")
    Fmt := { zip: 1, zipx: 1, 7z: 1, rar: 1, arc: 1, part: 1, tar: 1, gz: 1, iso: 1, dmg: 1, img: 1, zst: 1, tzst: 1, tzstd: 1, doi: 1, br: 1, bz2: 1, lz: 1, lz4: 1, lzma: 1, rz: 1, xz: 1, ace: 1 }
Return


ButtonOK:
Gui, Submit, nohide


If sub =
{
    MsgBox, 4096, ,Folder Path can't be Empty!
    ExitApp
}
If gen =
{
    MsgBox, 4096, ,Folder Path can't be Empty!
    ExitApp
}

Path  := sub


Loop, %Path%\*.*,0,1 ; loop through all folders and subfolders
{
    SplitPath, A_LoopFileFullPath, name, SubPath, ext, name_no_ext,

    ; Check for .nomedia
    if nm {
        ifExist, %SubPath%\*.nomedia
        Goto reloop
    }

    If (Fmt[ext]) {

        if      (A_LoopFileSizeMB < 512)
        PER := 15
        else if (A_LoopFileSizeMB < 3072)
        PER := 10
        else if (A_LoopFileSizeMB < 5120)
        PER := 7
        else if (A_LoopFileSizeMB < 16384)
        PER := 5
        else
        PER := 3

        ; Retrieve upper parent folder if parent folder contains "Season", "Temporada" or "S##" string
        If InStr(A_LoopFileDir, "Season", 0) or InStr(A_LoopFileDir, "Temporada", 0) or RegExMatch(A_LoopFileDir, "(\w|)S\d\d\ ")
        {
            StringGetPos,pos,A_LoopFileDir,\,R2
            StringTrimLeft,ParentFolder,A_LoopFileDir,pos+=1
            StringGetPos,pos,ParentFolder,\,R
            StringLen, AppLen, ParentFolder
            StringTrimRight,ParentFolder,ParentFolder,AppLen-pos
        } else {
            StringGetPos,pos,A_LoopFileDir,\,R
            StringTrimLeft,ParentFolder,A_LoopFileDir,pos+=1
        }


        if cpar2 {
            IfNotExist, %gen%\%ParentFolder%\PAR2
            FileCreateDir, %gen%\%ParentFolder%\PAR2
            ifExist, %gen%\%ParentFolder%\PAR2\%name_no_ext%.par2
            Goto next

            SetWorkingDir, %gen%\%ParentFolder%\PAR2
            RunWait, "%epar2%" c -s5120000 -r%PER% -B "%SubPath%" "%name_no_ext%.par2" "%A_LoopFileFullPath%"
        }

        next:
        Sleep 1000

        if cpar3 {
            IfNotExist, %gen%\%ParentFolder%\PAR3
            FileCreateDir, %gen%\%ParentFolder%\PAR3
            ifExist, %gen%\%ParentFolder%\PAR3\%name_no_ext%.par3
            Goto reloop

            SetWorkingDir, %SubPath%
            RunWait, "%epar3%" c -s5120000 -r%PER% -v "%gen%\%ParentFolder%\PAR3\%name_no_ext%.par3" "%name_no_ext%`*.%ext%"
        }
    }

    reloop:
}

MsgBox, 4096, ,Finished!
Return

GuiClose:
ButtonCancel:
ExitApp
