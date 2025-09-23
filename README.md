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
  `cat ./adapta_test.desktop`. Yes, icons are made after launch test.
  You might want to edit it a little. Something to do with GUI launch and  
  setting the virtual environment not being automatic, or maybe you don't need
  a debug terminal. You also get an icon made. For other icons, don't use
  a command name, just make a `.svg` and pick a unique ID. It also makes a
  mimetype for the application icon. Put the application icon in `ìcon_base`
  before `./pydo.sh` so the document mimetype icon is also made.
- `lang.sh` makes a localization file based on the user's language setting.
  Also updates the localizations if new things to translate are found.

Change the paths from `xapp_adapta`, as the name must be unique on `PyPI`, if
you intend to upload a derivative work there. This is important.

The `C++` module `.so` must be edited in `xapp_adapta/cpp` with `so.in.cpp`
being edited to auto generate `so.cpp`. So, don't edit `so.cpp`. Add python
interface definitions to `so.pyi` in `xapp_adapta`.

Thanks

_Simon Jackson_

## Installing

1. `git clone git@github.com:jackokring/mint-python-adapta.git`
2. `cd mint-python-adapta`
3. `./install.sh` (following the instructions for optional things)
4. If you've changed the name from `xapp_adapta`, `./build.sh` will make a
   python module which can be uploaded to PyPI by `hatch publish` (check how in
   the `hatch` documentation), making `pip install xapp-adapta` work maybe?
5. A `pip install` would need a once `àdapta_make_local` for desktop Linux
   installs. Fancy icons and mimetypes

## Interesting Things

The 3-way split of `C++`/`Python`/`LuaJIT-5.1` can solve most problems. The
`C++` takes the role of ultimate fast without going rusty. The `Python` takes
the role of glue and any ML via extensive modules from its community. `Lua`
takes the role of a compact and reasonably fast interface to an alternate
small scene due to a very compact language embedding, and documentation that
you can read within a night.
