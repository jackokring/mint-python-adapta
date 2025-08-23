# A template for Using libadapta with Python

![PyPI - Version](https://img.shields.io/pypi/v/xapp_adapta)
![GitHub Downloads](https://img.shields.io/github/downloads/jackokring/mint-python-adapta/total)
![GitHub Commit Activity](https://img.shields.io/github/commit-activity/t/jackokring/mint-python-adapta)

![License](https://img.shields.io/badge/License-MIT-blue)
![License](https://img.shields.io/badge/License-LGPL-blue)
![License](https://img.shields.io/badge/License-GPL-blue)

The scripts.

- `ìnstall.sh` to add the `.deb` files, `pip install` and python syntax symbols.
  Also it rebuilds and fixes a few issues if you rename or move the repo
  clone directory. `gum` is included to make nicer scripts.
- `build.sh` to build the `.gz`, `.whl` and install the package. This causes
  all python packages to be updated and makes ready for `hatch publish`.
- `freeze.sh` to make `requirements.txt` before a `git add` if more python
  dependencies become included in the project.
- `pydo.sh` to make a virtual environment launch icon. Just in case you don't
  have `pipx` or admin rights, and maybe need a `.desktop` file. Try
  `./pydo.sh adapta_test` for example, and see
  `cat ./adapta_test.desktop`. Yes,
  you might want to edit it a little. Something to do with GUI launch and  
  setting the virtual environment not being automatic, or maybe you don't need
  a debug terminal. You also get an icon made. For other icons, don't use
  a command name, just make a `.svg` and pick a unique ID.

Change the paths from `xapp_adapta`, as the name must be unique on `PyPI`, if
you intend to upload a derivative work there. This is important.

The `C++` module `.so` must be edited in `xapp_adapta/cpp` with `so.in.hpp`
being edited to auto generate `so.hpp`. So, don't edit `so.hpp` and add
interface definitions to `so.pyi` in `xapp_adapta`.

Thanks
_Simon Jackson_
