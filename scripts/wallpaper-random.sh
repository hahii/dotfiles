#!/bin/bash
#
# idk what im doing
#
#   To the extent possible under law, the author(s) have
#   dedicated all copyright and related and neighboring
#   rights to this software to the public domain worldwide.
#   This software is distributed without any warranty. 
#
#   You should have received a copy of the 
#   CC0 Public Domain Dedication along with this software.
#   If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 
#
# Might want to use the following bash/zsh function with this script
#    wp() {pkill -f wallpaper-random.sh; /home/hahi/scripts/wallpaper-random.sh "$@" &}
# and disown the process. zsh users can use &! instead for this.
# Aliases in bash/zsh cannot take parameters, so use a function.
# Note that this will background the script right away, so output
# will messily appear in the shell, but only when you first start it.
# If this is a problem, disable the informational output using the
# SHOWINFO variable below.
#
# This script requires tmsu and a recent git version of nitrogen.
# Surround in quotes when specifying multiple tmsu tags.


# immediately exit if any commands return non-zero
set -e

# wont run variable expansion if variable is unset, to make the rm in here safer
set -u

SLEEPTIME='5m'
MONITORS=2
SHOWINFO=1
TAGDB="$XDG_DATA_HOME/tmsu/wallpaperdb"

# default tags for each monitor can be set here, will be overridden by command line tag arguments
MONTAG0=""
MONTAG1=""
MONTAG2=""
MONTAG3=""

# tags that will NOT be changed by command line tag arguments 
PMONTAG0="(3840 or 2560)"
PMONTAG1="(3840 or 2560)"
PMONTAG2=""
PMONTAG3=""




# while there are still arguments remaining
while [[ "$#" > 0 ]]; do
	# idk how to cover arbitrary number of monitors within case so I specified 4 separately
	# use a variable instead of $1 directly because $1 may change before the loop ends due to shift
	key="$1"
	case $key in
		-s|--sleep)
		SLEEPTIME="$2"
		shift
		;;
		-ms|--monitors)
		MONITORS="$2"
		shift
		;;
		-m0|--monitor0)
		MONTAG0="$2"
		shift
		;;
		-m1|--monitor1)
		MONTAG1="$2"
		shift
		;;
		-m2|--monitor2)
		MONTAG2="$2"
		shift
		;;
		-m3|--monitor3)
		MONTAG3="$2"
		shift
		;;
		blank)
		# i guess nitrogen --set-color="#000000" can't be used alone? also need to suppot multi mon here.. figure something out for this feature later
		exit 0
		;;
		stop)
		echo "$(basename $0): Stopping and restoring default wallpapers."
		nitrogen --restore
		exit 0
		;;
		exit)
		echo "$(basename $0): Exiting immediately."
		exit 0
		;;
		-*)
		echo "$(basename $0): Option $key not found."
		exit 1
		;;
		*)
		MONTAG0="$1"
		;;
	esac
	# shift moves all arguments down a number, disposing of the first argument.
	# Basically, we take the first argument, check for matches in the case structure, then dispose of it by shifting here before starting the loop again so the next argument becomes the first one.
	# a second shift is used within the case structure for matches that are option switches using - or --, as those have an accompanying option value $2 that must be disposed of as well
	shift
done

# securely create a random directory in /tmp that starts with the script's basename. trap will then remove this directory automatically when the script ends as long as it terminates cleanly.
TMPINFODIR=$(mktemp -dt "$(basename $0).XXXXXXXXXX")
trap 'rm -rf "${TMPINFODIR}"' EXIT


# While we are using set -e at the start, there are limitations
# and the script will not exit if the failing command is in
# command substitution with $(), which all of the tmsu commands
# are. The nitrogen command should stop the script below but
# it improperly returns a 0 even when it fails to set a wallpaper.
# We also don't want to output any info text until we are
# sure the tags are all valid. A hack around the problem is to
# set a variable while doing the command substitution. If the 
# command fails, the variable won't be set and the non-zero error
# will close the script. This does mean we are running tmsu more
# times but it shouldn't be too slow. It should be possible to
# use these created variables throughout the rest of the script
# to speed it up, but I don't think the effort is worth it for now.

COUNTER=0
while [ $COUNTER -lt $MONITORS ]; do
	MONTAGC=MONTAG${COUNTER}
	PMONTAGC=PMONTAG${COUNTER}
	if [[ $MONTAG0 ]] && [[ ! "${!MONTAGC}" ]]; then
		MONTAGC=MONTAG0
	fi
	TAGFILELIST="$( tmsu --database=${TAGDB} files "${!PMONTAGC} ${!MONTAGC}" )"
	let COUNTER=COUNTER+1
done


# This section will output informational text ONLY WHEN FIRST STARTING
# the script if the SHOWINFO variable is set to 1. The reason for
# all of the conditionals is to form proper sentences regardless of
# the number of monitors being set. Might actually be more readable
# to not use full sentences but whatever. 
COUNTER=0
while [  $SHOWINFO -eq 1 ] && [ $COUNTER -lt $MONITORS ]; do
	if [[ $COUNTER -eq 0 ]]; then
		echo -n "Shuffling every ${SLEEPTIME} through " 
	fi
	if [[ $MONITORS -eq 2 ]] && [[ $COUNTER -eq $MONITORS-1 ]]; then
		echo -n " "
	fi
	if [[ $MONITORS -gt 1 ]] && [[ $COUNTER -eq $MONITORS-1 ]]; then
		echo -n "and "
	fi

	MONTAGC=MONTAG${COUNTER}
	PMONTAGC=PMONTAG${COUNTER}
	if [[ $MONTAG0 ]] && [[ ! "${!MONTAGC}" ]]; then
		MONTAGC=MONTAG0
	fi
	echo -n "$(tmsu --database=${TAGDB} files "${!PMONTAGC} ${!MONTAGC}" | wc -l) wallpapers tagged ${!MONTAGC}"
	
	if [[ $MONITORS -gt 1 ]]; then
		echo -n " on monitor $COUNTER"
	fi
	if [[ $MONITORS -gt 2 ]]  && [[ $COUNTER -lt $MONITORS-1 ]]; then
		echo -n ", "
	fi
	if [[ $COUNTER -eq $MONITORS-1 ]]; then
		echo "."
	fi

	let COUNTER=COUNTER+1
done



while true; do
	COUNTER=0
	while [ $COUNTER -lt $MONITORS ]; do
		# to nest variables in bash you have to do it like this in a new variable and then reference it using an exclamation point
		MONTAGC=MONTAG${COUNTER}
		PMONTAGC=PMONTAG${COUNTER}
		# for multiple monitors, montag above 0 will be empty if tags aren't specified for each monitor individually. If montag0 is not empty and the current monitor is, we can assume we want those tags used for the current monitor (useful when you don't want to specify the same tags for every monitor 1 by 1)
		# if you DO want a secondary monitor to not have any tags (meaning all wallpapers will be shown) despite the first monitor having tags, specify a space " " using -m and that montag will not be seen as empty by this check, but tmsu will still see it as no tags and list all files
		if [[ $MONTAG0 ]] && [[ ! "${!MONTAGC}" ]]; then
			MONTAGC=MONTAG0
		fi
		nitrogen --head=$COUNTER --set-zoom-fill "$(tmsu --database=${TAGDB} files "${!PMONTAGC} ${!MONTAGC}" | shuf -n1 | tee -a "${TMPINFODIR}/current_wallpaper" )"
		# note we tee the output of ls to a file in the /tmp directory so the currently used wallpaper can be checked externally
		let COUNTER=COUNTER+1
	done
	sleep ${SLEEPTIME}
done

exit 0
