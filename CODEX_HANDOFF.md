# BrainrotFruits Handoff

## Premium Showcase Visual Pass

This pass upgraded the existing code-generated mascot models toward a more premium Roblox simulator showcase style without changing the core gameplay loop.

Files changed in this pass:

- `src/ReplicatedStorage/BrainrotFruits/Modules/BrainrotModelFactory.lua`
- `src/ServerScriptService/BrainrotFruits/CharacterSpawnService.lua`
- `src/ServerScriptService/BrainrotFruits/Map/MapBuilder.lua`
- `src/ServerScriptService/BrainrotFruits/StrawberitaPreview.server.lua`
- `CODEX_HANDOFF.md`

Visual changes:

- `BrainrotModelFactory.Version` is now `BrainrotModelFactory_PremiumShowcaseMascots_V2`.
- All generated mascots now use stronger face frames, bigger readable expressions, more layered fruit/body massing, and extra contour parts.
- Strawberita received the most mascot-benchmark polish: broader strawberry form, top shoulder mass, side cheek masses, more leaf crown pieces, bow tails, skirt pleats, and front shine.
- BananaBandito now has stronger banana curve pieces, peel crown, mask ties, hat band, bandana knot, money bag patch, and clearer bandit/cowboy identity.
- CoconuttoBonkini now has side shell massing, cream drips, coconut pores, extra cracks, flower/palm details, tunic teeth, and club wrap.
- LemonaldoSprintini now has lemon skin dots, stronger front belly, headband knot/tail, sport stripe, sock stripes, speed-bolt accents, and more athletic readability.
- WatermeloniWobblino now has bigger rind caps, belly roundness, extra stripe rhythm, top leaf, sumo belt ties, inner slice glow, and a happier wobble face.
- DragonfruttoDrippo now has side body massing, extra spikes, front shine, sunglasses glint, jacket lapels, chain charm, and a clearer confident pose.
- Non-base variants now get attached premium accents such as glow disks, chest badges, crown shards, diamond shards, star chips, orbit bars, rainbow strips, and toxic bubble gems.

Presentation changes:

- Preview spawns now use `PreviewStands` with layered pedestals, glow insets, small nameplates, and rarity gems instead of plain flat pads.
- Normal preview mode includes a low showroom floor band with subtle glow strips and top text.
- Preview model roots were raised slightly so characters sit better on the new stands.
- `Workspace.BrainrotMap` sets `BrainrotShowcaseVisualVersion = "PremiumShowcaseMascots_V2"`.

## Current Pass

Restored and polished the first real Brainrot Fruits roster from the current voxel/chibi reference pack:

- `references/modelreferences/CharactersRefs/Characters/BananitoBandito`
- `references/modelreferences/CharactersRefs/Characters/CoconuttoBonkini`
- `references/modelreferences/CharactersRefs/Characters/DragonfruttoDrippo`
- `references/modelreferences/CharactersRefs/Characters/LemonaldoSprintini`
- `references/modelreferences/CharactersRefs/Characters/Strawberita`
- `references/modelreferences/CharactersRefs/Characters/WatermeloniWobblino`

The runtime uses canonical `BananaBandito` as the character id, with `BananitoBandito` preserved as a registry alias because the reference folder is still named `BananitoBandito`.

## Restored Structure

- Rojo project maps `ReplicatedStorage`, `ServerScriptService`, `StarterGui`, `StarterPlayer`, and `Workspace`.
- No nested duplicate `.git` folders were found.
- `CharacterRegistry.lua` now owns the six-character roster, source reference paths, income values, sell values, variant definitions, weights, and animation styles.
- `BrainrotModelFactory.lua` is the active polished model factory.
- `CharacterModelFactory.lua` remains as a compatibility shim for older require paths.
- `BrainrotAnimationService.lua` is the active animation-service wrapper.
- `CharacterAnimationService.lua` still contains the unique idle/intro implementation for the roster.

## Character Roster

Each registry entry includes:

- `Id`
- `DisplayName`
- `Rarity`
- `BaseFruit`
- `BaseIncome`
- `SellValue`
- `ColorTheme`
- `ShortDescription`
- `ReferencePath`
- `ReferenceFolderPath`
- `BaseReferenceImagePath`
- `NotesPath`
- `IncomeMultiplier`
- `Weight`
- `StyleTags`
- `AnimationStyle`
- `Variants` / `VariantDefinitions`

Supported shared variants:

- `Base`
- `Golden`
- `Diamond`
- `Galaxy`
- `Rainbow`
- `Toxic`
- `Cosmic`

Aliases preserve older reward data names:

- `Normal` -> `Base`
- `Shiny` -> `Rainbow`
- `BananitoBandito` -> `BananaBandito`

## Model Factory

Active module:

`src/ReplicatedStorage/BrainrotFruits/Modules/BrainrotModelFactory.lua`

The factory creates Roblox-native, part-based placeholder mascots for all six characters. No external meshes or uploaded assets are required.

Visual polish now includes:

- rounder toy-like silhouettes using ball/cylinder/wedge parts
- layered contour pieces and stronger silhouette-specific shapes
- large readable face panels, face frames, and eyes
- chibi arms, legs, shoes, and accessories
- character-specific props such as hat, bandana, club, sunglasses, chain, sumo belt, bow, leaves, and rind stripes
- attached premium variant accent parts for non-base variants
- per-part `AnimationRole` and `VariantColorRole` attributes for animation and variant styling

