# Add the Coco tools directory to the search path
. getcoco.sh
export PATH=$PATH:$COCO_BIN_DIR

# Setup for GNU makefile
cp gmake.mak Makefile
