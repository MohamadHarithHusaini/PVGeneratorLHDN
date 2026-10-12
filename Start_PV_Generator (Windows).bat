@echo off
REM ============================================================
REM  PV Generator - one-click launcher (Windows)
REM  Starts a local server using PowerShell, which is already
REM  built into every Windows PC - no Python or any other install
REM  needed. This enables all features, including automatic
REM  amount reading from payment screenshots. Everything stays on
REM  this computer; no internet is used.
REM ============================================================
title PV Generator
cd /d "%~dp0"

echo Starting PV Generator...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"

echo.
echo Server stopped.
pause
