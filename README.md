# A template for using `libadapta` with python

There are some scripts.

- `ìnstall.sh` to add the `.deb` files, `pip install` and python syntax symbols.
- `build.sh` to build the `.gz`, `.whl` and install the package.
- `freeze.sh` to make `requirements.txt` before a `git add`.
- `pydo.sh` to make a virtual environment launch. Just in case you don't
  have `pipx` or admin rights, and maybe need a `.desktop` file. Try
  `./pydo.sh ./test` for example, and see `cat ./test.desktop`. Yes,
  you might want to edit it a little and place it in a virtual environment
  `bin` directory next to the command. Something to do with GUI launch and  
  setting the virtual environment not being automatic.

Change the paths from `xapp_adapta` as the name must be unique on `PyPI` if
you intend to upload a derivative work there. This is important.

Thanks
