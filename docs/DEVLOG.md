# BrainrotFruits Devlog

## Strawberita Catapult Slice

### Pass 1 - Project setup and structure

- Created the Rojo service layout for BrainrotFruits.
- Added initial development handoff notes.
- Updated `.gitignore` for public-repo hygiene.

### Pass 2 - Strawberita procedural model factory

- Added variant config for Normal, Shiny, Golden, Galaxy, and Diamond Strawberita.
- Added a reusable part-based Strawberita factory with welds, a PrimaryPart, labels, and lightweight variant effects.
- Added a runtime preview lineup in `Workspace/BrainrotFruitsTest/PreviewModels`.

### Pass 3 - Catapult test world

- Added an idempotent test-world builder for `Workspace/BrainrotFruitsTest/TestArea`.
- Added a launch lane, distance markers, landing zone, direction arrow, and simple wooden catapult model.
- Added a named `InteractZone` with launch origin/direction attributes for the gameplay pass.

### Pass 4 - Catapult launch gameplay

- Added shared catapult config and remote names.
- Added server-authoritative launch validation, cooldowns, crate spawning, physics launch, and landing distance measurement.
- Added a client charge input loop with keyboard, mouse, and touch action support plus a temporary charge HUD.

### Pass 5 - Distance-based rarity and reveal

- Added distance bands and weighted variant rolls.
- Added server-side reward reveal that opens the crate and spawns the matching Strawberita variant.
- Added reveal remotes and debug prints for landed distance, band, rarity, and variant.

### Pass 6 - UI and effects

- Added server-replicated burst effects for landing, crate opening, and reveal moments.
- Improved the catapult HUD with mobile-friendly sizing, charge color feedback, cooldown color feedback, and a reveal banner.
- Added rarity-colored reveal text with distance and band name.

### Pass 7 - PG chaos hazard placeholder

- Added a non-violent Wobble Blob placeholder hazard.
- The placeholder spawns after a Strawberita reveal, drifts toward the reward, and marks the sequence as bonked.
- Added attributes and debug output that clearly mark this as future survive/claim placeholder logic.
