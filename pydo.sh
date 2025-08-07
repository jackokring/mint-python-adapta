#!/usr/bin/bash
# MAYBE USEFUL FOR .desktop FILES
# SUPPLY command name to run as "venv_dir/command"
# YOU DON'T need the "/bin/"

# cd to directory containing venv
cd "$(dirname "$1")" || exit

# activate venv
. ./bin/activate

# call file as if overrides builtin, then needs following
"./bin/$(basename "$1")" || exit

# make a desktop file
cat <<EOF >"./$(basename "$1").desktop"
[Desktop Entry]
Name=$(basename "$1")
Comment=XApp Python Application
Exec="$(pwd)/pydo.sh" "$(pwd)/$(basename "$1")"
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Utility;
EOF

chmod +x "$(basename "$1").desktop"
