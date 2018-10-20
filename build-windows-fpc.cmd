cd src
call makefpc.bat
if %builderror% == 1 (  
  echo build failed... can related to broken repository or your computer configuration.
) else (
  echo Wrapper and samples are build! You can test compiled samples at the following path : /bin/package/Win32/Release
)
cd ..