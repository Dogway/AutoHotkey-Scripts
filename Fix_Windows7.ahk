; Fix Windows 7 - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway

#NoEnv
#InstallKeybdHook

SendMode Input
SetWorkingDir %A_ScriptDir%

;Explorer
; Disables ctrl+W to avoid Explorer closing by mistake
; Disables file deletion with Ctrl+D, Undo with Ctr+Z and F1 (help)
; Disables F11 (Full Screen) for FileExplorer
; F3 for New Folder
; Ctrl+F for Search (With FileSearchEX)
; Ctrl+I for Invert Selection
; Ctrl+D for Detail View
; Ctrl+V for Thumbnail View


;General
; Disable Capslock
; Disable Ctrl+Wheel (Resize Icons) when on Desktop
; Disable Alt+F4 (Shutdown) when taskbar is in focus
; Disable Alt+Shift (taskbar language switch) while in Photoshop and Blender
; Disable Win+F (Windows Search)
; Alt+T for Always on Top on Active Window
; MMB for Closing Window
; Win+MMB for Minimizing Window


GroupAdd, FileExplorer, ahk_class CabinetWClass
GroupAdd, FileExplorer, ahk_class ExploreWClass

;Perform a WinClose with MMB for all applications except the Exclude Group and the Minimize group
Exclude := "TaskSwitcherWnd" . "NotifyIconOverflowWindow" . "Progman" . "WorkerW" . "ExploreWClass" . "DV2ControlHost" . "Shell_TrayWnd" . "Qt5QWindowIcon" . "Photoshop" . "MozillaWindowClass" . "Chrome_WidgetWin_1"
Minimizing := "WindowsForms10.Window.8.app.0.378734a" . "wxWindowClassNR"



; Block Alt+F4 when taskbar is in focus (it will try to Shut Windows)
!F4::
If !WinActive("ahk_class Shell_TrayWnd")
Winclose, A
Return

; Disable Ctrl+WheelUp/Down when mouse is over Desktop (Icon Resizing)
^WheelUp::
MouseGetPos, , , id, control
WinGetClass, class, ahk_id %id%
Desktop := "Progman" . "WorkerW"

IfInString, Desktop, %class%
	SendInput, {}
else
	SendInput, ^{WheelUp}
Return

^WheelDown::
MouseGetPos, , , id, control
WinGetClass, class, ahk_id %id%
Desktop := "Progman" . "WorkerW"

IfInString, Desktop, %class%
	SendInput, {}
else
	SendInput, ^{WheelDown}
Return



;Perform a WinClose with MMB for all applications except the Exclude Group and the Minimize group

