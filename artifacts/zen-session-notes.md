# Zen session drift notes (2026-10-15)

## Spaces display order is file order, not `position` order
Upstream `zen-browser-flake` activation (`hm-module/session/store.nix`) upserts
`.spaces` by UUID and appends new entries. It never sorts `.spaces`.
`.tabs` get `sort_by(.index)` on every activation, but spaces do not.
Symptom: workspace switcher showed Entertainment, Personal, School, Social
despite positions 1000, 2000, 3000, 4000.
One-time fix (browser closed): `jq '.spaces |= sort_by(.position)'`,
recompress with `mozlz4a`, overwrite `zen-sessions.jsonlz4`.
Future activations preserve existing order, so the fix sticks.
Adding space-routing rules does not reorder spaces (separate file, no sort).

## Pinned-tab entries/indices drift at runtime
Navigating a pinned tab rewrites its `entries`, and Zen normalizes pinned
`index` values on save. Only a switch with Zen closed restores declarative
URLs and indices. Always close Zen before `home-manager switch`.

## Full wipe (2026-10-15 12:15, user-confirmed)
Backup: `~/zen-wipe-backup-20261015-1215/` (main, clean, recovery,
sessionstore.jsonlz4, sessionCheckpoints.json, sessionstore-backups/).
Removed live: `zen-sessions.jsonlz4`, `zen-sessions-backup/{clean,recovery.baklz4}`,
`sessionstore.jsonlz4{,.bak}`, `sessionCheckpoints.json`,
`sessionstore-backups/{previous,recovery.baklz4,recovery.jsonlz4}`.
Dated snapshots in `zen-sessions-backup/` were kept.
Headless first-run (`--headless`, `--screenshot`) never creates session files,
so seeded `{}` + `mozlz4a`, then switched to populate, then re-applied the
spaces position-sort (fresh append order is attr-sorted, Entertainment first).
Result: 4 spaces position-ordered, exactly 8 declared tabs, zero cruft.
Rollback: copy backup files back with Zen closed, then switch.
