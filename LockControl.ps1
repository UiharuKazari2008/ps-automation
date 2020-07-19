if ($args[0] -eq "status") {
(Get-CimInstance Win32_DesktopMonitor).IsLocked
}
if ($args[0] -eq "lock") {
&"E:\Windows\nircmd.exe" monitor off
}