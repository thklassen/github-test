#!/bin/bash
./build.sh
rm  hello.exe.csexe

echo Executing test "Test Suite/no params"...
echo *Test Suite/no params>> hello.exe.csexe
( set -x 
./hello.exe
)
echo The result of the test is set to CHECK_MANUALLY
echo !CHECK_MANUALLY>> hello.exe.csexe

echo Executing test "Test Suite/1 param"...
echo *Test Suite/1 param>> hello.exe.csexe
( set -x 
./hello.exe Joe
)
echo The result of the test is set to FAILED
echo !FAILED>> hello.exe.csexe

echo Executing test "Test Suite/2 param"...
echo *Test Suite/2 param>> hello.exe.csexe
( set -x 
./hello.exe Joe James
)
echo The result of the test is set to PASSED
echo !PASSED>> hello.exe.csexe

echo Executing test "Test Suite/3 param"...
echo *Test Suite/3 param>> hello.exe.csexe
( set -x 
./hello.exe Joe James Jim
)
echo The result of the test is set to PASSED
echo !PASSED>> hello.exe.csexe
