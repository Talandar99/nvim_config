#!/usr/bin/env python3

import hashlib
import os
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
cache_dir = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "nvim" / "oil-preview" / "aseprite"
cache_dir.mkdir(parents=True, exist_ok=True)
png_path = cache_dir / f"{cache_key}.png"

if not png_path.is_file():
    with tempfile.TemporaryDirectory(prefix="nvim-aseprite-", dir=cache_dir) as temp_dir:
        rendered = Path(temp_dir) / "preview.png"
        subprocess.run(
            ["aseprite", "--batch", str(source), "--frame-range", "1,1", "--save-as", str(rendered)],
            check=True,
            stdout=subprocess.DEVNULL,
        )
        shutil.copyfile(rendered, png_path)

subprocess.run(
    [
        "chafa",
        "--format=symbols",
        "--colors=full",
        "--color-space=din99d",
        f"--size={width}x{height}",
        "--polite=on",
        str(png_path),
    ],
    check=True,
)
