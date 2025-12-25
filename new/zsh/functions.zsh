# Functions  {{{
jupyter_notebook() {
    mkdir -p $NOTEBOOKS_DIR
    ipynb_file="${NOTEBOOKS_DIR}/$(date --iso-8601=seconds).ipynb"
    cat $NOTEBOOKS_DIR/empty.ipynb > $ipynb_file
    jupyter notebook $ipynb_file &S
}

get_repeat_delay() {
    return `cat tempfile |awk '/auto repeat delay/ {print $4}'`
}

get_repeat_rate() {
    return `cat tempfile |awk '/auto repeat rate/ {print $7}'`
}

print_xset_settings() {
    repeat_delay=get_repeat_delay
    repeat_rate=get_repeat_rate  
    echo "repeat-delay = $repeat_delay"
    echo "repeat-rate = $repeat_rate"
}

# TODO: write increment functions for repeat rate and dec

# Shorthand for pdftk  
extract_pdf() {
	pdftk $2 cat $1 output $3 	
}

commitFast(){ 
	hg commit -u dominik -m "interim";
	hg push;
}

new_class() {
	touch $1.h   
	touch $1.cc 
	chmod +x $1.h 
	chmod +x $1.cc
	vim -p $1.h $1.cc 
}
new_class_cpp() {
	touch $1.h   
	touch $1.cpp 
	chmod +x $1.h 
	chmod +x $1.cpp
	vim -p $1.h $1.cpp 
}

mouse() {
	if [[ `lsmod | grep "psmouse"` ]]; then
		modprobe -r psmouse
	else
		modprobe psmouse
	fi
}

snippets() {
    cd ~/.vim/bundle/vim-snippets/UltiSnips;
    vim -p all.snippets cpp.snippets c.snippets ../snippets/c.snippets ../snippets/cpp.snippets python.snippets
}

# }}}

# add to visudo                    {{{
visudo_add() {
    cmdname=`whereis -b "$@" | awk {'print $2'}`
    echo "ALL ALL = NOPASSWD:$cmdname" | sudo tee "/etc/sudoers.d/$1"
}
## }}}

# kill process by grepping for regex            {{{
killgrep () {
    python3 "$DOTFILES_REPOSITORY_PATH/killgrep/killgrep.py" "$@"
}
#                                               }}}

# grep in manpage for regex                     {{{
mg () {
    MANARG="$1"
    shift
    man "$MANARG" | grep "$@"
}
#                                               }}}

# SXIV                                  {{{
sxiv() {
    /usr/bin/sxiv "$@" &!
}
#                                               }}}


# CS: CD + LS                                   {{{
cs() {
    if ! [ "$1" ]
    then
        cd "$HOME" && ls
    else
        var=$(expr $# - 1)
        cd "${@: -1}" && ls "${@:1:$var}"
    fi
}

cdls() { cd "$@" && ls;}

cdls2() { 
	cd "$@" && ls;
	if [[ -e .exe ]]; then
		make -j -f .exe
	fi
}

#                                               }}}


# get current weather in given city             {{{
weather() {
    if [ "$1" ] 
    then
        curl wttr.in/$1
    else
        echo "Usage: weather CITY"
        exit(1)
    fi
}
#                                               }}}


# PI: Fast directory switching                  {{{

# Fast access to directories => replace csd,css,etc in the long run
# TODO: Generate/Allow/enable autocompletion for this pi command
function pi() { 
    cmd=$(/bin/grep $1 ~/.pi | head -1)
    if [ -z "$cmd" ]; then
        echo "$1 is not stored as pi-accessible directory yet!"
    fi
    shift
    if [ "$1" ]; then
        cd "$cmd" && cs "$@"
    else
        cs "$cmd"
    fi
}
function addpi() { 
    if [ "$#" = 0 ]; then
        # no arguments => add current path
        echo "$PWD" >> ~/.pi 
    else
        while [[ $# -gt 0 ]]; do
            # arguments = for each directory given as argument, add it 
            # to .pi file for fast access
            argpath="$PWD/$1"
            if [ -d "${argpath}" ]; then
                echo "$PWD/$1" >> ~/.pi
            fi
            shift
        done
    fi
}
function mvpi() {
    cmd=$(/bin/grep $0 ~/.pi | head -1)
    if [ -z "$cmd" ]; then
        echo "$1 is not stored as pi-accessible directory yet!"
        exit 1
    else
        shift
        mv "$@" "$cmd"
    fi
}


#                                               }}}
# added from zshwiki: extract any archive
extract_archive () {
    local old_dirs current_dirs lower
    lower=${(L)1}
    old_dirs=( *(N/) )
    if [[ $lower == *.tar.gz || $lower == *.tgz ]]; then
        tar zxfv $1
    elif [[ $lower == *.gz ]]; then
        gunzip $1
    elif [[ $lower == *.tar.bz2 || $lower == *.tbz ]]; then
        bunzip2 -c $1 | tar xfv -
    elif [[ $lower == *.bz2 ]]; then
        bunzip2 $1
    elif [[ $lower == *.zip ]]; then
        unzip $1
    elif [[ $lower == *.rar ]]; then
        unrar e $1
    elif [[ $lower == *.tar ]]; then
        tar xfv $1
    elif [[ $lower == *.lha ]]; then
        lha e $1
    else
        print "Unknown archive type: $1"
        return 1
    fi
    # Change in to the newly created directory, and
    # list the directory contents, if there is one.
    current_dirs=( *(N/) )
    for i in {1..${#current_dirs}}; do
        if [[ $current_dirs[$i] != $old_dirs[$i] ]]; then
            cd $current_dirs[$i]
            ls
            break
        fi
    done
}
