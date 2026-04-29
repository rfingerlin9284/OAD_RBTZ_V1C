#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: bash scripts/import_overlay_from_folder.sh /path/to/backup_root" >&2
  exit 1
fi

SRC="$(python3 - <<'PY' "$1"
import os,sys
print(os.path.abspath(sys.argv[1]))
PY
)"
ROOT="${HOME}"

if [ ! -d "$SRC" ]; then
  echo "ERROR: source folder not found: $SRC" >&2
  exit 1
fi

copy_item() {
  local rel="$1"
  local from="$SRC/$rel"
  local to="$ROOT/$rel"

  if [ ! -e "$from" ]; then
    echo "SKIP missing: $rel"
    return 0
  fi

  mkdir -p "$(dirname "$to")"
  echo "IMPORT: $rel"
  if command -v rsync >/dev/null 2>&1; then
    if [ -d "$from" ]; then
      rsync -a "$from/" "$to/"
    else
      rsync -a "$from" "$to"
    fi
  else
    rm -rf "$to"
    cp -a "$from" "$to"
  fi
}

while IFS= read -r rel; do
  [ -z "$rel" ] && continue
  case "$rel" in
    \#*) continue ;;
  esac
  copy_item "$rel"
done < manifests/required_transfer_paths.txt

cat <<'EOF'
Overlay import complete.

Run next:
  bash scripts/post_restore_check.sh
EOF
