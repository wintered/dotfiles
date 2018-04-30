#!/bin/bash

WITH_OCAML=false
WITH_FFMPEG=false
WITH_MOCP=false
WITH_ANKI=false

LOAD_ONLY=false

usage() {
    echo "Usage: $0 --help | --load-only | --full | --with-ffmpeg | --with-mocp | --with-anki | --with-ocaml"
    exit 1
}

print_cyan() {
    CYAN='\033[0;36m' # CYAN
    NC='\033[0m' # No Color
    echo "${CYAN}$@${NC}"
}

if [ "$1" = "--full" ]; then
    WITH_FFMPEG=true
    WITH_OCAML=true
    WITH_MOCP=true
    WITH_ANKI=true
    WITH_WORKRAVE=true
else
    while [ ! "$1" = "" ]; do
        if [ "$1" = "--help" ]; then
            usage
            exit 1
        elif [ "$1" = "--with-ffmpeg" ]; then
            WITH_FFMPEG=true
        elif [ "$1" = "--with-mocp" ]; then
            WITH_MOCP=true
        elif [ "$1" = "--with-ocaml" ]; then
            WITH_OCAML=true
        elif [ "$1" = "--with-workrave" ]; then
            WITH_WORKRAVE=true
        elif [ "$1" = "--with-anki" ]; then
            WITH_ANKI=true
        elif [ "$1" = "--load-only" ]; then
            LOAD_ONLY=true
        fi
        shift
    done
fi

if [[ -z "$XDG_CONFIG" ]]; then
    XDG_CONFIG="$HOME/.config"
fi

# i3-window-manager {{{ #
i3wm_(){
    print_cyan "Installing i3-wm.." 
    echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" | sudo tee -a /etc/apt/sources.list
    sudo apt-get update
    sudo apt-get --allow-unauthenticated install sur5r-keyring
    sudo apt-get update
    sudo apt-get install -y --force-yes  i3
    sudo apt-get install -y --force-yes i3-wm

    # I3-CONFIG {{{ #

    print_cyan "Configuring i3..." 
    mkdir "$HOME/.i3" &&
    cp "i3/config" "$HOME/.i3/config"
    cp "i3/i3status.conf" "$HOME/.i3/i3status.conf"
    cp "i3/i3_layout_start.sh" "$HOME/i3_layout_start.sh"

    # }}} I3-CONFIG #


}
# }}} i3-window-manager  #

# git {{{ #

git_(){
    print_cyan "Installing git.." 
    sudo apt-get install -y --force-yes git

}
# }}} git #

# CMake {{{ #

cmake_() {
    print_cyan "Installing cmake..." 
    sudo apt-get install -y --force-yes build-essential cmake
}

# }}} CMake #

# Vim {{{ #
vim_() {
    print_cyan "Installing vim-gnome.." 
    sudo apt-get install vim-gnome -y --force-yes

    # VIM CONFIG {{{ #

    print_cyan "Configuring vim..." 
    cp "vim/vimrc" "$HOME/.vimrc"

    mkdir -p "$HOME/vim/bundle"
    git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/vim/bundle/Vundle.vim"
    vim +PluginInstall

    # }}} VIM CONFIG #

}
# }}} Vim #

