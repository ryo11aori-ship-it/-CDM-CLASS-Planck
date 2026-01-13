#!/bin/bash
set -e

echo "[CI] CLASS alive check started"

# 最小 ΛCDM（CLASS 標準）
INI=class/explanatory.ini

# 3分で強制終了
timeout 180 ./class/class $INI > /tmp/class.log 2>&1

echo "[CI] CLASS finished without immediate crash"