if ($args[0] -eq "shutdown") {
    (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Shutdown.wav').PlaySync()
}
if ($args[0] -eq "login") {
    (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Logon Sound.wav').PlaySync()
}
if ($args[0] -eq "logoff") {
    (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Logoff Sound.wav').PlaySync()
}
if ($args[0] -eq "warning") {
    if ($(Get-Process | Where-Object { $_.Name -Match "OculusClient" } | Measure-Object -line).Lines -gt 0) {
        (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Battery Critical.wav').PlaySync()
    }
}
echo "Done"