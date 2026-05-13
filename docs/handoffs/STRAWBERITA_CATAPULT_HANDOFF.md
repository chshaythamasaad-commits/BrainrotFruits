# Strawberita Catapult Handoff

## Status

Pass 7 complete: a PG Wobble Blob placeholder appears after reveals and bonks the reward.

## Implemented

- Rojo service layout for shared code, server scripts, client scripts, starter UI, and test workspace content.
- Public-repo ignore rules for logs, temporary files, cache folders, and local duplicate reference exports.
- Procedural Strawberita factory with Normal, Shiny, Golden, Galaxy, and Diamond variants.
- Runtime preview lineup under `Workspace/BrainrotFruitsTest/PreviewModels`.
- Runtime test world under `Workspace/BrainrotFruitsTest/TestArea` with catapult, lane, markers, and landing zone.
- Server-owned launch remotes, cooldown validation, crate physics, and landing distance measurement.
- Client charge controls for keyboard, mouse, and touch.
- Server-owned rarity rolls, crate opening pieces, and Strawberita reveal spawns.
- Landing, crate-open, and reveal burst effects.
- Mobile-conscious charge HUD and rarity-colored reveal banner.
- PG Wobble Blob placeholder hazard for the future survive/claim system.

## How to Test in Roblox Studio

1. Run `aftman install`.
2. Run `rojo serve default.project.json`.
3. Open Roblox Studio and connect the Rojo plugin to `localhost:34872`.

## Branch

- `feature/strawberita-catapult-slice`

## Known Issues

- The hazard is deliberately placeholder logic. It marks a bonk and prints debug output, but it does not yet drive a real claim/fail economy.
- Local workspace contains an unreadable legacy `.git` folder, so this session is using an external Git metadata directory.

## Next Suggested Tasks

- Finalize documentation and handoff notes.

## Notes for Future Codex Sessions

- Treat BrainrotFruits as a fresh project.
- Do not do Reverend Ru recovery work in this repository.
