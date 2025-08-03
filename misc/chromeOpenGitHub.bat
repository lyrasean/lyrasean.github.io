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

"C:\Program Files\Google\Chrome\Application\chrome.exe" --host-rules="MAP github.com octocaptcha.com, MAP github.githubassets.com yelp.com, MAP *.githubusercontent.com yelp.com" --host-resolver-rules="MAP octocaptcha.com 20.27.177.113, MAP yelp.com 199.232.240.116"
