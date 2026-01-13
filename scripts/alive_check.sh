#!/bin/bash

echo "[CI] CLASS alive check started"

# CLASS が要求する出力ディレクトリ
mkdir -p output/class

INI=class/explanatory.ini

timeout 180 ./class/class $INI > /tmp/class.log 2>&1
RET=$?

if [ $RET -eq 0 ]; then
    echo "[CI] CLASS finished successfully (alive)"
    exit 0
elif [ $RET -eq 124 ]; then
    echo "[CI] TIMEOUT: possible divergence or infinite loop"
    tail -n 50 /tmp/class.log
    exit 1
else
    echo "[CI] CLASS crashed or exited with error code $RET"
    tail -n 50 /tmp/class.log
    exit 1
fi