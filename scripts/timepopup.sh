#!/bin/bash
popup_duration="3"

for i in $(seq 1 ${popup_duration}); do \
	LC_ALL="en-US.utf8" date +"%A %Y-%m-%d %H:%M:%S %Z"; \
	LC_ALL="en-US.utf8" TZ="CET" date +"%A %Y-%m-%d %H:%M:%S %Z"; \
	TZ="Japan" date +"%Y年%-m月%-d日（%a） %H:%M:%S %Z"; \
	sleep 1; \
done \
| dzen2 -w 400 -h 50 -x 20 -y 20 -fg '#282828' -bg '#ff99cc' -fn '-*-ipapgothic-medium-r-normal--13-*-*-*-*-*-iso10646-1' -l 2 -u -sa c
