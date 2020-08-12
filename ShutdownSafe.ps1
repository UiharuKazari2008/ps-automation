$Procc=(Get-Process)
if (($($Procc | Where-Object {$_.ProcessName -eq "Unity"} | Measure-Object -Line).Lines -eq 0) -and ($($Procc | Where-Object {$_.ProcessName -eq "blender"} | Measure-Object -Line).Lines -eq 0)) {
    if (($(Get-ScheduledTask | Where-Object {$_.TaskName -match "StopVR"}).State -match "Running") -or ($(Get-ScheduledTask | Where-Object {$_.TaskName -match "StartVR"}).State -match "Running")) {
        if ($(Get-ScheduledTask | Where-Object {$_.TaskName -match "StartVR"}).State -match "Running") {
            Start-ScheduledTask -TaskPath Personal -TaskName StopVR
            Sleep -Seconds 10
        }
        Do { Sleep -Seconds 10 } until ($(Get-ScheduledTask | Where-Object {$_.TaskName -match "StopVR"}).State -notmatch "Running")
    }
    shutdown /p
} else {
    echo "Shutdown cancelled due to open applications."
}