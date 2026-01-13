#!/usr/bin/env bash
set -e

echo "[INFO] CLASS path: $CLASS_PATH"
echo "[INFO] Starting Planck ΛCDM smoke test"

export PLANCK_DATA_PATH=/opt/planck
export MP_CLASS_PATH=$CLASS_PATH

cd /opt/montepython

python3 montepython.py run \
  -p /work/montepython/planck_LCDM.param \
  -N 1 \
  --silent

echo "[INFO] MontePython started likelihood evaluation"