#!/usr/bin/env bash
set -euo pipefail

echo "=== CLASS alive check ==="

cd /work

# コンパイル確認
if [ ! -f class/class ]; then
  echo "ERROR: CLASS binary not found"
  exit 1
fi

# 超軽量パラメータ（即死検知用）
cat > test.ini <<EOF
h = 0.67
omega_b = 0.022
omega_cdm = 0.12
A_s = 2.1e-9
n_s = 0.965
tau_reio = 0.054
output = tCl
l_max_scalars = 20
EOF

# 3分で強制終了（発散検知）
timeout 180 ./class/class test.ini

echo "CLASS finished without immediate divergence"