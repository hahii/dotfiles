#!/bin/bash

# USE: crop_video.sh filename [map]
# if map added, you will be asked to specify the tracks to include instead of including first video and audio tracks

# NOTE: trackselect in the command must remain unquoted, or quotation marks will be addded to the command (since it has spaces) and mess it up

echo "Enter start time in [hh:]mm:ss"
read starttime

echo "Enter clip duration in [hh:]mm:ss or just seconds"
read durationtime

echo "Enter output filename (including extension)"
read outputfilename

if [ "$2" == "map" ]; then
	echo "Enter channel number to include (starting from 0)"
	read temporarytrack
	trackselect="-map 0:"$temporarytrack"" 
	while true; do
		echo "Add another channel? (y/n)"
		read temporaryanswer
		if [ "$temporaryanswer" == "y" ]; then
			echo "Enter channel number to include (starting from 0)"
			read temporarytrack
			trackselect+=" -map 0:"$temporarytrack""
		else
			break
		fi
	done
fi

ffmpeg -ss "$starttime" -i "$1" -vcodec copy -acodec copy -sn -map_chapters -1 -t "$durationtime" $trackselect /mnt/storage3t/video/"$outputfilename"
