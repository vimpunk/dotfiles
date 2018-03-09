#
[[ $- != *i* ]] && return

export PATH=$HOME/bin:$PATH
export EDITOR='nano'
export HISTCONTROL=ignoreboth:erasedups

PS1='[\u@\h \W]\$ '

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'
alias l='ls'
alias l.="ls -A | egrep '^\.'"
alias merge='xrdb -merge ~/.Xresources'
alias pmsyu='sudo pacman -Syu --color=auto'
alias pacman='sudo pacman --color auto'
alias update='sudo pacman -Syu'
alias upmirrors='sudo reflector --score 100 --fastest 25 --sort rate --save /etc/pacman.d/mirrorlist --verbose'

shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases

neofetch

