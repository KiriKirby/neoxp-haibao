# NeoXP Haibao

NeoXP Haibao is an Electron desktop application for turning the Fiji macrophage analysis workflow into a desktop workbench.

This repository is for the desktop product: UI, workflow orchestration, parsing rules, shared contracts, and future native compute modules. The Fiji macro itself still lives in the separate source-of-truth repository: `../Macrophage-4-Analysis`.

## What This Repository Contains

- `apps/desktop`: Electron + React desktop app
- `packages/contracts`: shared types, error codes, and parameter-spec definitions
- `packages/parser`: filename and time parsing logic aligned with the Fiji workflow
- `packages/workflow`: phase model and workflow state logic
- `references/fiji-upstream`: copied Fiji macro baseline used for parity tracking
- `docs`: migration notes and architecture planning

## Relationship to the Fiji Repository

The Fiji repository is the behavioral source of truth.

This repository keeps a copied macro baseline under `references/fiji-upstream/` so desktop work can stay aligned with the current Fiji implementation.

Sync rules:

- Ignore `Macrophage Image Four-Factor Analysis_3.0.2.ijm`
- Treat the highest versioned root-level `Macrophage Image Four-Factor Analysis_X.Y.Z.ijm` in `../Macrophage-4-Analysis` as the active baseline
- Never edit copied macro files inside `references/fiji-upstream/` manually

Useful commands:

- Manual sync: `npm run sync:fiji-ref`
- Manual sync script: `./sync-fiji-ref.ps1`
- Normal dev/build commands also run an optional pre-sync first

Files created by sync:

- `references/fiji-upstream/LATEST_MACRO.ijm`
- `references/fiji-upstream/Macrophage Image Four-Factor Analysis_X.Y.Z.ijm`
- `references/fiji-upstream/UPSTREAM_VERSION.json`

If you change behavior that depends on Fiji semantics, sync first, then read `UPSTREAM_VERSION.json` before you start editing code.

## Current Project Status

The repository is currently strongest in these areas:

- Desktop shell and project structure
- Zed-based local development workflow
- Parser/contracts/workflow foundations
- Fiji baseline sync and parity reference handling

The repository is still early in these areas:

- Full execution engine parity with Fiji
- End-to-end scientific output validation
- Production packaging and release flow

## Local Development

Requirements:

- Windows
- Node.js 22
- npm
- Zed

Install dependencies:

```powershell
npm install
```

Start development:

```powershell
npm run dev
```

Build the desktop app:

```powershell
npm run build
```

Run type checks:

```powershell
npm run typecheck
```

Run tests:

```powershell
npm run test
```

## Zed Workflow

This repository is configured primarily for Zed on Windows.

Common tasks:

- `NeoXP: Dev`
- `NeoXP: Dev Inspect Main`
- `NeoXP: Build`
- `NeoXP: Typecheck`
- `NeoXP: Test`
- `NeoXP: Preview`

Common debug entries:

- `NeoXP: Launch Desktop Main (Built)`
- `NeoXP: Attach Electron Main (9229)`
- `NeoXP: Launch Renderer In Chrome`

Project-local Zed configuration is stored in `.zed/tasks.json` and `.zed/debug.json`.

## Direction

The long-term goal is a desktop workbench that can replace the macro-driven workflow without changing scientific meaning.

The practical approach is incremental:

1. Keep the Fiji baseline visible and current.
2. Move workflow and validation logic into shared TypeScript modules.
3. Replace Fiji-dependent execution pieces only after parity checks are in place.

## License

This repository is licensed under GPL-3.0-or-later.
