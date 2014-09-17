#set monitor positions
xrandr --output DVI-D-0 --auto --output DVI-I-0 --auto --right-of DVI-D-0

#read Xresources file, first part makes sure file exists first
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

#set wallpaper
nitrogen --restore &

#Japanese input
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS='@im=uim'

#Disable Display Power Management Signaling and Xscreensaver
xset -dpms
xset s off

#typematic (keyboard repeat/delay) settings, ms delay, Hz speed
xset r rate 250 25

#this is required to fix cursor for bspwm, not sure why it isn't needed with dwm
xsetroot -cursor_name left_ptr &

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd

#start bspwm
sxhkd &
exec bspwm
