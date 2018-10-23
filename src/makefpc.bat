@echo off
where /q fpc
cd
pause
if errorlevel 1 (
  echo Error: FPC compiler not found...
  set builderror=1
) else (
  set builderror=0	
  mkdir fpctemp
  fpc -Sd -B -FEfpctemp -FUfpctemp -o../bin/Win32/Release/TilengineProject.exe ./src/project/multi/TilengineProject.dpr
  fpc -Sd -B -FEfpctemp -FUfpctemp -o../bin/Win32/Release/Test.exe ./src/samples/test/test.dpr
  if errorlevel 1 (
    set builderror=1
  )
  rmdir /s /q fpctemp
)


