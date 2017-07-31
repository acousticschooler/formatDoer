$uacPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Write-Host Disabling UAC
Set-ItemProperty -Path $uacPath -Name "EnableLUA" -Value 0
Write-Host Done

Write-Host Downloading Set-Privacy script and running it on "balanced" mode
(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/hahndorf/Set-Privacy/master/Set-Privacy.ps1') | out-file ~\Downloads\Set-Privacy.ps1 -force 
~\Downloads\Set-Privacy.ps1 -Balanced
~\Downloads\Set-Privacy.ps1 -Balanced -Admin
Write-Host Done

Write-Host Nerfing Cortana, and the Notification Center as well.
$microsoftWindowsPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows"
$suggestionsPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$consumerID = "DisableWindowsConsumerFeatures"
$windowsSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$suggestionsValueCheck = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures"
$aCortana = "AllowCortana"
$cortanaValueCheck = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana"
$value = "0"
$windowsExploring = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
$disableNC = "DisableNotificationCenter"
$ncValueCheck = Get-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter"
$posValue = "1"
$hpPowerScheme = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
$hdSubID = "0012ee47-9041-4b5d-9b77-535fba8b1442"
$hdTurnOff = "6738e2c4-e8a5-4a42-b16a-e040e769756e"
$ieSubID = "02f815b5-a5cf-4c84-bf20-649d1f75d3d8"
$ieJavaScriptTimerFreq = "4c793e7d-a264-42e1-87d3-7a0d2f523ccd"
$wirelessAdapterSubID= "19cbb8fa-5279-450e-9fac-8a3d5fedd0c1"
$powerSaveMode = "12bbebe6-58d6-4636-95bb-3217ef867c1a"
$sleepSubID = "238c9fa8-0aad-41ed-83f4-97be242c8f20"
$sleepAfter = "29f6c1db-86da-48c5-9fdb-f2b67b1f44da"
$hibernateAfter = "9d7815a6-7ee4-497e-8888-515a05f02364"
$allowWakeTimer = "bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d"
$usbSubID = "2a737441-1930-4402-8d77-b2bebba308a3"
$usbSelectiveSuspend = "48e6b7a6-50f5-4782-a5d4-53bb8f07e226"
$pciSubID = "501a4d13-42af-4429-9fd1-a8218c268e20"
$linkStatePowerManagement = "ee12f906-d277-404b-b6da-e5fa1a576df5"
$displaySubID = "7516b95f-f776-4464-8c53-06167f40cc99"
$turnOffDisplayAfter = "3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e"

IF(!(Test-Path $windowsSearch))

  {
    New-Item -Path $windowsSearch -Force | Out-Null

    New-ItemProperty -Path $windowsSearch -Name $aCortana -Type DWORD -Value $value
}

 ELSE {
    IF(!($cortanaValueCheck.AllowCortana -ne 0))
    {
         Set-ItemProperty -Path $windowsSearch -Name "AllowCortana" -value 0

    }
}

IF(!(Test-Path $windowsExploring))

  {
    New-Item -Path $windowsExploring -Force | Out-Null

    New-ItemProperty -Path $windowsExploring -Name $disableNC -Type DWORD -Value $posValue
}

 ELSE {
    IF(!($ncValueCheck.$disableNC -ne 1))
    {
         Set-ItemProperty -Path $windowsExploring -Name $disableNC -value $posValue

    }
}

IF(!(Test-Path $suggestionsPath))

  {
    New-Item -Path $suggestionsPath -Force | Out-Null

    New-ItemProperty -Path $suggestionsPath -Name $consumerID -Type DWORD -Value $posValue
}

 ELSE {
    IF(!($suggestionsValueCheck.$consumerID -ne 1))
    {
         Set-ItemProperty -Path $suggestionsPath -Name $consumerID -value $posValue

    }
}
Write-Host Done

Write-Host Setting power plan to HP and also changing powercfg options for performance
powercfg /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
Write-Host Changing HDD spin down to 0
powercfg /setdcvalueindex $hpPowerScheme $hdSubID $hdTurnOff 0
Write-Host Done
Write-Host Changing something about javascripttimerfreq
powercfg /setdcvalueindex $hpPowerScheme $ieSubID $ieJavaScriptTimerFreq 1 
Write-Host Done
Write-Host Changing adapter power save mode to 0
powercfg /setdcvalueindex $hpPowerScheme $wirelessAdapterSubID $powerSaveMode 0
Write-Host Done
Write-Host Sleep after never
powercfg /setdcvalueindex $hpPowerScheme $sleepSubID $sleepAfter 0
Write-Host Done
Write-Host Hibernate Never
powercfg /setdcvalueindex $hpPowerScheme $sleepSubID $hibernateAfter 0
Write-Host Done
Write-Host Wake Timer Never
powercfg /setdcvalueindex $hpPowerScheme $sleepSubID $allowWakeTimer 0
Write-Host Done
Write-Host USB suspend off
powercfg /setdcvalueindex $hpPowerScheme $usbSubID $usbSelectiveSuspend 0
Write-Host Done
Write-Host PCI Power manager off
powercfg /setdcvalueindex $hpPowerScheme $pciSubID $linkStatePowerManagement 0
Write-Host Done
Write-Host Turn display off never
powercfg /setdcvalueindex $hpPowerScheme $displaySubID $turnOffDisplayAfter 0
Write-Host Done

Write-Host Testing unpinning defaults from start menu
function Pin-App { param(
[string]$appname,
[switch]$unpin
)
try{
if ($unpin.IsPresent){
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}
return "App '$appname' unpinned from Start"
}else{
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'To "Start" Pin|Pin to Start'} | %{$_.DoIt()}
return "App '$appname' pinned to Start"
}
}catch{
Write-Error "Error Pinning/Unpinning App! (App-Name correct?)"
}
}

