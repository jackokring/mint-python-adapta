#!/usr/bin/bash

# version
VER=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')

# ivalidate older
rm -rf bin include lib

# virtual environment
python3 -m venv .

# set virtual environment
. ./bin/activate

# add libadapta-1
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
