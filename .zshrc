# add to completions path
fpath+=( ~/scripts/zsh )

# enable tab completion system
autoload -U compinit && compinit

# highlight files during tab completion and allow arrow keys
zstyle ':completion:*' menu select

# cycle backwards through tab completion using shift-tab
bindkey "${terminfo[kcbt]}" reverse-menu-complete

# tab completion is case insensitive and can start from middle of filename
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


# enable prompt colours and set prompt
autoload -U colors && colors
PROMPT="%n@%{$fg_no_bold[blue]%}%M%{$reset_color%} %1~ $ "


# Do not add duplicates or commands beginning with a space to history
setopt hist_ignore_dups
setopt hist_ignore_space

# add time stamps to history, which can be seen using history -i
setopt extended_history

HISTFILE=$XDG_CACHE_HOME/zsh_history
HISTSIZE=10000
SAVEHIST=10000

# search through history of partially typed command using up/down key
bindkey "${terminfo[kcuu1]}" up-line-or-search
bindkey "${terminfo[kcud1]}" down-line-or-search



# improved kill completion to show user processes only
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"


# enable syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# incorrect command
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
# various types of fully typed commands
ZSH_HIGHLIGHT_STYLES[command]='none'
ZSH_HIGHLIGHT_STYLES[builtin]='none'
ZSH_HIGHLIGHT_STYLES[alias]='none'
# partially typed command
ZSH_HIGHLIGHT_STYLES[path_approx]='none'
# fully typed path or filename
ZSH_HIGHLIGHT_STYLES[path]='none'
# partially typed path or filename
ZSH_HIGHLIGHT_STYLES[path_prefix]='none'
# && ; | 
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta,bold'
# options/arguments
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=white,bold'



# Exporting some variables to make some stuff use .config

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"


export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"


## aliases ##

alias ls='ls --color=auto'

alias stor1='cd /mnt/storagetoshiba/'
alias stor2='cd /mnt/storageseagate/'


# aliases to use .config directory for config files

alias anki='anki -b ~/.config/anki'
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/config'
alias vim='vim -u ~/.config/vim/vimrc'
alias weechat='weechat -d ~/.config/weechat'
alias tmsu='tmsu --database=$XDG_DATA_HOME/tmsu/wallpaperdb'


# script aliases

wp() {pkill -f wallpaper-random.sh; /home/hahi/scripts/wallpaper-random.sh "$@" &!}
alias checkupdates='/home/hahi/scripts/updatecheck.sh'
alias wpstop='/home/hahi/scripts/wallpaper-stop.sh'
alias winxpstart='QEMU_AUDIO_DRV=alsa qemu-system-i386 -enable-kvm -cpu host -net none -soundhw es1370 -m 1024 -vga std -usbdevice tablet /mnt/storagetoshiba/software/image/WinXP/winxp.raw.overlay.1'
