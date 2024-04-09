@echo OFF
call "%SQUISHCOCO%\coveragescannerenv_csharp.bat"
@echo ON
cls
@echo Building hello.exe
cscsc /out:hello.exe /nologo tutorial.cs
pause
