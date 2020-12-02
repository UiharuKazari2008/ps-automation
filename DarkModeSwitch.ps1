if ($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes").CurrentTheme.split("\")[-1].split(".")[0] -match "Dark") {
    Start-ScheduledTask -TaskPath Personal -TaskName CUE-Night
} else {
    Start-ScheduledTask -TaskPath Personal -TaskName CUE-Day
}