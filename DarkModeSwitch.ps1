if ($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes").CurrentTheme.split("\")[-1].split(".")[0] -match "Dark") {
    &E:\Windows\Scripts\Normal.exe
} else {
    &E:\Windows\Scripts\Daytime.exe
}