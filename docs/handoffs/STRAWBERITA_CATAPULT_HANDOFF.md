# Strawberita Catapult Handoff

## Current Status

The Strawberita + Catapult slice now runs inside a generated 6-player simulator-style map with one shared central launch area on `feature/strawberita-catapult-slice`.

This repository is a fresh BrainrotFruits side project. Do not run Reverend Ru recovery logic here.

## What Was Implemented

- Clean Rojo layout for BrainrotFruits services.
- Procedural blocky Strawberita factory with variants including Base, Shiny, Golden, Galaxy, and Diamond.
- Central hub under `Workspace.BrainrotMap.CentralHub` with a Brainrot Fruits sign and preview lineup.
- Six generated player plots under `Workspace.BrainrotMap.Plots`.
- Each plot has an owner sign, spawn pad, baseplate, colored borders, path access, and ten fruit display slots.
- One shared central launch area under `Workspace.BrainrotMap.SharedLaunchArea`.
- Shared launch lane with distance markers and a shared reveal zone.
- Shop, Upgrades, Sell, and Index stands around the hub.
- Central rare Strawberita showcase statue on a pedestal.
- Server-side plot assignment for up to six players.
- Shared catapult binding so any assigned player can use the central catapult.
- Server-authoritative launch validation, cooldowns, crate physics, landing distance, rarity roll, and reveal.
- Revealed Strawberita rewards are auto-placed on the player’s next open fruit slot as placeholder claim behavior.
- Mobile-conscious charge HUD, cooldown feedback, reveal banner, and burst effects.
- PG Wobble Blob placeholder hazard for future survive/claim gameplay.

## Strawberita Style Rule

Strawberita must stay in a chunky voxel / block-built Roblox simulator collectible style.

- Main body is stacked red cuboids and wedge taper blocks.
- Face is a larger flat front panel with symmetrical framed eyes, centered pupils, tiny highlights, square cheeks, and a simple small mouth.
- Seeds are small block accents, not dots on a smooth surface.
- Leaf top is a chunky layered block crown.
- Arms, legs, shoes, and accessories are rectangular block parts.
- Do not return Strawberita to smooth fruit blob, Ball body, organic mascot, or Pixar-like shapes.
- Golden, Diamond, and Galaxy variants must keep the same base block structure and only change colors, materials, particles, glow, and accessory finish.

## Files Created or Edited

- `default.project.json`
- `docs/DEVLOG.md`
- `docs/handoffs/STRAWBERITA_CATAPULT_HANDOFF.md`
- `src/ReplicatedStorage/BrainrotFruits/Shared/CatapultConfig.lua`
- `src/ServerScriptService/BrainrotFruits/CatapultService.server.lua`
- `src/ServerScriptService/BrainrotFruits/ChaosHazardService.lua`
- `src/ServerScriptService/BrainrotFruits/RewardService.lua`
- `src/ServerScriptService/BrainrotFruits/StrawberitaPreview.server.lua`
- `src/ServerScriptService/BrainrotFruits/TestWorldBuilder.server.lua`
- `src/ServerScriptService/BrainrotFruits/Map/MapBuilder.lua`
- `src/ServerScriptService/BrainrotFruits/Map/CatapultBinder.lua`
- `src/ServerScriptService/BrainrotFruits/Map/PlotService.lua`
- `src/ServerScriptService/BrainrotFruits/MapBootstrap.server.lua`
- `src/StarterPlayer/StarterPlayerScripts/BrainrotFruits/CatapultClient.client.lua`
- `src/Workspace/BrainrotMap/.gitkeep`
- Removed `src/Workspace/BrainrotFruitsTest/.gitkeep`

## Plot Assignment

- `PlotService` builds the map once through `MapBuilder`.
- When a player joins, `PlotService.assignPlayer` gives them the first plot whose `OwnerUserId` is `0`.
- Plot ownership is stored with:
  - `OwnerUserId`
  - `OwnerName`
  - `Status`
