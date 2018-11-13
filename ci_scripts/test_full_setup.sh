#!/bin/sh
OUTPUT_FILENAME="/tmp/setup_output.txt" 
ansible-playbook -vvvv -i setup/test_inventory.yml setup/install/install.yml
ansible-playbook -vvvv -i setup/test_inventory.yml setup/uninstall/uninstall.yml
