@echo off
set COVERAGE_FLAGS=--cs-on --cs-count

REM Path of Scons
set PYTHON_PATH=c:\Python27
set PATH=%PYTHON_PATH%\scripts;%PATH%

REM Cleaning first the project
call scons.bat -c -Q

REM Building the project
call scons.bat coverage="%COVERAGE_FLAGS%" -Q
