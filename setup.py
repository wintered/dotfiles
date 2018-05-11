#!/usr/bin/python3
# -*- coding: iso-8859-15 -*-
import argparse
import logging
from glob import glob
from subprocess import check_call
import os
from os import makedirs
from os.path import abspath, dirname, expanduser, expandvars, join as path_join
from shutil import copy


DOTFILES_PATH = path_join(dirname(abspath(__file__)))


def filename(path):
    *_, name = os.path.split(path)
    return name


def apt_install(package_name, extra_args=("-y", "--force-yes")):
    check_call(("sudo", "apt-get", "install", package_name, *extra_args))


def _expand(path):
    return expandvars(expanduser(path))


def setup_archive_tools():
    apt_install("unrar")
    apt_install("unzip")


def setup_zathura(home_directory=_expand("~")):
    logging.info("Installing zathura pdf viewer..")
    apt_install("zathura")

    zathura_home = path_join(home_directory, ".config", "zathura")
    try:
        makedirs(zathura_home)
    except FileExistsError:
        pass

    zathurarc_path = path_join(DOTFILES_PATH, "zathura", "zathurarc")
    zathurarc_target = path_join(zathura_home, "zathurarc")
    logging.info("Copying zathurarc to '{}'".format(zathurarc_target))
    copy(zathurarc_path, zathurarc_target)


def setup_git():
    apt_install("git")


def setup_svn():
    apt_install("subversion")


def setup_silversearcher_ag():
    apt_install("silversearcher-ag")


def setup_scrot():
    apt_install("scrot")


def setup_sxiv():
    apt_install("sxiv")


def setup_latex():
    raise NotImplementedError


def setup_anki():
    raise NotImplementedError


def setup_python(home_directory=_expand("~")):
    raise NotImplementedError


def setup_i3wm(home_directory=_expand("~")):
    raise NotImplementedError


def setup_xstart_and_keymap():
    raise NotImplementedError


def setup_mutt():
    raise NotImplementedError


def setup_cmake():
    apt_install("build-essential")
    apt_install("cmake")


def setup_zsh(home_directory=_expand("~")):
    apt_install("zsh")
    zsh_home = path_join(home_directory, ".zsh")
    try:
        makedirs(zsh_home)
    except FileExistsError:
        pass

    zsh_directory = path_join(DOTFILES_PATH, "zsh")

    zshrc_path = path_join(zsh_directory, "zshrc")
    zshrc_target = path_join(home_directory, ".zshrc")
    logging.info("Copying zshrc to '{}'".format(zshrc_target))
    copy(zshrc_path, zshrc_target)

    for zsh_filepath in glob("{}/*.zsh".format(zsh_directory)):
        zsh_filename = filename(zsh_filepath)
        file_target = path_join(zsh_home, zsh_filename)
        logging.info("Copying '{}' to '{}'.".format(zsh_filename, file_target))
        copy(zsh_filepath, file_target)

    # XXX: Install antigen?

    logging.info("Installing zsh as default shell.")
    check_call(("sudo", "usermod", "-s", "/bin/zsh", os.getenv("USER")))

    logging.info("Installing fortune cookies.")
    apt_install("fortunes")
    apt_install("fortune-mod")


def setup_vim(home_directory=_expand("~")):
    apt_install("vim-gnome")
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
    check_call(("git", "clone", "https://github.com/VundleVim/Vundle.vim.git", bundle_home))
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
