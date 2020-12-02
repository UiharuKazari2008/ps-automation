cd 'HKCU:\Control Panel\Desktop\PerMonitorSettings\DEL40E8XVNNT7CIAYVL_33_07E1_8C^C436303F5A08E0936E8BA7603BA70A4C'
$val = Get-ItemProperty -Path . -Name "DpiValue"

if ($args[0] -eq "status") {
    if($val.DpiValue -ne 1) { echo "true"} else { echo "false"}
} else {
    if($val.DpiValue -ne 1) {
        Write-Host 'Change to 125% / 120 dpi'
        Set-ItemProperty -Path . -Name DpiValue -Value 1
    } else { 
        Write-Host 'Change to 100% / 96 dpi'
        Set-ItemProperty -Path . -Name DpiValue -Value 0
    }

$source = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Windows.Forms;
namespace KeyboardSend
{
    public class KeyboardSend
    {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
        private const int KEYEVENTF_EXTENDEDKEY = 1;
        private const int KEYEVENTF_KEYUP = 2;
        public static void KeyDown(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY, 0);
        }
        public static void KeyUp(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);
        }
    }
}
"@
    Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Windows.Forms"
    Function Win($Key, $Key2, $Key3)
    {
        [KeyboardSend.KeyboardSend]::KeyDown("LWin")
        [KeyboardSend.KeyboardSend]::KeyDown("$Key")
        [KeyboardSend.KeyboardSend]::KeyDown("$Key2")
        [KeyboardSend.KeyboardSend]::KeyDown("$Key3")
        [KeyboardSend.KeyboardSend]::KeyUp("LWin")
        [KeyboardSend.KeyboardSend]::KeyUp("$Key")
        [KeyboardSend.KeyboardSend]::KeyUp("$Key2")
        [KeyboardSend.KeyboardSend]::KeyUp("$Key3")
    }

    Win 163 161 66
}