;TaskSwitcherWnd ;alt-tab window
;NotifyIconOverflowWindow ;notification area (square box above the taskbar's systray (system tray)
;Progman ;desktop
;WorkerW ;desktop after win+d
;CabinetWClass ;folder windows
;ExploreWClass ;folder windows
;DV2ControlHost ;start menu
;Shell_TrayWnd ;taskbar
;GroupAdd, Exclude, ahk_class ZBrush
;GroupAdd, Exclude, ahk_class Qt5QWindowIcon ; maya, substance designer, Nuke, KeepPassXC
;GroupAdd, Exclude, ahk_class WxWindowNR ; RizomUV
;GroupAdd, Exclude, ahk_class GHOST_WindowClass ; blender
;GroupAdd, Exclude, ahk_class Photoshop ; Photoshop
;GroupAdd, Exclude, ahk_class MozillaWindowClass ; Firefox and Palemoon
;GroupAdd, Exclude, ahk_class Chrome_WidgetWin_1 ; Vivaldi
;GroupAdd, Exclude, ahk_class QWidget ; Marvelous Designer

;GroupAdd, Minimizing, ahk_class WindowsForms10.Window.8.app.0.378734a ; emClient
;GroupAdd, Minimizing, ahk_class wxWindowClassNR ; AVSpMod
;GroupAdd, Minimizing, ahk_class TForm1 ; speedfan (wanted to autominimize, but shares class with FileExplorer)


~<#MButton::
MouseGetPos, , , id, control
WinGetClass, winclass, ahk_id %id%

IfInString, Minimizing, %winclass%
{
	WinMinimize, ahk_id %id%

} else IfNotInString, Exclude, %winclass%
{

	WinMinimize, ahk_id %id%

}
Return

~MButton::
MouseGetPos, , , id, control
WinGetClass, winclass, ahk_id %id%
WinGetTitle, title, ahk_id %id%


IfInString, Minimizing, %winclass%
{
	WinMinimize, ahk_id %id%

} else IfNotInString, Exclude, %winclass%
{
	if (title="eM Client")
	WinMinimize, ahk_id %id%
	else if (title="SpeedFan 4.51") {
	WinHide, ahk_id %id%
	WinSet, ExStyle, +0x80, ahk_id %id%
	}
	else
	WinClose, ahk_id %id%

}
Return


; Closes taskbar buttons with MMB. I have a program (7+TaskbarTweaker), but here is for future reference
~MButton::
	MouseGetPos, xpos, ypos, WinID, ControlUnderMouse
	If (ControlUnderMouse = "MSTaskSwWClass1" || ControlUnderMouse = "ApplicationManager_DesktopShellWindow" || ControlUnderMouse = "Shell_TrayWnd1" || ControlUnderMouse = "MSTaskListWClass1")
	{
	MouseClick, Right, %xpos%, %ypos%
	Sleep, 200
	Send, {Up}
	Send, {Enter}
	}
Return



; Makes current window "Always on Top"
!t::
WinGet, currentWindow, ID, A
WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
{
	Winset, AlwaysOnTop, off, ahk_id %currentWindow%
	SplashImage,, x0 y0 b fs12 CT000000 CWffcc00, OFF always on top.
	Sleep, 1500
	SplashImage, Off
}
else
{
	WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
	SplashImage,, x0 y0 b fs12 CT000000 CWffcc00, ON always on top.
	Sleep, 1500
	SplashImage, Off
}
Return

; Copies the last 8 secs clipboard text and create a new folder with its text
; otherwise normal "new folder" command
global clipboardCreatTime := A_TickCount
 
OnClipboardChange:
    clipboardCreatTime := A_TickCount
return

getClipboard(seconds = 8) {
    t_limit := seconds * 1000
    clipboardAge := A_TickCount - clipboardCreatTime
    if (clipboardAge < t_limit) {
;        clipboard := clipboard
        return clipboard
    }
}


; Disable Win+F, Shortcut for FileSearchEX (Ctrl+F) and Create Folder (F3)
#IfWinActive, ahk_group FileExplorer
#f::return

~^f::
SendInput !a{ENTER}
Return

; Invert selection
~^i::
ControlGet, hCtl, Hwnd,, SHELLDLL_DefView1, A
PostMessage, 0x111, 28706, 0,, % "ahk_id " hCtl
Return

; Detail View
~!d::
ControlGet, hCtl, Hwnd,, SHELLDLL_DefView1, A
PostMessage, 0x111, 28747, 0,, % "ahk_id " hCtl
Return

; Thumbnail View
!v::
ControlGet, hCtl, Hwnd,, SHELLDLL_DefView1, A
PostMessage, 0x111, 28751, 0,, % "ahk_id " hCtl
Return


~F3::
if (GetClipboard() = "" ) or (instr(Clipboard, "\"))
	{
	send !anc
	}
else
	{
SendInput {ENTER}
ControlGetText, currentPath, ToolbarWindow322, A
Var := SubStr(currentPath, InStr(currentPath, ":\")-1)
FileCreateDir, %Var%\%clipboard%
send {F5}
	}
Return
#IfWinActive



; Disables taskbar language switch in Photoshop and Blender
#If WinActive("ahk_class Photoshop")
!Shift::SendInput, {}
Return
#If



;######################################

; Disable Capslock
CapsLock::SendInput {Tab}
*CapsLock::Return
SetCapsLockState, off

;######################################

; Disables Full Screen for FileExplorer
#If !WinActive("ahk_class Notepad2U") && WinActive("ahk_group FileExplorer")
F11::SendInput, {}
#If

; Disables ctrl+W to avoid Explorer closing by mistake
#If !WinActive("ahk_class Notepad2U") && WinActive("ahk_group FileExplorer")
^w::SendInput, {}
#If

; Disables file deletion with Ctrl+D, Undo with Ctr+Z and F1 (help)
#If WinActive("ahk_group FileExplorer")
^d::SendInput, {}
^z::SendInput, {}
F1::SendInput, {}
#If

Return

