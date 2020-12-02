Do { Sleep -Milliseconds 250 } until ($(Get-Process | Where-Object { $_.Name -Match "iCUE" } | Measure-Object -line).Lines -gt 0)
Do { Sleep -Milliseconds 250 } until ($(Get-Process | Where-Object { $_.Name -Match "StreamDeck" } | Measure-Object -line).Lines -gt 0)
Do { Sleep -Milliseconds 250 } until ($(Get-Process | Where-Object { $_.Name -Match "Razer Synapse" } | Measure-Object -line).Lines -gt 0)
Sleep -Seconds 10
Invoke-WebRequest http://192.168.100.62:3001/button-mac1ready?event=double-press -ErrorAction SilentlyContinue 