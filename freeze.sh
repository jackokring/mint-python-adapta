#!/usr/bin/bash

# in dir
cd "$(realpath "$(dirname "$0")")" || exit 1

# ah, try removing the package first if not ok
#pip uninstall ./*.whl

# output the currently installed venv
pip freeze >./requirements.txt
echo "Make requirements.txt ..."
