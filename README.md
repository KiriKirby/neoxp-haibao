# neoxp_haibao

This directory is the migration workspace for turning the Fiji macro workflow into a standalone desktop product.

## Goal

Build a non-linear desktop workflow (Electron front-end) while preserving scientific output consistency for phagocytosis analysis.

## Recommended Strategy

1. Keep a compatibility baseline (Fiji headless adapter) for parity checks.
2. Build a native primary engine step-by-step.
3. Replace Fiji-dependent compute modules only after metric-level regression passes.

## Why This Strategy

The current macro logic is deterministic but deeply tied to ImageJ command behavior. Directly replacing all image algorithms in one shot is high-risk and likely to drift from existing results.

## Current Scope in This Folder

1. `docs/`:
   - Fiji algorithm audit
   - migration architecture and sequencing
2. `packages/contracts`:
   - shared model definitions (error codes, phase keys, param-spec keys)
3. `packages/parser`:
   - filename/time parsing behavior aligned with macro presets
4. `packages/workflow`:
   - phase model and non-linear state machine baseline
5. `apps/desktop`:
   - runnable Electron + React shell
   - phase navigation and filename preset parser smoke check

## Upstream Baseline

This workspace keeps a copied Fiji baseline for parity reference.

- Fixed historical reference to ignore: `Macrophage Image Four-Factor Analysis_3.0.2.ijm`
- Latest upstream baseline rule: choose the highest versioned root-level `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm` file, excluding `3.0.2`
- Local copy directory: `references/fiji-upstream/`
- Refresh command: `npm run sync:fiji-ref`

After syncing:

- `references/fiji-upstream/LATEST_MACRO.ijm` is the stable alias
- `references/fiji-upstream/UPSTREAM_VERSION.json` records the copied upstream version and source file

## Next Build Targets

1. `packages/engine-adapter-fiji`: run existing pipeline in headless mode with structured output.
2. `packages/engine-native`: native implementations of thresholding/morphology/particle counting.
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
