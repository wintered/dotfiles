
# Unix Commands                                         {{{

#  Python {{{ # 

#  BPython {{{ # 

alias b="bpython"
alias b3="bpython3"

#  }}} BPython # 

alias python3.6="$HOME/.pyenv/versions/3.6.0/bin/python3.6"
alias b3.6="python3.6 $HOME/.pyenv/versions/3.6.0/lib/python3.6/site-packages/bpython/cli.py"
alias pip3.6="$HOME/.pyenv/versions/3.6.0/bin/pip3.6"

# python shortcuts
alias p="python"
alias p3="python3"

alias upgrade-pips="sudo pip install --upgrade pip; sudo pip3 install --upgrade pip"

#  }}} Python # 

alias print_tf="python3 $HOME/freiburg_tf_print/freiburg_tf_print.py"
alias eclimd="$HOME/eclipse/eclimd"

alias check_style='find . -name "*.tex" -exec check_style.py {} \;'

alias pdf_presenter_console="xset r rate && /usr/bin/pdf_presenter_console"

alias mtex="python $DOTFILES_REPOSITORY_PATH/tex_makefile.py"

# black out screen and wait for enter key press
alias blackout="sudo sh -c 'vbetool dpms off; read ans; vbetool dpms on'"

# Easily reexecute last bash command
alias .="fc -s"

# always also make parent directories, whenever necessary
alias mkdir="mkdir -p"

# locate file
alias loc="locate"

# alias to copy directories just like files
alias cp="cp -r"

# grep alias
alias grep="grep --color='always'"

# some more ls aliases
alias ls="ls --color='always'"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# reboot
alias re="sudo reboot now"

# mutt
alias mu="mutt"

# alsamixer (make darker)
alias al="alsamixer -g"

#                                                       }}}

# Filetype -> Tool mappings                             {{{

alias -s cpp='vim'
alias -s ml='vim'
alias -s pdf='z '
alias -s tex='vim'
alias -s png='sxiv'
alias -s jpg='sxiv'
alias -s JPG='sxiv'
alias -s jpeg='sxiv'

alias -g G="| grep"
alias -g L="| less"
alias -g HL="--help"
alias -g D="& disown"

#                                                       }}}


# Version Control                                       {{{

# GIT                                               {{{

alias ga="git add"
alias gstat="git status"
# XXX: Replace this with smart custom handling that parses last commit line 
# and reuses it partially to create a "meaningful" commit line without 
# any typing.
alias gi="git commit -m "interim" && git push"
alias gc="git commit && git push"
alias gu="git pull"
alias gp="git push"

#                                                   }}}


# SVN                                               {{{

alias sa="svn add"
alias si="svn commit -m 'interim'"
alias sc="svn commit"
alias su="svn up ."

#                                                   }}}

#                                                       }}}


# Archives (Extraction/Packing)                         {{{

alias pack='tar -zcvf '
alias ex=extract_archive

#                                                       }}}


# Navigation                                            {{{

alias ..='cs ..'
alias ...="cs ../.."
alias ....="cs ../../.."

# alias to quickly change to snippet creation/editing directory
alias cssn="cs $HOME/.vim/bundle/vim-snippets/UltiSnips/"
# alias to quickly change to vim swap storage (to remove swap files after 
# successful recovery)
alias cssw="cs $HOME/.vim/swaps/"

#                                                       }}}


# MAKE                                                  {{{

# alias make in parallel shortcut
alias m='make -j'
# alias make clean
alias mc='make clean'
# alias make very clean
alias mvc='make veryclean'
#                                                       }}}


#  USB (Mount/Unmount) {{{ # 

#  Mount {{{ # 

alias mount-usb='udisksctl mount -b /dev/sdb1'
alias usb-mount='mount-usb'

#  }}} Mount # 

#  Unmount {{{ # 

alias unmount-usb='cd && udisksctl unmount -b /dev/sdb1 && {cd "$OLDPWD" > /dev/null}'
alias usb-unmount='unmount-usb'

#  }}} Unmount # 

#  }}} USB (Mount/Unmount) # 


# Configuration File Editing                            {{{

alias vv="vim $HOME/.vimrc"
alias zz="vim $HOME/.zshrc && zsh"
alias ff="vim $HOME/.zsh/functions.zsh && zsh"
alias aa="vim $HOME/.zsh/aliases.zsh && zsh"
alias ii="vim $HOME/.i3/config"

#                                                       }}}

# APT-GET convenience mappings                         {{{

alias ins="sudo apt-get install -y"
alias upd="sudo apt-get update -y"
alias upg="sudo apt-get upgrade -y"
alias cache-search="sudo apt-cache search"

#                                                       }}}


# Restore broken things (danger control)                {{{
alias aaaa="xset r rate 100 80"
alias aaaaa="xset r rate 65 115"
alias aaaaaa="xset r rate 65 115"

alias fix_visudo="pkexec visudo"
#                                                       }}}


# AG Searching Customizations                           {{{
alias ag="ag --color-line-number='4;36' --color-path='4;36'"
#                                                       }}}
