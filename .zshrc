typeset -U path
# add to command path
path=(~/scripts $path)
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

# case-insensitive tab completion: first try the term from anywhere in the phrase (bird can complete to Blue_Bird), then try each letter after separators (a.b.c can complete to aqua.blue.cfg), then try finding the letters individually anywhere in the phrase as long as they're in order (abc can complete to far_obstacle)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*' 'm:{a-zA-Z}={A-Za-z} r:|[._-]=** r:|=*' 'm:{a-zA-Z}={A-Za-z} r:|?=**'

# separate tab completion styles for files (anywhere in name) and commands (only start of name). However, you cannot use matcher-list in conjunction with this as it overrides all other matchers globally, so only a single matcher type is possible for each. Not worth it for me but I'll leave it here anyway
#zstyle ':completion:*' matcher 'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'
#zstyle ':completion:*:*:-command-:*' matcher 'm:{a-zA-Z}={A-Za-z}'

# ignore completion functions when tab completing commands
zstyle ':completion:*:functions' ignored-patterns '_*'

# tab completion uses same colours as LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# improved kill completion to show user processes only
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# tab completion show dot files without specifying the dot
setopt globdots

# short form recursive globbing, for example **.txt instead of **/*.txt
setopt globstarshort

# do not change niceness of background processes
unsetopt BG_NICE

# enable prompt colours and set prompt
autoload -U colors && colors
setopt PROMPT_SUBST
#PROMPT="%{$fg_no_bold[blue]%}%~%{$reset_color%} $ "

# the output of pwd is modified using parameter substitution to replace the contents of $HOME at the start of the string (/home/user) with ~, then fed to another nested parameter substitution /#\/mnt\/ which matches EXACTLY /mnt/ at the beginning of a string, which means it will remove it from /mnt/directory1 but NOT from /mnt itself, because the last / is missing. This is the desired behaviour, so when in /mnt/directory1 it displays directory1 and when in /mnt it still displays /mnt
# also note that because # before a pattern indicates a prefix, /home/user and /mnt/ will only be removed when the path begins with them, so for example /home/user/.cache/something/home/user will only replace the beginning, becoming ~/.cache/something/home/user
# in order to highlight the current directory within the full working directory path, the previous string is piped into grep (with colour highlighting enabled) to match everything after the last / using regex
# GREP_COLORS is the environment variable to set grep colours, ms is matching, sl is non-matching, 00;34 means non-bold colour 34, 38;5;250 means 256-colour mode colour 250
# using * instead of + in the grep regex still returns a string that ends in /, whereas + would give no match at all. The practical effect of this is that being in the root directory (/, so it ends in /) will still be displayed instead of being blank, since the output of pwd will never display a / at the end otherwise
# normally, cursor positioning would be incorrect when doing certain things due to the amount of characters in the prompt variable not matching what's actually being displayed after the commands are evaluated. To solve this, first everything encased within %{...%} isn't counted. However, this now means only the " $ ", which is 3 characters, would be seen as the length of the prompt. In order to add the correct amount of characters, "glitch" characters are added using %<number>G within the %{...%}. Because the prompt's length dynamically changes, it must generate this number based on the same commands generating the prompt, which is why the parameter substitution stuff is being repeated at the end before the G. To get the number of characters in the resulting string, another nested parameter substitution ${# } is used to count the variable length. Unlike the other parameter substitution, a # before the variable name instead of before a pattern indicates number of characters instead of prefix.
PROMPT='%{$(echo ${${PWD/#$HOME/"~"}/#\/mnt\/} | GREP_COLORS="ms=00;34:sl=38;5;250" grep --color=always "[^/]*$")%${#${${PWD/#$HOME/"~"}/#\/mnt\/}}G%} $ '


# do not add duplicates or commands beginning with a space to history
setopt hist_ignore_dups
setopt hist_ignore_space

# add time stamps to history, which can be seen using history -i
setopt extended_history

# immediately write history instead of on exit. ensures commands get written to history in the correct order when using multiple zsh instances
setopt inc_append_history

HISTFILE=$XDG_CACHE_HOME/zsh_history
HISTSIZE=10000
SAVEHIST=10000

# search through history of partially typed command using up/down key
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search


# delete from cursor to start of line (default in bash), instead of delete entire line (default in zsh)
bindkey '^U' backward-kill-line

# ctrl-z is handled directly by the terminal to suspend the process currently in the foreground, so this only applies at the zsh input
# the purpose of this is to double tap ctrl-z to quickly bg a suspended process so it continues running in the background instead of just being suspended
background-ctrl-z () {
	bg
	# required in order to show the zsh input again properly
	zle redisplay
}
# create a user-defined widget and bind it to ctrl-z
zle -N background-ctrl-z
bindkey '^Z' background-ctrl-z


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

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc-2.0
export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"
export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/aspell.en.pws; repl $XDG_CONFIG_HOME/aspell/aspell.en.prepl"

# make journalctl clear on exit, add case insensitive search
export SYSTEMD_LESS="RSMKi"

# colour support for less
export LESS="-R"

# Qt5 uses gtk2 theme
export QT_QPA_PLATFORMTHEME=gtk2

## aliases ##

alias ls='LC_COLLATE="en_US.UTF-8" ls -N --human-readable --almost-all --color=auto --group-directories-first'

alias cp='cp --preserve=timestamps'

alias grep='grep --color=auto'

alias bc='bc -ql'

alias units='units --history ""'

alias ffprobe='ffprobe -hide_banner'

alias watch='watch --no-title'

alias stor1='cd /mnt/storagetoshiba/'
alias stor2='cd /mnt/storagewd/backup/'
alias stor3='cd /mnt/storage3t/'


# aliases to use .config directory for config files

alias vim='vim -u ~/.config/vim/vimrc'
alias vimdiff='vimdiff -u ~/.config/vim/vimrc'
alias weechat='weechat -d ~/.config/weechat'
alias tmsu='tmsu --database=$XDG_DATA_HOME/tmsu/wallpaperdb'
alias qmv='qmv -e "vim -u ~/.config/vim/vimrc" -f do'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/nvidia-settings-rc'


# functions

wp() {pkill -f wallpaper-random; /home/hahi/scripts/wallpaper-random "$@" &!}
t() {/usr/bin/mpv --vo=gpu --profile=gpu-hq "https://twitch.tv/$1" --ytdl-format=$2 --screenshot-directory="/mnt/storage3t/images/snapshots/stream/" --demuxer-lavf-probe-info=yes}
rt() {until /usr/bin/mpv --vo=gpu --profile=gpu-hq "https://twitch.tv/$1" --ytdl-format=$2 --screenshot-directory="/mnt/storage3t/images/snapshots/stream/" --demuxer-lavf-probe-info=yes; do echo "Retrying in 15 seconds."; sleep 15; done}
s() {find -iname "*$@*" | sort}
g() {grep -i "$@" **}
nocom() {grep "^[^#;]" "$@" | less}
highlight() {grep --color -E -- "$1|$" "${@:2}"}
dud() {du -hd1 "$@" | sort -hr}
dua() {du -had1 "$@" | sort -hr}


# colourized man pages
# md is bold, us is underline
# me/ue are the ends of the above, so colours are reset
man() {
    LESS_TERMCAP_md=$'\e[01;33m' \
    LESS_TERMCAP_us=$'\e[01;37m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    command man "$@"
}
