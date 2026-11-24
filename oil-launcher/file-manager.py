#!/usr/bin/env python3

import subprocess
from pathlib import Path
from urllib.parse import unquote, urlparse

import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib


launcher = Path(__file__).with_name("nvim-oil")


def open_location(uris):
    if not uris:
        return

    parsed = urlparse(str(uris[0]))
    if parsed.scheme != "file":
        return

    target = unquote(parsed.path)
    subprocess.Popen([str(launcher), target], start_new_session=True)


class FileManager(dbus.service.Object):
    @dbus.service.method("org.freedesktop.FileManager1", in_signature="ass", out_signature="")
    def ShowItems(self, uris, startup_id):
        open_location(uris)

    @dbus.service.method("org.freedesktop.FileManager1", in_signature="ass", out_signature="")
    def ShowFolders(self, uris, startup_id):
        open_location(uris)

    @dbus.service.method("org.freedesktop.FileManager1", in_signature="ass", out_signature="")
    def ShowItemProperties(self, uris, startup_id):
        open_location(uris)


DBusGMainLoop(set_as_default=True)
bus = dbus.SessionBus()
name = dbus.service.BusName("org.freedesktop.FileManager1", bus=bus)
FileManager(bus, "/org/freedesktop/FileManager1")
GLib.MainLoop().run()
