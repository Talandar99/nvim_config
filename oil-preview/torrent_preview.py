#!/usr/bin/env python3

import os
import sys
import textwrap
from datetime import datetime
from pathlib import Path


source = Path(os.path.abspath(sys.argv[1]))
width = max(1, int(sys.argv[2]))
height = max(1, int(sys.argv[3]))
data = source.read_bytes()


def decode(data, offset=0):
    token = data[offset : offset + 1]
    if token == b"i":
        end = data.index(b"e", offset)
        return int(data[offset + 1 : end]), end + 1
    if token == b"l":
        items = []
        offset += 1
        while data[offset : offset + 1] != b"e":
            item, offset = decode(data, offset)
            items.append(item)
        return items, offset + 1
    if token == b"d":
        items = {}
        offset += 1
        while data[offset : offset + 1] != b"e":
            key, offset = decode(data, offset)
            value, offset = decode(data, offset)
            items[key] = value
        return items, offset + 1
    if token.isdigit():
        colon = data.index(b":", offset)
        size = int(data[offset:colon])
        start = colon + 1
        return data[start : start + size], start + size
    raise ValueError("Invalid torrent data")


def text(value):
    return value.decode("utf-8", "replace") if isinstance(value, bytes) else str(value)


def size_label(value):
    units = ("B", "KiB", "MiB", "GiB", "TiB")
    amount = float(value)
    for unit in units:
        if amount < 1024 or unit == units[-1]:
            return f"{amount:.1f} {unit}" if unit != "B" else f"{int(amount)} B"
        amount /= 1024


torrent, _ = decode(data)
info = torrent[b"info"]
lines = [f"Name: {text(info.get(b"name.utf-8", info.get(b"name", b"")))}"]

for key, label in ((b"announce", "Tracker"), (b"comment", "Comment"), (b"created by", "Created by")):
    if torrent.get(key):
        lines.append(f"{label}: {text(torrent[key])}")

if isinstance(torrent.get(b"creation date"), int):
    created = datetime.fromtimestamp(torrent[b"creation date"]).strftime("%Y-%m-%d %H:%M:%S")
    lines.append(f"Created: {created}")

lines.append(f"Piece length: {size_label(info.get(b"piece length", 0))}")

files = info.get(b"files")
if files:
    total = sum(item.get(b"length", 0) for item in files)
    lines.append(f"Files: {len(files)}, total {size_label(total)}")
    for item in files:
        path = item.get(b"path.utf-8", item.get(b"path", []))
        name = "/".join(text(part) for part in path)
        lines.append(f"{size_label(item.get(b"length", 0))}  {name}")
else:
    lines.append(f"Size: {size_label(info.get(b"length", 0))}")

wrapped = []
for line in lines:
    wrapped.extend(textwrap.wrap(line, width=width, replace_whitespace=False) if line else [""])
sys.stdout.write("\n".join(wrapped[:height]))
