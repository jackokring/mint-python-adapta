#!/usr/bin/bash

# virtual environment
python3 -m venv .

# add libadapta-1
sudo dpkg -i ./*.deb

# install pips
pip install -r requirements.txt

# make ADap symbol visible
# change this when the version bumps from 3.12
cp Adap.pyi lib/python3.12/site-packages/gi-stubs/repository/Adap.pyi
