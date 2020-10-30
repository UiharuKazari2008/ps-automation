$Init={
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
}
if ($args[0] -eq "start") {
    if ($(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -eq 0) {
        Start-Transcript -Path "E:\Windows\Logs\StartVR.txt"
        
        Write-Output "Setting Audio Interface..."
        &E:\Windows\Scripts\AudioSet.ps1 set-vr
        
        &E:\Windows\Scripts\VR.exe

        # VR System Jobs
        Start-Job -Name "VR-System-Oculus" -InitializationScript $Init {
            # Set Audio I/O to Razer Headset
            # Kill Oculus
            Write-Output "Setting up Oculus Hardware..."
            Stop-Process -Name "OculusClient" -Force -ErrorAction SilentlyContinue
            # Boot Oculus Service
            Start-Service OVRService
            Do { Sleep -Milliseconds 250 } until ($(Get-Process | Where-Object { $_.Name -Match "OVRRedir" } | Measure-Object -line).Lines -gt 0)
            Write-Host "Oculus Service started!"
            Sleep -Seconds 5

            # Start Oculus Client
            &"C:\Program Files\Oculus\Support\oculus-client\OculusClient.exe"
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "OculusDash" } | Measure-Object -line).Lines -gt 0)
            # Move and Hide Window
            Select-Window -ProcessName "OculusClient" | Select-Object -Last 1 | Set-WindowPosition -Left 2580 -Top 474 -Width 1024 -Height 768
            Sleep -Seconds 5
            Get-Process OculusClient | Set-WindowState -State MINIMIZE -ErrorAction SilentlyContinue
            Write-Output "Oculus is ready!"
        }
        Start-Job -Name "VR-System-SteamVR"-InitializationScript $Init {
            # Wait for Oculus to Start
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "OculusDash" } | Measure-Object -line).Lines -gt 0)
            Write-Output "Setting up SteamVR..."
            # Start SteamVR
            &"C:\Program Files (x86)\Steam\steamapps\common\SteamVR\bin\win64\vrmonitor.exe"
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -gt 0)
            Sleep -Seconds 15
            # Position Window
            Select-Window -ProcessName "vrmonitor" | Select-Object -Last 1 | Set-WindowPosition -Left 3347 -Top 176
            Write-Output "SteamVR is ready!"
            # Play Start Tone
            (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Print complete.wav').PlaySync()
        }

        # VR Tools
        Start-Job -Name "VR-Tool-VRCX" -InitializationScript $Init {
            # If VRCX is not open, Launch it
            if ($(Get-Process | Where-Object { $_.Name -Match "VRCX" } | Measure-Object -line).Lines -eq 0) { &"E:\Program Files\VRCX\VRCX.exe" } else { Write-Host "VRCX was already open!" }
            Sleep -Seconds 1
            Do { Sleep -Milliseconds 250 } until ($(Get-Process | Where-Object { $_.Name -Match "VRCX" } | Measure-Object -line).Lines -gt 0)
            # Move and Minimize VRCX
            Select-Window -ProcessName "VRCX" | Select-Object -Last 1 | Set-WindowPosition -Left 1537 -Top 842 -Width 1024 -Height 600
            Get-Process VRCX | Set-WindowState -State MINIMIZE -ErrorAction SilentlyContinue
            Write-Output "VRCX is ready!"
        }
        Start-Job -Name "VR-Tool-SSTweetToolForSteamVR" -InitializationScript $Init {
            # Wait for SteamVR
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -gt 0)
            Sleep -Seconds 2
            # Launch SSTool4SVR
            &"E:\Program Files\SSTweetToolForSteamVR\SSTweetToolForSteamVR.exe"
            Do { Sleep -Milliseconds 250 } until ($(Get-Process | Where-Object { $_.Name -Match "SSTweetToolForSteamVR" } | Measure-Object -line).Lines -gt 0)
            Sleep -Seconds 2
            # Move and Hide Window
            Select-Window -ProcessName "SSTweetToolForSteamVR" | Select-Object -Last 1 | Set-WindowPosition -Left 2564 -Top 182 -Width 427 -Height 580
            Get-Process SSTweetToolForSteamVR | Set-WindowState -State HIDE -ErrorAction SilentlyContinue
            Write-Output "Screenshot Tool is ready!"
        }
        Start-Job -Name "VR-Tool-Driver4VR" -InitializationScript $Init {
            # Wait for Driver4VR
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "Driver4VR" } | Measure-Object -line).Lines -gt 0)
            Sleep -Seconds 2
            #Get-Process | Where-Object { $_.Name -Match "Driver4VR" } | Stop-Process
            # Move and Hide Window
            Select-Window -ProcessName "Driver4VR" | Select-Object -Last 1 | Set-WindowPosition -Left 2565 -Top 184
            #Get-Process Driver4VR | Set-WindowState -State MINIMIZE -ErrorAction SilentlyContinue
            Write-Output "Kinect FBT is ready!"
        }
        Start-Job -Name "VR-Tool-OBS" {
            Start-ScheduledTask -TaskName "StartOBS" -TaskPath "Personal" # Start OBS
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "obs64" } | Measure-Object -line).Lines -gt 0)
            Sleep -Seconds 5
            Select-Window -ProcessName "obs64" | Select-Object -Last 1 | Set-WindowPosition -Left 3659 -Top 186 -Width 738 -Height 1052
            Write-Output "OBS Recorder is ready!"
            Sleep -Seconds 30
            
            #Ensure Scene is ready
            $actions = @(
                "/hidesource=Overlay",
                "/hidesource=VRChat",
                "/showsource=HeadsetInput",
                "/showsource=HeadsetOutput",
                "/mute=HeadsetInput",
                "/mute=HeadsetOutput"
            )
            $proc = Start-Process -WindowStyle hidden -filePath "OBSCommand.exe" -ArgumentList $actions -workingdirectory "E:\Program Files\OBSCommand\" -PassThru
            $timeouted = $null
            $proc | Wait-Process -Timeout 5 -ErrorAction SilentlyContinue -ErrorVariable timeouted
            if ($timeouted) { 
                $proc | kill
                Write-Output "Sorry, Took to long to respond!"
            } elseif ($proc.ExitCode -eq 0) {
                Write-Host "OBS Recorder is good to go!"
            }
        }

        # HTTP File Updates
        Start-Job -Name "VR-Update-HTTP" {
            # DLL Mods to update
            $Mods = @("http://thetrueyoshifan.com/downloads/emmVRCLoader.dll",
                    "https://github.com/l-404-l/Portal-Confirmation/releases/latest/download/PortalConfirmation.dll",
                    "https://github.com/HerpDerpinstine/NoSteamP2P/releases/latest/download/NoSteamP2P.dll",
                    "https://github.com/dave-kun/PlayerVolumeControl/releases/latest/download/PlayerVolumeControl.dll")  
            # MelonLoader URL
            $MLURL = "https://github.com/HerpDerpinstine/MelonLoader/releases/latest/download/MelonLoader.zip"
            # Update VRChat DLL's 
            foreach ($url in $Mods) {
                $filename="D:\Program Files\Steam\steamapps\common\VRChat\Mods\" + $($url.Split("/")[-1])
                Write-Output "Save ${url} to ${filename}"
                Invoke-WebRequest $url -OutFile $filename -ErrorAction SilentlyContinue
            }
            Write-Output "Updated Downloaded Files!"
            if ($(Get-ChildItem "D:\Program Files\Steam\steamapps\common\VRChat\version.dll").lastwritetime -lt (get-date).addhours(-8)) {
                Invoke-WebRequest $MLURL -OutFile $env:TEMP/MelonLoader.zip  -ErrorAction SilentlyContinue
                & 'C:\Program Files\7-Zip\7z.exe' x $env:TEMP/MelonLoader.zip -o"D:\Program Files\Steam\steamapps\common\VRChat\" -y
                Remove-Item $env:TEMP/MelonLoader.zip
                Write-Output "Updated Melonloader!"
            } else {
                Write-Output "Already have updated MelonLoader!"
            }
            
        }

        # Manage VRChat Window (Forever Loop)
        Start-Job -Name "VR-Manage-VRChat" -InitializationScript $Init {
            # Wait for me to launch VRChat
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "VRChat" } | Measure-Object -line).Lines -gt 0)
            Sleep -Seconds 5
            While ($true) {
                # Move and Resize VRChat to 1:1 Aspect Ratio
                Do {
                    $window=$(Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1 | Get-WindowPosition)
                    # If Window is NOT minimzed
                    if ($window.Top -gt -1000) {
                        if ( $window.Width -ne "1084" -or $window.Height -ne "1107" -or $window.Left -ne "1474" -or $window.Top -ne "334") {
                            $(Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1) | Set-WindowPosition -Left 1474 -Top 334
                            $(Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1) | Set-WindowPosition -Width 1084 -Height 1107
                            Sleep -Milliseconds 100
                        }
                        if ( $window.Width -eq "1084" -and $window.Height -eq "1107" -and $window.Left -eq "1474" -and $window.Top -eq "334") {
                            Get-Process -Name VRChat | Set-WindowState -State MINIMIZE -ErrorAction SilentlyContinue
                        }                    
                    } else { $status="Complete" }
                    Sleep -Seconds 1
                } until ($status -eq "Complete")
                # Look for VRChat Crash
                Sleep -Seconds 5
            }
        }

        # Manage OBS for VRChat (Forever Loop)
        Start-Job -Name "VR-Manage-OBS" -InitializationScript $Init {
            # Wait for SteamVR
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -gt 0)
            While ($true) {
                $isVRChatRunning = $(Get-Process | Where-Object { $_.Name -Match "VRChat" } | Measure-Object -line).Lines
                if ($isVRChatRunning -gt 0) {
                    $actions = @(
                        "/showsource=HeadsetInput",
                        "/showsource=HeadsetOutput",
                        "/unmute=HeadsetInput",
                        "/unmute=HeadsetOutput",
                        "/showsource=VRCView",
                        "/showsource=Overlay"
                    )
                    $proc = Start-Process -WindowStyle hidden -filePath "OBSCommand.exe" -ArgumentList $actions -workingdirectory "E:\Program Files\OBSCommand\" -PassThru
                    $timeouted = $null
                    $proc | Wait-Process -Timeout 10 -ErrorAction SilentlyContinue -ErrorVariable timeouted
                    if ($timeouted) { 
                        $proc | kill
                        Write-Output "Sorry, Took to long to respond!"
                    }
                } else {
                    $actions = @(
                        "/mute=HeadsetInput",
                        "/mute=HeadsetOutput",
                        "/hidesource=Overlay"
                    )
                    $proc = Start-Process -WindowStyle hidden -filePath "OBSCommand.exe" -ArgumentList $actions -workingdirectory "E:\Program Files\OBSCommand\" -PassThru
                    $timeouted = $null
                    $proc | Wait-Process -Timeout 10 -ErrorAction SilentlyContinue -ErrorVariable timeouted
                    if ($timeouted) { 
                        $proc | kill
                        Write-Output "Sorry, Took to long to respond!"
                    }
                }
                # Wait for me to launch VRChat
                Sleep -Seconds 15
            }
        }

        Do {
            Get-Job | Receive-Job
            Sleep -Seconds 1
        } until ($(Get-Job -State Running | Where-Object { $_.Name -notmatch "VR-Manage-*" } | Measure-Object -line).Lines -lt 1)
        Write-Host "======= Start up complete, Passing the torch off to the Manager. Bye! ======="
        Stop-Transcript
        Get-Job -State Completed | Remove-Job
        Do { Sleep -Seconds 120 } until ($(Get-Job -State Running | Measure-Object -line).Lines -lt 1)
    }
}
if ($args[0] -eq "stop") {
    if ($(Get-Process | Where-Object { $_.Name -Match "OculusClient" } | Measure-Object -line).Lines -gt 0 -OR 
        $(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -gt 0) {
        (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Shutdown.wav').Play()
        
        Start-Transcript -Path "E:\Windows\Logs\StopVR.txt"

        &E:\windows\Scripts\DarkModeSwitch.ps1

        # Start Backup Script
        Start-Job -Name "VR-Manage-Backup" {
            # Wait for OBS to stop
            Do { Sleep -Seconds 1 } until ($(Get-Process | Where-Object { $_.Name -Match "obs64" } | Measure-Object -line).Lines -lt 1)
            Write-Output "Backing up Files....."
            &E:\Windows\Scripts\Backup.ps1
            Write-Output "Backup Complete! (I hope...)"
        }

        # Stop OBS
        Start-Job -Name "VR-Stop-OBS" {
            Write-Output "Stopping OBS Buffer....."
            $proc = Start-Process -WindowStyle hidden -filePath "OBSCommand.exe" -ArgumentList @("/stoprecording", "/command=StopReplayBuffer") -workingdirectory "E:\Program Files\OBSCommand\" -PassThru
            $timeouted = $null
            $proc | Wait-Process -Timeout 4 -ErrorAction SilentlyContinue -ErrorVariable timeouted
            if ($timeouted) { 
                $proc | kill
                Write-Output "Sorry, Took to long to respond!"
            } elseif ($proc.ExitCode -eq 0) {
                Write-Host "OBS Recorder Stopped!"
            }
            Write-Output "Stopping OBS....."
            Stop-ScheduledTask -TaskName StartOBS -TaskPath Personal
            Stop-Process -Name "obs64" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "OBSCommand" -Force -ErrorAction SilentlyContinue
            Write-Host "OBS Closed!"
        }

        # Stop VRChat
        Start-Job -Name "VR-Stop-VRChat" {
            Stop-ScheduledTask -TaskName StartVR -TaskPath Personal; Write-Host "Start VR Task Stopped!"
            Stop-Process -Name "VRChat" -Force -ErrorAction SilentlyContinue; Write-Host "VRChat Closed!"
            &"E:\Windows\Scripts\AudioSet.ps1" set-headset; Write-Host "Set Audio to Headset!"
        }

        # Shutdown VR
        Start-Job -Name "VR-Stop-System" {
            Write-Output "Stopping Oculus Client....."
            Stop-Process -Name "OculusClient" -Force -ErrorAction SilentlyContinue
            Stop-Service OVRService; Write-Host "Oculus Services Shutdown!"
            Stop-Process -Name "OculusClient" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "Fixer" -Force -ErrorAction SilentlyContinue
            
            Write-Output "Stopping SteamVR Client....."
            Stop-Process -Name "vrmonitor" -Force -ErrorAction SilentlyContinue; Write-Host "SteamVR Stopped!"
            
            Write-Output "Stopping VR Tools....."
            Stop-Process -Name "VRCX" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "Driver4VR" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "SSTweetToolForSteamVR" -Force -ErrorAction SilentlyContinue
            Write-Host "VR Tools Closed!"
        }

        Do {
            Get-Job | Receive-Job
            Sleep -Seconds 1
        } until ($(Get-Job -State Running | Measure-Object -line).Lines -lt 1)
        exit
    } else {
        exit
    }
}
if ($args[0] -eq "status") {
    if ($(Get-Process | Where-Object { $_.Name -Match "OculusClient" } | Measure-Object -line).Lines -gt 0) {echo "true"} else {echo "false"}
}
exit