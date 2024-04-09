@echo OFF
cls
IF NOT EXIST tutorial.exe goto buildfirst
IF NOT EXIST tutorial_load_library.exe goto buildfirst
ECHO To execute the tutorial type:
ECHO     tutorial.exe "person 1" ... "person n"
ECHO or
ECHO     tutorial_load_library.exe "person 1" ... "person n"
cmd /K

exit
:buildfirst
color d0
echo Error: first build the tutorial
pause
