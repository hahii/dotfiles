#!/bin/bash

url="$(curl -sf -F randomname=xxxxxx -F file=@"$1" https://uguu.se/api.php?d=upload-tool)"

if [[ -z "$url" ]]; then
	echo "Error uploading image."
	exit 1
fi

echo -n "$url" | xclip

echo "$url copied to clipboard."
