#!/usr/bin/env bash
set -euo pipefail

ROOT="${HOME}"
status=0

check_path() {
  local path="$1"
  if [ -e "$ROOT/$path" ]; then
    echo "OK   $path"
  else
    echo "MISS $path"
    status=1
  fi
}

check_path OAD_PROD
check_path OAD_DEV
check_path OAD_CLONE
check_path OAD_FREEZE
check_path PRODUCTION_BUNDLES
check_path RBOTZILLA_VERSION_AUDIT_LAB
check_path RBOTZILLA_VERSION_LEDGER.json
check_path .codex
check_path .vscode
check_path .vscode-server
check_path .config/Antigravity
check_path .ssh
check_path .gitconfig
check_path OAD_PROD/.env
check_path OAD_PROD/STATE_SNAPSHOT/production_identity.json
check_path OAD_PROD/logs/active_boot.json

cat <<'EOF'

Next manual checks:
  cd ~/OAD_PROD
  python3 scripts/verify_engine_identity.py | tail -120
  python3 scripts/v1c_preflight_audit.py

Do NOT restart anything until identity and preflight look right.
EOF

exit "$status"
