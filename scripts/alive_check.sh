#!/usr/bin/env bash
set -euo pipefail

# Path assumptions:
# - CLASS binary is /opt/class/class (standard from class_public make)
# - ci_alive.ini is at /work/class-ci/ci_alive.ini (in-repo)
# - Script prints human-friendly messages; CI checks logs

LOGFILE=/work/class.log
INI=/work/class-ci/ci_alive.ini
CLASS_BIN=/opt/class/class

echo "[CI] Starting CLASS alive check at $(date)" > "$LOGFILE"
echo "[CI] CLASS binary: $CLASS_BIN" >> "$LOGFILE"
echo "[CI] INI file: $INI" >> "$LOGFILE"

if [ ! -x "$CLASS_BIN" ]; then
  echo "[CI][ERROR] CLASS binary not found or not executable: $CLASS_BIN" | tee -a "$LOGFILE"
  exit 1
fi

if [ ! -f "$INI" ]; then
  echo "[CI][ERROR] INI file not found: $INI" | tee -a "$LOGFILE"
  exit 1
fi

# Run CLASS with the CI ini; capture stdout/stderr to logfile
echo "[CI] Running: $CLASS_BIN $INI" | tee -a "$LOGFILE"
/opt/class/class "$INI" >> "$LOGFILE" 2>&1 || {
  echo "[CI][ERROR] CLASS exited with non-zero status" | tee -a "$LOGFILE"
  # show tail for quick debugging in CI logs
  tail -n 200 "$LOGFILE" || true
  exit 1
}

# Immediate numeric blow-up checks
if grep -E -i "nan|inf|infinity|segmentation fault|abort|floating point exception" "$LOGFILE"; then
  echo "[CI][ERROR] Numerical blow-up or crash pattern detected in class.log" | tee -a "$LOGFILE"
  tail -n 200 "$LOGFILE" || true
  exit 1
fi

# Heuristic: check whether CLASS completed background+thermo+pert or at least printed 'perturbations' / 'thermodynamics'
if grep -E -i "background|thermodynamics|perturbations" "$LOGFILE" >/dev/null; then
  echo "[CI][OK] CLASS printed key integration stage markers" | tee -a "$LOGFILE"
else
  echo "[CI][WARN] CLASS did not print expected stage markers; check logs" | tee -a "$LOGFILE"
  tail -n 200 "$LOGFILE" || true
  # Treat as failure because we expect at least these markers
  exit 1
fi

echo "[CI] CLASS alive check passed at $(date)" | tee -a "$LOGFILE"
exit 0