#!/usr/bin/bash
# Original: http://frexx.de/xterm-256-notes/ [dead link 2013-11-21]
#           http://frexx.de/xterm-256-notes/data/colortable16.sh [dead link 2013-11-21]
# Modified by Aaron Griffin
# and further by Kazuo Teramoto
# and further by 
FGNAMES=('  30m  ' '  31m  ' '  32m  ' '  33m  ' '  34m  ' '  35m  ' '  36m  ' '  37m  ')
FGNAMESB=('1;30m  ' '1;31m  ' '1;32m  ' '1;33m  ' '1;34m  ' '1;35m  ' '1;36m  ' '1;37m  ')
BGNAMES=('DFT' '40m' '41m' '42m' '43m' '44m' '45m' '46m' '47m')

for b in {0..8}; do
  ((b>0)) && bg=$((b+39))

  echo -en "\033[0m ${BGNAMES[b]}  "
  
  for f in {0..7}; do
    echo -en "\033[${bg}m\033[$((f+30))m ${FGNAMES[f]} "
  done
  
  echo -en "\033[0m "
  echo -en "\033[0m\n\033[0m      "
  
  for f in {0..7}; do
    echo -en "\033[${bg}m\033[1;$((f+30))m ${FGNAMESB[f]} "
  done

  echo -en "\033[0m "
  echo -e "\033[0m"

  ((b<8)) &&
  echo " "
done
