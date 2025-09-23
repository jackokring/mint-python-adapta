#!/usr/bin/bash

# in dir
cd "$(realpath "$(dirname "$0")")" || exit 1

# version
VER=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')
NAME=$(sed -nr "s/^name = \"(.*)\"$/\1/p" <pyproject.toml)

echo "Making or replacing a virtual environment in '$CWD'"
echo "Python version '$VER'"
echo "Project name '$NAME'"
echo
echo "You can now abort the install if you need to prepare."

if ./yes-no.sh "abort"; then
	exit 0
fi

# ivalidate older
rm -rf bin include lib "$NAME/applications" "$NAME/icons" "$NAME/locale"
echo "Clean ..."

# virtual environment
python3 -m venv .
echo "VENV ..."

# set virtual environment
. ./bin/activate

echo "The next bit depends on Linux Mint being installed."
echo "If you have Xia you can install libAdapta (not needed if you have Zara or later)."
echo "This has not been tested on Wilma or earlier."
echo "You may ignore any later version installed messages as that is good."
echo "Needs SUDO"

if ./yes-no.sh "install libAdapata"; then
	# add libadapta-1 and gum TUI tool for nicer scripts
	sudo dpkg -i ./*.deb
fi

echo "If your disto Ubuntu LTS based (Noble or later), you can install the necessary packages."
echo "It might work on other versions or even debian 12 or 13, but has not been tested."
echo "Nedds SUDO"

if ./yes-no.sh "install gtk4, luaJIT and python libs"; then
	# apt installs might be necessary
	sudo apt install -y libadwaita-* libadwaita-*-dev gir1.2-adw-* python3-gi libluajit-5.1-dev
fi

echo "If you wish to develop for other locales, the following might be required."
echo "Needs SUDO"

if ./yes-no.sh "gettext language locale utilities"; then
	# international
	sudo apt install -y gettext*
fi

# install pips
./bin/pip install -r requirements.txt

echo "An error about 'Adap.pyi' indicates a fall back to libAdwaita."
echo "The symbols for libAdapta might not have installed."
echo "This allows python programming LSP symbols for libAdapta."

# make ADap symbol visible
# change this when the version bumps from 3.12
cp Adap.pyi "lib/python$VER/site-packages/gi-stubs/repository/Adap.pyi"

echo "Perfoming first build."

# build once
./build.sh
