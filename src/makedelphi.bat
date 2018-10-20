@echo off
where /q dcc32
if errorlevel 1 (
  echo Error: Delphi compiler not found...
  set builderror=1
) else (
  call rsvars.bat
  set builderror=0
  msbuild project\multi\TilengineProject.dproj /t:Rebuild /p:Config=Release
  msbuild samples\test\test.dproj /t:Rebuild /p:Config=Release
  if errorlevel 1 (
    set builderror=1
  )
)

