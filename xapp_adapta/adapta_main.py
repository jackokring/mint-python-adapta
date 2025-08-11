#!/usr/bin/python3

# sudo apt install libgirepository-2.0-dev
import gi
import sys

gi.require_version("Gtk", "4.0")
# so Gtk for graphics
# Gio for data files
# GLib.Error (FileDialog?)
from gi.repository import Gtk, Gio, GLib

# libAdapta uses its own module name (Adap.ApplicationWindow etc..).
# We would normally import it like this:
# from gi.repository import Adap
# Since libAdapta and libAdwaita use the same class names,
# the same code can work with both libraries, as long as we rename
# the module when importing it
try:
    gi.require_version("Adap", "1")
    from gi.repository import Adap as Adw
except ImportError or ValueError as ex:
    # To use libAdwaita, we would import this instead:
    print("Using Adwaita as Adapta not found:\n", ex)
    gi.require_version("Adw", "1")
    from gi.repository import Adw

from .adapta_test import _, MainWindow, domain


class MyWindow(MainWindow):  # pyright: ignore
    # override for different behaviour
    def layout(self):
        # multipaned content by selection widget
        # set list name in navigation 1:1 matches [] and {}
        self.pages = [self.content(_("Content"))]

    # methods to define navigation pages
    def content(self, name: str) -> Adw.NavigationPage:
        # Create the content page _() for i18n
        content_box = self.fancy()
        status_page = Adw.StatusPage()
        status_page.set_title("Python libAdapta Example")
        status_page.set_description(
            "Split navigation view, symbolic icon and a calendar widget to feature the accent color."
        )
        status_page.set_icon_name("document-open-recent-symbolic")
        calendar = Gtk.Calendar()
        content_box.append(status_page)
        content_box.append(calendar)
        # set title and bar
        return self.top(content_box, name)


class MyApp(Adw.Application):  # pyright: ignore
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        self.win = MyWindow(application=app)
        self.win.present()


def main():
    app = MyApp(application_id=domain)
    app.run(sys.argv)


if __name__ == "__main__":
    main()
