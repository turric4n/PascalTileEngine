@echo off
echo Building lib using Visual C++ compiler
set libraryfail=0
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" (
  call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" 
  msbuild "src/deps/tilengine/Tilengine.sln" /t:Rebuild /p:Config=Release
) else (
  set libraryfail=1
)
if errorlevel == 1 ( 
  set libraryfail=1
)