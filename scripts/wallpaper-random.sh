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
# showinfo variable below.
#
# This script requires tmsu and a recent git version of nitrogen.
# Surround in quotes when specifying multiple tmsu tags.


# immediately exit if any commands return non-zero
set -e

# wont run variable expansion if variable is unset, to make the rm in here safer
set -u

sleeptime='5m'
monitors=2
showinfo=1
tagdb="$XDG_DATA_HOME/tmsu/wallpaperdb"

# default tags for each monitor can be set here, will be overridden by command line tag arguments
montag0=""
montag1=""
montag2=""
montag3=""

# tags that will NOT be changed by command line tag arguments 
pmontag0="(3840 or 2560)"
pmontag1="(3840 or 2560)"
pmontag2=""
pmontag3=""




# while there are still arguments remaining
while [[ "$#" > 0 ]]; do
	# idk how to cover arbitrary number of monitors within case so I specified 4 separately
	# use a variable instead of $1 directly because $1 may change before the loop ends due to shift
	key="$1"
	case $key in
		-s|--sleep)
		sleeptime="$2"
		shift
		;;
		-ms|--monitors)
		monitors="$2"
		shift
		;;
		-m0|--monitor0)
		montag0="$2"
		shift
		;;
		-m1|--monitor1)
		montag1="$2"
		shift
		;;
		-m2|--monitor2)
		montag2="$2"
		shift
		;;
		-m3|--monitor3)
		montag3="$2"
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
		montag0="$1"
		;;
	esac
	# shift moves all arguments down a number, disposing of the first argument.
	# Basically, we take the first argument, check for matches in the case structure, then dispose of it by shifting here before starting the loop again so the next argument becomes the first one.
	# a second shift is used within the case structure for matches that are option switches using - or --, as those have an accompanying option value $2 that must be disposed of as well
	shift
done

# securely create a random directory in /tmp that starts with the script's basename. trap will then remove this directory automatically when the script ends as long as it terminates cleanly.
tmpinfodir=$(mktemp -dt "$(basename $0).XXXXXXXXXX")
trap 'rm -rf "${tmpinfodir}"' EXIT


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

counter=0
while [ $counter -lt $monitors ]; do
	montagc=montag${counter}
	pmontagc=pmontag${counter}
	if [[ $montag0 ]] && [[ ! "${!montagc}" ]]; then
		montagc=montag0
	fi
	tagfilelist="$( tmsu --database=${tagdb} files "${!pmontagc} ${!montagc}" )"
	let counter=counter+1
done


# This section will output informational text ONLY WHEN FIRST STARTING
# the script if the showinfo variable is set to 1. The reason for
# all of the conditionals is to form proper sentences regardless of
# the number of monitors being set. Might actually be more readable
# to not use full sentences but whatever. 
counter=0
while [  $showinfo -eq 1 ] && [ $counter -lt $monitors ]; do
	if [[ $counter -eq 0 ]]; then
		echo -n "Shuffling every ${sleeptime} through " 
	fi
	if [[ $monitors -eq 2 ]] && [[ $counter -eq $monitors-1 ]]; then
		echo -n " "
	fi
	if [[ $monitors -gt 1 ]] && [[ $counter -eq $monitors-1 ]]; then
		echo -n "and "
	fi

	montagc=montag${counter}
	pmontagc=pmontag${counter}
	if [[ $montag0 ]] && [[ ! "${!montagc}" ]]; then
		montagc=montag0
	fi
	echo -n "$(tmsu --database=${tagdb} files "${!pmontagc} ${!montagc}" | wc -l) wallpapers tagged ${!montagc}"
	
	if [[ $monitors -gt 1 ]]; then
		echo -n " on monitor $counter"
	fi
	if [[ $monitors -gt 2 ]]  && [[ $counter -lt $monitors-1 ]]; then
		echo -n ", "
	fi
	if [[ $counter -eq $monitors-1 ]]; then
		echo "."
	fi

	let counter=counter+1
done



while true; do
	counter=0
	while [ $counter -lt $monitors ]; do
		# to nest variables in bash you have to do it like this in a new variable and then reference it using an exclamation point
		montagc=montag${counter}
		pmontagc=pmontag${counter}
		# for multiple monitors, montag above 0 will be empty if tags aren't specified for each monitor individually. If montag0 is not empty and the current monitor is, we can assume we want those tags used for the current monitor (useful when you don't want to specify the same tags for every monitor 1 by 1)
		# if you DO want a secondary monitor to not have any tags (meaning all wallpapers will be shown) despite the first monitor having tags, specify a space " " using -m and that montag will not be seen as empty by this check, but tmsu will still see it as no tags and list all files
		if [[ $montag0 ]] && [[ ! "${!montagc}" ]]; then
			montagc=montag0
		fi
		nitrogen --head=$counter --set-zoom-fill "$(tmsu --database=${tagdb} files "${!pmontagc} ${!montagc}" | shuf -n1 | tee -a "${tmpinfodir}/current_wallpaper" )"
		# note we tee the output of ls to a file in the /tmp directory so the currently used wallpaper can be checked externally
		let counter=counter+1
	done
	sleep ${sleeptime}
done

exit 0
