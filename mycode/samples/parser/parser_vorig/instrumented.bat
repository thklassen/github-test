@echo off
setlocal

set PATH=%SQUISHCOCO%\visualstudio;%PATH%
set COVERAGESCANNER_ARGS=--cs-on --cs-mcdc --cs-mcc --cs-function-profiler=all

call %*

endlocal
