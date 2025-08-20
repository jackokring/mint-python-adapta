#!/usr/bin/bash

# make sure you install.sh first (at least once)
# you don't need to freeze.sh unless you wish to git push new dependencies

# enter virtual environment
. ./bin/activate || echo "Error! No VENV."

# clear old files
rm ./dist/*

# env vars
DOM=$(sed -nr "s/^domain = \"(.*)\"$/\1/p" <pyproject.toml)
NAME=$(sed -nr "s/^name = \"(.*)\"$/\1/p" <pyproject.toml)
echo "$DOM" >"./$NAME/domain.txt"

# desktop
mkdir -p "./$NAME/applications"
cp ./*.desktop "./$NAME/applications/"
mkdir -p "./$NAME/icons/hicolor/scalable/apps"
for icon in ./*.svg; do
	cp "$icon" "./$NAME/icons/hicolor/scalable/apps/"
done

# xgettext
mkdir -p "./$NAME/locale"
xgettext -d "./$NAME" -p ./locale -- *.py
for n in ./locale/*.po; do
	file="$(basename "$n")"
	dir="./$NAME/locale/LC_MESSAGES/${file%.*}"
	mkdir -p "$dir"
	msgfmt "$n" -o "$dir/$DOM.$NAME.mo"
done

# make source .tgz and .whl
hatch build

# then install the wheel to check
pip install --force-reinstall ./dist/*.whl

# then maybe twine, but remeber API keys for PyPI
# apparently hatch publish can also do this
