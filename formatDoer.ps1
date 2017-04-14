Write-Host Setting the execution policy
Set-ExecutionPolicy RemoteSigned
Write-Host Done

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
powercfg /setdcvalueindex $hpPowerScheme $hdSubID $hdTurnOff 0
powercfg /setdcvalueindex $hpPowerScheme $ieSubID $ieJavaScriptTimerFreq 1 
powercfg /setdcvalueindex $hpPowerScheme $wirelessAdapterSubID $powerSaveMode 0
powercfg /setdcvalueindex $hpPowerScheme $sleepSubID $sleepAfter 0
powercfg /setdcvalueindex $hpPowerScheme $sleepSubID $hibernateAfter 0
powercfg /setdcvalueindex $hpPowerScheme $sleepSubID $allowWakeTimer 0
powercfg /setdcvalueindex $hpPowerScheme $usbSubID $usbSelectiveSuspend 0
powercfg /setdcvalueindex $hpPowerScheme $pciSubID $linkStatePowerManagement 0
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
Pin-App "Calendar" -unpin
Pin-App "Microsoft Edge" -unpin
Pin-App "Photos" -unpin
Pin-App "Cortana" -unpin
Pin-App "Weather" -unpin
Pin-App "Xbox" -unpin
Pin-App "Movies & Tv" -unpin
Pin-App "Microsoft Solitaire Collection" -unpin
Pin-App "Get Office" -unpin
Pin-App "Onenote" -unpin
Pin-App "News" -unpin

Write-Host Disabling all bloatware services
Set-Service AJRouter -StartupType Disabled
Set-Service ALG -StartupType Disabled
Set-Service BthHFSrv -StartupType Disabled
Set-Service bthserv -StartupType Disabled
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


Write-Host Downloading FireFox 52.0.2
Invoke-WebRequest -Uri https://download-installer.cdn.mozilla.net/pub/firefox/releases/52.0.2/win64/en-US/Firefox%20Setup%2052.0.2.exe -Outfile '~\Downloads\Firefox Setup 52.0.2.exe'
Write-Host Finished downloading Firefox from the intraweberinos and now were going to install it
Start-Process -FilePath '~\Downloads\Firefox Setup 52.0.2.exe' -ArgumentList '/silent', '/install' -Wait
Write-Host Done

Write-Host Downloading Chrome
Invoke-WebRequest -Uri https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BE3116110-60AC-D0AE-44E9-5F352303192D%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Ddefaultbrowser/update2/installers/ChromeSetup.exe -Outfile '~\Downloads\ChromeSetup.exe'
Write-Host Finished downloading Chrome from the intraweberinos and now were going to install it
Start-Process -FilePath '~\Downloads\ChromeSetup.exe' -ArgumentList '/silent', '/install' -Wait
Write-Host Done

Write-Host Downloading Python
Invoke-WebRequest -Uri https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi -Outfile '~\Downloads\python-2.7.13.msi'
Write-Host Finished downloading Python 2.7.13 from the intraweberinos and now were going to install it
Start-Process '~\Downloads\python-2.7.13.msi' /quiet -Wait
Write-Host Done

Write-Host Downloading Teamspeak 3
Invoke-WebRequest -Uri http://dl.4players.de/ts/releases/3.1.3/TeamSpeak3-Client-win64-3.1.3.exe -Outfile '~\Downloads\TeamSpeak3-Client-win64-3.1.3.exe'
Write-Host Finished downloading Teamspeak 3 from the intraweberinos and now were going to install it
Start-Process -FilePath '~\Downloads\TeamSpeak3-Client-win64-3.1.3.exe' -ArgumentList '/S', '/install' -Wait
Write-Host Done

Write-Host Downloading Corsair Utility Engine
Invoke-WebRequest -Uri http://downloads.corsair.com/download?item=Files/CUE/CorsairUtilityEngineSetup_2.11.115_release.msi -Outfile '~\Downloads\CorsairUtilityEngineSetup_2.11.115_release.msi'
Write-Host Finished downloading Corsair Utility Engine from the intraweberinos and now were going to install it
Start-Process -FilePath '~\Downloads\CorsairUtilityEngineSetup_2.11.115_release.msi' /quiet -Wait
Write-Host Done

