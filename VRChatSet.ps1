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

if ($args[0] -eq "desktop") {
    Get-Process | Where-Object { $_.Name -Match "VRChat" } | Stop-Process -Force
    sleep -Seconds 2
    & "D:\Program Files\Steam\steamapps\common\VRChat\VRChat.exe" --no-vr --melonloader.hideconsole
    # Wait for me to launch VRChat and then force it to the 1080x1080 size in corner
    Do { 
        $status = $(Get-Process | Where-Object { $_.Name -Match "VRChat" } | Measure-Object -line).Lines; Sleep -Seconds 1 
    } until ($status -gt 0)

    Do {
        $window=$(Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1 | Get-WindowPosition)
        if ( $window.Width -ne "1920" -and $window.Height -ne "1400" -and $window.Left -ne "77" -and $window.Top -ne "21") {
            Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1 | Set-WindowPosition -Width 1920 -Height 1400
            Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1 | Set-WindowPosition -Left 77 -Top 21
        }
        if ( $window.Width -eq "1920" -and $window.Height -eq "1400" -and $window.Left -eq "77" -and $window.Top -eq "21") {
            $status="Complete"
        }
        Sleep -Seconds 1
    } until ($status -eq "Complete")
}
if ($args[0] -eq "vr") {
    function setVRC {
        # Wait for me to launch VRChat and then force it to the 1080x1080 size in corner
        Do { 
            $status = $(Get-Process | Where-Object { $_.Name -Match "VRChat" } | Measure-Object -line).Lines; Sleep -Seconds 1 
        } until ($status -gt 0)

        Sleep -Seconds 5
        Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1 | Set-WindowPosition -Left 2555 -Top -47 -Width 1058 -Height 1077
        Sleep -Seconds 3
        Get-Process -Name VRChat | Set-WindowState -State MINIMIZE -ErrorAction SilentlyContinue
    }
    While ($true) {
        setVRC
        Do { 
            $status = $(Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Measure-Object -line).Lines; Sleep -Milliseconds 250
        } until ($status -lt 1)
    }
}