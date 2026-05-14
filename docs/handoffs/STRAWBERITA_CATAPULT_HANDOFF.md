# Strawberita Catapult Handoff

## Current Status

The Strawberita + Catapult slice now runs inside a generated 6-player simulator-style map with one shared central launch area on `feature/strawberita-catapult-slice`.

Latest gameplay pass adds the first return-run loop: the shared catapult launches the player as a lucky crate, the crate opens into a pending Strawberita reward, and the player must run back to their own plot claim zone to secure it.

This repository is a fresh BrainrotFruits side project. Do not run Reverend Ru recovery logic here.

## Git State

- Working branch: `feature/strawberita-catapult-slice`
- Latest implementation commit before this pass: `a2cd4aa` - `feat: add polished base reference plot model`
- Remote status at handoff: push works from the active `M:\Games\BrainrotFruits-git` clone.

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

Latest note: older auto-placement notes are superseded by the Player Crate Return Run pass. Rewards now become pending rewards and are placed only after the player reaches their own `BaseClaimZone`.

## Latest Gameplay Pass - Player Crate Return Run

- `CatapultModelBuilder` creates the active `BlockyCatapult_V1` model for the shared launcher and decorative plot catapults.
- `MapBuilder.build()` sets `Workspace.BrainrotMap.GameplayVersion = "PlayerCrateReturnRun_V1"`.
- `CatapultService.server.lua` hides and locks the launching character, creates `LaunchedPlayerCrate_<UserId>`, moves the hidden character root with the crate during flight, then restores the character at reveal time.
- `RewardService.revealCrate` now creates a pending reward with `ClaimState = "PendingReturnRun"` and no longer auto-places it.
- `ReturnRunService` owns pending reward state, speed boost cleanup, own-plot claim detection, timeout/loss cleanup, and final `RewardService.claimPendingReward` placement.
- `ChaosHazardService.spawnReturnBonker` adds a simple PG bonker that can catch the returning player and trigger reward loss.
- `CatapultClient.client.lua` displays "Loading crate...", "Launch! You are the crate!", "Run back to your base to keep it!", "Reward Secured!", and "Reward Lost!" feedback.
- `PlotModelBuilder` now emits `BaseReferencePlot_V3` plots with invisible center-safe `SpawnPad` parts and invisible `BaseClaimZone` parts.

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
- `references/references/Catapult/catapult-reference.png`
- `references/references/Catapult/notes.md`
- `references/references/Strawberita/strawberita_source_reference.png`
- `src/ReplicatedStorage/BrainrotFruits/Configs/BrainrotFruitConfig.lua`
- `src/ReplicatedStorage/BrainrotFruits/Models/StrawberitaFactory.lua`
- `src/ReplicatedStorage/BrainrotFruits/Shared/CatapultConfig.lua`
- `src/ReplicatedStorage/BrainrotFruits/Models/Strawberita/BaseStrawberita.lua`
- `src/ServerScriptService/BrainrotFruits/CatapultService.server.lua`
- `src/ServerScriptService/BrainrotFruits/ChaosHazardService.lua`
- `src/ServerScriptService/BrainrotFruits/RewardService.lua`
- `src/ServerScriptService/BrainrotFruits/ReturnRunService.lua`
- `src/ServerScriptService/BrainrotFruits/StrawberitaPreview.server.lua`
- `src/ServerScriptService/BrainrotFruits/TestWorldBuilder.server.lua`
- `src/ServerScriptService/BrainrotFruits/Map/MapBuilder.lua`
- `src/ServerScriptService/BrainrotFruits/Map/CatapultBinder.lua`
- `src/ServerScriptService/BrainrotFruits/Map/CatapultModelBuilder.lua`
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

- Each plot has twelve display slots in `FruitSlots`.
- On reveal, `RewardService` rolls the variant server-side and creates a pending Strawberita model at the landing zone.
- `ReturnRunService` calls `PlotService.placeRewardOnSlot` only after the player reaches their own `BaseClaimZone`; placement stores:
  - `Occupied`
  - `OwnerUserId`
  - `FruitVariant`
  - `FruitDisplayName`
