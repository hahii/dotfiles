#!/bin/bash

# THIS DOES NOT SANITIZE USER INPUT

# USE: crop_video.sh filename [map]
# if map added, you will be asked to specify the tracks to include instead of including first video and audio tracks

# NOTE: TRACKSELECT in the command must remain unquoted, or quotation marks will be addded to the command (since it has spaces) and mess it up

echo "Enter start time in hh:mm:ss"
read STARTTIME

echo "Enter clip duration in hh:mm:ss"
read DURATIONTIME

echo "Enter output filename (including extension)"
read OUTPUTFILENAME

if [ "$2" == "map" ]; then
	echo "Enter channel number to include (starting from 0)"
	read TEMPORARYTRACK
	TRACKSELECT="-map 0:"$TEMPORARYTRACK"" 
	while true; do
		echo "Add another channel? (y/n)"
		read TEMPORARYANSWER
		if [ "$TEMPORARYANSWER" == "y" ]; then
			echo "Enter channel number to include (starting from 0)"
			read TEMPORARYTRACK
			TRACKSELECT+=" -map 0:"$TEMPORARYTRACK""
		else
			break
		fi
	done
fi

ffmpeg -ss "$STARTTIME" -i "$1" -vcodec copy -acodec copy -to "$DURATIONTIME" $TRACKSELECT "$OUTPUTFILENAME"
