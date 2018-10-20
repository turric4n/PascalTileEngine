cd src
call make.bat
if errorlevel 0 (
  echo Wrapper and samples are build! You can test compiled samples at the following path : /bin/package/Win32/Release
) else (
  echo build failed... can related to broken repository or your computer configuration.
)
cd ..