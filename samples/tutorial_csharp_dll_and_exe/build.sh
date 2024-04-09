#!/bin/bash
if [ -z "$SQUISHCOCO" ]
then
    CSMCS=csgmcs  
else
    CSMCS=$SQUISHCOCO/csgmcs  
fi

set -x
$CSMCS  /target:library /nologo /out:hellodll.dll hello.cs
$CSMCS  /out:hello.exe /nologo /reference:hellodll.dll tutorial.cs
