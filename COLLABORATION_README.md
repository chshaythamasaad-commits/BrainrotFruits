# BrainrotFruits Collaboration Rules

This branch has multiple people and Codex instances contributing. Treat existing work as owned unless the user explicitly says it may be removed.

## Do Not Delete Or Overwrite

- Do not delete, reset, revert, rename, or replace another contributor's files without explicit permission.
- Do not use `git reset --hard`, force push, clean untracked files, or overwrite remote history.
- Do not "simplify" by removing working systems, reference files, generated map pieces, docs, or asset folders.
- If remote changes exist, fetch and integrate them before pushing.
- Normal pushes only. If a push is rejected, stop and inspect the remote changes.

## Current Branch Context

- Active branch: `feature/strawberita-catapult-slice`.
- Current playable slice: shared catapult, crate launch, Strawberita reveal, return-run, plot claim, bouncy/studded visual polish.
- Important handoff file: `docs/handoffs/STRAWBERITA_CATAPULT_HANDOFF.md`.

## Work Added By This Codex Pass

- Added `src/ServerScriptService/BrainrotFruits/AssetShowcase.server.lua`.
- The showcase creates `Workspace.AssetShowcase` during Play.
- It builds one platform with five labeled pedestals.
- It clones these builder assets from `ServerStorage` or `ServerStorage.BrainrotFruitAssets`:
  - `BrainrotCrate`
  - `Catapult`
  - `StrawberitaMascot`
  - `BananitoBonkito`
  - `AppleliniSlappelini`
- Missing assets appear as red placeholder cubes and warnings in Output.
- Updated `docs/handoffs/STRAWBERITA_CATAPULT_HANDOFF.md` with showcase verification steps.

## Model Builder Check

`src/ServerScriptService/BrainrotFruits/Map/CatapultModelBuilder.lua` was inspected after integrating the latest remote work.

- It keeps `BlockyCatapult_V1` and `BlockyCatapult_Statue_V1`.
- It uses `ReplicatedStorage.BrainrotFruits.Shared.BlockStyle` to apply the current studded block style to generated catapult parts.
- Shared catapults still expose an `InteractZone` with `SharedLaunch`, `LaunchOrigin`, and `LaunchDirection` attributes.
- The shared catapult uses the `InteractZone` as `PrimaryPart`; decorative catapults use the base frame.
- No model-builder code was changed in this pass.

## Studio Test Reminder

1. Run `rojo serve default.project.json`.
2. Connect Roblox Studio's Rojo plugin to `localhost:34872`.
3. Put the five builder models in `ServerStorage` or `ServerStorage.BrainrotFruitAssets`.
4. Press Play.
5. Confirm `Workspace.AssetShowcase` shows the five labeled assets.
