#!/usr/bin/env bash
set -euo pipefail

ROOT="${HOME}"
cd "$ROOT"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: required command not found: $1" >&2
    exit 1
  }
}

need_cmd git
need_cmd ln
need_cmd mkdir

clone_if_missing() {
  local repo_url="$1"
  local target_dir="$2"
  if [ -e "$target_dir/.git" ]; then
    echo "SKIP: $target_dir already exists as a git repo"
    return 0
  fi
  if [ -e "$target_dir" ] && [ ! -d "$target_dir/.git" ]; then
    echo "SKIP: $target_dir exists and is not a git repo"
    return 0
  fi
  echo "CLONE: $repo_url -> $target_dir"
  git clone "$repo_url" "$target_dir"
}

mkdir -p "$ROOT/PRODUCTION_BUNDLES"
mkdir -p "$ROOT/RBOTZILLA_VERSION_AUDIT_LAB"
mkdir -p "$ROOT/OAD_PROD_SAFE_SNAPSHOTS"
mkdir -p "$ROOT/restore_overlay"

clone_if_missing "https://github.com/rfingerlin9284/OANDA_GIT_CLEAN.git" "$ROOT/OAD_PROD"
clone_if_missing "https://github.com/rfingerlin9284/OANDA_GIT_CLEAN.git" "$ROOT/OAD_DEV"
clone_if_missing "https://github.com/rfingerlin9284/OANDA_GIT_CLEAN.git" "$ROOT/OAD_CLONE"
clone_if_missing "https://github.com/rfingerlin9284/OANDA_GIT_CLEAN.git" "$ROOT/OAD_FREEZE"

ln -sfn "$ROOT/OAD_PROD" "$ROOT/RBOTZILLA_OANDA_CLEAN"
ln -sfn "$ROOT/OAD_DEV" "$ROOT/RBOTZILLA_OANDA_DEV"

cat <<'EOF'
Bootstrap complete.

Next step if you copied a backup folder or extracted archive onto this computer:
  bash scripts/import_overlay_from_folder.sh /path/to/backup_root

Good candidate source paths:
  /mnt/d/V1C_OAD_MASTER_REPO
  /mnt/c/Users/<you>/Desktop/V1C_OAD_MASTER_REPO
  /path/to/extracted_backup_root

After import:
  bash scripts/post_restore_check.sh
EOF
