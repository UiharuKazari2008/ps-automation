﻿     $OTF_REC_FOLDER="$([Environment]::GetFolderPath("MyVideos"))\OBS Recorder\OnTheFly\"
$VRCHAT_PHOTO_FOLDER="$([Environment]::GetFolderPath("MyPictures"))\VRChat\"
        $VRCHAT_LOGS="$([Environment]::GetEnvironmentVariable("LocalAppData"))Low\VRChat\VRChat\"
        $VRCHAT_DATA="$([Environment]::GetEnvironmentVariable("ProgramFiles(x86)"))\Steam\steamapps\common\VRChat\UserData\"

     $ARCHIVE_FOLDER="\\xochitl.nyti.ne.jp\Backups\"
      $UPLOAD_FOLDER="\\eiga-2.prod.nyti.ne.jp\kanmi\"

Write-Output "Hello, Its $(date)! Time to backup your shit!"

if ($(Test-Path $ARCHIVE_FOLDER) -and $(Test-Path $UPLOAD_FOLDER)) {
    Write-Output "Backup Images"
    foreach ($i in $(Get-ChildItem "${VRCHAT_PHOTO_FOLDER}VRChat_*" | Where-Object {$_.lastwritetime -ge (get-date).addhours(-12) -and $_.Attributes -eq "Archive"})) {
        Write-Output "    $($i.Name) => ${ARCHIVE_FOLDER}VRChat Photos"
        Copy-Item $i.FullName "${ARCHIVE_FOLDER}VRChat Photos\"
        if (Test-Path "${ARCHIVE_FOLDER}VRChat Photos\$($i.Name)") {
            Copy-Item $i.FullName "${UPLOAD_FOLDER}VRChat\"
            if (Test-Path "${UPLOAD_FOLDER}VRChat\$($i.Name)") {
                $i.attributes = $i.Attributes -bxor ([System.IO.FileAttributes]::Archive)
            }
        }
    }

    Write-Output "Remuxing Clips"
    foreach ($i in $(Get-ChildItem "${OTF_REC_FOLDER}CLIP*.ts" | Where-Object {$_.lastwritetime -ge (get-date).addhours(-12) -and $_.Attributes -eq "Archive"})) {
        Write-Output "    $($i.Name) RENDER"
        $LowRenderName="${OTF_REC_FOLDER}$($i.BaseName)-Discord.mp4"
        & 'E:\Program Files\ffmpeg.exe' -hide_banner -loglevel panic -y -i "$($i.FullName)" -f mp4 -vcodec h264_nvenc -tune animation -preset slow -crf 22 -maxrate 750K -filter:v scale=640:-1 -acodec copy "${LowRenderName}"

        if (Test-Path $LowRenderName) {
            Write-Output "    $($i.Name) => ${UPLOAD_FOLDER}VRChat Photos"
            Copy-Item $LowRenderName "${UPLOAD_FOLDER}VRChat Clips\$($i.BaseName).mp4" -ErrorAction SilentlyContinue
            if (Test-Path "${UPLOAD_FOLDER}VRChat Clips\$($i.BaseName).mp4") {
                Remove-Item $LowRenderName
                $NewFile="${VRCHAT_PHOTO_FOLDER}$($i.BaseName).mp4"
                & 'E:\Program Files\ffmpeg.exe' -hide_banner -y -loglevel panic -i "$($i.FullName)" -f mp4 -vcodec copy -acodec copy $NewFile
                if (Test-Path $NewFile) {
                    $object=$(Get-ChildItem $NewFile | Where-Object {! $_.PSIsContainer})
                    $object.CreationTime = ($i.CreationTime)
                    $object.LastWriteTime = ($i.LastWriteTime)
                    Write-Output "    $($i.Name) => ${ARCHIVE_FOLDER}VRChat Photos"
                    Copy-Item $NewFile "${ARCHIVE_FOLDER}VRChat Clips\$($i.BaseName).mp4" -ErrorAction SilentlyContinue
                }
                $i.attributes = $i.Attributes -bxor ([System.IO.FileAttributes]::Archive)
                Remove-ItemSafely $i
            }
        }
    }

    Write-Output "Backup Logs"
    foreach ($i in $(Get-ChildItem "${VRCHAT_LOGS}output*")) {
        Write-Output "    $($i.Name) => ${ARCHIVE_FOLDER}VRChat Logs"
        Copy-Item $i "${ARCHIVE_FOLDER}VRChat Logs"
        $i.attributes = $i.Attributes -bxor ([System.IO.FileAttributes]::Archive)
        Remove-ItemSafely $i
    }

    Write-Output "Backup Config"
    Copy-Item ${VRCHAT_DATA}* "${ARCHIVE_FOLDER}VRChat Data\" -Recurse -ErrorAction SilentlyContinue -Force
}

Write-Output "--------------------------------------------------"