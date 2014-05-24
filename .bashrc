#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Do not add commands beginning with a space to bash history

export HISTCONTROL=ignoreboth

# Exporting some variables to make some stuff use .config, ideally this would be done in .bash_profile as it only needs to be run on login but w/e

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"


export MPV_HOME="$XDG_CONFIG_HOME/mpv"
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"

export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"

PS1='\[\e[0;30m\]\u@\[\e[0;34m\]\h\[\e[0;30m\] \W \$\[\e[0m\] '


## aliases ##

alias ls='ls --color=auto'

alias stor1='cd /mnt/storagetoshiba/'
alias stor2='cd /mnt/storageseagate/'


# aliases to use .config directory for config files

alias anki='anki -b ~/.config/anki'
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/config'
alias vim='vim -u ~/.config/vim/vimrc'
alias weechat='weechat -d ~/.config/weechat'
alias mcabber='mcabber -f ~/.config/mcabber/mcabberrc'


# script aliases

alias wpstart='/home/hahi/scripts/wallpaper-random.sh &'
alias wpstop='/home/hahi/scripts/wallpaper-stop.sh'
alias winxpstart='qemu-system-i386 -enable-kvm -net none -soundhw es1370 -m 1024 -vga std -usbdevice tablet /mnt/storagetoshiba/software/image/WinXP/winxp.raw.overlay.1'