Pin-App "Mail" -unpin
Pin-App "Store" -unpin
Pin-App "Cortana" -unpin
Pin-App "Calendar" -unpin
Pin-App "Microsoft Edge" -unpin
Pin-App "Photos" -unpin
Pin-App "Cortana" -unpin
Pin-App "Weather" -unpin
Pin-App "Twitter" -unpin
Pin-App "Store" -unpin
Pin-App "Xbox" -unpin
Pin-App "Groove Music" -unpin
Pin-App "Money" -unpin
Pin-App "Movies & TV" -unpin
Pin-App "Microsoft Solitaire Collection" -unpin
Pin-App "Minecraft: Windows 10 Edition" -unpin
Pin-App "Get Office" -unpin
Pin-App "Onenote" -unpin
Pin-App "News" -unpin

Write-Host Disabling all bloatware services
Set-Service AJRouter -StartupType Disabled
Set-Service ALG -StartupType Disabled
Set-Service AppMgmt -StartupType Disabled
Set-Service BthHFSrv -StartupType Disabled
Set-Service bthserv -StartupType Disabled
Set-Service PeerDistSvc -StartupType Disabled
Set-Service CertPropSvc -StartupType Disabled
Set-Service CscService -StartupType Disabled
Set-Service diagnosticshub.standardcollector.service -StartupType Disabled
Set-Service dmwappushservice -StartupType Disabled
Set-Service FrameServer -StartupType Disabled
Set-Service HvHost -StartupType Disabled
Set-Service icssvc -StartupType Disabled
Set-Service iphlpsvc -StartupType Disabled
Set-Service irmon -StartupType Disabled
Set-Service lfsvc -StartupType Disabled
Set-Service MapsBroker -StartupType Disabled
Set-Service MSiSCSI -StartupType Disabled
Set-Service NcbService -StartupType Disabled
Set-Service NcdAutoSetup -StartupType Disabled
Set-Service Netlogon -StartupType Disabled
Set-Service PeerDistSvc -StartupType Disabled
Set-Service PhoneSvc -StartupType Disabled
Set-Service RetailDemo -StartupType Disabled
Set-Service RmSvc -StartupType Disabled
Set-Service RpcLocator -StartupType Disabled
Set-Service ScDeviceEnum -StartupType Disabled
Set-Service SCPolicySvc -StartupType Disabled
Set-Service SensorDataService -StartupType Disabled
Set-Service SensorService -StartupType Disabled
Set-Service SensrSvc -StartupType Disabled
Set-Service SEMgrSvc -StartupType Disabled
Set-Service SessionEnv -StartupType Disabled
Set-Service SharedAccess -StartupType Disabled
Set-Service SmsRouter -StartupType Disabled
Set-Service SNMPTRAP -StartupType Disabled
Set-Service StorSvc -StartupType Disabled
Set-Service TabletInputService -StartupType Disabled
Set-Service TermService -StartupType Disabled
Set-Service TrkWks -StartupType Disabled
Set-Service UmRdpService -StartupType Disabled
Set-Service vmicguestinterface -StartupType Disabled
Set-Service vmicheartbeat -StartupType Disabled
Set-Service vmickvpexchange -StartupType Disabled
Set-Service vmicrdv -StartupType Disabled
Set-Service vmicshutdown -StartupType Disabled
Set-Service vmictimesync -StartupType Disabled
Set-Service vmicvmsession -StartupType Disabled
Set-Service vmicvss -StartupType Disabled
Set-Service WbioSrvc -StartupType Disabled
Set-Service wcncsvc -StartupType Disabled
Set-Service WebClient -StartupType Disabled
Set-Service WinRM -StartupType Disabled
Set-Service wisvc -StartupType Disabled
Set-Service WwanSvc -StartupType Disabled
Set-Service XblAuthManager -StartupType Disabled
Set-Service XblGameSave -StartupType Disabled
Set-Service XboxNetApiSvc -StartupType Disabled
Set-Service WMPNetworkSvc -StartupType Disabled
Write-Host Done

Write-Host MarkCs Mouse Fix Win 10 100%
$mouseBinary = 'HKCU:Control Panel\Mouse'
$generalMouse = 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Mouse'
Set-ItemProperty -Path $mouseBinary -Name SmoothMouseXCurve -value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xC0,0xCC,0x0C,0x00,0x00,0x00,0x00,0x00,0x80,0x99,0x19,0x00,0x00,0x00,0x00,0x00,0x40,0x66,0x26,0x00,0x00,0x00,0x00,0x00,0x00,0x33,0x33,0x00,0x00,0x00,0x00,0x00))
Write-Host Fixed the X Curve, Now were gonna do the Y
Set-ItemProperty -Path $mouseBinary -Name SmoothMouseYCurve -value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x38,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x70,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xA8,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,0x00,0x00,0x00,0x00,0x00))
Write-Host Done, lets do the mouse sensitivity now
Set-ItemProperty -Path $mouseBinary -Name MouseSensitivity -value 10
Write-Host Done, lets do the mouse speed
Set-ItemProperty -Path $generalMouse -Name MouseSpeed -value 0
Write-Host Done, lets do the mouse threshold 1
Set-ItemProperty -Path $generalMouse -Name MouseThreshold1 -value 0
Write-Host Done, lets do the mouse threshold 2
Set-ItemProperty -Path $generalMouse -Name MouseThreshold2 -value 0
Write-Host Done

Write-Host Finished the whole thing
pause