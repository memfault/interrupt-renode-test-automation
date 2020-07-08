#!/bin/sh

# Loads a Renode Save image and starts a GDB server
# https://renode.readthedocs.io/en/latest/basic/saving.html

sh /Applications/Renode.app/Contents/MacOS/macos_run.command --disable-xwt \
  -e "Load @$1" \
  -e 'mach set 0' \
  -e 'machine StartGdbServer 3333'
