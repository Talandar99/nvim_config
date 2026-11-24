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
    ["ffprobe", "-hide_banner", "-pretty", str(source)],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True,
)
lines = []
for line in result.stdout.splitlines():
    if line.strip():
        lines.extend(textwrap.wrap(line, width=width, replace_whitespace=False))
    else:
        lines.append("")
sys.stdout.write("\n".join(lines[:height]))
