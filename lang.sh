#!/usr/bin/bash

# in dir
cd "$(realpath "$(dirname "$0")")" || exit 1

# make sure you install.sh first (at least once)
# make a new locale file based on $LANG and msginit

# enter virtual environment
. ./bin/activate || (
	echo "Error! No VENV."
	exit 1
)

# env vars
FILE=$(sed -nr "s/^(.*)\..*\$/\1/p" <<<"$LANG")
# old format no .charset
FILE_OLD=$(sed -nr "s/^([^.]*)\$/\1/p" <<<"$LANG")
# just one or the other
FILE="$FILE$FILE_OLD"

# msginit
if [ ! -f "locale/$FILE.po" ]; then
	msginit -i "locale/messages.pot" -o "locale/$FILE.po"
fi
msgmerge -U "locale/$FILE.po" "locale/messages.pot"
