#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
mkdir ci_test/config

#test config
cp tools/ci/ci_config.txt ci_test/config/config.txt

#throw auxmos into ldd
cp libauxmos.so ~/.byond/bin/libauxmos.so
chmod +x ~/.byond/bin/libauxmos.so
ldd ~/.byond/bin/libauxmos.so

cd ci_test
DreamDaemon tgstation.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
