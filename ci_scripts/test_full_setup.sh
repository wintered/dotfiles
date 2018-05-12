#!/bin/sh
OUTPUT_FILENAME="/tmp/setup_output.txt" 
python3 setup.py install | sudo tee -a "$OUTPUT_FILENAME"
if grep "ERROR" "$OUTPUT_FILENAME"; then
    exit 1
fi
exit 0
