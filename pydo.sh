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
echo "No icon YET test of launch before making it ..."
echo "Click in terminal and ctrl+C if this is not the action you expect ..."
echo "Just close the application if it's the right one ..."
"$(basename "$FILE")" || exit

# env vars
DOM=$(sed -nr "s/^domain = \"(.*)\"$/\1/p" <pyproject.toml)

# copy an Icon
# the marvels of ChatGPT and Freud
cp "./$DOM.butt-mint-axe.svg" "./$DOM.$(basename "$FILE").svg"
cp "./$DOM.butt-mint-axe.svg" "./application-$DOM-$(basename "$FILE").svg"

# make a desktop file
cat <<EOF >"./$(basename "$FILE").desktop"
[Desktop Entry]
Name=$(basename "$FILE")
Comment=XApp Python Application
# Maybe it's just a PyPI module (so place inside the venv/bin)
# Do you feel lucky, punk?
# Big F for all files as args (thanx for ')
Exec=bash -c '. "$VIRTUAL_ENV/activate" && "$(basename "$FILE")" %F'
Icon=$DOM.$(basename "$FILE")
# If you don't need debug terminal
Terminal=true
Type=Application
Categories=Utility
# And the mimetype
MimeType=application/$DOM-$(basename "$FILE")
EOF

# make a mimetype for project opening
cat <<EOF >"./$DOM-$(basename "$FILE").xml"
<?xml version="1.0"?>
<mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
  <mime-type type="application/$DOM-$(basename "$FILE")">
    <comment>$(basename "$FILE") file</comment>
    <glob pattern="*.$(basename "$FILE")"/>
  </mime-type>
</mime-info>
EOF

chmod +x "./$(basename "$FILE").desktop"
echo "Make .svg and .desktop, and mime-type ..."
# call the named command which makes make_local
echo "rebuild ..."
./build.sh

# Icon test of launch
echo "Should have application icon now ..."
"$(basename "$FILE")" || exit
