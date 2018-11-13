#!/bin/sh
OUTPUT_FILENAME="/tmp/setup_output.txt" 
ansible-playbook -K setup/install/install.yml | sudo tee -a "$OUTPUT_FILENAME"
NUM_ERRORS=`grep "ERROR" "$OUTPUT_FILENAME" | wc -l`
echo "$NUM_ERRORS errors occurred during installation.."
if [[ "$NUM_ERRORS" -gt 0 ]]; then
    echo "There were errors during installation - STATUS: Build Failed"
    exit 1
fi
exit 0
