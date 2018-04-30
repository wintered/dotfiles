#!/usr/bin/env/python
# -*- coding: iso-8859-15 -*-
"""
Small script that checks if there exists a user-installed alias
in "$HOME/.zsh/aliases.zsh" for the last command.
If so, it will remind me to use that instead of the long command I typed.

Particularly helpful to get accustomed to fresh aliases.
"""
from os.path import expanduser
import re
from sys import argv


class AliasDefinition(object):
    """ Simple class for alias definitions of the form:
            alias SHORTCUT=ALIASED_COMMAND
    """
    def __init__(self, shortcut, aliased_command):
        """ Initialize an alias definition object with fields from an
            alias definition of the form:
                alias SHORTCUT=ALIASED_COMMAND

        Parameters
        ----------
        shortcut : string
            SHORTCUT in
                alias SHORTCUT=ALIASED_COMMAND

        aliased_command : string
            ALIASED_COMMAND in
                alias SHORTCUT=ALIASED_COMMAND
        """
        self.shortcut, self.aliased_command = shortcut, aliased_command

    def __str__(self):
        alias_str = "{shortcut} => {aliased_command}".format
        return alias_str(
            shortcut=self.shortcut, aliased_command=self.aliased_command
        )

    def __len__(self):
        """ Length of an alias definition is the length of its aliased command.  """
        return len(self.aliased_command)


# Regex that matches valid alias definitions and groups shortcut
# and aliased command for easy access.
alias_definition = re.compile("alias +(?! *-s *) *(.+)=\"?([^\"]+)\"?")


def parse_aliases(filename=expanduser("~/.zsh/aliases.zsh")):
    """ Parse alias definitions from `filename` into `AliasDefinition` objects.

    Parameters
    ----------
    filename : str, optional
        Full path to filename containing alias definitions for the current user.
        Defaults to `$HOME/.zsh/aliases.zsh`

    Yields
    -------
    alias_definition: `AliasDefinition`
        Alias definitions with fields `shortcut` and `aliased_command`.

    """
    with open(filename, "r") as f:
        for line in f:
            match = re.match(alias_definition, line)
            if match:
                shortcut, aliased_command = match.group(1), match.group(2)
                yield AliasDefinition(
                    shortcut=shortcut, aliased_command=aliased_command
                )


def red(string):
    """ Use ascii escape sequences to turn `string` in red color.

    Parameters
    ----------
    string : str
        String to add red color to.

    Returns
    -------
    red_string: str
        `string` with ascii escape codes added that will make it show up as red.

    """
    return "\033[91m{}\033[0m".format(string)


def alias_for(command, alias):
    """ Check if `alias` is an alias for `command`.

    Parameters
    ----------
    command : str

    alias : AliasDefinition
        Custom wrapper for a user-defined alias with a `shortcut` and
        `aliased_command`.

    Returns
    -------
    is_alias : boolean
        `True` if and only if `alias` is an alias for `command`,
        `False` otherwise.

    """
    if "|" in command:
        # Recurse into components of the piped-command.
        return any((alias_for(subcommand, alias) for subcommand in command.split("|")))

    command_name = next(iter(command.split()))
    return command_name.startswith(alias.aliased_command)


def main():
    # Command that might have an existing alias.
    command = " ".join(argv[1:])

    # Find all aliases whose aliased command prefixes the typed command
    matching_aliases = set()
    for alias in parse_aliases(expanduser("~/.zsh/aliases.zsh")):
        if alias_for(command=command, alias=alias):
            matching_aliases.add(alias)

    if matching_aliases:
        # If any aliases matched the typed command, inform the user about
        # the longest match we found.
        alias = max(matching_aliases, key=len)
        print(red("Don't be lengthy! Use alias: {alias}".format(alias=alias)))

if __name__ == "__main__":
    main()
