;~ Setting Defaults
#NoEnv
#SingleInstance, Force
#Persistent
SetTitleMatchMode, 2
SendMode, Input
DetectHiddenText, On
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%

if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
	ExitApp
}

activateSettings(){
	IfWinExist, Settings
	WinActivate, Settings
	else
	WinWait, Settings
}

activateSettingsClass(){
	IfWinExist, ahk_class ApplicationFrameWindow
	WinActivate, ahk_class ApplicationFrameWindow
	else
	WinWait, ahk_class ApplicationFrameWindow
}

openSettings(){
	ControlClick,  Start1, ahk_class Shell_TrayWnd
	Sleep 200
	MouseMove, 20, 565
	Sleep 200
	Click
	Sleep 200
	activateSettings()
	Sleep 200
	WinMove, ahk_class ApplicationFrameWindow,, -7, 0, 500, 352
	Sleep 1000
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
	Sleep 1000
	ControlGet, OutputVar, Visible, , ApplicationFrameTitleBarWindow2, Settings
	Loop{
		if (OutputVar != 1){
			Sleep 200

		}else{
			break
		}
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
	MouseMove, 100, 100
	Send {Tab}
	Sleep 300
	Send {Tab}
	Sleep 300
	Send {Tab}
	Sleep 1000
	activateSettingsClass()
	PixelSearch, x, y, 18, 96, 57, 351, 0xFEB61F, 1, Fast RGB
	if(ErrorLevel){
		Send {Enter}
		Sleep 300
		Loop{
			Sleep 1000
			activateSettingsClass()
			PixelSearch, x, y, 57, 33, 395, 229, 0xFEB61F, 1, Fast RGB
			if (ErrorLevel = 1){
				activateSettings()
				Click WheelDown
				Sleep 1000 ;FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUCK THIS SLEEP FUCK
			}else{
				Sleep 300
				Send {Enter}
				Sleep 300
				MouseMove, %x%, %y%
				Click
				Sleep 300
				MouseMove, 402, 334
				Sleep 1000
				break
			}
		}
	}else{
		MouseMove, 402, 334
		return
		return
	}
}

setDefaultPhoto(){
	Loop{
		Click WheelDown
		Sleep 1000
		activateSettingsClass()
		PixelSearch, x, y, 18, 96, 57, 351, 0xA80B04, 1, Fast RGB
		if (ErrorLevel){
			MouseGetPos, mX, mY,, 1
			PixelGetColor, color, %mX%, %mY%, RGB
			if (color = 0xCCCCCC){
				Click
				break
			}else{
				Sleep 300
			}
		}else{
			MouseMove, 402, 334
			return
			return
		}
	}
	Sleep 300
	Loop{
		Sleep 1000
		activateSettingsClass()
		PixelSearch, x, y, 57, 33, 395, 229, 0xA80B04, 1, Fast RGB
		if (ErrorLevel = 1){
			activateSettings()
			Click WheelDown
			Sleep 1000 ;FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUCK THIS SLEEP FUCK
		}else{
			Sleep 300
			Send {Enter}
			Sleep 300
			MouseMove, %x%, %y%
			Click
			Sleep 300
			MouseMove, 402, 334
			Sleep 1000
			break
		}
	}
}

setDefaultVideo(){
	Loop{
		Click WheelDown
		Sleep 1000
		activateSettingsClass()
		PixelSearch, x, y, 18, 0, 57, 767, 0xF88300, 1, Fast RGB
		if (ErrorLevel){
			MouseGetPos, mX, mY,, 1
			PixelGetColor, color, %mX%, %mY%, RGB
			if (color = 0xCCCCCC){
				Click
				break
			}else{
				Sleep 300
			}
		}else{
			MouseMove, 402, 334
			return
			return
		}
	}
	Sleep 300
	Loop{
		Sleep 1000
		activateSettingsClass()
		PixelSearch, x, y, 57, 33, 395, 229, 0xF88300, 1, Fast RGB
		if (ErrorLevel = 1){
			activateSettings()
			MouseMove, 395, 300
			Click WheelDown
			Sleep 1000 ;FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUCK THIS SLEEP FUCK
		}else{
			Sleep 300
			Send {Enter}
			Sleep 300
			MouseMove, %x%, %y%
			Click
			Sleep 300
			MouseMove, 402, 334
			Sleep 1000
			break
		}
	}
}

setDefaultBrowser(){
	Loop{
		Click WheelDown
		Sleep 1000
		activateSettingsClass()
		PixelSearch, x, y, 18, 96, 57, 351, 0xDD4E42, 1, Fast RGB
		if (ErrorLevel){
			MouseGetPos, mX, mY,, 1
			PixelGetColor, color, %mX%, %mY%, RGB
			if (color = 0xCCCCCC){
				Click
				break
			}else{
				Sleep 300
			}
		}else{
			MouseMove, 402, 334
			return
			return
		}
	}
	Sleep 300
	Loop{
		Sleep 1000
		activateSettingsClass()
		PixelSearch, x, y, 57, 33, 395, 229, 0xDD4E42, 1, Fast RGB
		if (ErrorLevel = 1){
			activateSettings()
			MouseMove, 395, 300
			Click WheelDown
			Sleep 1000 ;FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUCK THIS SLEEP FUCK
		}else{
			Sleep 300
			MouseMove, %x%, %y%
			Click
			Sleep 300
			MouseMove, 402, 334
			Sleep 1000
			break
		}
	}
}

setDefaultApps(){
	setDefaultMusic()
	setDefaultPhoto()
	setDefaultVideo()
	setDefaultBrowser()
}

startSwitch(){
	openSettings()
	goToDefaultApps()
	setDefaultApps()
}

startSwitch()

ExitApp

^1::
Pause
Escape::
ExitApp