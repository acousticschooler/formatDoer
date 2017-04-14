;~ This script runs after Razer Synapse has been downloaded and then installs it.
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Input
DetectHiddenText, On
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%

PixelGetColor, color, 300, 362
While !(color = "0xCCCCCC")
PixelGetColor, color, 300, 362

IfWinExist, Razer Synapse - InstallShield Wizard
	WinActivate, Razer Synapse - InstallShield Wizard
else
	WinWait, Razer Synapse - InstallShield Wizard

WinWaitActive, Razer Synapse - InstallShield Wizard
ControlClick, Button1
Sleep, 300

IfWinExist, Razer Synapse - InstallShield Wizard
	WinActivate, Razer Synapse - InstallShield Wizard
else
	WinWait, Razer Synapse - InstallShield Wizard

WinWaitActive, Razer Synapse - InstallShield Wizard
ControlClick, Button3
Sleep, 300
ControlClick, Button5
Sleep, 300

IfWinExist, Razer Synapse - InstallShield Wizard
	WinActivate, Razer Synapse - InstallShield Wizard
else
	WinWait, Razer Synapse - InstallShield Wizard

WinWaitActive, Razer Synapse - InstallShield Wizard
ControlClick, Button1
Sleep, 100

PixelGetColor, color, 475, 360
While !(color = "0xCCCCCC")
PixelGetColor, color, 475, 360

IfWinExist, Razer Synapse - InstallShield Wizard
	WinActivate, Razer Synapse - InstallShield Wizard
else
	WinWait, Razer Synapse - InstallShield Wizard

WinWaitActive, Razer Synapse - InstallShield Wizard
Sleep, 100
ControlClick, Button3
Sleep, 100
ControlClick, Button1
ExitApp