Write-Host Downloading Steam
Invoke-WebRequest -Uri https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe -Outfile '~\Downloads\SteamSetup.exe'
Write-Host Finished downloading Steam from the intraweberinos and now were going to install it
Start-Process -FilePath '~\Downloads\SteamSetup.exe' -ArgumentList '/S', '/install' -Wait
Write-Host Done

Write-Host Downloading MalwareBytes
Invoke-WebRequest -Uri https://downloads.malwarebytes.com/file/mb3/ -Outfile '~\Downloads\mb3-setup-consumer-3.0.6.1469-1096.exe'
Write-Host Finished downloading MalwareBytes from the intraweberinos and now were going to install it
Start-Process -FilePath '~\Downloads\mb3-setup-consumer-3.0.6.1469-1096.exe' -ArgumentList '/silent', '/install' -Wait
Write-Host Done

Write-Host Downloading Samsung Magician
Invoke-WebRequest -Uri http://www.samsung.com/semiconductor/minisite/ssd/downloads/software/Samsung_Magician_Installer.zip -Outfile '~\Downloads\Samsung_Magician_Installer.zip'
Write-Host Finished downloading Samsung Magician from the intraweberinos and now were going to extract it
Expand-Archive ~\Downloads\Samsung_Magician_Installer.zip -DestinationPath ~\Downloads\Samsung_Magician_Installer -Force
Write-Host Finished extracting Samsung Magician, now lets install it
Start-Process -FilePath '~\Downloads\Samsung_Magician_Installer\Samsung_Magician_Installer.exe' -ArgumentList '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -Wait
Write-Host Done

Write-Host Downloading Nvidia Drivers
Invoke-WebRequest -Uri http://us.download.nvidia.com/Windows/381.65/381.65-desktop-win10-64bit-international-whql.exe -Outfile '~\Downloads\381.65-desktop-win10-64bit-international-whql.exe'
Write-Host Finished downloading Nvidia Drivers from the intraweberinos and now were going to extract it
Expand-Archive ~\Downloads\381.65-desktop-win10-64bit-international-whql.exe -DestinationPath C:\NVIDIA\DisplayDriver\381.65\Win10_64\International\setup.exe -Force
Write-Host Finished extracting Nvidia Drivers, now lets install it
Start-Process -FilePath 'C:\NVIDIA\DisplayDriver\381.65\Win10_64\International\setup.exe' -ArgumentList '-s', '-noeula', '-noreboot' -Wait
Write-Host Done

Write-Host Downloading AHK
Invoke-WebRequest -Uri https://autohotkey.com/download/ahk-install.exe -Outfile '~\Downloads\AutoHotkey_1.1.25.01_setup.exe'
Write-Host Finished downloading AHK from the intraweberinos and now were going to extract it
Start-Process -FilePath '~\Downloads\AutoHotkey_1.1.25.01_setup.exe' -ArgumentList '/S' -Wait
Write-Host Done

Write-Host Downloading VLC
Invoke-WebRequest -Uri http://videolan.mirrors.hivelocity.net/vlc/2.2.4/win32/vlc-2.2.4-win32.exe -Outfile '~\Downloads\vlc-2.2.4-win32.exe'
Write-Host Finished downloading VLC from the intraweberinos and now were going to extract it
Start-Process -FilePath '~\Downloads\vlc-2.2.4-win32.exe' -ArgumentList '/S' -Wait
Write-Host Done

