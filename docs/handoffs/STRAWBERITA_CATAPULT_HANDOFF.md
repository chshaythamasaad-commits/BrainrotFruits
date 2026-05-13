# Strawberita Catapult Handoff

## Status

Pass 2 complete: Strawberita variants can be generated procedurally and previewed in the test world.

## Implemented

- Rojo service layout for shared code, server scripts, client scripts, starter UI, and test workspace content.
- Public-repo ignore rules for logs, temporary files, cache folders, and local duplicate reference exports.
- Procedural Strawberita factory with Normal, Shiny, Golden, Galaxy, and Diamond variants.
- Runtime preview lineup under `Workspace/BrainrotFruitsTest/PreviewModels`.

## How to Test in Roblox Studio

1. Run `aftman install`.
2. Run `rojo serve default.project.json`.
3. Open Roblox Studio and connect the Rojo plugin to `localhost:34872`.

## Branch

- `feature/strawberita-catapult-slice`

## Known Issues

- Playable catapult logic is not implemented yet.
- Local workspace contains an unreadable legacy `.git` folder, so this session is using an external Git metadata directory.

## Next Suggested Tasks

- Build the test lane and catapult model.

## Notes for Future Codex Sessions

- Treat BrainrotFruits as a fresh project.
- Do not do Reverend Ru recovery work in this repository.
