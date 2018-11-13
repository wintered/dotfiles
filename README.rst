========
dotfiles
========

Status of automatic dotfiles installation via `setup.py`:

|Build Status|

This is a collection of my dotfiles together with ansible-based automatic installation 
facilities to allow transferring my setup quickly and painlessly to new machines. 

.. |Build Status| image:: https://travis-ci.org/MFreidank/dotfiles.svg?branch=master
   :target: https://travis-ci.org/MFreidank/dotfiles

Installation
============

Installation of tools is done using `ansible 
<http://www.ansible.com/>`_.

An installation of all popular targets can be done using:
.. code-block:: bash

    ansible-playbook -i dotfiles_installation/localhost_inventory.yml dotfiles_installation/install/install.yml

To install only a single target with its configuration, e.g. vim, simply do:

.. code-block:: bash

    ansible-playbook -i dotfiles_installation/localhost_inventory.yml dotfiles_installation/install/install.yml --tags="vim"

To list all possible targets do: 

.. code-block:: bash

    ansible-playbook --list-tags dotfiles_installation/install/install.yml

Uninstalling a dotfile target with associated packages is also supported:

.. code-block:: bash

    ansible-playbook -i dotfiles_installation/localhost_inventory.yml dotfiles_installation/uninstall/uninstall.yml --tags="vim"
