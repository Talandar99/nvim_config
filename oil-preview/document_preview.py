#!/usr/bin/env python3

import os
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path


source = Path(os.path.abspath(sys.argv[1]))
width = max(1, int(sys.argv[2]))
height = max(1, int(sys.argv[3]))

if source.suffix.lower() == ".docx":
    result = subprocess.run(
        ["pandoc", "-f", "docx", "-t", "plain", "--wrap=none", str(source)],
        check=True,
        stdout=subprocess.PIPE,
        text=True,
    )
    content = result.stdout
else:
    with tempfile.TemporaryDirectory(prefix="nvim-doc-") as temp_dir:
        temp = Path(temp_dir)
        profile_uri = (temp / "profile").as_uri()
        subprocess.run(
            [
                "libreoffice25.8",
                "--headless",
                f"-env:UserInstallation={profile_uri}",
                "--convert-to",
                "txt",
                "--outdir",
                str(temp),
                str(source),
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        content = (temp / f"{source.stem}.txt").read_text(encoding="utf-8", errors="replace")

content = content.lstrip("\ufeff")
lines = []
for line in content.splitlines():
    if line.strip():
        lines.extend(textwrap.wrap(line, width=width, replace_whitespace=False))
    else:
        lines.append("")
sys.stdout.write("\n".join(lines[:height]))
