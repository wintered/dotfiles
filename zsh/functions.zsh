# add to visudo                    {{{
visudo_add() {
    cmdname=`whereis -b "$@" | awk {'print $2'}`
    echo "ALL ALL = NOPASSWD:$cmdname" | sudo tee "$1"
}
#                                               }}}


# insert full pdf2 into pdf1                    {{{
insert_pdf_at_page() {
    if [ "$#" -lt 3 ]
    then
        echo "USAGE: insert_pdf_at_page BIG.pdf TOINSERT.pdf AT_PAGE [OUTFILE.pdf]"
    else
        if [ "$4" ]
        then
            output="$4"
        else
            output="output_merged.pdf"
        fi
        big_pdf="$1"
        small_pdf="$2"
        breakpoint=$(expr "$3" - 1)
        pdftk A="$1" B="$2" cat A1-"$breakpoint" B A"${3}"-end output "$output"
        echo "Wrote merged pdf to file '$output'."
    fi
}

#                                               }}}


# kill process by grepping for regex            {{{
killgrep () {
    python "$DOTFILES_REPOSITORY_PATH/killgrep/killgrep.py" "$@"
}
#                                               }}}


# grep in manpage for regex                     {{{
mangrep () {
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


# mp4 --> mp3                                   {{{
mp4tomp3() {
    ffmpeg -i "$1" -vn \
        -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 "$2"
}



#                                               }}}


# build + install a new program (with configure arguments) {{{
# XXX Once my "builder" tool is sophisticated enough, it should supersede 
# this function in functionality; switch to using it instead then
build() {
    ./configure "$@" && make -j && sudo make -j install
}

#                                               }}}


# Fix broken zsh history file                   {{{
fix_zsh_history() {
    mv "$HOME/.zsh_history" "$HOME/.zsh_history_bad"
    strings "$HOME/.zsh_history_bad" > "$HOME/.zsh_history"
    fc -R "$HOME/.zsh_history"
}
#                                               }}}


# PI: Fast directory switching                  {{{

# Fast access to directories => replace csd,css,etc in the long run
# TODO: Generate/Allow/enable autocompletion for this pi command
function pi() { 
    cmd=$(grep $1 ~/.pi | head -1)
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
    if [[ $# -lt 2 ]]; then
        echo "usage: $(basename $0) FILES TARGET"
        exit 1
    fi

    target_regexp="${@: -1}"
    target_location=$(grep "$target_regexp" ~/.pi | head -1)

    index=$(expr $# - 1)
    files="${@:1:$index}"

    if [ -z "$target_location" ]; then
        echo "$target_regexp is not stored as pi-accessible directory yet!"
        exit 1
    else
        mv "$files" "$target_location"
    fi
}

#                                               }}}


# Spawn Fortune Cookie                          {{{
 
small_fortune() { 
    string=""
    size=10000
    while [[ "$size" -ge 100 || $string != *"--"* ]]; do
        string=$(fortune people wisdom literature work)
        size=${#string}
    done
    echo "$string"
}

#                                               }}}


# Extract any archive                           {{{
 
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

#                                               }}}


# Open program and close spawning terminal      {{{

# firefox web browser
f () {
   if  (($# >= 2)); then
        # If we have more than 2 arguments, some options were specified. 
        # Run firefox normally.
        exec /usr/bin/firefox "$@" & disown
    else
        PPPID=$$
        if [ "$1" ]; then
            # Exactly one argument! We were called with some url
            # => just open it and kill my nasty terminal.
            exec /usr/bin/firefox "$1" & disown
        else
            # No arguments => open empty instance
            exec /usr/bin/firefox & disown
        fi
        kill -s SIGKILL $PPPID
    fi
}
# vim
v () {
    random_string=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    /usr/bin/vim -p --servername "$random_string" "$@"
}
#                                               }}}


# zathura pdf viewer  {{{
z () {
    # the {...} stuff is for autocompletion...
    command zathura ${*:-*.pdf(om[1])} & disown
}

#                                               }}}


# Smart shutdown                                {{{

function sd() {
    # no argument = now
    if [ -z "$1" ]; then
        sudo shutdown -P now
    else
        # argument = treated as minutes
        sudo shutdown -P "$1"
    fi
}

#                                               }}}


#  Smart reboot {{{ # 
function re() {
    # no argument = now
    if [ -z "$1" ]; then
        sudo shutdown --reboot now
    else
        # argument = treated as minutes
        sudo shutdown --reboot "$1"
    fi
}
#  }}} Smart reboot # 


#  Make directory and move into it at the same time {{{ # 

function mkd() {
    mkdir -p "$@" && cd "$_"
}

#  }}} Make directory and move into it at the same time # 


#  Pack+Pipe file to ssh server {{{ # 

# pipe a given file (first argument) to a ssh server.
# example usage: pipe_ssh "test.txt" "ssh test@test.testtest.com"
function pipe_ssh() {
   if [[ $# -eq 0 ]]; then 
       echo "USAGE: pipe_ssh FILENAME ssh test@test.testtest.com"
   else
       tar zcf - "$1" | "${@:2}" 'tar zxf -'
   fi
}

#  }}} Pack+Pipe file to ssh server # 


#  Most Frequently Used Commands {{{ # 
most_used_commands() {
    if [[ "$1" = "--help" || "$1" = "-h" ]]; then
        echo "USAGE: most_used_commands [NUMBER_OF_COMMANDS=10]"
    else
        no="10"
        if [ "$1" ]; then
            no="$1"
        fi
        cat "$HOME/.zsh_history" | awk '{CMD[$1]++;count++;}END { for (a in CMD)print CMD[a]" "CMD[a]/count*100 "% "a;}' | grep -v ",/" | column -c3 -s " " -t | sort -nr | nl | head -n$no
    fi
}
#  }}} Most Frequently Used Commands # 
