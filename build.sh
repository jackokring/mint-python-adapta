#!/usr/bin/bash

# in dir
cd "$(realpath "$(dirname "$0")")" || exit 1

# make sure you install.sh first (at least once)
# you don't need to freeze.sh unless you wish to git push new dependencies

# enter virtual environment
. ./bin/activate || (
	echo "Error! No VENV."
	exit 1
)

# clear old files
rm ./dist/*

# env vars
DOM=$(sed -nr "s/^domain = \"(.*)\"$/\1/p" <pyproject.toml)
NAME=$(sed -nr "s/^name = \"(.*)\"$/\1/p" <pyproject.toml)
echo "$DOM" >"./$NAME/domain.txt"

# desktop
mkdir -p "./$NAME/applications"
cp ./*.desktop "./$NAME/applications/"
echo "Desktops ..."
mkdir -p "./$NAME/icons/hicolor/scalable/apps"
for icon in ./*.svg; do
	cp "$icon" "./$NAME/icons/hicolor/scalable/apps/"
done
echo "Icons ..."

# xgettext
mkdir -p "./$NAME/locale"
xgettext -d "./$NAME" -p ./locale -- *.py
echo "New messages.po ... (edit and name <lang>.po)"
# makes the messages.po file to adapt into <LANG>.po files
for n in ./locale/*.po; do
	file="$(basename "$n")"
	dir="./$NAME/locale/LC_MESSAGES/${file%.*}"
	mkdir -p "$dir"
	# makes the language indexes
	msgfmt "$n" -o "$dir/$DOM.$NAME.mo"
	echo "Language: $n"
done

# make source .tgz and .whl
hatch build

# then install the wheel to check
# has a tight redownload for checks on dependencies
pip install --force-reinstall ./dist/*.whl

# then maybe twine, but remeber API keys for PyPI
# apparently hatch publish can also do this

# hatch publish after first config using __token__
