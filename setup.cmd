@echo off
if exist .git (
  echo initializing dependancies
  call initsubmodules.cmd
  call src/deps/makelibtilengine.cmd
)
if %libraryfail% == 1 (
  echo Cannot compile Tilengine library automatically... You need Visual Studio Community 2017 in the default path. Don't worry you can compile libary manually with VC++ or GCC32
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

