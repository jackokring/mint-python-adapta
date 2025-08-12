#!/usr/bin/bash

# make sure you install.sh first (at least once)
# you don't need to freeze.sh unless you wish to git push new dependencies

# enter virtual environment
. ./bin/activate || echo "Error! No VENV."

# clear old files
rm ./dist/*

# desktop
cp ./bin/*.desktop ./xapp_adapta/

# xgettext
xgettext ./xapp_adapta/*.py -p ./locale
for n in ./locale/*.po; do
	file="$(basename "$n")"
	dir="./xapp_adapta/locale/LC_MESSAGES/${file%.*}"
	mkdir -p "$dir"
	msgfmt "$n" -o "$dir/com.github.jackokring.xapp_adapta.mo"
done

# make source .tgz and .whl
hatch build

# then install the wheel to check
pip install --force-reinstall ./dist/*.whl

# then maybe twine, but remeber API keys for PyPI
# apparently hatch publish can also do this
