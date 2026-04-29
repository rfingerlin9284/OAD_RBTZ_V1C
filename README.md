# OAD_RBTZ_V1C

Public bootstrap repo for moving the OANDA V1C workspace onto a different computer.

Important:
- This repo is **public**.
- It does **not** contain your live `.env`, tokens, SSH keys, Codex logs, or broker secrets.
- Use it as a safe bootstrap and restore helper only.
- The exact local working state still needs to come from your own backup folder or WSL export.

## What This Repo Is For

Use this repo on the new computer to:
- recreate the canonical OAD folder layout
- clone the public OANDA code base into the main OAD folders
- import your private overlay from an external backup folder
- run a post-restore sanity check before any restart

## Exact VS Code Terminal Commands For The New Computer

Paste these in the VS Code terminal on the new computer:

```bash
cd ~
git clone https://github.com/rfingerlin9284/OAD_RBTZ_V1C.git
cd OAD_RBTZ_V1C
bash scripts/bootstrap_new_computer.sh
```

If you copied your private backup folder onto the new computer, then run:

```bash
cd ~/OAD_RBTZ_V1C
bash scripts/import_overlay_from_folder.sh /path/to/backup_root
bash scripts/post_restore_check.sh
```

Good candidate backup roots:

```bash
/mnt/d/V1C_OAD_MASTER_REPO
/mnt/c/Users/<you>/Desktop/V1C_OAD_MASTER_REPO
/path/to/extracted_backup_root
```

## What The Private Backup Root Should Contain

See:
- `manifests/required_transfer_paths.txt`

At minimum, that backup root should include:
- `OAD_PROD`
- `OAD_DEV`
- `OAD_CLONE`
- `OAD_FREEZE`
- `PRODUCTION_BUNDLES`
- `RBOTZILLA_VERSION_AUDIT_LAB`
- `RBOTZILLA_VERSION_LEDGER.json`
- `.codex`
- `.vscode`
- `.vscode-server`
- `.config/Antigravity`
- `.ssh`
- `.gitconfig`

## After Restore

Run these on the new computer before starting anything:

```bash
cd ~/OAD_PROD
python3 scripts/verify_engine_identity.py | tail -120
python3 scripts/v1c_preflight_audit.py
```

Do not restart the engine until:
- identity is aligned
- preflight is clean
- your private `.env` is in place
- your production bundle and state snapshots are restored

## Strong Recommendation

For true no-loss migration, keep a full WSL export in addition to this GitHub bootstrap repo.

This repo helps the new computer scoop the folder structure and restore commands cleanly, but it is **not** a substitute for a full private backup.