- If the player is bonked, dies, times out, or leaves before returning, the pending reward is cleared instead of placed.

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
10. Watch your character become the launched crate.
11. After reveal, run back to your own plot.
12. Confirm the reward is placed only after touching your plot's invisible `BaseClaimZone`.

## Multi-Player Studio Test

1. In Roblox Studio, use Test > Start with at least 2 players.
2. Each player should spawn at a different plot.
3. Each plot sign should show the assigned player name.
4. Multiple players should be able to use the shared central catapult, each with their own cooldown.
5. Rewards should place onto the launching player’s own fruit slots.
6. Leaving the server should reset that player’s plot to unclaimed.

Latest multiplayer note: overlapping shared-catapult launches should now fail with "Catapult is busy!", and rewards should only place after the launching player returns to their own base.

## Latest Gameplay/Map Polish Notes

- Active map builder: `src/ServerScriptService/BrainrotFruits/Map/MapBuilder.lua`, function `MapBuilder.build()`.
- Active catapult builder: `src/ServerScriptService/BrainrotFruits/Map/CatapultModelBuilder.lua`, function `CatapultModelBuilder.createCatapult(config)`.
- Active launch service: `src/ServerScriptService/BrainrotFruits/CatapultService.server.lua`.
- Active transform service: `src/ServerScriptService/BrainrotFruits/StrawberitaTransformService.lua`.
- Active reward Tool grant logic: `src/ServerScriptService/BrainrotFruits/RewardService.lua`, function `claimPendingReward`.
- `Workspace.BrainrotMap` now sets `GameplayVersion = "StrawberitaReturnTool_V2"` and `LaunchLaneVersion = "ExtendedDecoratedLane_V1"`.
- The shared catapult remains the gameplay launcher and is tagged with `OrientationCorrected = true` and `FacesLaunchLane = true`.
- Decorative plot catapults are smaller statue/showpieces tagged with `CatapultVersion = "BlockyCatapult_Statue_V1"` and remain `Decorative = true`.
- During launch and return-run, the player's normal avatar is hidden while a non-colliding voxel Strawberita visual is welded to the real character root; after success/failure, the avatar visuals are restored.
- Successful base return still places the reward on the next open plot slot and now also grants a variant-named Strawberita Tool into the player's Backpack.

## Latest Studio Verification

1. Press Play and confirm Output prints:
   - `[BrainrotFruits] Catapult orientation corrected`
   - `[BrainrotFruits] LaunchLaneExtended_V1 active`
   - `[BrainrotFruits] StrawberitaTransform_Fixed_V1 active`
   - `[BrainrotFruits] StrawberitaToolReward_V1 active`
   - `[BrainrotFruits] CleanKidFriendlyUI_V1 active`
   - `[BrainrotFruits] Debug visual markers hidden in normal mode`
   - `[BrainrotFruits] Map decorations polish active`
2. In Explorer, confirm `Workspace.BrainrotMap` has:
   - `GameplayVersion = StrawberitaReturnTool_V2`
   - `LaunchLaneVersion = ExtendedDecoratedLane_V1`
   - `VisualPolishVersion = CleanKidFriendlyUI_V1`
3. Confirm no large `VOXEL STRAWBERITA ACTIVE`, `ACT`, or `MAP V2 ACTIVE` sign is visible in normal play.
4. Confirm `Workspace.BrainrotMap.SharedLaunchArea.LaunchLane` includes distance markers through `500`.
5. Confirm each `Workspace.BrainrotMap.Plots.Plot*/PlotCatapult` has `CatapultVersion = BlockyCatapult_Statue_V1`.
6. Launch from the shared catapult and verify the visible player becomes Strawberita during flight and while running back.
7. Secure the reward by touching the player's own `BaseClaimZone`; verify the reward is on a plot slot and a matching Tool appears in the player's Backpack.
8. Confirm the reward card is a smaller top-center panel and the bottom task bar reads `Run Home!` with a compact progress fill.

