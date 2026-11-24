#!/bin/sh
set -e

nvim --headless -c "Lazy! sync" -c qa
