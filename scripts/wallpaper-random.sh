#!/bin/bash

WALLPAPERDIR="/mnt/storagetoshiba/images/art/wallpapers/"

while true; do
	nitrogen --head=0 --set-zoom-fill "$(ls ${WALLPAPERDIR}*/* | shuf -n1)"
	nitrogen --head=1 --set-zoom-fill "$(ls ${WALLPAPERDIR}*/* | shuf -n1)"

	sleep 5m
done
