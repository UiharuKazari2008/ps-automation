Import-Module "E:\Windows\WASP.dll"

While ($true) {
    # Wait for me to launch VRChat
    Do { Sleep -Seconds 5 } until ($(Get-Process | Where-Object { $_.Name -Match "VRChat" } | Measure-Object -line).Lines -gt 0)
    Sleep -Seconds 5
    $isVRActive=$($(Get-Process | Where-Object { $_.Name -Match "vrmonitor" } | Measure-Object -line).Lines -gt 0)
    Do {
        # Get Mode Sepecific Window Settings
        #                      X     Y    W     H
        if ($isVRActive) {
            $windowSettings=@(1473, 303, 1084, 1107)
        } else {
            $windowSettings=@(305, 100, 1920, 1225)
        }

        Do {
            $window=$(Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1 | Get-WindowPosition)
            $proccess=$(Select-Window -ProcessName "VRChat" | Where-Object { $_.Title -Match "VRChat" } | Select-Object -First 1)
            # If Window is NOT minimzed
            if ($window.Top -lt -1000) {
                $status="Complete"
            } else {
                if ( $isVRActive ) {
                    if ( $window.Width -ne $windowSettings[2] -or $window.Height -ne $windowSettings[3] -or $window.Left -ne $windowSettings[0] -or $window.Top -ne $windowSettings[1]) {
                        $proccess | Set-WindowPosition -Left $windowSettings[0] -Top $windowSettings[1]
                        $proccess | Set-WindowPosition -Width $windowSettings[2] -Height $windowSettings[3]
                        Sleep -Seconds 1
                    } else {
                        if ( $window.Top -gt -1000 ) {
                            $proccess | Set-WindowPosition -Minimize
                        } else { $status="Complete" }
                    }    
                } else {
                    $proccess | Set-WindowPosition -Maximize
                    $status="Complete"
                }
            }
            Sleep -Seconds 5
        } until ($status -eq "Complete")
        Sleep -Seconds 60
    } until ($(Get-Process | Where-Object { $_.Name -Match "VRChat" } | Measure-Object -line).Lines -lt 1)
}