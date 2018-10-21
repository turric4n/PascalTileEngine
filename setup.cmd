@echo off
echo ##############################
echo # Native library dependancy  #
echo ##############################
echo do you want to compile native library or use a precompiled one?
CHOICE /C ab /M "Build yourself or download manually from https://megamarc.itch.io/tilengine"
if %errorlevel% == 1 (
  goto :buildlibrary
)
if %errorlevel% == 2 (
  goto :buildpascal
) 

:buildpascal
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
goto :eof

:buildlibrary  
echo you select build library using VC++ automatically, you need Visual Studio Community 2017 in the default path
echo initializing dependancies
call initsubmodules.cmd  
call src/deps/makelibtilengine.cmd
if %libraryfail% == 1 (
  echo Cannot compile Tilengine library automatically... You need Visual Studio Community 2017 in the default path. Don't worry you can compile libary manually with VC++ or GCC32
)
goto :buildpascal

:eof
echo Finished.