@echo off

md c:\nxt
pwsh -NoProfile -ExecutionPolicy Bypass -File "getinfo.ps1"

:: Get installed drivers
Dism /online /get-drivers > c:\nxt\drivers.txt
md c:\nxt\backup
pnputil /export-driver oem1.inf c:\nxt\backup
pnputil /export-driver * c:\nxt\backup

:: Check if device with problem exists
pnputil /enum-devices /problem
pnputil /enum-devices /problem > c:\nxt\device_problem.txt

:: Get device/driver status
pnputil /export-pnpstate c:\nxt\pnpstate.pnp
echo Use pnpexplr to open pnpstate.pnp

systeminfo > c:\nxt\sysinfo.txt

echo list vol | diskpart
