#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx




# golang
# Go environment variables
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Odin
# export PATH="$HOME/Odin:$PATH"
# export ODIN_ROOT="$HOME/Odin"

# . "$HOME/.local/bin/env"


alias ec="emacsclient -nw -c"
export EDITOR="emacsclient -nw -t"
export CODEEDITOR="emacsclient -nw -c -a 'emacs'"
export VISUAL="emacsclient -nw -c -a 'emacs'"
export SUDO_EDITOR="emacsclient -nw -t"
