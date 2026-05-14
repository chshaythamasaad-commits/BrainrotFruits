# Catapult Upgrades Stall Reference Notes

Use the images in this folder as the main visual/style reference for the Catapult Upgrades Stall.

Reference images:
- catapult_upgrades_front_left.png
- catapult_upgrades_front.png
- catapult_upgrades_front_right.png
- catapult_upgrades_rear_right.png

Goal:
- bright modern classic Roblox catapult upgrades stall
- classic Roblox look modernized
- visible studs on major surfaces
- chunky block-built booth
- simple rectangular construction
- green and white striped roof canopy
- tan/orange and brown stall body
- dark brown trim and base
- glowing green interaction pad in front
- readable from a zoomed-out simulator camera
- clean toy-like Roblox construction

Do not directly copy another game's exact asset.
Use the references for shape language, proportions, color blocking, stud usage, and simulator-style readability only.

Important player-readability goals:
1. Player should instantly understand this is an upgrades stall.
2. Player should instantly see the glowing green interaction pad / interaction area.
3. Player should instantly distinguish this stall from the sell stall, run upgrades stall, shop stall, index stand, or leaderboard.
4. Player should understand this stall is tied to catapult upgrades through its unique green color theme.

Visual style:
- Modern Studded Roblox Simulator Style
- bright plastic colors
- classic Roblox studs as a major visual feature
- blocky and clean
- simple but polished
- toy-like proportions
- readable from a zoomed-out camera
- not realistic
- not generic low-poly
- not smooth minimalist
- not mesh-heavy
- not cluttered with tiny details

Catapult upgrades stall structure:
- rectangular raised booth
- recessed interior / counter basin
- four chunky vertical support posts
- dark brown lower trim/base layer
- tan/orange upper rim and counter
- flat striped canopy roof
- alternating green and white roof stripes
- front glowing green interaction pad
- thin green accent line on the base if desired
- strong color separation between roof, booth body, trim, and pad

Approximate scale target:
- stall width: 18 to 22 studs
- stall depth: 10 to 14 studs
- stall height: 12 to 15 studs
- interaction pad: 8 to 12 studs wide, 5 to 8 studs deep
- roof should overhang the booth slightly
- posts should be chunky, not thin

Construction guidance:
- use Roblox Parts as the primary building method
- prioritize blocks, slabs, plates, posts, frames, and simple trim
- use Plastic material by default
- use visible studded surfaces on major parts
- use Neon only for the interaction pad glow or thin green accent line if needed
- avoid MeshParts unless absolutely necessary
- avoid UnionOperations unless absolutely necessary
- avoid random rotations
- use grid-aligned dimensions
- keep proportions chunky and toy-like
- keep the silhouette big and readable
- keep the hierarchy clean and modular

Suggested hierarchy:
CatapultUpgradesStall
- Base
  - LowerBase
  - FrontTrim
  - BackTrim
  - LeftTrim
  - RightTrim
  - OptionalGreenAccentLine
- Counter
  - CounterWallFront
  - CounterWallBack
  - CounterWallLeft
  - CounterWallRight
  - InteriorFloor
  - TopRim
- Posts
  - FrontLeftPost
  - FrontRightPost
  - BackLeftPost
  - BackRightPost
  - PostFootBlocks
- Roof
  - RoofMain
  - RoofStripes
  - RoofFrontTrim
  - RoofBackTrim
  - RoofSideTrim
- Interaction
  - CatapultUpgradePad
  - PadBorder
  - PadGlow

Color direction:
- roof stripes: bright green and white
- interaction pad: bright neon green / light green
- optional glow/border: green neon
- upper stall/counter: tan/orange
- lower stall: medium brown
- base/trim: dark brown
- support posts: tan/orange

Collision and gameplay:
- static stall parts should be Anchored = true
- main base, counter, posts, and roof can collide
- purely visual trim and glow elements should usually not collide
- interaction pad should be obvious and placed directly in front of the stall
- interaction pad should not block player movement
- keep enough open space around the pad for players to stand

Stud usage:
- studs are part of the identity, not optional decoration
- major visible surfaces should look studded
- roof, posts, base, counter, and pad should all visibly use studs
- do not make the asset smooth unless a specific part needs to be smooth for readability
- do not add manual stud geometry
- the studded look should come from surface/texture treatment only

Do not add:
- text
- signs
- catapult models on the stall
- realistic wood grain
- realistic metal detail
- complex roof details
- tiny clutter props
- random barrels, crates, or decorations
- muted colors
- organic curved details
- detailed mesh ornaments
- overly thin supports
- fancy realistic architecture

Important quality rules:
- do not manually model studs as separate little parts
- use studded surfaces / studded texture treatment only
- do not leave visible gaps between connected parts
- structural parts that should touch must connect cleanly
- the stall should look clean, connected, and professionally block-built
- keep the design almost identical in structure to the run upgrades stall, but with green replacing the blue/yellow color identity

Studio inspection checklist:
1. Does the stall immediately read as an upgrade stall?
2. Does it match the reference images from multiple angles?
3. Are studs visible on the roof, posts, base, counter, and pad?
4. Is the green/white roof stripe pattern clear?
5. Is the glowing green interaction pad obvious?
6. Are the colors bright and simulator-like?
7. Is the silhouette chunky and simple?
8. Does it look Roblox-first instead of generic-3D-first?
9. Is the model hierarchy clean?
10. Would the asset fit beside bright green baseplates, orange studded walls, tan paths, sell stall, run upgrades stall, and leaderboard?

Reject and rebuild if:
- it looks realistic
- it looks like generic low-poly instead of Roblox-studded
- the studs are missing from major surfaces
- manual stud parts were added
- there are visible gaps between connected parts
- the interaction pad is unclear
- the green/white roof pattern is unclear
- the colors are dull or muted
- the model uses too much tiny detail
- the structure is not readable from a zoomed-out camera
- it would not visually fit in a bright modern Roblox simulator map