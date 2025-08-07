#!/usr/bin/bash

# ah, try removing the package first if not ok
#pip uninstall ./*.whl

# output the currently installed venv
pip freeze >requirements.txt
