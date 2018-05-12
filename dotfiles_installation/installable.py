import logging
from os import makedirs, remove
from os.path import dirname, split as path_split
import shutil
from subprocess import check_call, CalledProcessError
from shutil import copy

# XXX: Use logging everywhere (logging.debug for detailed info,
# logging.info with colored output for progress.)


def color_cyan(text):
    cyan = '\033[0;36m'
    no_color = '\033[0m'
    return "{cyan}{text}{no_color}".format(cyan=cyan, text=text, no_color=no_color)


def color_red(text):
    red = '\033[0;36m'
    no_color = '\033[0m'
    return "{red}{text}{no_color}".format(red=red, text=text, no_color=no_color)


def log_info(text, dryrun):
    if not dryrun:
        logging.info(color_cyan(text))


def log_error(text):
    logging.error(color_red(text))


def execute_command(command, dryrun):
    if isinstance(command, str):
        command_str = command
    else:
        command_str = " ".join(command)

    if dryrun:
        print(command_str)
    else:
        try:
            check_call(command, shell=True)
        except CalledProcessError as e:
            log_error(
                "ERROR -- Command failed: '{}'\n"
                "Error was: {}".format(command_str, str(e))
            )


def get_filename(path):
    *_, filename = path_split(path)
    return filename


def apt_install(package, dryrun):
    execute_command(
        ("sudo", "apt-get", "install", package, "-y", "--force-yes"),
        dryrun
    )


def apt_uninstall(package, dryrun):
    execute_command(
        ("sudo", "apt-get", "purge", package, "-y", "--force-yes"),
        dryrun
    )


def git_clone(url, target_location, dryrun):
    if dryrun:
        print("mkdirs", "-p", dirname(target_location))
    else:
        try:
            makedirs(dirname(target_location))
        except FileExistsError:
            pass
    execute_command(("git", "clone", url, target_location), dryrun)


class Installable(object):
    def __init__(self,
                 name,
                 description=None,
                 pre_commands=None,
                 apt_packages=None,
                 configuration_installation=None,
                 git_clones=None,
                 post_commands=None,):
        self.name = name
        self.description = description if description is not None else ""
        self.apt_packages = apt_packages if apt_packages is not None else []

        self.pre_commands = pre_commands if pre_commands is not None else []

        if configuration_installation is not None:
            self.configuration_installation = configuration_installation
        else:
            self.configuration_installation = []

        self.git_clones = git_clones if git_clones is not None else {}
        self.post_commands = post_commands if post_commands is not None else []

    def install(self, dryrun):
        log_info("Installing {}...".format(self.name), dryrun)

        for command in self.pre_commands:
            execute_command(command, dryrun)

        for package in self.apt_packages:
            apt_install(package, dryrun=dryrun)

        for configuration_location, configuration_target in self.configuration_installation:
            if dryrun:
                print("mkdir", "-p", dirname(configuration_target))
            else:
                try:
                    makedirs(dirname(configuration_target))
                except FileExistsError:
                    pass

            if dryrun:
                print("cp", configuration_location, configuration_target)
            else:
                copy(configuration_location, configuration_target)

        for repository_url, target_location in self.git_clones.items():
            git_clone(repository_url, target_location=target_location, dryrun=dryrun)

        for command in self.post_commands:
            execute_command(command, dryrun)

        log_info("Done.", dryrun)

    def uninstall(self, dryrun):
        log_info("Uninstalling {}...".format(self.name), dryrun)
        for package in self.apt_packages:
            apt_uninstall(package, dryrun=dryrun)

        for _, configuration_target in self.configuration_installation:
            if dryrun:
                print("rm", configuration_target)
            else:
                remove(configuration_target)

        for _, target_location in self.git_clones.items():
            if dryrun:
                print("rm", "-rf", target_location)
            else:
                shutil.rmtree(target_location, ignore_errors=True)

        log_info("Done.", dryrun)
