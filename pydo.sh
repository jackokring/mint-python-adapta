#!/usr/bin/bash
# MAYBE USEFUL FOR .desktop FILES
# SUPPLY command name to run as "venv_dir/command"
# YOU DON'T need the "/bin/"

# cd to directory containing venv
cd "$(dirname "$1")" || exit

# activate venv
. ./bin/activate

# call file as if overrides builtin, then needs following
"./bin/$(basename "$1")"
