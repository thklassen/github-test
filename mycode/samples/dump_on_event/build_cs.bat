echo off
cd %~dp0%
call "%SQUISHCOCO%\coveragescannerenv_csharp.bat"
nmake /nologo

@echo ON
echo Building event_sample.cs
set COVERAGESCANNER_ARGS=--cs-dump-on-event=COVERAGE --cs-on
csc /nologo -out:event_sample_cs.exe event_sample.cs

del /Q *.csexe
echo > event_sample_cs.exe.csexe  
start cmd /K dump_sample.bat
start "%SQUISHCOCO%\coveragebrowser.exe" event_sample_cs.exe.csmes
event_sample_cs.exe
