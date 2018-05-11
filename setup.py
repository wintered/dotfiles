#!/usr/bin/python3
# -*- coding: iso-8859-15 -*-
import argparse
import logging
from subprocess import check_call
from os import makedirs
from os.path import abspath, dirname, expanduser, expandvars, join as path_join
from shutil import copy


DOTFILES_PATH = path_join(dirname(abspath(__file__)))


def _expand(path):
    return expandvars(expanduser(path))


def setup_zsh(home_directory=_expand("~")):
    check_call("sudo", "apt-get", "install", "zsh", "-y", "--force-yes")
    zsh_home = path_join(home_directory, ".zsh")
    try:
        makedirs(zsh_home)
    except FileExistsError:
        pass

    zshrc_path = path_join(DOTFILES_PATH, "zsh", "zshrc")
    zshrc_target = path_join(home_directory, ".zshrc")
    copy(zshrc_path, zshrc_target)
    # XXX: Copy all zsh files to .zsh/filename
    # XXX: Install zsh as default shell


def setup_vim(home_directory=_expand("~")):
    check_call("sudo", "apt-get", "install", "vim-gnome", "-y", "--force-yes")
    vim_home = path_join(home_directory, ".vim")
    try:
        makedirs(vim_home)
    except FileExistsError:
        pass
    vimrc_path = path_join(DOTFILES_PATH, "vim", "vimrc")
    vimrc_target = path_join(home_directory, ".vimrc")
    logging.info("Copying vimrc to '{}'".format(vimrc_target))
    copy(vimrc_path, vimrc_target)
    logging.debug("Done.")

    bundle_home = path_join(vim_home, "bundle")
    logging.debug("Installing vundle to '{}'".format(bundle_home))
    try:
        makedirs(bundle_home)
    except FileExistsError:
        pass
    logging.debug("Cloning vundle..")
    check_call(("git", "clone", "BUNDLEURL", bundle_home))
    logging.debug("Done.")

    logging.info("Installing vim plugins with Vundle.")
    check_call(("vim", "-c", "PluginInstall"))
    logging.debug("Done.")
    logging.info("Vim installed.")


def setup():
    raise NotImplementedError()


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()
    full_parser = subparsers.add_parser("full")
    full_parser.set_defaults(fun=lambda args: setup("full", args=args))

    # TODO: Add additional modes of installation

    args = parser.parse_args()
    args.fun(args)


if __name__ == "__main__":
    main()
