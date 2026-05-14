# BrainrotFruits Devlog

## Strawberita Catapult Slice

Branch: `feature/strawberita-catapult-slice`

### Gameplay pass - player crate return run

Commit: this pass - `feat: add player crate return run gameplay`

- Added `CatapultModelBuilder` and replaced the old shared/decorative catapult geometry with `BlockyCatapult_V1`, a blocky wooden A-frame catapult based on `references/references/Catapult/catapult-reference.png`.
- Updated the shared launcher to set `GameplayVersion = "PlayerCrateReturnRun_V1"` on `Workspace.BrainrotMap`.
- Changed launch behavior so the launching player's character is hidden/locked while a player-sized lucky crate represents them during flight.
- Refactored reward reveal so crate opening creates a pending Strawberita reward at the landing zone instead of immediately placing it on the plot.
- Added `ReturnRunService`: after reveal, the player is restored, receives a speed boost, and must run to their own `BaseClaimZone` to secure the pending reward.
- Added return-run success/loss UI feedback, a temporary "YOUR BASE" marker, a simple return-run bonker hazard, and server-side duplicate-claim protection.
- Updated plots to `BaseReferencePlot_V3`, with invisible center-safe `SpawnPad` parts and invisible `BaseClaimZone` claim areas.

### Pass 10 - Voxel reference geometry rebuild

Commit: this pass - `feat: rebuild strawberita voxel reference geometry`

- Rebuilt `BaseStrawberita` around the direct voxel 4-view reference at `art/references/Strawberita/strawberita_voxel_reference.png`.
- Enlarged the normal collectible to an estimated 6.05 studs tall and changed the central showcase to a 2.35x Galaxy statue, about 14.2 studs tall.
- Reworked the body into a deeper chunky 3D strawberry mass with stacked cuboids, rounded side blocks, lower taper wedges, and seeds on the front, sides, and back.
- Replaced the awkward face with a large peach rectangular face panel, two simple black pixel eyes, white square highlights, green lower accents, a tiny smile, and pink cheek blocks.
- Rebuilt the leaf crown as layered green voxel plates/wedges with a small stem, then tightened the bow, chest berry emblem, skirt band, white square accents, socks, and red boot details.
- Kept Golden, Diamond, and Galaxy on the exact same base geometry and limited variant differences to colors, materials, particles, glow, and finish.
- Updated preview display to show Base, Golden, Diamond, and Galaxy with wider spacing and compact two-line labels for name and rarity.

### Pass 9 - Approved base Strawberita reference integration

Commits:

- `f55d72e` - `chore: integrate base strawberita reference model`
- `c223880` - `feat: add strawberita variants and preview lineup`

- Replaced the obsolete tracked Strawberita source image with the approved blocky front/angle/side/back reference sheet from the original workspace snapshot.
- Added `BaseStrawberita`, a canonical runtime template module that encodes the approved model-sheet silhouette, face layout, bow, leaf crown, mini berry badge, belt studs, socks, and red shoes.
- Refactored `StrawberitaFactory` so every reward and preview variant clones the same base template first, then applies variant colors/materials/effects without changing proportions.
- Updated the central preview lineup to show Normal, Shiny, Golden, Galaxy, and Diamond together.
- No serialized `.rbxm`, `.rbxmx`, or placed Studio model was found in the repo or workspace snapshot, so the handoff now treats the approved model sheet plus `BaseStrawberita` as the canonical base source.
- Push attempts for these commits were blocked by missing GitHub HTTPS credentials in this environment.

### Pass 1 - Project setup and structure

Commit: `09fbc17` - `chore: set up brainrotfruits project structure`

- Created the Rojo service layout for BrainrotFruits.
- Added initial development handoff notes.
- Updated `.gitignore` for public-repo hygiene.

### Pass 2 - Strawberita procedural model factory

Commit: `1486316` - `feat: add strawberita procedural model factory`

- Added variant config for Normal, Shiny, Golden, Galaxy, and Diamond Strawberita.
- Added a reusable part-based Strawberita factory with welds, a PrimaryPart, labels, and lightweight variant effects.
- Added a runtime preview lineup in `Workspace/BrainrotFruitsTest/PreviewModels`.

### Pass 3 - Catapult test world

Commit: `856fc33` - `feat: add catapult test world`

- Added an idempotent test-world builder for `Workspace/BrainrotFruitsTest/TestArea`.
- Added a launch lane, distance markers, landing zone, direction arrow, and simple wooden catapult model.
- Added a named `InteractZone` with launch origin/direction attributes for gameplay.

### Pass 4 - Catapult launch gameplay

Commit: `566a9aa` - `feat: add catapult launch prototype`

