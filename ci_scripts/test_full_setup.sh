#!/bin/sh
OUTPUT_FILENAME="/tmp/setup_output.txt" 
python3 setup.py install | sudo tee -a "$OUTPUT_FILENAME"
NUM_ERRORS=`grep "ERROR" "$OUTPUT_FILENAME" | wc -l`
if [[ "$NUM_ERRORS" -gt 0 ]]; then
    echo "$NUM_ERRORS errors occurred.."
    exit 1
fi
exit 0
