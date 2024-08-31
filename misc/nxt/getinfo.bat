@echo off

md c:\nxt
powershell -NoProfile -ExecutionPolicy Bypass -File "getinfo.ps1"

:: Get installed drivers
Dism /online /get-drivers > c:\nxt\drivers.txt

:: Check if any issue for driver
pnputil /enum-devices /problem
pnputil /enum-devices /problem > c:\nxt\device_problem.txt

:: Get driver status
pnputil /export-pnpstate c:\nxt\pnpstate.pnp
echo Use pnpexplr to open pnpstate.pnp

echo list vol | diskpart
