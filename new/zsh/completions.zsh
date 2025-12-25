autoload -Uz compinit
compinit

zstyle ':completion:*' menu select # neede to see the select menu   
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''


zstyle ':completion:*:default' list-colors ${(s.:.)#LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


#############################################################################
##Added from zsh lovers
#############################################################################
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
## Allowed no of errors in completion of commands gets bigger with length of what 
## I have typed..
#zstyle -e ':completion:*:approximate:*' \
        #max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

## Ignore completion for commands I don't have..
zstyle ':completion:*:functions' ignored-patterns '_*'

## Do not complete *.o, *.pyc, *.cmi, *.annot, *.cmo, *.cmt for vim
zstyle ':completion:*:*:v:*:*files' ignored-patterns '*?.aux' '*?.o' '*?.pyc' '*?.cmi' '*?.annot' '*?.cmo' '*?.cmt' '*?.aux' 

zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*?.aux' '*?.log' '*?.o' '*?.pyc' '*?.cmi' '*?.annot' '*?.cmo' '*?.cmt' '*?.aux' 

## Make zatura complete pdf files first and other files later only.
zstyle ':completion:*:*:z:*:*' file-patterns '*.pdf:pdf-files' '%p:all-files'

## Make mtex (makefile for tex autogeneration) complete tex files first
zstyle ':completion:*:*:mtex:*:*' file-patterns '*.tex:tex-files' '%p:all-files'


## Ignore same filename again when "removing" or "killing", only need single
## autocompletion for this
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
setopt complete_aliases

compdef '_files -g "*.gz *.tgz *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract_archive
compdef cs=cd
compdef _ins ins="apt-get install"
compdef _upd upd="sudo apt-get update"
compdef _upg upg="sudo apt-get upgrade"
compdef _cache-search cache-search="sudo apt-cache search"
