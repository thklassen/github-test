@echo OFF
call "%SQUISHCOCO%\coveragescannerenv_csharp.bat"
@echo ON
cls
@echo Building hellodll.dll
cscsc /target:library /nologo /out:hellodll.dll hello.cs
@echo Building hello.exe
cscsc /out:hello.exe /nologo /reference:hellodll.dll tutorial.cs
pause
