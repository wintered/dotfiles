#!/bin/sh
OUTPUT_FILENAME="/tmp/setup_output.txt" 
ansible-playbook -vvvv -i setup/localhost_inventory.yml setup/install/install.yml
