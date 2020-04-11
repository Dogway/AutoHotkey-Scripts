; CG_Hotkeys - AHK Script
;    Jose Linares -Dogway-
;        >> https://github.com/Dogway


#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent

SetTitleMatchMode, 2 ; Partial Match, use all the partial match blocks at the top of the Script
;USE
	;if WinActive("ahk_class Premiere Pro") ; then enclose in {}
	;or preferably
	;#IfWinActive, ahk_class Premiere Pro ; then close it with IfWinActive at the bottom

	;#If WinActive() or IfWinActive, , , are deprecated. Use preferably #IfWinActive if using hotkeys under it, so you can declare 2 same hotkeys under different circumstances



;Overall
; Disables taskbar language switch
!Shift::SendInput, {}



;##################################################################################


; Substance Designer

#MaxHotkeysPerInterval 250									; do not discard any WheelUp/Down event
#MaxThreads 250
#MaxThreadsPerHotkey 250
#MaxThreadsBuffer On
; #UseHook ; Adding $ before a hotkey is the same as setting #UseHook globally,
; and might make the above interval line not necessary. BUT wont work with mouse buttons or SendInputs.

; Substance Designer: Creates some shortcuts to create nodes rapidly

; Use Space and:

	;b -> blend
	;r -> Blur HQ
	;s -> Slope Blur
	;l -> levels
	;n -> show noises
	;m -> show clouds

	;f -> frame
	;c -> comment

	;u -> Uniform Color
	;g -> Gradient Map

#IfWinActive, Designer ahk_class Qt5QWindowIcon
; blend
~space & b::SendInput, {b}{ENTER}
; Blur HQ
~space & r::SendInput, {b}{l}{u}{down 3}{ENTER}
; Slope Blur
~space & s::SendInput, {s}{l}{down}{ENTER}
; levels
~space & l::SendInput, {l}{ENTER}
; show noises
~space & n::SendInput, {n}{o}{i}
; show clouds
~space & m::SendInput, {c}{l}{o}{u}

; frame
~space & f::SendInput, {f}{r}{ENTER}
; comment
~space & c::SendInput, {c}{o}{ENTER}

; Uniform Color
~space & u::SendInput, {u}{ENTER}
; Gradient Map
~space & g::SendInput, {ENTER}

; Invert Wheel Direction, This should work along the option
; in Preferences "Invert Zoom in views" enabled.
WheelUp::SendInput, {WheelDown}
WheelDown::SendInput, {WheelUp}
#IfWinActive
Return


; Substance painter

; Substance Designer: Creates some shortcuts to create nodes rapidly
; #IfWinActive, Painter ahk_class Qt5QWindowIcon
; Return
; #IfWinActive



;##################################################################################


; MAYA

; Maya: Reenable the º key to use for "live" component translation (tweak mode). Simply keybind Ctrl+Alt+\ to Tweak, in Maya pressing º will work as expected.
;SetTitleMatchMode, RegEx
#IfWinActive, Maya ahk_class Qt5QWindowIcon

SC029::SendInput, ^!{SC029}

; Disables Space button under certain color (Hypershade color) below the mouse
; If you want to maximize the hypershade window, clik Space over a node or a different color
Space::
Loop
{
	CoordMode,Mouse,Screen
	MouseGetPos , X, Y
	PixelGetColor, Color, %X%, %Y%
	if ( Color = 0x2F2F2F )
	Sendinput, {}
	else
	Sendinput, {space}
	Break
}
Return

;Use Tab and:

	;y -> layered texture
	;r -> ramp
	;s -> setRange
	;x -> multiplyDivide
	;e -> reverse
	;l -> luminance

	;f -> fractal

	;u -> surface shader
	;m -> rsMaterial


; Layered Texture Node
~Tab & y::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
SendInput, {LButton 3}{DEL}shadingNode -asTexture layeredTexture;{ENTER}
MouseMove, % X, % Y, 0
Return
~Tab & r::
; Ramp Node
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
SendInput, {LButton 3}{DEL}shadingNode -asTexture ramp;{ENTER}
MouseMove, % X, % Y, 0
Return
; Multiply Node
~Tab & x::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
SendInput, {LButton 3}{DEL}shadingNode -asUtility multiplyDivide;{ENTER}
MouseMove, % X, % Y, 0
Return
; Reverse Node
~Tab & e::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
SendInput, {LButton 3}{DEL}shadingNode -asUtility reverse;{ENTER}
MouseMove, % X, % Y, 0
Return
; Luminance Node
~Tab & l::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
SendInput, {LButton 3}{DEL}shadingNode -asUtility luminance;{ENTER}
MouseMove, % X, % Y, 0
Return
; Fractal Node
~Tab & f::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
SendInput, {LButton 3}{DEL}shadingNode -asTexture fractal;{ENTER}
MouseMove, % X, % Y, 0
Return
; Surface Shader Node
~Tab & u::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
SendInput, {LButton 3}{DEL}shadingNode -asShader surfaceShader;{ENTER}
MouseMove, % X, % Y, 0
Return

