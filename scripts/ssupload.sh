#!/bin/bash

screenshot_dir="/mnt/storagetoshiba/images/"
filename_format='%Y-%m-%d-%H%M%S_$wx$h'
file_extension=".png"
image_host="uguu.se"

notification="dzen2"
notification_args=(-w 400 -h 50 -x 20 -y 20 -fg '#282828' -bg '#ff99cc' -fn '-*-dejavu sans-medium-r-normal--13-*-*-*-*-*-iso10646-1' -p 3)

sleep 1 # required to fix scrot -s issue that breaks keybinds

file="$(scrot -s "${screenshot_dir}${filename_format}${file_extension}" -e 'echo -n $f')"

if [[ $image_host == "pomf.se" ]]; then
    base="$(curl -sf -F files[]=@"$file" http://pomf.se/upload.php | grep -Eo "\"url\":\"[A-Za-z0-9]+${file_extension}\"," | sed 's/"url":"//;s/",//')"

    url="http://a.pomf.se/$base"
elif [[ $image_host == "uguu.se" ]]; then
    base="$(curl -sf -F randomname=xxxxxx -F file=@"$file" http://uguu.se/api.php?d=upload-tool)"

    url="$base"
fi

if [[ -z "$base" ]]; then
    if [[ $notification == "dzen2" ]]; then
        echo "Error uploading image." | dzen2 "${notification_args[@]}"
    else
        echo "Error uploading image."
    fi

    exit 1
fi

echo -n "$url" | xclip

if [[ $notification == "dzen2" ]]; then
    echo "$url copied to clipboard." | dzen2 "${notification_args[@]}"
else
    echo "$url copied to clipboard."
fi
