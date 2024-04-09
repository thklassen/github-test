@echo off
setlocal

set PATH=%SQUISHCOCO%\visualstudio;%PATH%
set COVERAGESCANNER_ARGS=--cs-on --cs-mcdc --cs-mcc --cs-function-profiler=all --cs-exclude-path=../../cppunit-1.12.1 --cs-exclude-file-abs-wildcard=*\unittests.cpp --cs-exclude-file-abs-wildcard=*\CppUnitListener.cpp

call %*

endlocal
