#!/usr/bin/env python3

import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path


source = Path(os.path.abspath(sys.argv[1]))
width = max(1, int(sys.argv[2]))
height = max(1, int(sys.argv[3]))
stat = source.stat()
cache_key = hashlib.sha256(
    f"{source}\0{stat.st_size}\0{stat.st_mtime_ns}\0{width}\0{height}".encode()
).hexdigest()
cache_dir = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "nvim" / "oil-preview" / "stl"
cache_dir.mkdir(parents=True, exist_ok=True)
scad_path = cache_dir / f"{cache_key}.scad"
png_path = cache_dir / f"{cache_key}.png"

if not png_path.is_file():
    scad_path.write_text(f"import({json.dumps(str(source))});\n", encoding="utf-8")
    subprocess.run(
        [
            "openscad",
            "--quiet",
            "--preview=throwntogether",
            "--autocenter",
            "--viewall",
            f"--imgsize={width * 8},{height * 16}",
            "--colorscheme=Tomorrow Night",
            "-o",
            str(png_path),
            str(scad_path),
        ],
        check=True,
        stdout=subprocess.DEVNULL,
    )

subprocess.run(
    [
        "chafa",
        "--format=symbols",
        "--symbols=block+border+space-wide-inverted",
        "--colors=full",
        "--color-space=din99d",
        f"--size={width}x{height}",
        "--polite=on",
        str(png_path),
    ],
    check=True,
)
