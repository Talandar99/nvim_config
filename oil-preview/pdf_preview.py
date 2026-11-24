#!/usr/bin/env python3

import os
import subprocess
import sys
import textwrap
from pathlib import Path


source = Path(os.path.abspath(sys.argv[1]))
width = max(1, int(sys.argv[2]))
height = max(1, int(sys.argv[3]))
result = subprocess.run(
    ["pdftotext", "-layout", "-f", "1", "-l", "1", "-nopgbrk", str(source), "-"],
    check=True,
    stdout=subprocess.PIPE,
    text=True,
)
lines = []
for line in result.stdout.splitlines():
    if line.strip():
        lines.extend(textwrap.wrap(line, width=width, replace_whitespace=False))
    else:
        lines.append("")
sys.stdout.write("\n".join(lines[:height]))
