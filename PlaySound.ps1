$Init={
    Function Show-PopUp{ 
    [CmdletBinding()][OutputType([int])]Param( 
        [parameter(Mandatory=$true, ValueFromPipeLine=$true)][Alias("Msg")][string]$Message, 
        [parameter(Mandatory=$false, ValueFromPipeLine=$false)][Alias("Ttl")][string]$Title = $null, 
        [parameter(Mandatory=$false, ValueFromPipeLine=$false)][Alias("Duration")][int]$TimeOut = 0, 
        [parameter(Mandatory=$false, ValueFromPipeLine=$false)][Alias("But","BS")][ValidateSet( "OK", "OC", "AIR", "YNC" , "YN" , "RC")][string]$ButtonSet = "OK", 
        [parameter(Mandatory=$false, ValueFromPipeLine=$false)][Alias("ICO")][ValidateSet( "None", "Critical", "Question", "Exclamation" , "Information" )][string]$IconType = "None" 
         ) 
     
    $ButtonSets = "OK", "OC", "AIR", "YNC" , "YN" , "RC" 
    $IconTypes  = "None", "Critical", "Question", "Exclamation" , "Information" 
    $IconVals = 0,16,32,48,64 
    if((Get-Host).Version.Major -ge 3){ 
        $Button   = $ButtonSets.IndexOf($ButtonSet) 
        $Icon     = $IconVals[$IconTypes.IndexOf($IconType)] 
        } 
    else{ 
        $ButtonSets|ForEach-Object -Begin{$Button = 0;$idx=0} -Process{ if($_.Equals($ButtonSet)){$Button = $idx           };$idx++ } 
        $IconTypes |ForEach-Object -Begin{$Icon   = 0;$idx=0} -Process{ if($_.Equals($IconType) ){$Icon   = $IconVals[$idx]};$idx++ } 
        } 
    $objShell = New-Object -com "Wscript.Shell" 
    $objShell.Popup($Message,$TimeOut,$Title,$Button+$Icon) 
 
    <# 
        .SYNOPSIS 
            Creates a Timed Message Popup Dialog Box. 
 
        .DESCRIPTION 
            Creates a Timed Message Popup Dialog Box. 
 
        .OUTPUTS 
            The Value of the Button Selected or -1 if the Popup Times Out. 
            
            Values: 
                -1 Timeout   
                 1  OK 
                 2  Cancel 
                 3  Abort 
                 4  Retry 
                 5  Ignore 
                 6  Yes 
                 7  No 
 
        .PARAMETER Message 
            [string] The Message to display. 
 
        .PARAMETER Title 
            [string] The MessageBox Title. 
 
        .PARAMETER TimeOut 
            [int]   The Timeout Value of the MessageBox in seconds.  
                    When the Timeout is reached the MessageBox closes and returns a value of -1. 
                    The Default is 0 - No Timeout. 
 
        .PARAMETER ButtonSet 
            [string] The Buttons to be Displayed in the MessageBox.  
 
                     Values: 
                        Value     Buttons 
                        OK        OK                   - This is the Default           
                        OC        OK Cancel           
                        AIR       Abort Ignore Retry 
                        YNC       Yes No Cancel      
                        YN        Yes No              
                        RC        Retry Cancel        
 
        .PARAMETER IconType 
            [string] The Icon to be Displayed in the MessageBox.  
 
                     Values: 
                        None      - This is the Default 
                        Critical     
                        Question     
                        Exclamation  
                        Information  
             
        .EXAMPLE 
            $RetVal = Show-PopUp -Message "Data Trucking Company" -Title "Popup Test" -TimeOut 5 -ButtonSet YNC -Icon Exclamation 
 
        .NOTES 
            FunctionName : Show-PopUp 
            Created by   : Data Trucking Company 
            Date Coded   : 06/25/2012 16:55:46 
 
        .LINK 
             
     #> 
 
} 
}

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
if ($args[0] -eq "warning-dialog") {
    (New-Object Media.SoundPlayer 'E:\Windows\Media\Windows Vista Sounds\Windows Battery Critical.wav').PlaySync()
    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Its almost time for bed! You have 5 Min to overide!','Bedtime')
    #$Init
    #Show-PopUp -Message "Its almost time for bed! You have 10 Min to overide!" -Title "Bedtime" -TimeOut 60 -ButtonSet OK -IconType None -ErrorAction SilentlyContinue
}
echo "Done"