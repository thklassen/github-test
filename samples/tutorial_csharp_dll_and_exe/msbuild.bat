
set COVERAGESCANNER_ARGS=--cs-on
msbuild.exe /p:UseEnv=true /p:UseHostCompilerIfAvailable=true tutorial.sln
