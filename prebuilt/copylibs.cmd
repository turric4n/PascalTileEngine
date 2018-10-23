@echo off
rem ### Don't call this script directly ###
echo ----------------------------------------
echo ---Copying Tilengine native libraries---
echo ----------------------------------------
xcopy prebuilt\Tilengine\arm-linux\libTilengine.so "bin\package\arm-linux\"
xcopy prebuilt\Tilengine\arm-linux\libTilengine.so "bin\package\arm-android\"
xcopy prebuilt\Tilengine\i386-linux\libTilengine.so "bin\package\i386-linux\"
xcopy prebuilt\Tilengine\i386-win32\Tilengine.dll "bin\package\i386-win32\"
xcopy prebuilt\Tilengine\x86-64-win64\Tilengine.dll "bin\package\x86-64-win64\"
xcopy prebuilt\Tilengine\x86-x64-darwin\Tilengine.dylib "bin\package\x86-x64-darwin\"
echo --------------------------------------------------
echo ---Copying SDL2 native libraries (Only Windows)---
echo --------------------------------------------------
xcopy prebuilt\SDL2\i386-win32\SDL2.dll "bin\package\i386-win32\"
xcopy prebuilt\SDL2\x86-64-win64\SDL2.dll "bin\package\x86-64-win64\"



