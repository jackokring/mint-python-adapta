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

# version
PYVER=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')
# env vars
DOM=$(sed -nr "s/^domain = \"(.*)\"$/\1/p" <pyproject.toml)
NAME=$(sed -nr "s/^name = \"(.*)\"$/\1/p" <pyproject.toml)
echo "$DOM" >"./$NAME/domain.txt"

# desktop
mkdir -p "./$NAME/applications"
cp ./*.desktop "./$NAME/applications/"
echo "Desktops ..."
mkdir -p "./$NAME/icons/hicolor/scalable/apps"
mkdir -p "./$NAME/icons/hicolor/scalable/mimetypes"
for icon in $(find . -maxdepth 1 -name '*.svg' | sed -nr 's/^([^-]*)$/\1/p'); do
	cp "$icon" "./$NAME/icons/hicolor/scalable/apps/"
done
for icon in $(find . -maxdepth 1 -name '*.svg' | sed -nr 's/^(.*\/application-.*)$/\1/p'); do
	cp "$icon" "./$NAME/icons/hicolor/scalable/mimetypes/"
done
# use same icon for mimetype but might change later ... applications v. documents
echo "Icons ..."
mkdir -p "./$NAME/mime/packages"
cp ./*.xml "./$NAME/mime/packages/"

# xgettext
mkdir -p "./$NAME/locale"
pushd "$NAME" || exit 1
sed -r "s/_LOCALE/$DOM\.$NAME/" "cpp/so.in.cpp" >"cpp/so.cpp"
sed -ri "s/python3.12/python$PYVER/" "cpp/so.cpp"
xgettext -p ../locale --keyword="_" -o messages.pot -- *.py cpp/so.cpp
# alter specific phrases in .pot file
VER=$(sed -nr "s/^version = \"(.*)\"$/\1/p" <../pyproject.toml)
sed -ri "s/VERSION/$VER/g" "../locale/messages.pot"
sed -ri "s/PACKAGE/$NAME/g" "../locale/messages.pot"
popd || exit 1
# set a reasonable 2025 charset
echo "New messages.pot ... (edit and name <lang>.po [msginit])"
# makes the messages.po file to adapt into <LANG>.po files
for n in ./locale/*.po; do
	file="$(basename "$n")"
	dir="./$NAME/locale/${file%.*}/LC_MESSAGES"
	mkdir -p "$dir"
	# makes the language indexes
	msgfmt "$n" -o "$dir/$DOM.$NAME.mo" || rmdir "$dir"
	echo "Language: $n"
done

# make source .tgz and .whl
hatch build

# then install the wheel to check
# has a tight redownload for checks on dependencies
pip install --force-reinstall ./dist/*.whl
rm ./dist/*.whl

# call the named command which makes make_local
"./bin/$(sed -nr "s/^(.*) = \".*:make_local\"\$/\1/p" <pyproject.toml)"

# then maybe twine, but remeber API keys for PyPI
# apparently hatch publish can also do this

# hatch publish after first config using __token__
