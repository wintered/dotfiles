#!/usr/bin/env/python
# -*- coding: iso-8859-15 -*-
import json
import subprocess


def class_has_name(name, node):
    try:
        has_name = name in node["window_properties"]["class"] and node["focused"]
    except KeyError:
            return False
    else:
        return has_name


def is_focused(window_name, js):
    nodes = js["nodes"] + js["floating_nodes"]
    if any(map(lambda node: class_has_name(window_name, node), nodes)):
        return True
    else:
        return any(map(lambda js: is_focused(window_name, js), nodes))


out = json.loads(subprocess.check_output(["i3-msg", "-t", "get_tree"]))


def read_touchpad_state():
    out = subprocess.check_output(["synclient -l | grep 'TouchpadOff'"],
                                  shell=True)
    if "TouchpadOff" not in out or "=" not in out:
        raise ValueError("Well, what was that?")
    else:
        if "0" in out:
            return "on"
        elif "1" in out:
            return "off"
        else:
            raise ValueError("Well, what was that?")


def turn_touchpad_on():
    state = read_touchpad_state()
    if state == "off":
        subprocess.call(["synclient", "TouchpadOff=0"])


def turn_touchpad_off():
    state = read_touchpad_state()
    if state == "on":
        subprocess.call(["synclient", "TouchpadOff=1"])


def some_firefox_focused(js):
    return is_focused("Firefox", js) or is_focused("Vimperator", js)


def some_zathura_focused(js):
    return is_focused("zathura", js) or is_focused("Zathura", js)


def some_anki_focused(js):
    return is_focused("anki", js) or is_focused("Anki", js)


def some_skype_focused(js):
    return is_focused("skype", js) or is_focused("Skype", js)


def some_kolourpaint_focused(js):
    return is_focused("Kolourpaint", js)


def some_Mocp_focused(js):
    return is_focused("Mocp", js)


def some_tk_focused(js):
    return is_focused("Tk", js)


def some_Totem_focused(js):
    return is_focused("Totem", js)


def some_Hamster_focused(js):
    return is_focused("Hamster", js)


def some_Uppaal_focused(js):
    return is_focused("UPPAAL", js)


def main():
    while(True):
        out = json.loads(subprocess.check_output(["i3-msg", "-t", "get_tree"]))

        if (some_firefox_focused(out) or some_zathura_focused(out) or
           some_anki_focused(out) or some_skype_focused(out) or
           some_Mocp_focused(out) or
           some_Totem_focused(out) or
           some_tk_focused(out) or
           some_Hamster_focused(out) or
           some_Uppaal_focused(out) or
           some_kolourpaint_focused(out)):
            turn_touchpad_on()

        else:
            turn_touchpad_off()


if __name__ == "__main__":
    main()
