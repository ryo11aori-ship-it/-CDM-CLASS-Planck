#!/usr/bin/env bash
set -e

echo "[INFO] CLASS path: $CLASS_PATH"
echo "[INFO] Starting Planck ΛCDM smoke test"

# 展開済み Planck data を想定
export PLANCK_DATA_PATH=/opt/planck

# MontePython が参照
export MP_CLASS_PATH=$CLASS_PATH

cd /work

# 1 walker / 本物設定 / 完走は期待しない
montepython run \
  -p montepython/planck_LCDM.param \
  -N 1 \
  --silent

echo "[INFO] Smoke test reached likelihood evaluation"
