#!/usr/bin/env/python
# -*- coding: iso-8859-15 -*-
import sys


def main():

    name = sys.argv[1][0].upper() + sys.argv[1][1:]

    with open("./toggle_mouse_firefox.py", 'r') as f:
        lines = f.readlines()
    new_lines = []

    exception_def = ("def some_{name}_focused(js):\n"
                     "    return is_focused(\"{0}\", js)"
                     "\n\n\n".format(name))

    for line in lines:
        if "def" in line and "main" in line:
            new_lines.append(exception_def)
            new_lines.append(line)
        elif "turn_touchpad_on" in line and "def" not in line:

            exception_call = "some_{0}_focused(out) or\n".format(name)
            new_lines.insert(-1, (12 * " ") + exception_call)
            new_lines.append(line)
        else:
            new_lines.append(line)

    with open("./toggle_mouse_firefox.py", "w") as f:
        f.writelines(new_lines)


if __name__ == "__main__":
    main()
