#!/bin/bash

# This script removes the following symbols from japanese .srt files:
#	♪♪～ ♬～ ♪ ♬		(BGM)
#	☎ 			(phone ringing)
#	≪ 			(coming from off screen)
#	(( )) 《 》		(flashback)
#	＜ ＞			(narration)
#	→ ➡			(sentence continues on next subtitle line)
# It then removes anything enclosed in （） () []

# WARNING: this script overwrites the original files, so you must create backups manually beforehand

# WARNING: do not use more than once on the same files, or necessary blank lines will be removed

# NOTE: if you simply used (.*) to remove the contents of parentheses (same for [.*]), it does a "greedy" match
# a greedy match will spill over to later ) in the same line, removing characters that are not enclosed in the initial ()
# to prevent this, [^)]* is used instead of .* which means any character that is not ), so it will stop when the first ) is encountered

# NOTE: some subtitle lines in srt files would have closed captions followed by a newline with dialogue after
# after caption removal, there would be a blank line followed by dialogue. This will cause the subtitle line to be ignored by video players
# to fix this, a hack is used that APPENDS ~+~+~ to all lines following the SRT timestamp line
# this means that only the formerly blank lines will begin with ~+~+~, so we can easily identify them and remove them
# we then remove all the now unneeded ~+~+~ from the ends of valid lines
# this must also be on its own sed call for some reason or it breaks the entire thing
# the file must NOT be CRLF format for this to work, so it is converted at the start of the script using s/\r$//

for file in "$@"; do
	sed -i 's/\r$//; s/((//g; s/))//g; s/♪♪～//g; s/♬～//g; s/[♪♬☎≪＜＞《》→➡]//g; s/([^)]*)//g; s/\[[^]]*\]//g; s/（[^）]*）//g' "$file"
	sed -i '/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9] --> [0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9]$/{n;s/$/~+~+~/}; /^~+~+~/d; s/~+~+~//' "$file"
done
