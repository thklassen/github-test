call "%SQUISHCOCO%\coveragescannerenv_csharp.bat"
msbuild.exe Tutorial.sln /t:Build /p:Configuration=Release
del /Q testTutorial.trx
mstest.exe  /testcontainer:TestTutorial\bin\release\testtutorial.dll /resultsfile:testTutorial.trx
copy tutorial\obj\release\tutorial.dll.csmes  tutorial.dll.csmes
cmcsexeimport -m tutorial.dll.csmes -t "Unit tests" testtutorial.hellotest.csexe testtutorial.messagetest.csexe
coveragebrowser tutorial.dll.csmes
