#!/bin/bash
if [ -n "$SQUISHCOCO" -a -e "$SQUISHCOCO" ]
then
    CSGXX=$SQUISHCOCO/csg++  
else
    CSGXX=csg++  
fi

set -x
$CSGXX  tutorial.cpp -o hello
