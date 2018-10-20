@echo off
if exist .git (
  echo initializing dependancies
  call initsubmodules.cmd
)
echo ##############################
echo # Pascal Tile Engine Wrapper #
echo ##############################
echo what compiler do you want to use?
CHOICE /C ab /M "DCC32 or FPC"
if %errorlevel% == 1 (
  call build-windows-delphi.cmd
)
if %errorlevel% == 2 (
  build-windows-fpc.cmd
) 

