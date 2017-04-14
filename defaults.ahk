;~ Setting Defaults
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Input
DetectHiddenText, On
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%

Send {LWin}
Sleep 1000
WinWaitActive, Cortana
Sleep 100
Send, apps: defau
Sleep 100
WinWaitActive, Cortana
Sleep, 100
Loop{
PixelGetColor, color, 77, 124, RGB
if color = 0x0078D7
{
	Click, 77, 124
	break
}else{
	Sleep, 100
}
}
WinWait, Settings
Sleep, 1000
WinActivate, Settings
WinMove, Settings,,-8,0,500,352
Send {Tab}
Sleep, 100
Send  {Tab}
Sleep, 100
Send  {Tab}
Sleep, 100
Send  {Enter}
Sleep, 3000
PixelSearch, Px, Py, 0, 0, 500, 352, 0xA50A03, 0, Fast RGB ; oxoooo4c is the pixel color fould from using the first script, insert yours there
Click, %Px%, %Py%
Sleep, 2000
Send  {Tab}
Sleep, 100
Send {Enter}
Sleep, 3000
PixelSearch, Px, Py, 0, 0, 500, 352, 0xCACFD2, 0, Fast RGB ; oxoooo4c is the pixel color fould from using the first script, insert yours there
Click, %Px%, %Py%
Sleep, 2000
Send  {Tab}
Sleep, 100
Send {Enter}
Sleep, 3000
PixelSearch, Px, Py, 0, 0, 500, 352, 0xDA5225, 0, Fast RGB ; oxoooo4c is the pixel color fould from using the first script, insert yours there
Click, %Px%, %Py%
Sleep, 2000
WinClose, Settings