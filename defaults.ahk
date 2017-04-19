;~ Setting Defaults
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Input
DetectHiddenText, On
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%
activateSettings(){
IfWinExist, Settings
	WinActivate, Settings
else
	WinWait, Settings
}

openSettings(){
	ControlClick,  Start1, ahk_class Shell_TrayWnd
	Sleep 200
	MouseMove, 20, 565
	Sleep 200
	Click
	Sleep 200
	activateSettings()
	WinMove, Settings,, -7, 0, 500, 352
}

goToDefaultApps(){
	activateSettings()
	while !WinExist("Settings"){
		openSettings()
	}
	Send {Tab}
	Sleep 200
	Send {Down}
	Sleep 200
	Send {Down}
	Sleep 200
	Send {Down}
	Sleep 200
	Send {Down}
	Sleep 200
	Send {Enter}
	activateSettings()
	ControlGet, OutputVar, Visible, , ApplicationFrameTitleBarWindow2, Settings
	if (OutputVar != 1){
		WinClose, Settings
		goToDefaultApps()
	}
	Sleep 200
	Send {Tab}
	Sleep 200
	Send {Down}
	Sleep 200
	Send {Enter}
}

checkIfAtAppDefault(){
activateSettings()
PixelGetColor, color, 197, 77, RGB
if(color = 0xDDDDDD){
		setDefaultApps()
	}else{
		WinClose, Settings
		goToDefaultApps()
	}
}
setDefaultMusic(){
	Send {Tab}
	Sleep 200
	Send {Tab}
	Sleep 200
	Send {Tab}
	Sleep 200
	Send {Enter}
	Sleep 200
	Loop{
	PixelSearch, x, y, 0, 0, 500, 500, 0xFFECBD, 3, Fast RGB
	if (ErrorLevel = 1){
			Send {Enter}
			Sleep 200
			Send {Enter}
			Sleep 200
		}else{
			Sleep 300
			Send {Enter}
			Sleep 200
			MouseMove, %x%, %y%
			Click
			break
		}
	}
}
setDefaultApps(){
	setDefaultMusic()
}
 
openSettings()
goToDefaultApps()
setDefaultApps()
ExitApp

Escape::
ExitApp