# Strawberita Catapult Handoff

## Current Status

The Strawberita + Catapult slice now runs inside a generated 6-player simulator-style map with one shared central launch area on `feature/strawberita-catapult-slice`.

This repository is a fresh BrainrotFruits side project. Do not run Reverend Ru recovery logic here.

## Git State

- Working branch: `feature/strawberita-catapult-slice`
- Latest local implementation commit before this docs pass: `c223880` - `feat: add strawberita variants and preview lineup`
- Previous local implementation commit: `f55d72e` - `chore: integrate base strawberita reference model`
- Remote status at handoff: local branch is ahead of `origin/feature/strawberita-catapult-slice`; push attempts were blocked because this environment has no GitHub HTTPS credentials.

## What Was Implemented

- Clean Rojo layout for BrainrotFruits services.
- Canonical base-template Strawberita factory with variants including Normal, Shiny, Golden, Galaxy, and Diamond.
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

## Base Strawberita Reference Used

The approved base visual anchor is the blocky front/angle/side/back Strawberita reference sheet now stored at `art/references/Strawberita/strawberita_voxel_reference.png`.

Inspection note: no serialized `.rbxm`, `.rbxmx`, `.rbxl`, `.rbxlx`, mesh, or manually placed Studio model was found in the Git repo or the provided local snapshot. The newer approved reference was found only as the blocky model-sheet PNG in `M:\Games\BrainrotFruits-main\references\references\Strawberita\strawberita_source_reference.png`, then copied into the Git repo to replace the obsolete older image.

Runtime source: `src/ReplicatedStorage/BrainrotFruits/Models/Strawberita/BaseStrawberita.lua` encodes the approved reference silhouette into one cloneable base template named `BaseStrawberita`. It creates a transparent `Root` PrimaryPart, welded Roblox `Part` / `WedgePart` descendants, visual-role attributes, canonical reference attributes, and an estimated normal collectible height of about 6.05 studs.

Variant rule: `StrawberitaFactory` clones `BaseStrawberita` first, then applies variant colors, materials, highlights, lights, and particles. Variants must not add a new silhouette or unrelated character body.

## Strawberita Style Rule

Strawberita must stay anchored to the approved chunky voxel / block-built Roblox simulator collectible style from the base reference sheet.

- Main body is a large rounded-square strawberry costume built from stacked red cuboids, side depth blocks, back fill, and lower wedge taper blocks.
- Face is a large peach rectangular front panel with symmetrical black pixel eyes, one white square highlight per eye, one green lower accent per eye, square cheeks, and a tiny pixel smile.
- Seeds are small block/cube accents on the front, sides, and back, not tiny dots.
- Leaf top is a layered chunky block crown with front, side, and back leaf plates plus a small stem.
- Arms, legs, shoes, bow, chest emblem, skirt band, and white accents are rectangular block parts. Accessories should stay above or beside the face instead of crossing it.
- Do not return Strawberita to smooth fruit blob, Ball body, organic mascot, or Pixar-like shapes.
- Normal, Shiny, Golden, Diamond, and Galaxy variants must keep the same base block structure and only change colors, materials, particles, glow, and accessory finish.

## Files Created or Edited

- `default.project.json`
- `docs/DEVLOG.md`
- `docs/asset_research/blocky_style_references.md`
- `docs/asset_research/mesh_candidates.md`
- `docs/handoffs/STRAWBERITA_CATAPULT_HANDOFF.md`
- `art/references/Strawberita/strawberita_voxel_reference.png`
- `references/references/Strawberita/strawberita_source_reference.png`
- `src/ReplicatedStorage/BrainrotFruits/Configs/BrainrotFruitConfig.lua`
- `src/ReplicatedStorage/BrainrotFruits/Models/StrawberitaFactory.lua`
- `src/ReplicatedStorage/BrainrotFruits/Shared/CatapultConfig.lua`
- `src/ReplicatedStorage/BrainrotFruits/Models/Strawberita/BaseStrawberita.lua`
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

## Latest Voxel Rebuild Notes

- Body shape: rebuilt into a 6-stud-tall, deeper 3D strawberry costume with stacked red cuboids, side depth, back fill, lower taper wedges, and cube seeds on front, sides, and back.
- Face: replaced with a larger peach rectangle, simple black pixel eyes, white square highlights, green lower accents, pink cheeks, and a tiny smile.
- Leaf crown: rebuilt as layered chunky green plates and wedges visible from front, side, and back, with a small stem block.
- Accessories: added a larger upper-left block bow, chest strawberry emblem, skirt/bottom band, white square trim accents, socks, and red square boots.
- Variants: Golden, Diamond, and Galaxy use the same improved base geometry and only change colors, materials, sparkles, glow, and finish.
- Preview spacing: central hub preview now shows Base, Golden, Diamond, and Galaxy with wider 8-stud spacing and compact name/rarity labels.
- Central statue: showcase uses the improved Galaxy geometry scaled to 2.35x, landing around 14 studs tall on the hub pedestal.

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

- The requested initial cwd, `M:\Games\BrainrotFruits-main`, was a source snapshot without `.git`; implementation work was done in the real clone at `M:\Games\BrainrotFruits`.
- GitHub push is not complete from this environment. `git push` was attempted after stable commits, but HTTPS auth failed with `could not read Username for 'https://github.com': terminal prompts disabled`.
- No serialized approved `.rbxm`/`.rbxmx` base model was found. The canonical base is the approved voxel model-sheet PNG at `art/references/Strawberita/strawberita_voxel_reference.png` plus the runtime `BaseStrawberita` template module.
- Rojo structure validates with `rojo build default.project.json`, but this was not play-tested inside Roblox Studio from Codex.
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
