@echo off
pushd %~dp0%
set HERE=%cd%
call "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat" amd64
nmake /nologo -f vs.mak clean
nmake /nologo -f vs.mak all_unit_test
pause
