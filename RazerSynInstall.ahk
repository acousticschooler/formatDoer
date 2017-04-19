;~ This script runs after Razer Synapse has been downloaded and then installs it.
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Input
DetectHiddenText, On
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%
activateRazer(){
IfWinExist, Razer Synapse - InstallShield Wizard
	WinActivate, Razer Synapse - InstallShield Wizard
else
	WinWait, Razer Synapse - InstallShield Wizard
}
activateRazer()
Loop{
	ControlGet, OutputVar, Visible, , Preparing to Install..., Razer Synapse - InstallShield Wizard
	Sleep 600
}until OutputVar != 1
activateRazer()
Sleep 600
ControlGet, OutputVar, Visible, , &Next >, Razer Synapse - InstallShield Wizard
if OutputVar = 1
	ControlClick, &Next >
Sleep 600
activateRazer()
ControlGet, OutputVar, Visible, , I &accept the terms in the license agreement, Razer Synapse - InstallShield Wizard
if OutputVar = 1
	ControlClick, I &accept the terms in the license agreement
	Sleep 600
	ControlClick, &Next >
activateRazer()
ControlGet, OutputVar, Visible, , &Install, Razer Synapse - InstallShield Wizard
if OutputVar = 1
	ControlClick, Button1
activateRazer()
ControlGet, OutputVar, Checked, , Button3, Razer Synapse - InstallShield Wizard
if OutputVar = 1
	ControlClick, Button3
	Sleep 100
	ControlClick, &Finish
