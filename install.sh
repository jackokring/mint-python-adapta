#!/usr/bin/bash

# in dir
cd "$(realpath "$(dirname "$0")")" || exit 1

# version
VER=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')
NAME=$(sed -nr "s/^name = \"(.*)\"$/\1/p" <pyproject.toml)

# ivalidate older
rm -rf bin include lib "$NAME/applications" "$NAME/icons" "$NAME/locale"
echo "Clean ..."

# virtual environment
python3 -m venv .
echo "VENV ..."

# set virtual environment
. ./bin/activate

# add libadapta-1 and gum TUI tool for nicer scripts
sudo dpkg -i ./*.deb

# apt installs might be necessary
sudo apt install -y libadwaita-* libadwaita-*-dev gir1.2-adw-* python3-gi

# international
sudo apt install gettext*

# install pips
./bin/pip install -r requirements.txt

# make ADap symbol visible
# change this when the version bumps from 3.12
cp Adap.pyi "lib/python$VER/site-packages/gi-stubs/repository/Adap.pyi"

# build once
./build.sh
