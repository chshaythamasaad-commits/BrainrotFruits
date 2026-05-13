# Strawberita Catapult Handoff

## Current Status

The first playable Strawberita + Catapult vertical slice is implemented on `feature/strawberita-catapult-slice`.

Latest implementation commit before this documentation pass: `f873e72`.

This repository is a fresh BrainrotFruits side project. Do not run Reverend Ru recovery logic here.

## What Was Implemented

- Clean Rojo layout for BrainrotFruits services.
- Procedural Strawberita factory with five variants: Normal, Shiny, Golden, Galaxy, and Diamond.
- Runtime preview lineup in `Workspace/BrainrotFruitsTest/PreviewModels`.
- Runtime test world with catapult, launch lane, distance markers, landing zone, and direction arrow.
- Server-authoritative catapult launch flow with remotes, cooldown validation, crate physics, and server-measured landing distance.
- Distance-based rarity roll and automatic crate reveal.
- Server-spawned Strawberita reward model that remains visible for inspection.
- Mobile-conscious charge HUD, cooldown feedback, reveal banner, and burst effects.
- PG Wobble Blob placeholder hazard for future survive/claim gameplay.

## Files Created or Edited

- `.gitignore`
- `default.project.json`
- `docs/DEVLOG.md`
- `docs/handoffs/STRAWBERITA_CATAPULT_HANDOFF.md`
- `src/ReplicatedStorage/BrainrotFruits/Configs/BrainrotFruitConfig.lua`
- `src/ReplicatedStorage/BrainrotFruits/Configs/init.lua`
- `src/ReplicatedStorage/BrainrotFruits/Models/StrawberitaFactory.lua`
- `src/ReplicatedStorage/BrainrotFruits/Models/init.lua`
- `src/ReplicatedStorage/BrainrotFruits/Remotes/.gitkeep`
- `src/ReplicatedStorage/BrainrotFruits/Shared/CatapultConfig.lua`
- `src/ReplicatedStorage/BrainrotFruits/Shared/RarityConfig.lua`
- `src/ReplicatedStorage/BrainrotFruits/Shared/init.lua`
- `src/ServerScriptService/BrainrotFruits/CatapultService.server.lua`
- `src/ServerScriptService/BrainrotFruits/ChaosHazardService.lua`
- `src/ServerScriptService/BrainrotFruits/FXService.lua`
- `src/ServerScriptService/BrainrotFruits/RewardService.lua`
- `src/ServerScriptService/BrainrotFruits/StrawberitaPreview.server.lua`
- `src/ServerScriptService/BrainrotFruits/TestWorldBuilder.server.lua`
- `src/ServerScriptService/BrainrotFruits/init.server.lua`
- `src/StarterGui/BrainrotFruits/.gitkeep`
- `src/StarterPlayer/StarterPlayerScripts/BrainrotFruits/CatapultClient.client.lua`
- `src/StarterPlayer/StarterPlayerScripts/BrainrotFruits/init.client.lua`
- `src/Workspace/BrainrotFruitsTest/.gitkeep`

## How to Test in Roblox Studio

1. Run `aftman install`.
2. Run `rojo serve default.project.json`.
3. Open Roblox Studio.
4. Connect the Rojo plugin to `localhost:34872`.
5. Press Play.
6. Walk near the catapult in `Workspace/BrainrotFruitsTest/TestArea`.
7. Hold `E`, `Space`, mouse click, or the mobile `Launch` action to charge.
8. Release to launch the crate down the lane.
9. Watch the crate land, open, reveal a Strawberita variant, and spawn the Wobble Blob placeholder.

## Branch and Git Notes

- Branch: `feature/strawberita-catapult-slice`
- Remote: `https://github.com/chshaythamasaad-commits/BrainrotFruits.git`
- Latest implementation commit before docs pass: `f873e72`
- This session used an external Git metadata directory because the local `.git` folder in the workspace is unreadable on Windows.

## Known Issues

- The local workspace contains an unreadable legacy `.git` folder. Git operations in this session used an external metadata directory outside the project root.
- Rojo structure validates with `rojo sourcemap`, but this was not play-tested inside Roblox Studio from Codex.
- The crate landing detector is intentionally simple and may need tuning for exact terrain or collision changes.
- The Wobble Blob is placeholder logic only; it does not yet integrate with a real claim, fail, inventory, or economy system.
- UI is functional but still prototype-level; art/audio polish is future work.

## Next Suggested Tasks

- Play-test in Roblox Studio and tune launch speed, arc height, cooldown, and distance bands.
- Add a retry/reset flow after the Wobble Blob bonk.
- Add a claim button and simple collection/inventory stub.
- Add sound effects for charge, launch, landing, reveal, and bonk.
- Replace placeholder particles with game-specific effects once the style settles.
- Add basic analytics/debug commands for launch distance and variant roll testing.

## Notes for Future Codex Sessions

- Keep working in small passes with commits and pushes after stable changes.
- Keep BrainrotFruits original and Roblox-safe for younger audiences.
- Do not copy exact meme/TikTok/copyrighted characters.
- Prefer procedural Roblox parts for early content.
- Keep server authority for distance, rarity, reward, and cooldown decisions.
- Treat the Wobble Blob as a PG placeholder for the future survive/claim system.
