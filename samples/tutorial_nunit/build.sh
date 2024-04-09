#!/bin/bash
if [ -z "$SQUISHCOCO" ]
then
    CSMCS=csdmcs  
    CMCSEXEIMPORT=cmcsexeimport
    COVERAGEBROWSER=coveragebrowser
else
    CSMCS=$SQUISHCOCO/csdmcs  
    CMCSEXEIMPORT=$SQUISHCOCO/cmcsexeimport
    COVERAGEBROWSER=$SQUISHCOCO/coveragebrowser
fi


echo Building tutorial_nunit.dll
set -e
$CSMCS /target:library /out:tutorial_nunit.dll --cs-exclude-file-abs-wildcard="*test.cs" --cs-verbose=build /nologo HelloTest.cs MessageTest.cs Hello.cs Message.cs /reference:"/usr/lib/cli/nunit.framework-2.6/nunit.framework.dll" 

echo Executing Unit Tests
nunit-console tutorial_nunit.dll || true

echo Collecting code coverage results
$CMCSEXEIMPORT -m tutorial_nunit.dll.csmes -t "Unit Test Results" --delete tutorial_nunit.dll.csexe

echo Code coverage analysis
$COVERAGEBROWSER tutorial_nunit.dll.csmes 
