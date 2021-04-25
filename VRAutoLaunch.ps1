While ($true) {
    # Wait for me to launch VRChat
    Do { Sleep -Seconds 5 } until ($(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -gt 0)
    Sleep -Seconds 5
    Start-ScheduledTask -TaskName StartVR -TaskPath '\Personal\'
    Do { Sleep -Seconds 10 } until ($(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -lt 1)
    Invoke-WebRequest http://192.168.100.62:3001/button-emmbtn5?event=long-press -ErrorAction SilentlyContinue 
    Start-ScheduledTask -TaskName StopVR -TaskPath '\Personal\'
}