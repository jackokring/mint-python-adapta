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


class MainWindow(Adw.ApplicationWindow):  # pyright: ignore
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.set_title("Python libAdapta example")
        self.set_default_size(800, 600)

        # Create a split view
        split_view = Adw.NavigationSplitView()
        split_view.set_min_sidebar_width(200)
        split_view.set_max_sidebar_width(300)

        # set for overrides in complex examples
        split_view.set_sidebar(self.side())  # pyright: ignore
        split_view.set_content(self.content())  # pyright: ignore

        self.set_content(split_view)

    def side(self):
        # Create a sidebar
        sidebar_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        listbox = Gtk.ListBox()
        listbox.add_css_class("navigation-sidebar")
        listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        row = Adw.ActionRow(title="Page")
        listbox.append(row)
        sidebar_box.append(listbox)
        sidebar_toolbar = Adw.ToolbarView()
        sidebar_toolbar.add_top_bar(Adw.HeaderBar())
        sidebar_toolbar.set_content(sidebar_box)
        sidebar_page = Adw.NavigationPage(title="Sidebar")
        sidebar_page.set_child(sidebar_toolbar)
        return sidebar_page

    def content(self):
        # Create the content page
        content_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        status_page = Adw.StatusPage()
        status_page.set_title("Python libAdapta Example")
        status_page.set_description(
            "Split navigation view, symbolic icon and a calendar widget to feature the accent color."
        )
        status_page.set_icon_name("document-open-recent-symbolic")
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        calendar = Gtk.Calendar()
        box.append(status_page)
        box.append(calendar)
        content_box.append(box)
        content_toolbar = Adw.ToolbarView()
        content_toolbar.add_top_bar(Adw.HeaderBar())
        content_toolbar.set_content(content_box)
        content_page = Adw.NavigationPage(title="Page")
        content_page.set_child(content_toolbar)
        return content_page


class MyApp(Adw.Application):  # pyright: ignore
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        self.win = MainWindow(application=app)
        self.win.present()


def main():
    app = MyApp()
    app.run(sys.argv)


if __name__ == "__main__":
    main()
