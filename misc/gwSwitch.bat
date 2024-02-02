@echo off

REM Double-click
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
goto is_admin

REM Run_as check
net session 1>nul 2>&1 && (
    goto is_admin
) || (
    echo Please run as administrator!
    echo.
    pause
    exit
)

:is_admin
powershell Get-NetAdapter
REM set /p ifIndex="Please enter the InterfaceIndex to change: "
set ifIndex=14

powershell Get-NetIPConfiguration -InterfaceIndex %ifIndex% | findstr "IPv4DefaultGateway"
powershell Get-NetIPConfiguration -InterfaceIndex %ifIndex% | findstr "IPv4DefaultGateway" > "%~dp0gw.log"
REM set /p ipAddress="Please enter the ipAddress to change: "
REM set /p gatewayBefore="Please enter the gateway before changing: "
REM set /p gatewayAfter="Please enter the gateway after changing: "
set ipAddress="192.168.1.65"
set gatewayBefore="192.168.1.1"
set gatewayAfter="192.168.1.99"

findstr /e %gatewayBefore% "%~dp0gw.log" >nul && (
    powershell Remove-NetIPAddress -IPAddress %ipAddress% -DefaultGateway %gatewayBefore% -Confirm:$false
    powershell New-NetIPAddress -InterfaceIndex %ifIndex% -IPAddress %ipAddress% -PrefixLength 24 -DefaultGateway %gatewayAfter% >nul
    goto end
)

findstr /e %gatewayAfter% "%~dp0gw.log" >nul && (
    powershell Remove-NetIPAddress -IPAddress %ipAddress% -DefaultGateway %gatewayAfter% -Confirm:$false
    powershell New-NetIPAddress -InterfaceIndex %ifIndex% -IPAddress %ipAddress% -PrefixLength 24 -DefaultGateway %gatewayBefore% >nul
)

:end
del "%~dp0gw.log"
echo.
powershell Get-NetIPConfiguration -InterfaceIndex %ifIndex% | findstr "IPv4DefaultGateway"
echo.
pause
