# add to completions path
fpath=(~/scripts/zsh $fpath)

# set XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# set LS_COLORS
eval "$(dircolors $XDG_CONFIG_HOME/dircolors)"


# enable tab completion system
autoload -U compinit && compinit

# highlight files during tab completion and allow arrow keys
zstyle ':completion:*' menu select

# cycle backwards through tab completion using shift-tab
bindkey "${terminfo[kcbt]}" reverse-menu-complete

# tab completion is case insensitive and can start from middle of filename
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# tab completion uses same colours as LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# tab completion show dot files without specifying the dot
setopt globdots


# enable prompt colours and set prompt
autoload -U colors && colors
PROMPT="%n@%{$fg_no_bold[blue]%}%M%{$reset_color%} %1~ $ "


# do not add duplicates or commands beginning with a space to history
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


# delete from cursor to start of line (default in bash), instead of delete entire line (default in zsh)
bindkey '^U' backward-kill-line


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



# prevent ctrl-s from freezing terminal
stty -ixon

# Exporting some variables to make some stuff use .config

export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export MEDNAFEN_HOME="$XDG_CONFIG_HOME"/mednafen

export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"


## aliases ##

alias ls='LC_COLLATE="en_US.UTF-8" ls -N --human-readable --almost-all --color=auto --group-directories-first'

alias grep='grep --color=auto'

alias bc='bc -ql'

alias stor1='cd /mnt/storagetoshiba/'
alias stor2='cd /mnt/storagewd/backup/'


# aliases to use .config directory for config files

alias anki='anki -b ~/.config/anki'
alias vim='vim -u ~/.config/vim/vimrc'
alias vimdiff='vimdiff -u ~/.config/vim/vimrc'
alias weechat='weechat -d ~/.config/weechat'
alias tmsu='tmsu --database=$XDG_DATA_HOME/tmsu/wallpaperdb'
alias qmv='qmv -e "vim -u ~/.config/vim/vimrc" -f do'


# script aliases

wp() {pkill -f wallpaper-random.sh; /home/hahi/scripts/wallpaper-random.sh "$@" &!}
t() {/usr/bin/mpv "https://twitch.tv/$1" --ytdl-format=$2}
alias checkupdates='/home/hahi/scripts/updatecheck.sh'
