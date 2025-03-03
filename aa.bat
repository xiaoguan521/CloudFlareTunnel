@echo off
title Cloudflared Tunnel Manager
setlocal EnableDelayedExpansion

:menu
cls
echo ========================================
echo      Cloudflared Tunnel Manager
echo ========================================
echo 1. Start Tunnel
echo 2. Stop Tunnel
echo 3. Check Tunnel Status
echo 4. Exit
echo ========================================
set /p choice="Please select an option (1-4): "

if "%choice%"=="1" goto start_tunnel
if "%choice%"=="2" goto stop_tunnel
if "%choice%"=="3" goto check_status
if "%choice%"=="4" goto exit
echo Invalid choice, please try again.
pause
goto menu

:start_tunnel
echo Starting Cloudflared tunnel...
net start Cloudflared
if %errorlevel%==0 (
    echo Tunnel started successfully!
) else (
    echo Failed to start tunnel. Check if service is installed correctly.
)
pause
goto menu

:stop_tunnel
echo Stopping Cloudflared tunnel...
net stop Cloudflared
if %errorlevel%==0 (
    echo Tunnel stopped successfully!
) else (
    echo Failed to stop tunnel. Check if service is running.
)
pause
goto menu

:check_status
echo Checking Cloudflared service status...
sc query Cloudflared | find "RUNNING" >nul
if %errorlevel%==0 (
    echo Tunnel is RUNNING.
) else (
    echo Tunnel is NOT RUNNING.
)
pause
goto menu

:exit
echo Exiting manager...
exit /b