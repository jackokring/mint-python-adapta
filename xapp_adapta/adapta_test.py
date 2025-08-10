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

    def fancy(self) -> Gtk.Box:
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_margin_top(10)
        box.set_margin_bottom(10)
        box.set_margin_start(10)
        box.set_margin_end(10)
        box.set_spacing(10)
        return box

    def top(self, content: Gtk.Box, title: str) -> Adw.NavigationPage:
        # make a page
        toolbar = Adw.ToolbarView()
        toolbar.add_top_bar(Adw.HeaderBar())
        toolbar.set_content(content)
        page = Adw.NavigationPage(title=title)
        page.set_child(toolbar)
        return page

    def side(self) -> Adw.NavigationPage:
        # Create a sidebar
        sidebar_box = self.fancy()
        listbox = Gtk.ListBox()
        listbox.add_css_class("navigation-sidebar")
        listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        row = Adw.ActionRow(title="Page")
        listbox.append(row)
        sidebar_box.append(listbox)
        return self.top(sidebar_box, "navigation")

    def content(self) -> Adw.NavigationPage:
        # Create the content page
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
        return self.top(content_box, "content")


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
