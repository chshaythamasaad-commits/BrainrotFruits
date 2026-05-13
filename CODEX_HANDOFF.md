# BrainrotFruits Codex Handoff

## Project Summary

BrainrotFruits is a Roblox/Rojo project for a game currently called "Catapult a Brainrot Fruit" / "BrainrotFruits."

Core concept:

Players use a catapult to launch a Brainrot Crate across a map. The distance reached determines rarity. The crate opens into a brainrot fruit character. A cartoon chaos hazard such as a banana monkey, chef knife curse, blender blade wall, or similar chase mechanic spawns. The player must survive, return, or claim the reward, place the brainrot fruit on their plot, earn money, and upgrade their catapult, luck, speed, and slots.

Core loop:

`Catapult -> Crash -> Reveal -> Escape -> Collect -> Place -> Earn -> Upgrade`

## Design Direction

BrainrotFruits is inspired by the general simulator loop of games like Kick a Lucky Block, but we do not want to fully copy it.

The unique hook should be:

- Catapult instead of kicking
- Brainrot fruit characters instead of lucky blocks
- Distance plus survival determines reward value
- Cartoon chaos hazards after landing
- Collectible brainrot fruits generate money on player plots

## Current Theme

The theme is TikTok/Italian-brainrot-inspired fruit characters. Use original parody-style brainrot fruits and characters rather than relying on exact disputed or copyrighted meme characters.

Main early character focus:

- Strawberita / Strawberina style fruit mascot
- Bananito Bonkito
- Applelini Slappelini
- Orangutango Mango
- Pineapplino Spinnino
- Dragonfrutto Delirium
- Crocodilo Watermelono
- The Forbidden Smoothie

Current reference files are stored in the `references/` folder.

## Technical Stack

- Roblox Studio
- Rojo
- Aftman
- Luau
- GitHub repo: https://github.com/chshaythamasaad-commits/BrainrotFruits.git

## How To Run Locally

1. Clone the repo:

   ```powershell
   git clone https://github.com/chshaythamasaad-commits/BrainrotFruits.git
   ```

2. Open the folder in VS Code.
3. Install tools:

   ```powershell
   aftman install
   ```

4. Start Rojo:

   ```powershell
   rojo serve default.project.json
   ```

5. Open Roblox Studio.
6. Open the Rojo plugin.
7. Connect to the running Rojo server.

## Current File Structure

Important files and folders:

- `src/`
- `src/client/`
- `src/server/`
- `src/shared/`
- `references/`
- `aftman.toml`
- `default.project.json`
- `README.md`
- `start-rojo.cmd`
- `start-rojo.ps1`
- `CODEX_HANDOFF.md`

## Current Implementation Status

This clean repo is currently a foundation project, not a playable prototype yet.

What exists now:

- Rojo project file at `default.project.json`
- Aftman tool config at `aftman.toml`
- Starter server script at `src/server/init.server.luau`
- Starter client script at `src/client/init.client.luau`
- Basic shared module at `src/shared/init.luau`
- Rojo helper scripts: `start-rojo.cmd` and `start-rojo.ps1`
- Strawberita reference material under `references/`

What is not implemented yet in this clean repo:

- No catapult gameplay system yet
- No remotes yet
- No player data service yet
- No plot assignment yet
- No map builder yet
- No rarity/reward service yet
- No inventory or saving yet
- No production UI yet

## Next Recommended Implementation Pass

Build the first playable foundation in small passes:

1. Server/client folder structure
2. Remotes
3. Player leaderstats
4. Player data service
5. Map setup service
6. Plot assignment
7. Catapult launch test
8. Distance-to-rarity calculation
9. Basic UI
10. Debug messages

Do not implement full inventory, saving, trading, rebirth, monetization, or advanced modeling yet unless specifically asked.

## Development Rules

- Work in small passes.
- After each pass, test in Roblox Studio.
- Keep systems modular.
- Use `ServerScriptService` for server logic.
- Use `ReplicatedStorage` for remotes/shared modules.
- Use `StarterGui` or client scripts for UI.
- Avoid deprecated `BodyVelocity`.
- Prefer `TweenService`, constraints, or `AssemblyLinearVelocity` where appropriate.
- Add clear debug prints.
- Update `CODEX_HANDOFF.md` after each major change.
- Commit and push after each working pass.

## Git Workflow For Collaborators

Always pull before starting:

```powershell
git pull --rebase origin main
```

Check status:

```powershell
git status
```

Commit meaningful changes:

```powershell
git add .
git commit -m "Clear message"
```

Push:

```powershell
git push origin main
```

If two people edit the same files, merge conflicts can happen. Resolve carefully and do not overwrite each other's work.

## Latest Handoff Summary

Date: 2026-05-13

This session verified that `BrainrotFruits_Clean` is the clean Git repo on `main` with origin set to:

https://github.com/chshaythamasaad-commits/BrainrotFruits.git

Added this handoff file and updated the README so another Codex or user can clone the project, run Rojo, understand the concept, and continue from the foundation state.

Next Codex should start with the first playable foundation pass: remotes, leaderstats, plot/map setup, and a basic catapult launch test.
