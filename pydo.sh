#!/usr/bin/bash

# in dir
cd "$(realpath "$(dirname "$0")")" || exit 1

# MAYBE USEFUL FOR .desktop FILES
# SUPPLY command name to run as "command"
# YOU DON'T need the "/bin/"

# filename within bin
FILE="$(which "$1")"

# enter virtual environment
. ./bin/activate

# call file as if overrides builtin, then needs following
echo "No icon test of launch ..."
"$(basename "$FILE")" || exit

# env vars
DOM=$(sed -nr "s/^domain = \"(.*)\"$/\1/p" <pyproject.toml)

# copy an Icon
# the marvels of ChatGPT and Freud
cp "./butt-mint-axe.svg" "./$DOM.$(basename "$FILE").svg"

# make a desktop file
cat <<EOF >"./$(basename "$FILE").desktop"
[Desktop Entry]
Name=$(basename "$FILE")
Comment=XApp Python Application
# Maybe it's just a PyPI module (so place inside the venv/bin)
Exec=bash -c '. "$(dirname "$FILE")/activate" && "$(basename "$FILE")"'
Icon=$DOM.$(basename "$FILE")
Terminal=true
Type=Application
Categories=Utility;
EOF

chmod +x "./$(basename "$FILE").desktop"
echo "Make .svg and .desktop ..."
# call the named command which makes make_local
"./bin/$(sed -nr "s/^(.*) = \".*:make_local\"\$/\1/p" <pyproject.toml)"

# Icon test of launch
echo "Should have application icon now ..."
"$(basename "$FILE")" || exit
