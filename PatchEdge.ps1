Invoke-WebRequest "https://github.com/Ceiridge/Chrome-Developer-Mode-Extension-Warning-Patcher/releases/latest/download/ChromeDevExtWarningPatcher.zip" -OutFile $env:TEMP/ChromeDevExtWarningPatcher.zip  -ErrorAction SilentlyContinue
& 'C:\Program Files\7-Zip\7z.exe' x $env:TEMP/ChromeDevExtWarningPatcher.zip -o"E:\Program Files\ChromeDevExtWarningPatcher" -y
Remove-Item $env:TEMP/ChromeDevExtWarningPatcher.zip

$proc = Start-Process -filePath "ChromeDevExtWarningPatcher.exe" -ArgumentList @("--groups", "0,1", "-w") -workingdirectory "E:\Program Files\ChromeDevExtWarningPatcher\" -PassThru
$timeouted = $null
$proc | Wait-Process -Timeout 120 -ErrorAction SilentlyContinue -ErrorVariable timeouted
if ($timeouted) { 
    $proc | kill
    Write-Output "Sorry, Took to long to respond!"
}