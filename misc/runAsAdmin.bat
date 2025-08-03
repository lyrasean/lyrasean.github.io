@echo off

>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"
if %errorlevel% == 0 (
    echo Script is running with administrator rights.
) else (
    echo Script is not running with administrator rights.
    echo Requesting administrator rights...
    powershell -command "Start-Process '%0' -Verb RunAs"
    exit
)

echo test > C:\testfile
pause
