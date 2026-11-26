#!/usr/bin/env python3

import base64
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


source = Path(os.path.abspath(sys.argv[1]))
width = max(1, int(sys.argv[2]))
height = max(1, int(sys.argv[3]))
stat = source.stat()
cache_key = hashlib.sha256(f"{source}\0{stat.st_size}\0{stat.st_mtime_ns}".encode()).hexdigest()
cache_dir = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "nvim" / "oil-preview" / "bgcode"
cache_dir.mkdir(parents=True, exist_ok=True)
cached_images = [cache_dir / f"{cache_key}.{ext}" for ext in ("png", "jpg", "qoi")]
image_path = next((path for path in cached_images if path.is_file()), None)

if image_path is None:
    begin_re = re.compile(r"^;\s*thumbnail(?:_([A-Za-z0-9]+))?\s+begin\s+(\d+)x(\d+)\s+\d+\s*$", re.I)
    end_re = re.compile(r"^;\s*thumbnail(?:_[A-Za-z0-9]+)?\s+end\s*$", re.I)
    thumbnails = []

    with tempfile.TemporaryDirectory(prefix="nvim-bgcode-", dir=cache_dir) as temp_dir:
        temp_source = Path(temp_dir) / source.name
        shutil.copyfile(source, temp_source)
        subprocess.run(["bgcode", str(temp_source)], cwd=temp_dir, check=True, stdout=subprocess.DEVNULL)
        decoded = Path(temp_dir) / f"{source.stem}.gcode"

        if decoded.is_file():
            active = None
            with decoded.open(encoding="ascii", errors="ignore") as stream:
                for line in stream:
                    line = line.rstrip("\r\n")
                    match = begin_re.match(line)
                    if match:
                        active = [match.group(1) or "PNG", int(match.group(2)), int(match.group(3)), []]
                    elif active is not None and end_re.match(line):
                        thumbnails.append(active)
                        active = None
                    elif active is not None:
                        active[3].append(line.lstrip("; ").strip())

        if not thumbnails:
            sys.exit("No embedded thumbnail found in this BGCode file")

        fmt, _, _, chunks = max(thumbnails, key=lambda item: item[1] * item[2])
        ext = {"PNG": "png", "JPG": "jpg", "JPEG": "jpg", "QOI": "qoi"}.get(fmt.upper(), "png")
        image_path = cache_dir / f"{cache_key}.{ext}"
        image_path.write_bytes(base64.b64decode("".join(chunks)))

subprocess.run(
    [
        "chafa",
        "--format=symbols",
        "--symbols=block+border+space-wide-inverted",
        "--colors=full",
        "--color-space=din99d",
        f"--size={width}x{height}",
        "--polite=on",
        str(image_path),
    ],
    check=True,
)