Write-Host Downloading Irfanview64
Invoke-WebRequest -Uri 'http://dw.cbsi.com/redir?ttag=restart_download_click&ptid=3001&pagetype=product_pdl&astid=2&edid=3&tag=link&siteid=4&destUrl=&onid=2192&oid=3001-2192_4-76444710&rsid=cbsidownloadcomsite&sl=en&sc=us&topicguid=digitalphoto%2Fphoto-editors&topicbrcrm=&pid=15672085&mfgid=59333&merid=59333&ctype=dm&cval=NONE&devicetype=%3C!--esidesktop&pguid=091def71a8cc0c7dd8a7625d&viewguid=jwIFZaQOWgLBs-SHRLJmQvOIWJiHCkXA-uBq&destUrl=http%3A%2F%2Ffiles.downloadnow.com%2Fs%2Fsoftware%2F15%2F67%2F20%2F85%2Fiview444_x64_setup.exe%3Ftoken%3D1492167761_7d498fdc78c780932212c6f6c23c2284%26fileName%3Diview444_x64_setup.exe' -Outfile '~\Downloads\irfanview64.exe'
Write-Host Finished downloading Irfanview64 from the intraweberinos and now were going to extract it
Start-Process -FilePath '~\Downloads\irfanview64.exe' -ArgumentList '/silent' -Wait
Write-Host Done

Write-Host Downloading Razer Synapse
Invoke-WebRequest -Uri http://rzr.to/synapse-pc-download -Outfile '~\Downloads\Razer_Synapse_Framework_V2.exe'
Write-Host Downloading AHK script to install Synapse
(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/acousticschooler/formatDoer/master/RazerSynInstall.ahk?token=AFugwwS5anYsS4P_VwRj_nqjoQRryZVRks5Y-V8JwA%3D%3D') | out-file ~\Downloads\RazerSynInstall.ahk -force 
Write-Host Finished downloading Razer Synapse and script, now were going to run the AHK script to finish up.
Start-Process -FilePath '~\Downloads\RazerSynInstall.ahk'
Write-Host Ran the script so now PowerShell is going to trigger the install
Start-Process -FilePath '~\Downloads\Razer_Synapse_Framework_V2.exe' -Wait
Write-Host Done

Write-Host Downloading Blizzard App
Invoke-WebRequest -Uri 'https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP' -Outfile '~\Downloads\Battle.net-Setup.exe'
Write-Host Downloading AHK script to install Blizzard App
(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/acousticschooler/formatDoer/master/blizzardAppInstaller.ahk?token=AFugwyPxP82bHx-9RslNiLypz83xcUEDks5Y-V_jwA%3D%3D') | out-file ~\Downloads\blizzardAppInstaller.ahk -force
Write-Host Finished downloading Blizzard App and the script, now were going to run the AHK script to finish up.
Start-Process -FilePath '~\Downloads\blizzardAppInstaller.ahk'
Write-Host Ran the script so now PowerShell is going to trigger the install
Start-Process -FilePath '~\Downloads\Battle.net-Setup.exe' -Wait
Write-Host Done

Write-Host Downloading AHK script to change the defaults
(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/acousticschooler/formatDoer/master/defaults.ahk?token=AFugw0awcfSnXtS6-KcUvjEnIYXIfcNJks5Y-WA2wA%3D%3D') | out-file ~\Downloads\defaults.ahk -force
Write-Host Running the AHK script to change the defaults to my preferences
Start-Process -FilePath '~\Downloads\defaults.ahk' -Wait
Write-Host Done

Write-Host Setting Pythons paths permanantly so when powershell closes itll be permanant
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Python27\;C:\Python27\Scripts\", "User")
Write-Host Setting paths for this session now
$env:path="$env:Path;C:\Python27"
Write-Host Done 1
$env:path="$env:Path;C:\Python27\Scripts"
Write-Host Done2
Write-Host Changing to python dir
cd C:\Python27
Write-Host Downloading dependencies
Write-Host Downloading praw
pip install praw
Write-Host done
Write-Host Downloading prawcore
pip install prawcore
Write-Host done
Write-Host Downloading colorama
pip install colorama
Write-Host done
Write-Host Downloading os
pip install os
Write-Host done

Write-Host Finished the whole thing
pause