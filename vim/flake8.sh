#!/bin/sh

# Make flake aware of shebang line and choose right python version 
# for its checks accordingly - defaults to python3

FILENAME="$1"
read -r firstline < $FILENAME

DEFAULT_PYTHON="python3"
IGNORE_ERRORS="E501"

flake_bin=`which flake8`

python3_bin=`which python3`
python2_bin=`which python2`
default_python_bin=`which "$DEFAULT_PYTHON"`

case $firstline in
    *"python3.6"*)
        exec python3.6 $flake_bin --ignore="$IGNORE_ERRORS" $*
        ;;
    *"python3"* )
        exec $python3_bin $flake_bin --ignore="$IGNORE_ERRORS" $*
        ;;
    *"python2"*)
        exec $python2_bin $flake_bin --ignore="$IGNORE_ERRORS" $*
        ;;
    *) 
        exec $default_python_bin $flake_bin --ignore="$IGNORE_ERRORS" $*
        ;;
esac
