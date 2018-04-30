#!/bin/sh

# Make vim aware of shebang line and choose right python version 
# accordingly - default: python3

python3_bin=`which python3`
python2_bin=`which python2`
default_python_bin="$python3_bin"

FILENAME="$1"
read -r firstline < $FILENAME

case $firstline in
    *"python3.6"*)
        exec python3.6 $*
        ;;
    *"python3"* )
        exec $python3_bin $*
        ;;
    *"python2"*)
        exec $python2_bin $*
        ;;
    *) 
        exec $python3_bin $*
        ;;
esac
