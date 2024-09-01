@echo off

md c:\nxt
pwsh -NoProfile -ExecutionPolicy Bypass -File "NXT_GetInfo.ps1"

:: Get installed drivers
Dism /online /get-drivers > c:\nxt\drivers.txt

:: Check if any issue for driver
pnputil /enum-devices /problem
pnputil /enum-devices /problem > c:\nxt\device_problem.txt

:: Get driver status
pnputil /export-pnpstate c:\nxt\pnpstate.pnp
echo Use pnpexplr to open pnpstate.pnp

systeminfo > c:\nxt\sysinfo.txt

echo list vol | diskpart
