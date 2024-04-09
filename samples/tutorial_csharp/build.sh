#!/bin/bash
if [ -z "$SQUISHCOCO" ]
then
    CSMCS=csgmcs  
else
    CSMCS=$SQUISHCOCO/csgmcs  
fi

set -x
$CSMCS  tutorial.cs -out:hello.exe
