Import-Module "E:\Windows\AudioDeviceCmdlets.dll"

$Recording = $(Get-AudioDevice -Recording).Name
$Playback = $(Get-AudioDevice -Playback).Name

if ($args[0] -eq "status-headset") {
    if (($($Playback | Where { $_ -Match "THX"} | Measure-Object -line).Lines -gt 0 -or $($Playback | Where { $_ -Match "VB-Audio Hi-Fi Cable"} | Measure-Object -line).Lines -gt 0) -and ($($Recording | Where { $_ -Match "Chat"} | Measure-Object -line).Lines -gt 0 -or $($Recording | Where { $_ -Match "Xbox"} | Measure-Object -line).Lines -gt 0)) {echo "true"} else {echo "false"}
}
if ($args[0] -eq "status-mic") {
    if ($($Recording | Where { $_ -Match "Seiren X"} | Measure-Object -line).Lines -gt 0) {echo "true"} else {echo "false"}
}
if ($args[0] -eq "set-headset") {
    Start-ScheduledTask -TaskPath Personal -TaskName Audio-Headset
}
if ($args[0] -eq "set-vr") {
    Start-ScheduledTask -TaskPath Personal -TaskName Audio-VR
}
if ($args[0] -eq "set-speaker") {
   if ($($Recording | Where { $_ -Match "Xbox"} | Measure-Object -line).Lines -eq 0) {
        Get-AudioDevice -List | Where-Object { $_.Name -Match "Xbox" -AND $_.Type -match "Recording" } | Set-AudioDevice > $null
    }
    if ($($Playback | Where { $_ -Match "Theater"} | Measure-Object -line).Lines -eq 0) {
        Get-AudioDevice -List | Where-Object { $_.Name -Match "Theater" -AND $_.Type -match "Playback" } | Set-AudioDevice > $null
        (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Balloon.wav').PlaySync()
    }
}
if ($args[0] -eq "set-mic-desk") {
   Get-AudioDevice -List | Where-Object { $_.Name -Match "Seiren X" -AND $_.Type -match "Recording" } | Set-AudioDevice > $null
}
if ($args[0] -eq "set-mic-headset") {
   Get-AudioDevice -List | Where-Object { $_.Name -Match "Nari" -AND $_.Type -match "Recording" } | Set-AudioDevice > $null
}
if ($args[0] -eq "toggle-mic") {
    if ($($Recording | Where { $_ -Match "Razer Nari"} | Measure-Object -line).Lines -gt 0) {
        Get-AudioDevice -List | Where-Object { $_.Name -Match "Xbox" -AND $_.Type -match "Recording" } | Set-AudioDevice > $null
    } else {
        Get-AudioDevice -List | Where-Object { $_.Name -Match "Razer Nari" -AND $_.Type -match "Recording" } | Set-AudioDevice > $null
    }
}