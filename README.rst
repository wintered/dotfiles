========
dotfiles
========

Status of automatic dotfiles installation via `setup.py`:

|Build Status|

This is a collection of my dotfiles together with an automatic installation 
script that allows transferring my setup quickly and painlessly to new machines. 

.. |Build Status| image:: https://travis-ci.org/MFreidank/dotfiles.svg?branch=master
   :target: https://travis-ci.org/MFreidank/dotfiles

Installation
============

To install a target simply do:

.. code-block:: bash

    python3 setup.py install TARGET

To list possible targets do: 

.. code-block:: bash

    python3 setup.py install --help

Uninstalling dotfiles with associated packages is also supported:

.. code-block:: bash

    python3 setup.py uninstall TARGET

If this is too much magic, use `--dryrun` to have a risk-free peak at what's going on:

.. code-block:: bash

    python3 setup.py install --dryrun TARGET
    python3 setup.py uninstall --dryrun TARGET


