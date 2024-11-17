# AssetTag
Get-CimInstance -ClassName Win32_SystemEnclosure
gcim Win32_SystemEnclosure | Select-Object -Property SMBIOSAssetTag > c:\nxt\AssetTag.txt

# BIOS & SN
Get-CimInstance -ClassName Win32_BIOS
gcim Win32_BIOS > c:\nxt\BIOS-SN.txt

# ChassisTypes
Get-CimInstance -ClassName Win32_SystemEnclosure | Select-Object -Property * | Format-List
gcim Win32_SystemEnclosure | Select-Object -Property ChassisTypes > c:\nxt\ChassisTypes.txt

# TPM
Get-CimInstance -Namespace "ROOT/cimv2/security/microsofttpm" -ClassName Win32_TPM
gcim -Namespace "ROOT/cimv2/security/microsofttpm" -ClassName Win32_TPM > c:\nxt\TPM.txt

# Others
gcim Win32_BaseBoard > c:\nxt\BaseBoard.txt
gcim Win32_OperatingSystem | Format-List > c:\nxt\OS.txt
gcim Win32_ComputerSystem | Format-List > c:\nxt\PCinfo.txt
gcim Win32_Processor | Format-List > c:\nxt\CPU.txt

Suspend-BitLocker -MountPoint "C:" -RebootCount 0
# Resume-BitLocker -MountPoint "C:"
Get-BitLockerVolume -MountPoint "C:" | Format-List

