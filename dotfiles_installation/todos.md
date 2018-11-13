1. use "envvar" xdg-config-home, if defined, else set a custom one and create the directory
2. allow setting an installation prefix for everything (defaults to $HOME) 
   as a inventory variable and then use that everywhere we copy files around.
3. automatically set variables in zsh vim etc. properly for the installation prefix from (2.)
4. maintain version of the playbooks that installs everything from source/anaconda/pip and does not require any sudo rights.
5. make ansible a dependency and be sure to use pip ansible for everything (gets rid of last sudo requirement)
