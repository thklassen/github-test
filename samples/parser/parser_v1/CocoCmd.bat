@echo off

call "%SQUISHCOCO%\coveragescannerenv.bat"

copy nmake.mak Makefile

cmd /K
