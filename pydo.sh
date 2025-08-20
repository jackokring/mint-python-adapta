#!/usr/bin/bash
# MAYBE USEFUL FOR .desktop FILES
# SUPPLY command name to run as "command"
# YOU DON'T need the "/bin/"

# filename within bin
FILE="$(which "$1")"
FILE2="${FILE#"$HOME"/}"

# cd to directory containing venv
cd "$(dirname "$FILE")/.." || exit

# enter virtual environment
. ./bin/activate

# call file as if overrides builtin, then needs following
"$(basename "$FILE")" || exit

# env vars
DOM=$(sed -nr "s/^domain = \"(.*)\"$/\1/p" <pyproject.toml)

# copy an Icon
cp "/usr/share/icons/hicolor/scalable/apps/org.gnome.Terminal.svg" "./$DOM.$(basename "$FILE").svg"

# make a desktop file
cat <<EOF >"./$(basename "$FILE").desktop"
[Desktop Entry]
Name=$(basename "$FILE")
Comment=XApp Python Application
# Maybe it's just a PyPI module (so place inside the venv/bin)
Exec=bash -c '. "\$HOME/$(dirname "$FILE2")/activate" && "$(basename "$FILE")"'
Icon=$DOM.$(basename "$FILE")
Terminal=true
Type=Application
Categories=Utility;
EOF

chmod +x "./$(basename "$FILE").desktop"
