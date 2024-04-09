#!/bin/bash
NDK_BUILD=$(which ndk-build)
if [ ! -e "$NDK_BUILD" ]
then
   echo "Error: ndk-build command line not found"
   echo "Error: are you use that the Android NDK is installed?"
   exit 1
fi

COVERAGESCANNER_LOCATION=$(dirname "$COVERAGESCANNER")
NDK_LOCATION="$(dirname $NDK_BUILD)"
TOOLCHAINS="$NDK_LOCATION/toolchains"

function unpatch_gcc()
{
    EXECUTABLE=$1
# patching GCC
    for GCC_BINARY in $TOOLCHAINS/*/*/*/bin/*-${EXECUTABLE}
    do
        CSPRO_DEST="$GCC_BINARY".cspro
        GCC_NEW_BIN="$GCC_BINARY".real
        if [ -e "$GCC_BINARY" -a -e "$CSPRO_DEST" -a -e "$GCC_NEW_BIN" ]
        then
            echo "Deinstalling SquishCoco compiler wrapper for $GCC_BINARY"
            rm "$GCC_BINARY" "$CSPRO_DEST"
            mv "$GCC_NEW_BIN" "$GCC_BINARY" 
        fi
    done
}

unpatch_gcc gcc
unpatch_gcc g++