- Added shared catapult config and remote names.
- Added server-authoritative launch validation, cooldowns, crate spawning, physics launch, and landing distance measurement.
- Added a client charge input loop with keyboard, mouse, and touch action support plus a temporary charge HUD.

### Pass 5 - Distance-based rarity and reveal

Commit: `f5b4ee9` - `feat: add distance based strawberita reveal`

- Added distance bands and weighted variant rolls.
- Added server-side reward reveal that opens the crate and spawns the matching Strawberita variant.
- Added reveal remotes and debug prints for landed distance, band, rarity, and variant.

### Pass 6 - UI and effects

Commit: `cb74dba` - `feat: add catapult ui and reveal effects`

- Added server-replicated burst effects for landing, crate opening, and reveal moments.
- Improved the catapult HUD with mobile-friendly sizing, charge color feedback, cooldown color feedback, and a reveal banner.
- Added rarity-colored reveal text with distance and band name.

### Pass 7 - PG chaos hazard placeholder

Commit: `f873e72` - `feat: add pg chaos hazard placeholder`

- Added a non-violent Wobble Blob placeholder hazard.
- The placeholder spawns after a Strawberita reveal, drifts toward the reward, and marks the sequence as bonked.
- Added attributes and debug output that clearly mark this as future survive/claim placeholder logic.

### Pass 8 - Documentation and handoff

Commit: this documentation pass.

- Expanded devlog and handoff notes for future Codex sessions.
- Documented test steps, created/edited files, known issues, and recommended next work.

## Six-Player Playable Map Layout

### Map pass - 6-player simulator layout

- Replaced the synced empty test workspace with `Workspace.BrainrotMap`.
- Added generated central hub, paths, six separated plots, plot signs, spawn pads, catapult stations, launch lanes, reward zones, and ten fruit slots per plot.
- Added server-side plot assignment, owner attributes, plot cleanup on player leave, and spawn teleporting to the assigned plot.
- Refactored catapult launch validation to use the player's own plot catapult instead of a single global test catapult.
- Refactored reward placement so revealed Strawberita models are placed onto the player's next open fruit display slot.
- Moved preview models into the central hub and disabled the legacy single-lane test builder.

## Strawberita Art Direction Correction

### Style pass - blocky collectible Strawberita

- Rebuilt `StrawberitaFactory` to match a chunky voxel/block-built simulator collectible style.
- Removed smooth Ball-part body/face/seed/foot language from Strawberita.
- The character now uses stacked cuboids, wedge taper blocks, flat face parts, square eyes, block seeds, chunky leaves, rectangular limbs, square shoes, and a blocky sash/badge accessory.
- Variants keep the same base block structure and only change colors, materials, particles, glow, and accessory finish.

## Focused Polish Pass

### Map polish - shared central launch

- Reworked the playable map into a central safe hub with one shared launch area instead of per-plot catapults.
- Player plots now focus on ownership, fruit slots, spawn markers, borders, and paths back to the hub.
- Added Shop, Upgrades, Sell, and Index stands around the hub.
- Added a central showcase pedestal for the rarest Strawberita statue.
- Catapult launches now use the shared central catapult while rewards still route to the launching player's assigned plot.

### Strawberita polish - cleaner collectible face

- Simplified the face into a flatter, cleaner, more icon-like block composition.
- Added larger symmetrical framed eyes, centered pupils, small highlights, square cheeks, and a tiny open mouth.
- Enlarged the flat face panel and moved seed accents away from the face so the expression reads clearly from distance.

## Strawberita Visual Research Pass

### Style research - blocky collectible references

- Added Creator Store / Toolbox style research for generic cube pets, voxel characters, toy-like faces, and blocky fruit props.
- Recorded useful references, script risk, IP concerns, and design lessons in `docs/asset_research/blocky_style_references.md`.
- Reworked Strawberita's face again using the research lessons: clearer face tile, calmer square eyes, one highlight per eye, tiny pixel smile, and no accessory crossing the expression.
- Replaced the front sash with a small block bow near the top of the body and widened the stacked strawberry body slightly for a chunkier collectible silhouette.

## Gameplay/Map Polish Pass

### Strawberita return tool and extended lane

- Marked the generated map with `GameplayVersion = "StrawberitaReturnTool_V2"` and `LaunchLaneVersion = "ExtendedDecoratedLane_V1"`.
- Extended the shared launch lane out to 500-stud markers, added milestone arches, flags, lamps, rails, arrows, rocks, bushes, and a farther reveal island.
- Kept the shared central catapult as the active gameplay launcher and marked it with corrected launch-lane orientation attributes.
- Shrunk per-plot catapults into decorative statue-style pieces with `CatapultVersion = "BlockyCatapult_Statue_V1"`.
- Added `StrawberitaTransformService` so the launched player is visually represented by the voxel Strawberita during flight and return run.
- On successful base return, `RewardService` now grants a Strawberita reward Tool into the player's Backpack while preserving existing plot-slot display placement.

