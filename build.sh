#!/usr/bin/bash

# make sure you install.sh first (at least once)
# you don't need to freeze.sh unless you wish to git push new dependencies

# make source .tgz and .whl
hatch build .

# then install the wheel to check
pip install --force-reinstall ./*.whl

# then maybe twine, but remeber API keys for PyPI
# apparently hatch publish can also do this
