#!/usr/bin/python3
# -*- coding: iso-8859-15 -*-
from argparse import ArgumentParser
from psutil import process_iter
import re


def matching_processes(pattern):
    """ Find all processes whose command has the given `pattern`.

    Parameters
    ----------
    pattern : `_sre.SRE_Pattern`
        Find processes containing this regular expression.

    Yields
    ----------
    process: `psutil.Process`
        Matching process.

    """
    for process in process_iter():
        command = " ".join(process.cmdline())
        if re.search(pattern, command):
            yield process


def main():
    parser = ArgumentParser()
    parser.add_argument("-a", "--all", action="store_true", help="If set, *all* processes matching the given PATTERN will be killed.")
    parser.add_argument("pattern", help="Pattern to grep for.")

    args = parser.parse_args()

    matches = list(matching_processes(re.compile(args.pattern)))

    if not matches:
        raise ValueError("killgrep.py: Found no matches for pattern {}".format(args.pattern))

    unique_match = len(matches) == 1

    if not unique_match and not args.all:
        processes = [
            "\tPID: {pid} CMD: {cmd}".format(pid=process.pid, cmd=" ".join(process.cmdline()))
            for process in matches
        ]
        raise ValueError(
            "killgrep.py: option '--all' was not specified and multiple processes matched "
            "pattern '{pattern}'.\nRe-run with '--all' enabled to kill all matching processes "
            "or manually kill process id's for processes of interest as listed below:\n"
            "{processes}".format(pattern=args.pattern, processes="\n".join(processes))
        )

    for process in matches:
        process.terminate()


if __name__ == "__main__":
    main()
