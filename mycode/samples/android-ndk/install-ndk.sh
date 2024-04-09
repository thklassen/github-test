#!/bin/bash
NDK_BUILD=$(which ndk-build)
if [ ! -e "$NDK_BUILD" ]
then
   echo "Error: ndk-build command line not found"
   echo "Error: are you use that the Android NDK is installed?"
   exit 1
fi

COVERAGESCANNER=$(which coveragescanner)
if [ ! -e "$COVERAGESCANNER" ]
then
   echo "Error: coveragescanner command line not found"
   exit 1
fi

COVERAGESCANNER_LOCATION=$(dirname "$COVERAGESCANNER")
NDK_LOCATION="$(dirname $NDK_BUILD)"
TOOLCHAINS="$NDK_LOCATION/toolchains"

function patch_gcc()
{
    EXECUTABLE=$1
    ARCH=$2
    ADDITIONAL_LIBGEN=$3
    ADDITIONAL_TO_EXCLUDE="$NDK_LOCATION/platforms/*;$NDK_LOCATION/sources/*"
# patching GCC
    for GCC_BINARY in $TOOLCHAINS/$ARCH-*/*/*/bin/*-${EXECUTABLE}
    do
        CSPRO_DEST="$GCC_BINARY".cspro
        GCC_NEW_BIN="$GCC_BINARY".real
        if [ -e "$GCC_BINARY" -a ! -e "$CSPRO_DEST" ]
        then
            echo "Installing SquishCoco compiler wrapper for $GCC_BINARY"
            TOOL_LOCATION="$(dirname $GCC_BINARY)"
            mv  "$GCC_BINARY" "$GCC_NEW_BIN"
            cat "$COVERAGESCANNER_LOCATION/${EXECUTABLE}.cspro" | \
            sed -e 's#TOOL=\$PROFILE\$#TOOL='$GCC_NEW_BIN'#g' | \
            sed -e 's#\$LIBGEN\$#& '"$ADDITIONAL_LIBGEN"'#g' | \
            sed -e 's#SOURCE_IGNORE_INSTRUMENTATION=.*$#&;'"$ADDITIONAL_TO_EXCLUDE"'#g' > "$CSPRO_DEST"
            cp  "$COVERAGESCANNER" "$GCC_BINARY"
        fi
    done
}

patch_gcc gcc "arm" "-I$NDK_LOCATION/platforms/android-9/arch-arm/usr/include"
patch_gcc g++ "arm" "-I$NDK_LOCATION/platforms/android-9/arch-arm/usr/include"
patch_gcc gcc "mipsel" "-I$NDK_LOCATION/platforms/android-9/arch-mips/usr/include"
patch_gcc g++ "mipsel" "-I$NDK_LOCATION/platforms/android-9/arch-mips/usr/include"
patch_gcc gcc "x86" "-I$NDK_LOCATION/platforms/android-9/arch-x86/usr/include"
patch_gcc g++ "x86" "-I$NDK_LOCATION/platforms/android-9/arch-x86/usr/include"
