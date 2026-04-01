# Fiji Upstream Reference

This directory stores the copied Fiji macro baseline used by the Haibao desktop repository.

## Source Rule

1. Ignore `Macrophage Image Four-Factor Analysis_3.0.2.ijm`.
2. Look at the sibling Fiji repository root: `../Macrophage-4-Analysis`.
3. Treat the highest versioned root-level `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm` file as the active baseline.
4. Copy that file into this directory and refresh `LATEST_MACRO.ijm` plus `UPSTREAM_VERSION.json`.

## Allowed Update Path

- Strict/manual sync: `npm run sync:fiji-ref`
- Alias: `npm run refresh:fiji-baseline`
- Automatic optional sync runs before local `dev`, `dev:inspect-main`, `build`, `build:debug`, `typecheck`, and `test`

The automatic sync is best-effort. It skips cleanly when the sibling Fiji repository is not present. Use the strict sync command when you need to verify that this directory matches the latest Fiji macro baseline.

## Canonical Files

- `LATEST_MACRO.ijm`: stable alias used by tooling and docs
- `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm`: copied upstream source file with original filename
- `UPSTREAM_VERSION.json`: sync metadata

Do not edit copied macro files in this directory manually.
