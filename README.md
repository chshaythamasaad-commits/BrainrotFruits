# BrainrotFruits

Catapult a Brainrot Fruit.

Current playable slice: approach the shared catapult, charge a fruit crate launch, land it down the lane, reveal a distance-based Brainrot Fruit reward, survive the cartoon hazard/return run, place the collectible on a plot, and grant a matching reward tool.

The first roster is sourced from `references/modelreferences/CharactersRefs`:

- Banana Bandito
- Coconutto Bonkini
- Dragonfrutto Drippo
- Lemonaldo Sprintini
- Strawberita
- Watermeloni Wobblino

The active placeholder models are Roblox-native voxel/chibi mascots built by `BrainrotModelFactory`, with variants and lightweight idle animations ready for Studio preview.

## Tech

- Roblox Studio
- Rojo
- Aftman

## Setup

```powershell
aftman install
rojo serve default.project.json
```

In Roblox Studio, connect the Rojo plugin to `localhost:34872`, press Play, walk to the shared catapult in `Workspace.BrainrotMap.SharedLaunchArea`, then hold and release `E`, `Space`, mouse click, or the mobile `Launch` action.

## Character Preview

In Play mode, the central hub spawns a clean preview row of the six base characters. To inspect all variants from the Studio command bar:

```lua
local svc = require(game.ServerScriptService.BrainrotFruits.CharacterSpawnService)
svc.spawnAllVariants(nil, { clearFirst = true, playIntro = true })
```
