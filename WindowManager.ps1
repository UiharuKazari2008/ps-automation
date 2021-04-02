Import-Module "E:\Windows\WASP.dll"
function Set-WindowState {
<#
	.LINK
	https://gist.github.com/Nora-Ballard/11240204
	#>

[CmdletBinding(DefaultParameterSetName = 'InputObject')]
param(
	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
	[Object[]] $InputObject,

	[Parameter(Position = 1)]
	[ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
					'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
					'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
	[string] $State = 'SHOW'
)

Begin {
	$WindowStates = @{
		'FORCEMINIMIZE'		= 11
		'HIDE'				= 0
		'MAXIMIZE'			= 3
		'MINIMIZE'			= 6
		'RESTORE'			= 9
		'SHOW'				= 5
		'SHOWDEFAULT'		= 10
		'SHOWMAXIMIZED'		= 3
		'SHOWMINIMIZED'		= 2
		'SHOWMINNOACTIVE'	= 7
		'SHOWNA'			= 8
		'SHOWNOACTIVATE'	= 4
		'SHOWNORMAL'		= 1
	}

	$Win32ShowWindowAsync = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru

	if (!$global:MainWindowHandles) {
		$global:MainWindowHandles = @{ }
	}
}

Process {
	foreach ($process in $InputObject) {
		if ($process.MainWindowHandle -eq 0) {
			if ($global:MainWindowHandles.ContainsKey($process.Id)) {
				$handle = $global:MainWindowHandles[$process.Id]
			} else {
				Write-Error "Main Window handle is '0'"
				continue
			}
		} else {
			$handle = $process.MainWindowHandle
			$global:MainWindowHandles[$process.Id] = $handle
		}

		$Win32ShowWindowAsync::ShowWindowAsync($handle, $WindowStates[$State]) | Out-Null
		Write-Verbose ("Set Window State '{1} on '{0}'" -f $MainWindowHandle, $State)
	}
}
}

Sleep -Seconds 6

if ($args[0] -eq "desk") {
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 2565 -Top 18 -Width 940 -Height 1067
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 2565 -Top 18 -Width 940 -Height 1067
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Maximize

Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 17 -Top 510 -Width 1469 -Height 879
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 17 -Top 510 -Width 1469 -Height 879
}
if ($args[0] -eq "extend") {
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 2565 -Top 18 -Width 940 -Height 1067
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 2565 -Top 18 -Width 940 -Height 1067
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Maximize

Sleep -Seconds 15

Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 3799 -Top 114 -Width 1218 -Height 672
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 3799 -Top 114 -Width 1218 -Height 672
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Maximize
}
if ($args[0] -eq "off") {
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 1614 -Top 4 -Width 940 -Height 1400
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 1614 -Top 4 -Width 940 -Height 1400

Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 17 -Top 510 -Width 1469 -Height 879
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 17 -Top 510 -Width 1469 -Height 879
}
if ($args[0] -eq "tv") {
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 596 -Top 0 -Width 940 -Height 832
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -match " - Discord" } | Set-WindowPosition -Left 596 -Top 0 -Width 940 -Height 832

Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Restore
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 18 -Top 10 -Width 1174 -Height 702
Sleep -Seconds 1
Select-Window -ProcessName 'Discord' | Where-Object { $_.Title -notmatch " - Discord" } | Set-WindowPosition -Left 18 -Top 10 -Width 1174 -Height 702
}
if ($args[0] -eq "cvb") {
Select-Window -ProcessName 'voicemeeter8' | Remove-Window
}