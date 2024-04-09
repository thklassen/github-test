# Find the Coco binary directories
#
# Two shell variables are set for the use in other scripts.
#
# This script is essentially there to hide complex code other scripts,
# and also to have a central place for changes if you have a
# nonstandard configuration

# Get the directory of the compiler wrappers
COCO_WRAPPER_DIR=""
for D in $HOME/SquishCoco/wrapper/bin /opt/SquishCoco/wrapper/bin /Applications/SquishCoco/wrapper
do
    if [ -e "$D" ]
    then
        COCO_WRAPPER_DIR="$D"
    fi
done

# Get the directory of the command line tools
COCO_BIN_DIR=""
for D in $HOME/SquishCoco/bin /opt/SquishCoco/bin /Applications/SquishCoco
do
    if [ -e "$D/coveragescanner" ]
    then
        COCO_BIN_DIR="$D"
    fi
done