### Cleanup polish - kid-friendly UI and debug sign removal

- Marked the generated map with `VisualPolishVersion = "CleanKidFriendlyUI_V1"`.
- Hid the large runtime verification signs in normal play, including the voxel-active preview marker and the map-active sign.
- Reworked the reward HUD into a smaller top reward card and compact bottom return task bar with a time-progress fill.
- Reduced billboard label sizes/distances for previews, hazards, and return markers; plot ownership now relies on the physical sign surface.
- Added more decorative trees, bushes, flowers, crates, small fruit statues, and reveal-zone sparkles to fill empty grass without blocking paths.
- Kept the working Strawberita transform stable and added only lightweight return-run sparkle particles for movement polish.

### Center area polish - main launch hub

- Marked the generated map with `CenterAreaVersion = "MainLaunchHub_V1"`, `IslandLayoutVersion = "CompactSocialIsland_V1"`, and `PlotPolishVersion = "InvitingPlots_V2"`.
- Tightened the six-plot island layout so player bases sit closer to the hub and are easier to visit from the center.
- Replaced the visible launch sign with `MAIN LAUNCH`, added a brighter launch plaza, and rotated the main gameplay catapult 180 degrees while preserving the +Z launch-lane direction.
- Added physical `TOP LAUNCHES` and `TOP DISTANCE` leaderboard boards near the central plaza.
- Polished the rarest-fruit showcase with a cleaner `RAREST FRUIT` sign, glow platform, and central presentation ring.
- Moved shop/sell/upgrades/index booths out to side placements so they do not block the launch, leaderboards, or showcase.
- Added plot polish details including nicer gate trim, path stones, hut trim, welcome mats, gate flowers, bushes, and collector-side crates.

### Strawberita animation polish - fun bouncy motion

- Marked the generated map with `StrawberitaAnimationVersion = "FunBouncyMotion_V1"`.
- Reworked the temporary transformed Strawberita visual to use an adjustable weld offset instead of a fixed `WeldConstraint`, keeping the visual attached to the player's real root without creating a follower model.
- Added visual-only idle bounce, walk bob, leaf wiggle, face pop, launch stretch/puff, return-run trail, secured celebration, and bonked wobble effects.
- Movement animation is driven by `Humanoid.MoveDirection.Magnitude` and only changes weld offsets, part offsets, and lightweight particles.
- `ReturnRunService` now calls secured/lost animation hooks before cleaning up the transform, while reward placement and Tool grants remain unchanged.

### Platform idle bounce and studded block style

- Marked the generated map with `StrawberitaPlatformAnimationVersion = "PlatformBounce_V1"` and `BlockStyleVersion = "StuddedBlockStyle_V1"`.
- Added `Shared/StrawberitaAnimation.lua` for anchored fruit-slot collectibles, starting the platform idle loop from `PlotService.placeRewardOnSlot()`.
- Platform Strawberitas now get subtle bounce/sway, low-rate rarity sparkles, and optional rarity glow while staying centered on their assigned slot.
- Added `Shared/BlockStyle.lua` and routed `MapBuilder`, `PlotModelBuilder`, and `CatapultModelBuilder` generated parts through it for classic studded top surfaces where appropriate.
- Kept invisible zones, water, neon/glow parts, text/sign surfaces, and Strawberita face/eye/mouth pieces smooth for readability.
- `StrawberitaFactory` now applies studs only to suitable Strawberita body/leaf/seed/accessory blocks, preserving the clean face panel and expression.

### Visible studded block style fix

- Updated `Shared/BlockStyle.lua` to `StuddedBlockStyle_VISIBLE_V2` after Studio showed that legacy `TopSurface = Studs` was not visually obvious enough on the generated materials.
- Added capped physical `VisibleStud` grid details on important generated floors and platforms, including plot bases, fruit pad stone bases, central plaza floors, launch plaza panels, lane floors, path panels, catapult bases, collector bases, hut porches, and reveal-zone base platforms.
- Converted selected floor/path/pad surfaces to classic `Plastic` material while preserving color and gameplay physics, so the Roblox block style reads clearly from a normal camera angle.
- Kept invisible spawns, claim zones, interaction zones, water, neon/glow centers, signs, and text panels smooth and non-studded.
- Added map diagnostics: `BlockStyleVersion = "StuddedBlockStyle_VISIBLE_V2"`, `StuddedPartsStyled`, `StudGridFallbackParts`, and `StudGridFallbackStuds`.