# ZSH {{{ #
zsh_() {
    print_cyan "Installing zsh.." 
    sudo apt-get install -y --force-yes zsh

    # ZSH-CONFIG {{{ #

    print_cyan "Configuring zsh..." 
    cp "zsh/zshrc" "$HOME/.zshrc"

    mkdir "$HOME/.zsh" &&
    cp zsh/*.zsh "$HOME/.zsh"

    # TODO: Allow multiple retries for this command (in case pw/user is wrong)
    print_cyan "Making zsh default shell..." 
    sudo usermod -s "/bin/zsh" "$USER"  # make zsh default shell

    # install antigen
    print_cyan "Installing antigen-zsh..." 
    curl "https://cdn.rawgit.com/zsh-users/antigen/v1.2.2/bin/antigen.zsh" > "$HOME/antigen.zsh"
    source "$HOME/antigen.zsh"

    # }}} ZSH-CONFIG #
}

# }}} ZSH #

# OCAML {{{ #

ocaml_() {

print_cyan "Installing OCaml (Opam, ocaml, m4, utop, etc.)..." 
sudo add-apt-repository ppa:avsm/ppa && 
sudo apt-get update &&
sudo apt-get install -y --force-yes curl build-essential m4 ocaml opam &&
opam init &&
eval `opam config env` &&
opam install core utop &&
opam install \
   async yojson core_extended core_bench \
   cohttp async_graphics cryptokit menhir
}
# }}} OCAML #

# Archive Tools {{{ #
archive_tools_() {
    sudo apt-get install unrar -y --force-yes
    sudo apt-get install unzip -y --force-yes
}

# }}} Archive Tools #

# Zathura {{{ #
zathura_() {
    print_cyan "Installing zathura pdf viewer.." 
    sudo apt-get install -y --force-yes zathura

    print_cyan "Configuring zathura pdf viewer.." 
    mkdir -p "$HOME/.config/zathura/" && cp "zathura/zathurarc" "$HOME/.config/zathura/zathurarc"
}
# }}} Zathura #

# SVN {{{ #
svn_() {
    print_cyan "Installing svn.." 
    sudo apt-get install -y --force-yes subversion
}
# }}} SVN #

# MUTT-Mail {{{ #
mutt_() {
    print_cyan "Installing mutt..." 
    sudo apt-get install -y --force-yes mutt msmtp gpgsm

    print_cyan "Configuring mutt..." 
    cp "$HOME/dotfiles/mutt/muttrc" "$HOME/.muttrc"
    mkdir -p "$HOME/.mutt" && cp "./mutt/account.google" "$HOME/.mutt/account.google"
}

# }}} MUTT-Mail #

# AG-Search {{{ #
silversearcher_ag_() {
    print_cyan "Installing silversearcher-ag..." 
    sudo apt-get install -y --force-yes silversearcher-ag

}

# }}} AG-Search #

# Python {{{ #

python_() {
    print_cyan "Installing python..." 
    sudo apt-get install --force-yes -y flake8
    sudo apt-get install -y --force-yes python-dev python3-dev python-pip python3-pip
    sudo apt-get install -y --force-yes bpython bpython3
    sudo pip install --upgrade pip
    sudo pip3 install --upgrade pip
    sudo pip install numpy
    sudo pip install scipy
    sudo pip install sklearn
    sudo pip install sympy 

    print_cyan "Configuring python..." 
    bpython_config="$XDG_CONFIG/bpython"
    echo "$bpython_config"
    mkdir -p "$bpython_config"
    cp "./bpython/config" "$bpython_config"
    cp "./bpython/foo.theme" "$bpython_config"
}

# }}} Python #


# scrot {{{ #

scrot_() {
    print_cyan "Installing scrot..." 
    sudo apt-get install --force-yes -y scrot
}

# }}} scrot #

# SXIV {{{ #
sxiv_(){
    print_cyan "Installing sxiv image viewer..." 
    sudo apt-get install -y --force-yes sxiv 
}
# }}} SXIV #

# Latex {{{ #
latex_() {
    print_cyan "Installing latex..." 
    sudo apt-get install -y --force-yes texlive texlive-lang-german texlive-latex-extra texlive-latex-base texlive-luatex texlive-xetex texlive-latex-recommended texlive-science texlive-pstricks texlive-lang-english texlive-extra-utils texlive-fonts-extra texlive-fonts-recommended texlive-fonts-utils
    sudo apt-get install -y --force-yes dvipng #  for anki
}
# }}} Latex #

# Music {{{ #
music_(){
    if [ $WITH_MOCP = true ]; then
        print_cyan "Installing mocp..." 
        sudo apt-get install -y --force-yes mocp
    fi

    # XXX Add spotify?

    # FFMPEG {{{ #

    if [ $WITH_FFMPEG = true ]; then
        print_cyan "Installing ffmpeg..." 
        sudo apt-get install nasm -y --force-yes &&
        sudo apt-get install libmp3lame-dev -y --force-yes &&
        wget "http://ffmpeg.org/releases/ffmpeg-3.1.2.tar.bz2" &&

        tar xfv "ffmpeg-3.1.2.tar.bz2" &&
        cd ffmpeg-3.1.2 && 

        ./configure --enable-decoders --enable-encoders --enable-libmp3lame &&
        make -j &&
        sudo make install
    fi

    # }}} FFMPEG #
    

}

# }}} Music #

# Anki {{{ #

anki_() {
    print_cyan "Installing anki..." 
    sudo apt-get install anki -y --force-yes
}

# }}} Anki #


base_install() {
    print_cyan "Installing google-script"
    sudo cp "./google_script/google_script.bash" "/usr/local/bin/gx"

    i3wm_
    git_
    cmake_
    vim_
    zsh_
    archive_tools_
    zathura_
    svn_

    # Fortune Cookies {{{ #

    print_cyan "Installing fortune cookies.." 
    sudo apt-get install -y --force-yes fortune-mod fortunes

    # }}} Fortune Cookies #

    mutt_
    silversearcher_ag_
    python_
    scrot_
    latex_


    # XStart and Keymap {{{ #
    print_cyan "Setting up custom keybinding for capslock"
    cp "$HOME/dotfiles/xstart_and_keymap/xinitrc" "$HOME/.xinitrc" &&
    cp "$HOME/dotfiles/xstart_and_keymap/modmap" "$HOME/.modmap"
    # }}} XStart and Keymap #

}

if [ $LOAD_ONLY = false ]; then
    base_install

    if [ $WITH_MOCP = true || $WITH_FFMPEG = true ]; then
        music_
    fi

    if [ $WITH_ANKI = true ]; then
        anki_
    fi

    if [ $WITH_OCAML = true ]; then
        ocaml_
    fi
fi
