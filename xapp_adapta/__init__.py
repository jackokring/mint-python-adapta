# module initialization
from .adapta_test import main as test

# function dev utilities
import fcntl, sys, termios, os


def cdv():
    for c in "cd" + os.getenv("VIRTUAL_ENV", "") + "\n":
        fcntl.ioctl(sys.stdin, termios.TIOCSTI, c)
