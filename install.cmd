@echo off
chcp 65001 >nul

Tools\bspatch.exe "%~dp0Truth.exe" "%~dp0Truth.exe" "%~dp0Levels\DemoDay\Truth.4gb.mod"
Tools\bspatch.exe "%~dp0Levels\DemoDay\DemoDay.SWD" "%~dp0Levels\Jagdpanther\Jagdpanther.SWD" "%~dp0Levels\DemoDay\DemoDay.SWD.mod"
Tools\bspatch.exe "%~dp0Levels\DemoDay\Demo.SLD" "%~dp0Levels\Jagdpanther\Jagdpanther.SLD" "%~dp0Levels\DemoDay\Demo.SLD.mod"
rmdir /s /q "Levels\DemoDay" "Shaders\Cache"

for /r %%F in (*.mod) do (
    "%~dp0Tools\bspatch.exe" "%%~dpnF" "%%~dpnF" "%%F"
)
echo Completed!
pause
del /s /q *.mod install.cmd
