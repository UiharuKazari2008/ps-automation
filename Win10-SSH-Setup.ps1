# Start as admin
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# Preferences
Set-ExecutionPolicy RemoteSigned
$ConfirmPreference = 'None'

# OpenSSH: Install
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service -Name sshd -Computer localhost -StartupType Automatic
Start-Service sshd

# OpenSSH: Setup
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

New-Item -Path $Env:ALLUSERSPROFILE\ssh -Name "administrators_authorized_keys" -ItemType "file" `
  -Value "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjWknr/ulklcMW42doF9z7+Df96IfrO0jxHbuB9qJEU/oHHlwqHwJ7AIar/UGDzgEjpmW9V88OWcN/pX59TaQD+lYfqQSkQraloVqRXpcO+0TX+TF3BQyBYCTw6gAkFDcFNXm8U04mWk6kJbkyecveN3sf+V1NuH0yjfr5KYbmNN9qN974I5/CxoHZX7KFoZ92zK6z4XnKbPtGmrrrqsFKq2de2Be0GtixBqH9mrn8HPahH7aW7HMm/xwcWGwu1biYIXustkkxDMxZUZGJ1HS9AKPpVJ4mZbXx5heNfCLFdQj4IEDYdsk+egqq8YTfHUWeCsr79kl9rTDZ19IBoKPWQ=="
icacls "$Env:ALLUSERSPROFILE\ssh\administrators_authorized_keys" /inheritance:d
icacls "$Env:ALLUSERSPROFILE\ssh\administrators_authorized_keys" /remove `
    "NT AUTHORITY\Authenticated Users"
Restart-Service -Name sshd
