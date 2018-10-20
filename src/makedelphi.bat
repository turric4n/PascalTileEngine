@echo off 
call rsvars.bat
msbuild project\multi\TilengineProject.dproj /t:Rebuild /p:Config=Release
msbuild samples\test\test.dproj /t:Rebuild /p:Config=Release

