#!/bin/bash

echo -n "Last system update: "; \
grep 'starting full system upgrade' /var/log/pacman.log | tail -n 1 | tr -d []'[:alpha:]'; \
echo; \
echo "Available updates:"; \
/usr/bin/checkupdates
