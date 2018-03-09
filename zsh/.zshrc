#
[[ $- != *i* ]] && return

export PATH=$HOME/bin:$PATH
export EDITOR='vim'

setopt AUTO_CD # No cd needed to change directories
setopt BANG_HIST # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY # Share history between all sessions.

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
alias mirrors='sudo reflector --score 100 --fastest 25 --sort rate --save /etc/pacman.d/mirrorlist --verbose'

neofetch

