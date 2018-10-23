@echo off
rem ### Don't call this script directly ###
echo ----------------------------------------
echo ---Copying Tilengine native libraries---
echo ----------------------------------------
if exist prebuilt\Tilengine\arm-linux\libTilengine.so_ move prebuilt\Tilengine\arm-linux\libTilengine.so_ prebuilt\Tilengine\arm-linux\libTilengine.so
xcopy prebuilt\Tilengine\arm-linux\libTilengine.so "bin\package\arm-linux\"
if exist prebuilt\Tilengine\arm-linux\libTilengine.so_ move prebuilt\Tilengine\arm-linux\libTilengine.so_ prebuilt\Tilengine\arm-linux\libTilengine.so
xcopy prebuilt\Tilengine\arm-linux\libTilengine.so "bin\package\arm-android\"
if exist prebuilt\Tilengine\i386-linux\libTilengine.so_ move prebuilt\Tilengine\i386-linux\libTilengine.so_ prebuilt\Tilengine\i386-linux\libTilengine.so
xcopy prebuilt\Tilengine\i386-linux\libTilengine.so "bin\package\i386-linux\"
if exist prebuilt\Tilengine\i386-win32\Tilengine.dll_ move prebuilt\Tilengine\i386-win32\Tilengine.dll_ prebuilt\Tilengine\i386-win32\Tilengine.dll
xcopy prebuilt\Tilengine\i386-win32\Tilengine.dll "bin\package\i386-win32\"
if exist prebuilt\Tilengine\x86-64-win64\Tilengine.dll_ move prebuilt\Tilengine\x86-64-win64\Tilengine.dll_ prebuilt\Tilengine\x86-64-win64\Tilengine.dll
xcopy prebuilt\Tilengine\x86-64-win64\Tilengine.dll "bin\package\x86-64-win64\"
if exist prebuilt\Tilengine\x86-x64-darwin\Tilengine.dylib_ move prebuilt\Tilengine\x86-x64-darwin\Tilengine.dylib_ prebuilt\Tilengine\x86-x64-darwin\Tilengine.dylib
xcopy prebuilt\Tilengine\x86-x64-darwin\Tilengine.dylib "bin\package\x86-x64-darwin\"
echo --------------------------------------------------
echo ---Copying SDL2 native libraries (Only Windows)---
echo --------------------------------------------------
if exist prebuilt\SDL2\i386-win32\SDL2.dll_ move prebuilt\SDL2\i386-win32\SDL2.dll_ prebuilt\SDL2\i386-win32\SDL2.dll
xcopy prebuilt\SDL2\i386-win32\SDL2.dll "bin\package\i386-win32\"
if exist prebuilt\SDL2\x86-64-win64\SDL2.dll_ move prebuilt\SDL2\x86-64-win64\SDL2.dll_ prebuilt\SDL2\x86-64-win64\SDL2.dll
xcopy prebuilt\SDL2\x86-64-win64\SDL2.dll "bin\package\x86-64-win64\"



