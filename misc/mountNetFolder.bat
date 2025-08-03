@echo off

if exist Z:\MountFlag (
	goto UNMOUNT
) else (
	goto MOUNT
)

: MOUNT
net use Z: \\192.168.1.1\SHARE PASSWORD /user:USER /persistent:yes
echo > Z:\MountFlag
goto END

: UNMOUNT
del Z:\MountFlag
net use Z: /delete

: END
pause