- The owner sign changes from `Unclaimed Plot` to `PlayerName's Plot`.
- The player is teleported to their assigned plot spawn pad on character spawn.
- When a player leaves, the plot is freed, owner attributes are reset, runtime folders are cleared, and fruit slot attributes are reset.

## Shared Catapult Binding

- `MapBuilder` creates one shared catapult model in `Workspace.BrainrotMap.SharedLaunchArea`.
- The shared catapult has an `InteractZone` with:
  - `SharedLaunch`
  - `LaunchOrigin`
  - `LaunchDirection`
- `CatapultBinder` adds a prompt to the shared catapult.
- `CatapultService` ignores client plot choice and resolves the launch zone from `PlotService.getSharedCatapultZone()`.
- Launches fail if the player has no assigned plot, is too far from the shared catapult, or is still on cooldown.
- Rewards still route to the launching player's assigned plot through `PlotService`.

## Fruit Slot Placement

- Each plot has ten display slots in `FruitSlots`.
- On reveal, `RewardService` rolls the variant server-side and creates the Strawberita model.
- `PlotService.placeRewardOnSlot` moves the reward to the next open slot and stores:
  - `Occupied`
  - `OwnerUserId`
  - `FruitVariant`
  - `FruitDisplayName`
- This is placeholder auto-claim behavior until a real claim/inventory system exists.

## How to Test in Roblox Studio

1. Run `aftman install`.
2. Run `rojo serve default.project.json`.
3. Open Roblox Studio.
4. Connect the Rojo plugin to `localhost:34872`.
5. Press Play.
6. Confirm `Workspace.BrainrotMap` contains:
   - `CentralHub`
   - `Plots/Plot1` through `Plots/Plot6`
7. Walk to the shared central launch area.
8. Hold `E`, `Space`, mouse click, or the mobile `Launch` action to charge.
9. Release to launch the crate down your lane.
10. Watch it reveal a Strawberita, place onto your plot's next fruit slot, and spawn the Wobble Blob placeholder.

## Multi-Player Studio Test

1. In Roblox Studio, use Test > Start with at least 2 players.
2. Each player should spawn at a different plot.
3. Each plot sign should show the assigned player name.
4. Multiple players should be able to use the shared central catapult, each with their own cooldown.
5. Rewards should place onto the launching player’s own fruit slots.
6. Leaving the server should reset that player’s plot to unclaimed.

## Known Issues

- The local workspace contains an unreadable legacy `.git` folder. Git operations in this session used an external metadata directory outside the project root.
- Rojo structure validates with `rojo sourcemap`, but this was not play-tested inside Roblox Studio from Codex.
- Spawn pads teleport players by script; dedicated Roblox `SpawnLocation` team logic is not implemented yet.
- Fruit claiming is placeholder auto-placement, not a real claim button or inventory.
- The Wobble Blob is placeholder logic only; it marks a bonk but does not yet drive a real claim/fail economy.
- The crate landing detector is intentionally simple and may need tuning per lane after Studio play-testing.
- Map art is intentionally simple procedural parts.

## Next Suggested Tasks

- Play-test with 2 to 6 players in Studio and tune plot spacing, lane length, launch speed, and landing detection.
- Add a manual claim button before slot placement.
- Add collection/inventory persistence stubs.
- Add per-slot earning timers and simple currency UI.
- Add reset/retry flow after Wobble Blob bonk.
- Add sound effects and more polished map decorations.

## Notes for Future Codex Sessions

- Keep working in small passes with commits and pushes after stable changes.
- Keep BrainrotFruits original and Roblox-safe for younger audiences.
- Do not copy exact meme/TikTok/copyrighted characters.
- Prefer procedural Roblox parts for early content.
- Keep server authority for plot ownership, launches, distance, rarity, rewards, and cooldowns.
- Treat the Wobble Blob as a PG placeholder for the future survive/claim system.