## Latest Cleanup Notes

- Visible debug markers are gated by `DebugMode`; normal play keeps Output prints and attributes but hides the giant world signs.
- Preview labels, hazard labels, and return-base labels now have shorter MaxDistance values to reduce clutter.
- The plot owner billboard was removed; owner updates write to the physical sign surface instead.
- Movement polish avoids anchored followers, physics forces, or server-pivot jitter; the transformed Strawberita now uses safe weld-offset bounce, walk bob, leaf wiggle, and lightweight particles.
- Added kid-friendly decorations around the hub, lane edges, reveal island, and empty grass between plots.

## Latest Center Area Polish Notes

- Active central map builder: `src/ServerScriptService/BrainrotFruits/Map/MapBuilder.lua`, especially `MapBuilder.build()`, `buildHub()`, `buildSharedLaunchArea()`, `buildSharedCatapult()`, and `buildIslandBase()`.
- Active plot builder: `src/ServerScriptService/BrainrotFruits/Map/PlotModelBuilder.lua`, function `PlotModelBuilder.createPlot(config)`.
- Active catapult model builder: `src/ServerScriptService/BrainrotFruits/Map/CatapultModelBuilder.lua`, function `CatapultModelBuilder.createCatapult(config)`.
- `Workspace.BrainrotMap` now sets:
  - `CenterAreaVersion = MainLaunchHub_V1`
  - `IslandLayoutVersion = CompactSocialIsland_V1`
  - `PlotPolishVersion = InvitingPlots_V2`
- The visible launch sign now says `MAIN LAUNCH`; no active world sign uses `Shared Lunch` or `Shared Launch`.
- The main gameplay catapult is rotated in `buildSharedCatapult()` and tagged with `LaunchFacingFixed = true`; its launch origin/direction are explicitly overridden so gameplay still launches down the lane.
- The island was tightened by moving the six plot centers inward and shrinking the central/side/back island lobes.
- `TOP LAUNCHES` and `TOP DISTANCE` physical leaderboard boards are placed near the central hub.
- The rarest-fruit showcase remains in the central hub with a cleaner `RAREST FRUIT` sign, glow pedestal, and surrounding presentation ring.
- Plot polish is additive: `PlotModelVersion` remains `BaseReferencePlot_V3`, and each plot now also has `PlotPolishVersion = InvitingPlots_V2`.

## Latest Center Area Studio Verification

1. Press Play and confirm Output prints:
   - `[BrainrotFruits] CenterAreaPolish_V1 active`
   - `[BrainrotFruits] Main catapult rotated and aligned`
   - `[BrainrotFruits] CompactSocialIslandLayout_V1 active`
   - `[BrainrotFruits] PlotPolish_V2 active`
2. In Explorer, confirm `Workspace.BrainrotMap` has:
   - `CenterAreaVersion = MainLaunchHub_V1`
   - `IslandLayoutVersion = CompactSocialIsland_V1`
   - `PlotPolishVersion = InvitingPlots_V2`
3. Confirm `Workspace.BrainrotMap.SharedLaunchArea.MainLaunchSign` exists and the visible text reads `MAIN LAUNCH`.
4. Confirm the main catapult has `LaunchFacingFixed = true` and still launches players forward along the lane.
5. Confirm `CentralHub` contains `TopLaunchesLeaderboard`, `TopDistanceLeaderboard`, and the `ShowcasePedestal`.
6. Confirm each plot keeps `PlotModelVersion = BaseReferencePlot_V3` and now also has `PlotPolishVersion = InvitingPlots_V2`.

## Latest Strawberita Animation Polish Notes

