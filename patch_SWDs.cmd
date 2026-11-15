@echo off
chcp 65001 >nul

Tools\bspatch.exe "%~dp0Levels\DemoDay\DemoDay.SWD" "%~dp0Levels\Jagdpanther\Jagdpanther.SWD" "%~dp0Levels\DemoDay\DemoDay.SWD.mod"
rmdir /s /q "Levels\DemoDay" "Shaders\Cache"

for /r %%F in (*.mod) do (
    "%~dp0Tools\bspatch.exe" "%%~dpnF" "%%~dpnF" "%%F"
)
echo Completed!
pause
del /s /q *.mod patch_SWDs.cmd