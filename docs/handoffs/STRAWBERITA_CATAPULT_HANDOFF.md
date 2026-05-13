# Strawberita Catapult Handoff

## Status

Pass 3 complete: test lane and catapult model are generated at runtime.

## Implemented

- Rojo service layout for shared code, server scripts, client scripts, starter UI, and test workspace content.
- Public-repo ignore rules for logs, temporary files, cache folders, and local duplicate reference exports.
- Procedural Strawberita factory with Normal, Shiny, Golden, Galaxy, and Diamond variants.
- Runtime preview lineup under `Workspace/BrainrotFruitsTest/PreviewModels`.
- Runtime test world under `Workspace/BrainrotFruitsTest/TestArea` with catapult, lane, markers, and landing zone.

## How to Test in Roblox Studio

1. Run `aftman install`.
2. Run `rojo serve default.project.json`.
3. Open Roblox Studio and connect the Rojo plugin to `localhost:34872`.

## Branch

- `feature/strawberita-catapult-slice`

## Known Issues

- Playable catapult logic is not implemented yet, but the catapult has an `InteractZone` for it.
- Local workspace contains an unreadable legacy `.git` folder, so this session is using an external Git metadata directory.

## Next Suggested Tasks

- Implement server-authoritative launch, client charge controls, and remotes.

## Notes for Future Codex Sessions

- Treat BrainrotFruits as a fresh project.
- Do not do Reverend Ru recovery work in this repository.
