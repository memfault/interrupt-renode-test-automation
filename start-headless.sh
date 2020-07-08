#!/bin/sh

# Starts the built Renode image without a GUI
# To attach to it, use Telnet

sh /Applications/Renode.app/Contents/MacOS/macos_run.command --disable-xwt renode-config.resc --port 33334
