Import-Module "E:\Windows\AudioDeviceCmdlets.dll"

function ResetAudio {
    Sleep -Seconds 5
    Stop-Process -Name voicemeeter8 -Force
    Sleep -Seconds 5
    Start-ScheduledTask -TaskName Audio-Init -TaskPath '\Personal\'
}
function Connected {
    Invoke-WebRequest http://192.168.100.62:3001/button-emmbtn6?event=single-press -ErrorAction SilentlyContinue 
}
function Disconnected {
    Invoke-WebRequest http://192.168.100.62:3001/button-emmbtn6?event=long-press -ErrorAction SilentlyContinue 
}
While ($true) {
    Do { Sleep -Seconds 5 } until ($(Get-AudioDevice -List | Where-Object {$_.Name -match "Virtual Desktop Audio"} | Measure-Object -Line).Lines -gt 1)
    ResetAudio; Connected
    Do { Sleep -Seconds 5 } until ($(Get-AudioDevice -List | Where-Object {$_.Name -match "Virtual Desktop Audio"} | Measure-Object -Line).Lines -lt 2)
    ResetAudio; Disconnected
}