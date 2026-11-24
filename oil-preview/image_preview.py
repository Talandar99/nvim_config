#!/usr/bin/env python3

import os
import subprocess
import sys
from pathlib import Path


source = Path(os.path.abspath(sys.argv[1]))
width = max(1, int(sys.argv[2]))
height = max(1, int(sys.argv[3]))
subprocess.run(
    [
        "chafa",
        "--format=symbols",
        "--colors=full",
        "--animate=off",
        f"--size={width}x{height}",
        "--polite=on",
        "--",
        str(source),
    ],
    check=True,
)
