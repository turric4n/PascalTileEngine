@echo off
where /q dcc32
if errorlevel 1 (
  echo Error: Delphi compiler not found...
  set builderror=1
) else (
  call rsvars.bat
  set builderror=0
  echo # i386-win32
  msbuild project\multi\TilengineProject.dproj /t:Rebuild /p:Config=Release /p:platform=Win32
  msbuild samples\test\test.dproj /t:Rebuild /p:Config=Release /p:platform=Win32
  msbuild samples\platformer\platformer.dproj /t:Rebuild /p:Config=Release /p:platform=Win32
  msbuild samples\benchmark\benchmark.dproj /t:Rebuild /p:Config=Release /p:platform=Win32
  echo # x86-64-win64
  msbuild project\multi\TilengineProject.dproj /t:Rebuild /p:Config=Release /p:platform=Win64
  msbuild samples\test\test.dproj /t:Rebuild /p:Config=Release /p:platform=Win64
  msbuild samples\platformer\platformer.dproj /t:Rebuild /p:Config=Release /p:platform=Win64
  msbuild samples\benchmark\benchmark.dproj /t:Rebuild /p:Config=Release /p:platform=Win64
  if errorlevel 1 (
    set builderror=1
  )
)

