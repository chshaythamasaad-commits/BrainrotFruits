# Sell Stall Reference Notes

Use the images in this folder as the main visual/style reference for the Sell Stall.

Reference images:
- sell_stall_front_left.png
- sell_stall_front.png
- sell_stall_front_right.png
- sell_stall_rear_right.png

Goal:
- bright modern classic Roblox sell stall
- classic Roblox look modernized
- visible studs on major surfaces
- chunky block-built booth
- simple rectangular construction
- red studded roof canopy
- tan/orange and brown studded booth body
- dark brown trim and base blocks
- hanging sign that says Sell Brainrots
- red interaction/sell pad in front
- readable from a zoomed-out simulator camera
- clean toy-like Roblox construction

Do not directly copy another game's exact asset.
Use the references for shape language, proportions, color blocking, stud usage, and simulator-style readability only.

Important player-readability goals:
1. Player should instantly understand this is the sell stall.
2. Player should instantly see the red sell pad / interaction area.
3. Player should instantly read the hanging sign.
4. Player should instantly distinguish the stall from upgrades, shop, index, or other stands.

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

Sell stall structure:
- rectangular raised booth
- recessed interior / counter basin
- four chunky vertical support posts
- dark brown square foot blocks under the posts
- layered brown lower base
- tan/orange upper rim and counter
- bright red studded roof spanning the booth
- roof should feel slightly arched or stepped, but still built from blocky Roblox parts
- hanging rectangular sign suspended below the roof
- sign has a dark brown frame and tan/orange inner panel
- sign text reads Sell Brainrots
- front red studded pad for player interaction
- strong color separation between roof, booth body, trim, sign, and pad

Approximate scale target:
- booth width: 18 to 22 studs
- booth depth: 10 to 14 studs
- booth height: 13 to 16 studs
- interaction pad: 8 to 12 studs wide, 5 to 8 studs deep
- roof should overhang the booth slightly
- sign should be large enough to read from far away
- posts should be chunky, not thin

Construction guidance:
- use Roblox Parts as the primary building method
- prioritize blocks, slabs, plates, posts, frames, and simple trim
- use Plastic material by default
- use visible studded surfaces on major parts
- use Neon only if adding a glow effect to the interaction pad
- avoid MeshParts unless absolutely necessary
- avoid UnionOperations unless absolutely necessary
- avoid random rotations
- use grid-aligned dimensions
- keep proportions chunky and toy-like
- keep the silhouette big and readable
- keep the hierarchy clean and modular

Suggested hierarchy:
SellStall
- Base
  - LowerBase
  - FrontTrim
  - BackTrim
  - LeftTrim
  - RightTrim
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
  - RoofLeftSection
  - RoofRightSection
  - RoofFrontTrim
  - RoofBackTrim
  - RoofStudDetails
- Sign
  - SignFrame
  - SignPanel
  - SignText
  - HangingRods
- Interaction
  - SellPad
  - PadTrim
  - OptionalGlow

Color direction:
- roof: bright red
- sell pad: bright red or slightly lighter red
- booth upper body: tan/orange
- booth lower body: medium brown
- trim/base blocks: dark brown
- sign frame: dark brown
- sign panel: tan/orange
- sign text: red with dark outline
- optional pad glow: red or red-orange

Collision and gameplay:
- static booth parts should be Anchored = true
- main base, counter, posts, and roof can collide
- sign, hanging rods, decorative trim, and glow effects should usually not collide
- interaction pad should be obvious and placed directly in front of the stall
- interaction pad should not block player movement
- keep enough open space around the pad for players to stand

Sign guidance:
- sign must be oversized and readable
- sign should face the player-facing/front direction
- use a SurfaceGui/TextLabel or equivalent readable text system
- text should say Sell Brainrots unless the project requires a different sell label
- text should use red fill with dark outline or shadow when possible

Stud usage:
- studs are part of the identity, not optional decoration
- major visible surfaces should look studded
- roof, posts, base, counter, and pad should all visibly use studs
- do not make the asset smooth unless a specific part needs to be smooth for readability

Do not add:
- realistic wood grain
- realistic metal detail
- complex roof shingles
- tiny clutter props
- random barrels, crates, or decorations
- muted colors
- organic curved details
- detailed mesh ornaments
- overly thin supports
- fancy realistic architecture

Studio inspection checklist:
1. Does the stall immediately read as a sell stall?
2. Does it match the reference images from multiple angles?
3. Are studs visible on the roof, posts, base, counter, and pad?
4. Is the sign large and readable?
5. Is the red interaction pad obvious?
6. Are the colors bright and simulator-like?
7. Is the silhouette chunky and simple?
8. Does it look Roblox-first instead of generic-3D-first?
9. Is the model hierarchy clean?
10. Would the asset fit beside bright green baseplates, orange studded walls, tan paths, and other modern Roblox simulator structures?

Reject and rebuild if:
- it looks realistic
- it looks like generic low-poly instead of Roblox-studded
- the studs are missing from major surfaces
- the sign is too small
- the interaction pad is unclear
- the colors are dull or muted
- the model uses too much tiny detail
- the structure is not readable from a zoomed-out camera
- it would not visually fit in a bright modern Roblox simulator map