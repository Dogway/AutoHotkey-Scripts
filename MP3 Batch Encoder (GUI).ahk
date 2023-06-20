; MP3 Batch Encoder - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway
;
; Advanced and Convenient MP3 Batch encoder
;
; Useful for Music, to compress to high quality MP3s with IDtags*, ReplayGain2 and keeping the timestamp
; As well as for Movie tracks, by downmixing, setting the proper Loudness Target and optionally a new mode:
; and optionally a new mode MovieNight which compresses the dynamic range while enhancing dialog to make it apt to night sessions.
;
; * LAME only supports writing to v2.3, so you need to convert to v2.4 later in Mp3tag, as well as for adding the compilation, disc number and cover image tags.

SetWorkingDir %A_ScriptDir%
#SingleInstance, Force
#Persistent

Gui, +AlwaysOnTop
Gui, Add, Text, , RSGAIN executable path:
Gui, Add, Edit, -Wrap r1 w445 versg, %A_ScriptDir%
Gui, Add, Text, , LAME     executable path:
Gui, Add, Edit, -Wrap r1 w445 velam, %A_ScriptDir%
Gui, Add, Text, x15 y110, Loudness Target:
Gui, Add, DropDownList, x15 y130 w90 h20 gMode vLoud w113 h200, Music (-18)||Movie (-23)|MovieNight (-18)|
Gui, Add, Checkbox, x+15 y132 vLFE Checked, Incl`. LFE
Gui, Add, Checkbox, x+15 y132 vTS Checked, Preserve TimeStamp
Gui, Add, Text, x15 y170, Enter Scan Folder Path:
Gui, Add, Checkbox, x+15 vRec, Recursive
Gui, Add, Text, x+10, Search for:
Gui, Add, DropDownList, x+10 y165 w90 h20 gPresets vEntry w100 h200, Audio Lossless||Audio Lossy|Video|
Gui, Add, Edit, -Wrap r1 x15 vsub w440
Gui, Add, Text, x15 y230, Enter Save Folder Path:
Gui, Add, Text, x+96 y230, Quality:
Gui, Add, DropDownList, x+27 y225 w90 h20 gPresAud vQuali w100 h200, VBR V0||CBR 320Kbps|
Gui, Add, Edit, -Wrap r1 x15 vgen w440
Gui, Add, Button, Default w+100, OK
Gui, Add, Button, x+20 w+100, Cancel
Gui, Add, Text, x+46 y285, Jose Linares
Gui, Add, Text, x+10 y285 ca6a6ff gLaunchLink, (github.com/Dogway)
Gui, Show,, MP3 Batch Encoder

; Music (-18)
LR := [ "-18", "18" ]
; (Audio Lossless)
Fmt := { wav: 1, wv: 1, pcm: 1, raw: 1, rf64: 1, aiff: 1, flac: 1, ape: 1, alac: 1, tak: 1, tta: 1, thd: 1, ofr: 1, wmal: 1 }
Return

Presets:
Gui, Submit, NoHide
If (Entry = "Audio Lossy")
    Fmt := { m4a: 1, aac: 1, wma: 1, mka: 1, ogg: 1, oga: 1, ac3: 1, eac3: 1, dts: 1, mp2: 1, mpa: 1, rma: 1, ra: 1, gsm: 1, au: 1, mpc: 1, opus: 1 }
If (Entry = "Video")
    Fmt := { mkv: 1, avi: 1, mp4: 1, mpg: 1, mpeg: 1, mpe: 1, m2v: 1, m2ts: 1, ts: 1, ogm: 1, wmv: 1, mov: 1, asf: 1, ram: 1, rm: 1, flv: 1, vob: 1 }
Return

LaunchLink:
Run https://github.com/Dogway
Return

PresAud:
Gui, Submit, NoHide
Qual := Quali = "CBR 320Kbps"
Return

Mode:
Gui, Submit, NoHide
If (Loud = "Movie (-23)")
    LR := [ "-23", "20" ]
Return

ButtonOK:
Gui, Submit, nohide

If sub =
{
    MsgBox, 4096, ,Folder Path can't be Empty!
    ExitApp
}

LR1 := % LR[1]
LR2 := % LR[2]

gen := (gen == "") ? sub : gen

NM  := (Loud = "MovieNight (-18)")
LFE := LFE  ? "-lfe_mix_level 1 " : ""
CML := NM   ? "-center_mixlev 1 " : ""
MP3 := Qual ? "--preset insane"   : "-V 0 -q 2" ; preset insane vs preset extreme (could also do "--preset cbr 256")


Loop, %sub%\*.*,0,%ReC%
{

    SplitPath, A_LoopFileFullPath,, SubPath, ext, name_no_ext,

    If (Fmt[ext]) {

        If (Rec == 1) && (sub != gen) {
            StringReplace, SubPath, SubPath, %sub%, %gen%
            IfNotExist, %SubPath%
            FileCreateDir, %SubPath%
        }
        NewFilePath := SubPath . "\" . name_no_ext


        ch := ComObjCreate("WScript.Shell").Exec("ffprobe -i """ . A_LoopFileFullPath . """ -hide_banner -show_entries stream=channels -of compact=p=0:nk=1 -v 0").StdOut.ReadAll()
        sleep 500
        StringReplace, ch, ch,`r`n,,1
        StringLeft, ch, ch, 1
        sleep 500

        If (ch < 3) && (Loud = "Music (-18)") {

            ; Extract Metadata
            RunWait, % "ffmpeg -i """ . A_LoopFileFullPath . """ -v 0 -f ffmetadata """ . NewFilePath . "meta.txt""" ,, Hide
            sleep 500

            Loop, Read, %NewFilePath%meta.txt
            {
                If (A_Index == 1)
                    goto reloop
                warr := StrSplit(A_LoopReadLine, "=")
                StringLower, warr1, % warr[1]
                If (warr1 == "track")
                    track := warr[2]
                If (warr1 == "artist")
                    artist := warr[2]
                If (warr1 == "title")
                    title := warr[2]
                If (warr1 == "album")
                    album := warr[2]
                If (warr1 == "genre")
                    genre := warr[2]
                If (warr1 == "date")
                    date := warr[2]
                If (warr1 == "disc")
                    disc := warr[2]
                If (warr1 == "album_artist")
                    album_artist := warr[2]
                If (warr1 == "composer")
                    composer := warr[2]
                If (warr1 == "comment")
                    comment := warr[2]
                reloop:
            }
            ; From filename if Metadata is empty
            If (artist == "") {
                NT := StrSplit(name_no_ext, " - ")
                artist := NT[1]
                title  := NT[2]
            }
            ; Missing cover, disc, composer, and album_artist (+ comment)
            metadata := " --id3v2-only --tt """ . title . """ --ta """ . artist . """ --tl """ . album . """ --ty """ . date . """ --tn """ . track . """ --tg """ . genre . """"

            ; Encode and assign Metadata
            call := "ffmpeg -i """ . A_LoopFileFullPath . """ -v 0 -f wav -bitexact -map_metadata -1 -acodec pcm_f32le - | """ . elam .  "\lame.exe"" -m j " . MP3 . metadata . " --noreplaygain --quiet - """ . NewFilePath . ".mp3"""
            RunWait, %comspec% /c %call%,, Hide
            sleep 1000

            ; Add ReplayGain2
            RunWait, % """" . ersg . "\rsgain.exe"" custom -t -I 4 -m -2.0 -L -s i -c p -l " . LR1 . " """ . NewFilePath . ".mp3""" ,, Hide
            FileDelete, %NewFilePath%meta.txt

        } Else {

            ; Extract and Decode (and Downmix)
            NV := (Entry = "Video") ? " -vn " : ""
            If (ch > 2)
                RunWait, % "ffmpeg -i """ . A_LoopFileFullPath . """ -v 0 -f wav -bitexact " . LFE . CML . NV . "-map_metadata -1 -acodec pcm_f32le -ac 2 """ .  NewFilePath . "32.wav""" ,, Hide
            Else
                RunWait, % "ffmpeg -i """ . A_LoopFileFullPath . """ -v 0 -f wav -bitexact " . NV . "-map_metadata -1 -acodec pcm_f32le """ . NewFilePath . "32.wav""" ,, Hide
            sleep 1000

            ; Measure Loudness
            call := "ffmpeg -i """ . NewFilePath . "32.wav"" -hide_banner -nostats -loglevel info -threads 1 -filter:a loudnorm=I=" . LR1 . ":LRA=" . LR2 . ":TP=-2.0:print_format=json -f null NUL 2> """ . NewFilePath . "LOUD.txt"""
            RunWait, %comspec% /c %call% ,, Hide

            Loop {
            FileReadLine, line, %NewFilePath%LOUD.txt, %A_Index%
                if ErrorLevel
                    break
                if inStr(line, "input_i")
                    RegExMatch(line, "	""input_i"" : ""(.*?)""," , mes_i)
                if inStr(line, "input_tp")
                    RegExMatch(line, "	""input_tp"" : ""(.*?)""," , mes_tp)
                if inStr(line, "input_lra")
                    RegExMatch(line, "	""input_lra"" : ""(.*?)""," , mes_lra)
                if inStr(line, "input_thresh")
                    RegExMatch(line, "	""input_thresh"" : ""(.*?)""," , mes_thres)
            }
            filter_complex := "loudnorm=linear=true:I=" . LR1 . ":LRA=" . LR2 . ":TP=-2.0:measured_I=" . mes_i1 . ":measured_LRA=" . mes_lra1 . ":measured_tp=" . mes_tp1 . ":measured_thresh=" . mes_thres1

            ; Normalize to Loudness Target and Encode
            call := "ffmpeg -i """ . NewFilePath . "32.wav"" -v 0 -f wav -bitexact -map_metadata -1 -filter_complex " . filter_complex . " -acodec pcm_f32le - | """ . elam .  "\lame.exe"" -m j " . MP3 . " --noreplaygain --quiet - """ . NewFilePath . ".mp3"""
            RunWait, %comspec% /c %call% ,, Hide

            sleep 1000
            FileDelete, %NewFilePath%32.wav
            FileDelete, %NewFilePath%LOUD.txt
        }

        If TS {
            FileGetTime, MT, %A_LoopFileFullPath%, M
            FileGetTime, CT, %A_LoopFileFullPath%, C
            FileGetTime, AT, %A_LoopFileFullPath%, A
            FileSetTime, MT, %NewFilePath%.mp3, M
            FileSetTime, CT, %NewFilePath%.mp3, C
            FileSetTime, AT, %NewFilePath%.mp3, A
            }

        }
}

MsgBox, 4096, ,Finished!
Return

GuiClose:
ButtonCancel:
ExitApp