; SetRange Node
~Tab & s::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
; The first line ` escapes the character for the block
clipboard =
( `
string $setRange= `shadingNode -asUtility setRange -name "setRange"` ;
connectAttr ($setRange + ".oldMaxX") ($setRange + ".oldMaxZ") ;
connectAttr ($setRange + ".oldMaxX") ($setRange + ".oldMaxY") ;
connectAttr ($setRange + ".oldMinX") ($setRange + ".oldMinZ") ;
connectAttr ($setRange + ".oldMinX") ($setRange + ".oldMinY") ;
connectAttr ($setRange + ".maxX") ($setRange + ".maxZ") ;
connectAttr ($setRange + ".maxX") ($setRange + ".maxY") ;
connectAttr ($setRange + ".minX") ($setRange + ".minZ") ;
connectAttr ($setRange + ".minX") ($setRange + ".minY") ;
$setRange = `rename $setRange "setRange"` ;
)
SendInput, {LButton 3}{DEL}^v{ENTER}
MouseMove, % X, % Y, 0
Return

; rsMaterial Node
~Tab & m::
CoordMode,Mouse,Screen
MouseGetPos , X, Y
MouseMove, 100, 1370, 0
; The first line ` escapes the character for the block
clipboard =
( `
string $rsMat= `shadingNode -asShader RedshiftMaterial` ;
setAttr ($rsMat + ".refl_weight") 0 ;
setAttr ($rsMat + ".refl_brdf") 1 ;
setAttr ($rsMat + ".diffuse_color") -type double3 0.2 0.2 0.2 ;
$rsMat = `rename $rsMat "rsMaterial"` ;
)
SendInput, {LButton 3}{DEL}^v{ENTER}
MouseMove, % X, % Y, 0
Return
#IfWinActive
Return


;##################################################################################


; Premiere Pro

; Code to avoid timeline lose focus when Alt+Wheel (ZoomIn/Out)
#IfWinActive, ahk_class Premiere Pro
!WheelUp::
SendInput ^!{WheelUp}
!WheelDown::
SendInput ^!{WheelDown}
#IfWinActive
Return


;##################################################################################


; ZBrush

; ZBrush: Disable ctrl+shift+A (Everything) when using ZBrush
#IfWinActive, ahk_class ZBrush
^+A::SendInput, {}
; ZBrush: Remap Alt+WheelUp and Down to J and K to set those as Brush Resize in ZBrush
!WheelDown::SendInput, {j}
!WheelUp::SendInput, {k}
; Make Wheel Button behave as panning the camera, would like to map to Alt+WheelB as well but unable to
;MButton::SendInput, {Alt Down}{RButton Down}
;MButton Up::SendInput, {RButton Up}{Alt Up}
;!MButton::SendInput, {Alt Down}{RButton Down}
;!MButton Up::SendInput, {Alt Up + RButton Up}

; Resizes Brush by dragging the Middle Mouse Button to one side or the other, when these are mapped to J and K hotkeys in ZBrush
CoordMode, Mouse, Screen
~MButton::
    MouseGetPos, begin_x, begin_y
    while GetKeyState("MButton")
    {
        MouseGetPos, x, y
		Xo := x-begin_x

		if (Xo > 0)
		SendRaw, k
		else if (Xo < -0)
		SendRaw, j

		Sleep, 30
        }
; Needs more work** Move cursor up if too low when invoking the quick palette tool in Zbrush
~Space::
    while GetKeyState("Space")
    {
        MouseGetPos, x, y

		if (x > -980) && (x < 2170) && (y > 1100)
		{
		MouseMove, % x, 1100, 0
		SendInput, Space
		}
		Sleep, 3000
        }
Return
#IfWinActive


;##################################################################################

Return