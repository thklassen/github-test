@echo OFF
call "%SQUISHCOCO%\coveragescannerenv_csharp.bat"
@echo ON
cls
@echo Building InjectModuleInitializer tool
@pushd InjectModuleInitializer
msbuild /nologo /verbosity:quiet /p:Configuration=Release  InjectModuleInitializer.csproj
@popd
@echo Building hellodll.dll
cscsc /target:library /nologo /out:hellodll.dll hello.cs
@echo Activating CoverageScanner Library
InjectModuleInitializer\bin\release\InjectModuleInitializer.exe hellodll.dll
@echo Building hello.exe (not instrumented)
csc /out:hello.exe /nologo /reference:hellodll.dll tutorial.cs
@pause
