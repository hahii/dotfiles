#!/bin/bash

# pass image files with res in the filename like 1920x1080 and it will notify you if different from actual res
# example: check_image_res.sh /wherever/you/want/*/*

for file in "$@"; do
	REALRES="$(identify -format '%wx%h' "$file")"
	NAMERES="$(echo "$file" | grep -E -o '[0-9]{4}x[0-9]{4}')"
	if [ ! "$REALRES" = "$NAMERES" ]; then
		echo ""$file": filename ("$NAMERES") does not match resolution ("$REALRES")"
	fi
done
