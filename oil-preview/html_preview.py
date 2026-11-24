#!/usr/bin/env python3

import os
import subprocess
import sys
from pathlib import Path


source = Path(os.path.abspath(sys.argv[1]))
width = max(1, int(sys.argv[2]))
height = max(1, int(sys.argv[3]))
result = subprocess.run(
    ["w3m", "-dump", "-cols", str(width), str(source)],
    check=True,
    stdout=subprocess.PIPE,
    text=True,
)
sys.stdout.write("\n".join(result.stdout.splitlines()[:height]))
