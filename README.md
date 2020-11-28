# Windows Automation Scripts

Some of these scripts are ran remotely via HomeKit and button presses. 

* Audio Set - Used to Switch Between my Headset Audio and Desktop Audio (or Theater Speakers in this current setup)
* Backup - All in one backup script that is run at the end of the night and backs up the following:
    - VRChat Camera Images (Sent to discord automaticly via ACROSS)
    - VRChat Clips (Renders then to <8MB to be auto uploaded to discord via ACROSS)
    - VRChat Logs
    - VRChat Mod Config and UserData
    - Auto Commit and Push updates of my avatar
* DarkModeSwitch - Runs a dummy EXE depending on the current set theme, this is to switch iCUE profiles
* DPISet - Switches between 120% and 100% DPI for my NEC TV. Can not be run remotely due to it does key presses to reset DWM
* PlaySound - Used to play various alert sounds, like warning before my PC is powered off for auto shutdown
* ShutdownSafe - Is the Shutdown script that is called from HomeKit, It will wait for the backup script to complete and will overide a shutdown if Blender or Unity are open
* VRService - Automated VR controller script that is toggled via HomeKit to start, stop and query the status of my VR headset
    - Start:
    - Starts the Oculus Service and Launches the Oculus Client
    - Starts SteamVR (Disabled due to Oculus not noticing that it has started, requires you to launch it from Oculus)
    - Launches VRCX and SSTweetToolForSteamVR
    - Minimises Driver4VR
    - Controls OBS to make sure its ready and all sources are unmuted and visible
    - Updates VRChat Mods
    - Forces VRChat to a 1:1 aspect ratio for recording and minimises it (This is looped to make sure it does not mess up)
    - Mutes and Blanks Screen on Recordings when VRChat is not running
    - Stop:
    - Closes all windows
    - Stops VR programs
    - Stops the Oculus Service to prevent wakeups or background tasks (YOU MUST ADD YOUR ACCOUNT TO THE SERVICE PERMISSIONS)