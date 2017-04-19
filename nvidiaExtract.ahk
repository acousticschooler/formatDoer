;~ This script runs after Nvidia has been downloaded and then installs it.
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Input
DetectHiddenText, On
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%

IfWinExist, NVIDIA Display Driver v381.65 - International Package
	WinActivate, NVIDIA Display Driver v381.65 - International Package
else
	WinWait, NVIDIA Display Driver v381.65 - International Package

WinWaitActive, NVIDIA Display Driver v381.65 - International Package
Sleep, 300
ControlClick, OK

IfWinExist, NVIDIA Display Driver v381.65 - International
	WinActivate, NVIDIA Display Driver v381.65 - International
else
	WinWait, NVIDIA Display Driver v381.65 - International

Sleep 300

Loop{
	ControlGet, OutputVar, Visible, , Cancel, NVIDIA Display Driver v381.65 - International
	Sleep 300
	}until OutputVar != 1

IfWinExist, NVIDIA Installer
	WinActivate, NVIDIA Installer
else
	WinWait, NVIDIA Installer
Sleep 300
Process,Close,setup.exe