- Active animation code path: `src/ServerScriptService/BrainrotFruits/StrawberitaTransformService.lua`.
- Active transformation path remains `StrawberitaTransformService.beginFlight()`, `syncToCrate()`, `releaseForReturnRun()`, and `finish()`.
- Active reward outcome hooks are in `src/ServerScriptService/BrainrotFruits/ReturnRunService.lua`, where success calls `playRewardSecured()` and failure calls `playRewardLost()` before cleanup.
- `Workspace.BrainrotMap` now sets `StrawberitaAnimationVersion = FunBouncyMotion_V1`.
- The temporary transform still creates exactly one `TransformedStrawberita_{UserId}` visual and welds it to `HumanoidRootPart`; animation changes only the weld offset and internal part weld offsets.
- Idle/walk movement detection uses `Humanoid.MoveDirection.Magnitude > 0.08`.
- Cleanup disconnects the Heartbeat animation connection, disconnects the character-removing cleanup connection, destroys the transformed visual model, restores avatar transparency/movement, and sets `IsTransformedStrawberita = false`.
- Return-run particles are attached to the transformed visual root and are destroyed with the visual model.

## Latest Strawberita Animation Studio Verification

1. Press Play and confirm Output prints:
   - `[BrainrotFruits] StrawberitaFunAnimation_V1 active`
   - `[BrainrotFruits] Strawberita idle/walk animation active`
   - `[BrainrotFruits] Strawberita return-run trail active`
2. In Explorer, confirm `Workspace.BrainrotMap` has `StrawberitaAnimationVersion = FunBouncyMotion_V1`.
3. Launch from `MAIN LAUNCH` and confirm the player becomes a single Strawberita visual, with no second follower model behind the player.
4. During return run, stand still to see a gentle idle bounce, move to see quicker walk bob/foot puffs, and confirm the sparkle trail follows cleanly.
5. Secure the reward at the correct base and confirm the celebration plays, the avatar restores, and the reward Tool still appears in Backpack.
6. Trigger a bonk/loss path and confirm the short wobble/puff plays before cleanup, with no leftover visual model or particles.

## Latest Platform Idle and Studded Style Notes

- Active platform idle animation module: `src/ReplicatedStorage/BrainrotFruits/Shared/StrawberitaAnimation.lua`.
- Active platform animation start point: `src/ServerScriptService/BrainrotFruits/Map/PlotService.lua`, function `PlotService.placeRewardOnSlot()`.
- Active studded style utility: `src/ReplicatedStorage/BrainrotFruits/Shared/BlockStyle.lua`.
- Active generated-model style callers:
  - `src/ServerScriptService/BrainrotFruits/Map/MapBuilder.lua`
  - `src/ServerScriptService/BrainrotFruits/Map/PlotModelBuilder.lua`
  - `src/ServerScriptService/BrainrotFruits/Map/CatapultModelBuilder.lua`
  - `src/ReplicatedStorage/BrainrotFruits/Models/StrawberitaFactory.lua`
- `Workspace.BrainrotMap` now sets:
  - `StrawberitaPlatformAnimationVersion = PlatformBounce_V1`
  - `BlockStyleVersion = StuddedBlockStyle_VISIBLE_V2`
  - `StuddedPartsStyled = <number of generated visible parts styled>`
  - `StudGridFallbackParts = <number of visible surfaces with physical stud grids>`
  - `StudGridFallbackStuds = <number of non-colliding visual studs generated>`
- Platform reward models receive:
  - `PlatformIdleAnimation = Active`
  - `StrawberitaAnimationVersion = PlatformBounce_V1`
- Platform idle animation keeps models anchored/non-colliding and uses a lightweight Heartbeat loop to `PivotTo()` a fixed base pivot plus tiny bounce/sway offsets, so the model does not drift from its slot.
- Platform animation cleanup runs when the model leaves the hierarchy; it disconnects loop/ancestry connections and removes temporary sparkle/glow attachments.
- Studded style still sets classic `TopSurface = Studs` and `BottomSurface = Inlet`, but V2 also adds capped low-profile physical `VisibleStud` grids to major generated floors/platforms because Studio did not make legacy surface studs visible enough on the first pass.
- V2 intentionally targets plot bases, fruit pad stone bases, central hub/plaza panels, launch lane floors, reveal-zone base platforms, catapult bases, collector bases, hut porches, and path panels.
- Studded style intentionally keeps invisible zones, water, neon/glow pieces, triggers, text/sign panels, and Strawberita face/eye/cheek/smile parts smooth.

