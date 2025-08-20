# module initialization
from .adapta_test import main as test
from .adapta_main import main
import shutil, os


# make_local icons and desktop files
def make_local():
    # where are we?
    path = os.path.dirname(__file__)
    home_local = os.path.expanduser("~/.local/share")
    shutil.copytree(path + "/applications", home_local, dirs_exist_ok=True)
    shutil.copytree(path + "/icons", home_local, dirs_exist_ok=True)
    shutil.copytree(path + "/locale", home_local, dirs_exist_ok=True)
