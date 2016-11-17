#!/bin/bash

# pass image files with res in the filename like 1920x1080 and it will notify you if different from actual res
# example: check_image_res.sh /wherever/you/want/*/*

for file in "$@"; do
	realres="$(identify -format '%wx%h' "$file")"
	nameres="$(echo "$file" | grep -E -o '[0-9]{4}x[0-9]{4}')"
	if [ ! "$realres" = "$nameres" ]; then
		echo ""$file": filename ("$nameres") does not match resolution ("$realres")"
	fi
done
