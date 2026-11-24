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
thumbnailer = shutil.which("blender-thumbnailer")
if not thumbnailer:
    thumbnailers = sorted(Path("/opt").glob("blender-bin-*/blender-thumbnailer"))
    if not thumbnailers:
        sys.exit("blender-thumbnailer not found")
    thumbnailer = str(thumbnailers[-1])

stat = source.stat()
cache_key = hashlib.sha256(f"{source}\0{stat.st_size}\0{stat.st_mtime_ns}".encode()).hexdigest()
cache_dir = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "nvim" / "oil-preview" / "blend"
cache_dir.mkdir(parents=True, exist_ok=True)
preview_path = cache_dir / f"{cache_key}.png"

if not preview_path.is_file():
    with tempfile.TemporaryDirectory(prefix="nvim-blend-", dir=cache_dir) as temp_dir:
        thumbnail = Path(temp_dir) / "preview.png"
        subprocess.run(
            [thumbnailer, str(source), str(thumbnail)],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        if not thumbnail.is_file():
            sys.exit("No embedded preview in blend file")
        shutil.copyfile(thumbnail, preview_path)

subprocess.run(
    [
        "chafa",
        "--format=symbols",
        "--colors=full",
        "--color-space=din99d",
        f"--size={width}x{height}",
        "--polite=on",
        str(preview_path),
    ],
    check=True,
)
