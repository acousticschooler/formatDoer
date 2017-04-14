;~ This script runs after Razer Synapse has been downloaded and then installs it.
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Input
DetectHiddenText, On
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%

IfWinExist, Blizzard App Setup
	WinActivate, Blizzard App Setup
else
	WinWait, Blizzard App Setup

WinWaitActive, Blizzard App Setup
Loop{
	Sleep, 100
	PixelGetColor, color, 137, 358, RGB
	if color = 0x008FD6
	{
		break
	}else{
		Sleep, 100
}
}

WinWaitActive, Blizzard App Setup
PixelGetColor, color, 270,263 , RGB

if(color = 0x0986CE)
	ControlClick, x274 y260
	Sleep 100
	ControlClick, x600 y420

if(color = 0x0E1116)
	ControlClick, x600 y420

IfWinExist, Blizzard App Login
	WinActivate, Blizzard App Login
else
	WinWait, Blizzard App Login
Sleep 100

WinWaitActive, Blizzard App Login
WinClose, Blizzard App Login
ExitApp