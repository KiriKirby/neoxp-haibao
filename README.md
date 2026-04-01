# neoxp_haibao

Standalone Electron desktop project for the Haibao workflow.

## Repository Relationship

- Fiji macro source of truth: `../Macrophage-4-Analysis`
- Desktop/UI product repository: this repository
- Fixed historical macro to ignore: `Macrophage Image Four-Factor Analysis_3.0.2.ijm`
- Active parity baseline: the highest versioned root-level `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm` file from the Fiji repository, excluding `3.0.2`

This repository is allowed to implement UI, workflow orchestration, parser/contracts logic, and future native engines. It is not the source of truth for Fiji macro behavior. Macro semantics must be copied from the Fiji repository baseline before behavior-sensitive work.

## Goal

Build a non-linear desktop workflow while preserving scientific output consistency for phagocytosis analysis.

## Recommended Strategy

1. Keep a copied Fiji baseline for parity checks.
2. Build the desktop workflow and shared contracts around that baseline.
3. Replace Fiji-dependent compute modules only after metric-level regression passes.

## Why This Strategy

The current macro logic is deterministic but deeply tied to Fiji/ImageJ behavior. Replacing all image algorithms in one pass is high-risk and likely to drift from the current results.

## Current Scope in This Folder

1. `docs/`
   - Fiji algorithm audit
   - migration architecture and sequencing
2. `packages/contracts`
   - shared model definitions (error codes, phase keys, param-spec keys)
3. `packages/parser`
   - filename/time parsing behavior aligned with macro presets
4. `packages/workflow`
   - phase model and non-linear state machine baseline
5. `apps/desktop`
   - runnable Electron + React shell
   - phase navigation and filename preset parser smoke check
6. `references/fiji-upstream/`
   - copied Fiji macro baseline and sync metadata

## Fiji Baseline Sync

This repository keeps a copied Fiji baseline under `references/fiji-upstream/`.

Files:

- `references/fiji-upstream/LATEST_MACRO.ijm`: stable alias for tooling and docs
- `references/fiji-upstream/Macrophage Image Four-Factor Analysis_X.Y.Z.ijm`: copied upstream macro with original filename
- `references/fiji-upstream/UPSTREAM_VERSION.json`: last synced source path, filename, version, and timestamp

Rules:

1. Never edit copied `.ijm` files under `references/fiji-upstream/` manually.
2. Always ignore `Macrophage Image Four-Factor Analysis_3.0.2.ijm`.
3. Treat the highest versioned root-level `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm` in the Fiji repository as the latest baseline.
4. Refresh the copied baseline with `npm run sync:fiji-ref`.

Commands:

- Strict sync: `npm run sync:fiji-ref`
- Alias: `npm run refresh:fiji-baseline`
- Automatic local pre-sync: `npm run dev`, `npm run dev:inspect-main`, `npm run build`, `npm run build:debug`, `npm run typecheck`, and `npm run test`

Automatic local pre-sync uses the optional mode of `scripts/sync-fiji-latest.ps1`. If the sibling Fiji repository is missing, the command prints a skip message and continues. Use the strict sync command when you need to confirm that this repository is aligned with the latest Fiji macro before behavior-sensitive work.

Recommended sequence before parser/contracts/workflow changes:

1. Pull the latest `Macrophage-4-Analysis` repository.
2. Run `npm run sync:fiji-ref` in this repository.
3. Read `references/fiji-upstream/UPSTREAM_VERSION.json`.
4. Make the behavior change.
5. Re-run `npm run build` or `npm run typecheck`.

## Next Build Targets

1. `packages/engine-adapter-fiji`: run the existing pipeline in headless mode with structured output.
2. `packages/engine-native`: native implementations of thresholding, morphology, and particle counting.
3. Extend `apps/desktop` with persisted project state, parameter editing, and batch execution views.

## Zed Workflow

This repository is configured for a Zed-first workflow on Windows.

### Daily Run

1. Open the repository root in Zed.
2. Press `Ctrl+Shift+R` and run `NeoXP: Dev`.
3. Close the task terminal when you want to stop the full dev session.

### Main-Process Debugging

Recommended:

1. Press `Ctrl+Shift+D`.
2. Start `NeoXP: Launch Desktop Main (Built)`.
3. Set breakpoints in `apps/desktop/src/main/*.ts`.

Attach workflow:

1. Press `Ctrl+Shift+R` and run `NeoXP: Dev Inspect Main`.
2. Press `Ctrl+Shift+D`.
3. Start `NeoXP: Attach Electron Main (9229)`.
4. Set breakpoints in `apps/desktop/src/main/*.ts`.

### Renderer Debugging

1. Start `NeoXP: Dev`.
2. Press `Ctrl+Shift+D`.
3. Start `NeoXP: Launch Renderer In Chrome`.

### Common Tasks

- `NeoXP: Install`
- `NeoXP: Build`
- `NeoXP: Typecheck`
- `NeoXP: Test`
- `NeoXP: Preview`

Project-local Zed configuration lives in `.zed/tasks.json` and `.zed/debug.json`.

## License

This repository is licensed under GPL-3.0-or-later.

Why this license:

- Strong copyleft keeps modified and redistributed desktop versions open.
- Downstream forks that distribute changes must provide source under the same license family.
- The copied Fiji baseline remains a parity reference inside this repository; its upstream macro source remains available from the Fiji repository.