#!/usr/bin/bash
# MAYBE USEFUL FOR .desktop FILES
# SUPPLY command name to run as "command"
# YOU DON'T need the "/bin/"

# filename within bin
FILE="$(which "$1")"

# cd to directory containing venv
cd "$(dirname "$FILE")/.." || exit

# enter virtual environment
. ./bin/activate

# call file as if overrides builtin, then needs following
"$(basename "$FILE")" || exit

# make a desktop file
cat <<EOF >"./bin/$(basename "$FILE").desktop"
[Desktop Entry]
Name=$(basename "$FILE")
Comment=XApp Python Application
# Maybe it's just a PyPI module (so place inside the venv/bin)
Exec=bash -c '. "$(dirname "$FILE")/activate" && "$(basename "$FILE")"'
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Utility;
EOF

chmod +x "./bin/$(basename "$FILE").desktop"