## Latest Platform Idle and Studded Style Verification

1. Press Play and confirm Output prints:
   - `[BrainrotFruits] PlatformIdleBounce_V1 active`
   - `[BrainrotFruits] StuddedBlockStyle_VISIBLE_V2 active`
   - `[BrainrotFruits] Studded parts styled: X`
   - `[BrainrotFruits] Stud grid fallback parts: Y`
2. In Explorer, confirm `Workspace.BrainrotMap` has:
   - `StrawberitaPlatformAnimationVersion = PlatformBounce_V1`
   - `BlockStyleVersion = StuddedBlockStyle_VISIBLE_V2`
   - `StuddedPartsStyled`
   - `StudGridFallbackParts`
   - `StudGridFallbackStuds`
3. Secure a Strawberita reward and confirm the displayed model on the fruit slot has `PlatformIdleAnimation = Active`.
4. Watch the platform reward for subtle bounce/sway and low-rate rarity sparkles; it should stay centered and not drift.
5. Confirm plot foundations, fruit slot stone bases, central plaza floors, the `MAIN LAUNCH` plaza, launch lane floor, and `RevealZoneBase` show visible raised `VisibleStud` details.
6. Confirm invisible spawn pads, `BaseClaimZone`, catapult interact zone, water, neon/glow pads, and signs remain clean/smooth.
7. Confirm transformed-player Strawberita still uses one welded visual with no follower model and still grants the reward Tool on successful return.

## Latest Temporary Showcase Removal Notes

- Removed the temporary viewing-platform server script from `src/ServerScriptService/BrainrotFruits`.
- The temporary viewing platform no longer creates a separate review folder during Play.
- Asset review should happen through the normal map flow or a newly requested temporary Studio setup.

## Latest Temporary Showcase Removal Verification

1. Press Play in Studio.
2. Confirm no separate temporary asset-review platform appears.
3. Confirm the normal `Workspace.BrainrotMap` gameplay map still builds.

## Known Issues

Latest note: push now works from the active `M:\Games\BrainrotFruits-git` clone; older push-auth warnings below may refer to earlier sessions.

- The requested initial cwd, `M:\Games\BrainrotFruits-main`, was a source snapshot without `.git`; implementation work was done in the real clone at `M:\Games\BrainrotFruits`.
- GitHub push is not complete from this environment. `git push` was attempted after stable commits, but HTTPS auth failed with `could not read Username for 'https://github.com': terminal prompts disabled`.
- No serialized approved `.rbxm`/`.rbxmx` base model was found. The canonical base is the approved voxel model-sheet PNG at `art/references/Strawberita/strawberita_voxel_reference.png` plus the runtime `BaseStrawberita` template module.
- Rojo structure validates with `rojo build default.project.json`, but this was not play-tested inside Roblox Studio from Codex.
- Spawn pads teleport players by script; dedicated Roblox `SpawnLocation` team logic is not implemented yet.
- Fruit claiming is placeholder auto-placement, not a real claim button or inventory.
- The Wobble Blob is placeholder logic only; it marks a bonk but does not yet drive a real claim/fail economy.
- The crate landing detector is intentionally simple and may need tuning per lane after Studio play-testing.
- Map art is intentionally simple procedural parts.
- The Strawberita transform is currently a welded visual override on the real hidden character; a future pass can replace it with a true custom controllable rig if needed.
- The reward Tool is a lightweight miniature handle representation, not a full miniaturized clone of the complete Strawberita model yet.

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
