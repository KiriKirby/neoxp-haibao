# Fiji Upstream Reference

This directory stores the latest Fiji macro baseline copied from the upstream Fiji-script repository root.

Rules:

1. Ignore `Macrophage Image Four-Factor Analysis_3.0.2.ijm`.
2. Treat the highest versioned `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm` file at the upstream repository root as the latest macro baseline.
3. Do not edit copied macro files in this directory manually.
4. Refresh this directory only by running `npm run sync:fiji-ref`.
5. Read `UPSTREAM_VERSION.json` to know which upstream file/version was copied last.

Canonical files:

- `LATEST_MACRO.ijm`: stable alias used by tooling/docs.
- `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm`: copied upstream source file with original filename.
- `UPSTREAM_VERSION.json`: sync metadata.
