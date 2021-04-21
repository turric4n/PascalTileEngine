@echo off
echo ###############################
echo # Native library dependencies #
echo ###############################
echo do you want to compile native library yourself (Only Windows (Need VS)) or use prebuilt (easy mode)?
CHOICE /C ab /M "Compile or Prebuilt"
if %errorlevel% == 1 (
  goto :buildlibrary
)
if %errorlevel% == 2 (
  call "prebuilt/copylibs.cmd"
) 

:buildpascal
echo ##############################
echo # Pascal Tilengine Wrapper   #
echo ##############################
echo what compiler do you want to use to compile examples and wrapper?
CHOICE /C ab /M "DCC32 or FPC"
if %errorlevel% == 1 (
  call build-windows-delphi.cmd
)
if %errorlevel% == 2 (
  build-windows-fpc.cmd
) 
goto :finished

:buildlibrary  
echo you select build library using VC++ automatically, you need Visual Studio Community 2019 in the default path
echo initializing dependancies
call initsubmodules.cmd  
call src/deps/makelibtilengine.cmd
if %libraryfail% == 1 (
  echo Cannot compile Tilengine library automatically... You need Visual Studio Community 2019 in the default path. Don't worry you can compile libary manually with VC++ or GCC32
)
goto :buildpascal

:finished
call prebuilt/gitignorelibs.cmd
echo Finished.