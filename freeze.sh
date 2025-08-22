#!/usr/bin/bash

# in dir
if [ "$(realpath "$(dirname "$0")")" != "$(pwd)" ]; then
	exit 1
fi

# ah, try removing the package first if not ok
#pip uninstall ./*.whl

# output the currently installed venv
pip freeze >./requirements.txt
