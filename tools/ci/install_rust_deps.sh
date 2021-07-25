#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

mkdir -p ~/.byond/bin
wget -O ~/.byond/bin/librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
wget -O ~/.byond/bin/libauxmos.so "https://github.com/Putnam3145/auxmos/releases/download/$AUXMOS_VERSION/libauxmos.so"
chmod +x ~/.byond/bin/librust_g.so
chmod +x ~/.byond/bin/libauxmos.so
ldd ~/.byond/bin/librust_g.so
ldd ~/.byond/bin/libauxmos.so
