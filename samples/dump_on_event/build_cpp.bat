echo off
cd %~dp0%
call "%SQUISHCOCO%\coveragescannerenv.bat"
nmake /nologo

@echo ON
echo Building event_sample.cpp
cscl --cs-dump-on-event=COVERAGE /nologo /EHsc event_sample.cpp /Feevent_sample_cpp.exe

del /Q *.csexe
start "%SQUISHCOCO%\coveragebrowser.exe"  event_sample_cpp.exe.csmes
start cmd /K dump_sample.bat
event_sample_cpp.exe