Final imported meshes can replace these builders later by swapping the character builder inside `BrainrotModelFactory` while preserving model attributes and `PrimaryPart`.

## Variants

Active module:

`src/ReplicatedStorage/BrainrotFruits/Modules/CharacterVariantService.lua`

Variants are data-driven through `CharacterRegistry.VariantDefinitions`.

- `Base`: original fruit colors, no aura.
- `Golden`: gold palette, metal body accents, subtle sparkles.
- `Diamond`: icy blue-white palette, crystalline material on non-face parts, glints.
- `Galaxy`: purple/blue cosmic palette, star particles.
- `Rainbow`: color cycling on fruit/accent parts with sparkles.
- `Toxic`: lime/purple palette with bubble-style particles.
- `Cosmic`: high-tier purple/blue star aura.

Faces, eyes, and skin panels intentionally keep their base material so variants stay readable.

## Animation

Active wrapper:

`src/ReplicatedStorage/BrainrotFruits/Modules/BrainrotAnimationService.lua`

Implementation:

`src/ReplicatedStorage/BrainrotFruits/Modules/CharacterAnimationService.lua`

Unique idle styles:

- Strawberita: cute wave, bounce, leaf/bow life.
- BananaBandito: hat tip, suspicious look, side-step feel.
- CoconuttoBonkini: club raise, chunky stomp, dust puff.
- LemonaldoSprintini: fast foot taps and runner dust.
- WatermeloniWobblino: slow wobble, stomp, heavy bounce.
- DragonfruttoDrippo: shades adjustment, cool nod, sparkle flash.

Idle cleanup is handled by `CharacterAnimationService.stopIdle(model)`, which cancels tweens/connections, restores original part CFrames, and removes transient VFX.

## Preview Gallery

Server script:

`src/ServerScriptService/BrainrotFruits/StrawberitaPreview.server.lua`

Preview/debug service:

`src/ServerScriptService/BrainrotFruits/CharacterSpawnService.lua`

Normal play mode spawns one base model of each character in the central hub preview. If `Workspace.BrainrotMap.DebugMode` is true, the preview spawns all variants. Preview stands now include layered pedestals, glow insets, compact nameplates, and rarity gems.

Studio command examples:

```lua
local svc = require(game.ServerScriptService.BrainrotFruits.CharacterSpawnService)
svc.spawnAllCharacters("Base", { clearFirst = true, playIntro = true })
svc.spawnAllVariants(nil, { clearFirst = true, playIntro = true })
svc.spawnPreview("DragonfruttoDrippo", "Cosmic", { clearFirst = true, playIntro = true })
```

## Reward Integration

`RewardService` now rolls characters from `CharacterRegistry.getWeightedCharacters()` and variants from `RarityConfig.DistanceBands`.

Reward creation path:

1. Pick distance band.
2. Roll character id from the registry.
3. Roll variant id from `RarityConfig`.
4. Build reward data with character base income/sell value plus variant multiplier.
5. Spawn model through `BrainrotModelFactory`.
6. Apply variant VFX.
7. Play reveal/intro burst.
8. Place secured reward through `PlotService`.
9. Start display idle animation and display platform presentation.
10. Grant a matching reward tool.

Existing Strawberita-specific wrappers remain compatible.

## Manual Studio Test Checklist

1. Run `rojo serve default.project.json`.
2. Connect Roblox Studio's Rojo plugin to `localhost:34872`.
3. Press Play.
4. Confirm `Workspace.BrainrotMap` loads without output errors.
5. Confirm central preview shows all six base characters.
6. Confirm labels and nameplates are readable and not giant boards.
7. Run `spawnAllVariants(nil, { clearFirst = true, playIntro = true })` from the command bar.
8. Confirm Base, Golden, Diamond, Galaxy, Rainbow, Toxic, and Cosmic variants render.
9. Confirm idle animations start and stop without jitter or drifting.
10. Confirm variant accents do not block faces or movement.
11. Launch from the shared catapult and confirm the reward flow still reveals, places, animates, and grants a tool.

## Validation Done

- `git pull --rebase origin main`: already up to date.
- Remote confirmed: `https://github.com/chshaythamasaad-commits/BrainrotFruits.git`
- `rojo build default.project.json --output BrainrotFruits_rojo_check.rbxlx`: passed.
- Temporary build artifact was removed.
- No nested `.git` folders found.
- No `.log`, `.rbxlx`, or `.rbxl` junk artifacts remained after validation.

No local Luau syntax/static checker was available in PATH, so final behavior still needs the manual Studio output check above.

## Known Limitations

- These are still Roblox-native placeholder models, not final imported art meshes.
- The preview gallery is intentionally simple and debug-friendly.
- Passive income saving, trading, rebirths, monetization, and full economy progression remain out of scope.
- Roster weights and variant odds are early tuning values.

## Recommended Next Pass

- Studio playtest and screenshot pass for scale/readability.
- Fine-tune individual character part proportions after seeing them in-camera.
- Add proper imported meshes one character at a time while preserving registry ids, attributes, and factory API.
- Add lightweight UI for preview spawning only if command-bar preview becomes annoying.
