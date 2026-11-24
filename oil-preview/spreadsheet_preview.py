#!/usr/bin/env python3

import csv
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
cache_dir = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "nvim" / "oil-preview" / "spreadsheet"
cache_dir.mkdir(parents=True, exist_ok=True)
csv_path = cache_dir / f"{cache_key}.csv"

if not csv_path.is_file():
    with tempfile.TemporaryDirectory(prefix="nvim-lo-preview-", dir=cache_dir) as temp_dir:
        temp = Path(temp_dir)
        profile_uri = (temp / "profile").as_uri()
        subprocess.run(
            [
                "libreoffice25.8",
                "--headless",
                f"-env:UserInstallation={profile_uri}",
                "--convert-to",
                "csv",
                "--outdir",
                str(temp),
                str(source),
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        converted = temp / f"{source.stem}.csv"
        shutil.copyfile(converted, csv_path)

with csv_path.open(newline="", encoding="utf-8-sig", errors="replace") as stream:
    sample = stream.read(4096)
    stream.seek(0)
    try:
        dialect = csv.Sniffer().sniff(sample, delimiters=",;\t")
    except csv.Error:
        dialect = csv.excel
    lines = []
    for row in csv.reader(stream, dialect):
        line = " │ ".join(cell.replace("\n", " ").strip() for cell in row if cell.strip())
        if line:
            lines.append(line[:width])
        if len(lines) >= height:
            break
sys.stdout.write("\n".join(lines))
