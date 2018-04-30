#!/bin/sh

# Make mypy aware of shebang line and choose right python version 
# for its checks accordingly - defaults to python3

FILENAME="$1"
read -r firstline < $FILENAME

DEFAULT_PYTHON="python3"
ARGS="--ignore-missing-imports"

mypy_bin=`which mypy`

python3_bin=`which python3`
python2_bin=`which python2`
default_python_bin=`which "$DEFAULT_PYTHON"`

case $firstline in
    *"python3.6"*)
        $mypy_bin "$ARGS" $*
        ;;
    *"python3"* )
        $mypy_bin "$ARGS" $*
        ;;
    *"python2"*)
        $mypy_bin "$ARGS" $*
        ;;
    *) 
        $mypy_bin "$ARGS" $*
        ;;
esac
