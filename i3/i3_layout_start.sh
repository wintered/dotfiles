#! /bin/bash
xmodmap ~/.xmodmap

# Start network manager applet first, to be able to see if we have inet
nm-applet & disown 

# Check whether i net is running
wget -q --tries=10 --timeout=20 --spider http://google.com
# assert that inet runs correctly and that we are not in Telekom_ICE (they only
# want money!)
if [[ $? -eq 0 ]] && ! [ "$(iwgetid -r)" = "Telekom_ICE" ]; then
    # Start redshift-gtk in a mode that grabs the geolocation from the internet
    redshift-gtk & disown
    i3-msg 'workspace 3; exec firefox -P fun;workspace 3' & disown
    # Open a terminal on workspace 6
    i3-msg 'workspace 2; exec i3-sensible-terminal' & disown
    # Open a firefox instance with my wunderlist on workspace 3
    i3-msg 'workspace 1; exec firefox -P default;' & disown
    # run skype on startup (on fifth workspace)
    skype & disown
    i3-sensible-terminal -title 'mutt mail' -e mutt -n
else
    # run code that runs without network
    # Start redshift-gtk in "manual" mode which does not require network
    # connections to get my geolocation
    redshift-gtk -l 48.00:8.00 & disown
    # Open a terminal on workspace 4 
    i3-msg 'workspace 3; exec i3-sensible-terminal' & disown
    # Open a terminal on workspace 5 
    i3-msg 'workspace 2; exec i3-sensible-terminal' & disown
    # Open a terminal on workspace 6
    i3-msg 'workspace 1; exec i3-sensible-terminal' & disown
fi
