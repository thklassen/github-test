@set NUNIT=%ProgramFiles(x86)%\NUnit.org
@set FRAMEWORK=%NUNIT%\framework\3.4.0.0\net-2.0

@echo OFF
call "%SQUISHCOCO%\coveragescannerenv_csharp.bat"
@cls
if not exist "%NUNIT%\nunit-console\nunit3-console.exe" (
    @echo NUnit directory could not be found.
    @echo Please edit the script and set the variable NUNIT correctly.
) else if not exist "%FRAMEWORK%" (
    @echo NUnit framework subdirectory could not be found.
    @echo Please edit the script and set the variable FRAMEWORK correctly.
) else (
    @echo ON
    @echo Building tutorial_nunit.dll
    @copy /Y "%FRAMEWORK%\nunit.framework.dll"
    @copy /Y "%FRAMEWORK%\nunit.system.linq.dll"
    cscsc /target:library /out:tutorial_nunit.dll --cs-exclude-file-abs-wildcard="*test.cs" /nologo hellotest.cs messagetest.cs hello.cs message.cs /reference:"nunit.framework.dll" 

    @echo Executing Unit Tests
    "%NUNIT%\nunit-console\nunit3-console.exe" tutorial_nunit.dll 

    @echo Collecting code coverage results
    "%SQUISHCOCO%\cmcsexeimport.exe" -m tutorial_nunit.dll.csmes -t "Unit Test Results" --delete tutorial_nunit.dll.csexe

    @echo Code coverage analysis
    "%SQUISHCOCO%\coveragebrowser.exe" tutorial_nunit.dll.csmes 
)
@pause
