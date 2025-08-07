#!/usr/bin/bash

# version
VER=$(python -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')

# virtual environment
python3 -m venv .

# set virtual environment
. ./bin/activate

# add libadapta-1
sudo dpkg -i ./*.deb

# install pips
pip install -r requirements.txt

# make ADap symbol visible
# change this when the version bumps from 3.12
cp Adap.pyi "lib/python$VER/site-packages/gi-stubs/repository/Adap.pyi"
