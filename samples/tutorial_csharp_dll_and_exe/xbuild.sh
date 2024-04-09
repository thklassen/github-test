#!/bin/bash
# Sample of xbuild script.

# CoverageScanner instrumentation option
export COVERAGESCANNER_ARGS=--cs-on

COVERAGESCANNER=$(which coveragescanner)
if [ ! -e "$COVERAGESCANNER" ]
then
   echo "Error: 'coveragescanner' executable not found."
   echo "Error: please install Squish Coco and adjust the PATH environment variable."
   exit 1
fi

export SQUISHCOCO=$(dirname $COVERAGESCANNER)

set -x
xbuild /p:UseEnv=true /p:UseHostCompilerIfAvailable=true /p:CscToolPath="${SQUISHCOCO}/wrapper" tutorial.sln
