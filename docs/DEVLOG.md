# BrainrotFruits Devlog

## Strawberita Catapult Slice

Branch: `feature/strawberita-catapult-slice`

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
