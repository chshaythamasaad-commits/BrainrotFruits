# Leaderboard Reference Notes

Use the images in this folder as the main visual/style reference for the Leaderboard.

Reference images:
- leaderboard_front_left.png
- leaderboard_front.png
- leaderboard_front_right.png
- leaderboard_rear_right.png

Goal:
- bright modern classic Roblox leaderboard
- classic Roblox look modernized
- visible studs on major surfaces
- chunky block-built monument/signboard
- simple rectangular construction
- large cream-colored display panel
- brown studded outer frame
- dark brown stepped base
- readable from a zoomed-out simulator camera
- clean toy-like Roblox construction

Do not directly copy another game's exact asset.
Use the references for shape language, proportions, color blocking, stud usage, silhouette, and simulator-style readability only.

Important player-readability goals:
1. Player should instantly understand this is a leaderboard/display board.
2. Player should instantly see the large cream display area.
3. Player should instantly distinguish it from stalls, shops, pads, and decorative props.
4. Player should understand that UI/text can be added later on top of the cream panel.

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

Leaderboard structure:
- large vertical freestanding board
- dark brown stepped base
- brown studded outer frame
- cream-colored central display panel
- stepped block crown at the top
- chunky side supports / frame columns
- small raised side blocks near the upper corners
- lower side block supports near the base
- strong silhouette with a top crown and wide side shoulders
- no internal row boxes
- no placeholder text
- no ranking lines
- no icons
- the inside should remain one clean cream-colored panel

Approximate scale target:
- leaderboard width: 20 to 28 studs
- leaderboard height: 24 to 34 studs
- leaderboard depth: 3 to 6 studs
- base width should be wider than the board
- base should have 2 or 3 stepped dark brown layers
- central cream panel should take most of the front face
- frame should be thick and chunky, not thin

Construction guidance:
- use Roblox Parts as the primary building method
- prioritize blocks, slabs, plates, frame pieces, and stepped trim
- use Plastic material by default
- use visible studded surfaces on major parts
- use studded surfaces / texture treatment only
- do not manually model studs as separate little parts
- avoid MeshParts unless absolutely necessary
- avoid UnionOperations unless absolutely necessary
- avoid random rotations
- use grid-aligned dimensions
- keep proportions chunky and toy-like
- keep the silhouette big and readable
- keep the hierarchy clean and modular

Suggested hierarchy:
Leaderboard
- Base
  - BottomStep
  - MiddleStep
  - TopStep
  - BaseTrim
- Frame
  - LeftFrameColumn
  - RightFrameColumn
  - TopFrame
  - BottomFrame
  - TopCrownCenter
  - TopCrownLeft
  - TopCrownRight
  - UpperLeftBlock
  - UpperRightBlock
  - LowerLeftBlock
  - LowerRightBlock
- DisplayPanel
  - CreamPanel
- BackSupport
  - RearPanel
  - RearSupports

Color direction:
- main outer frame: medium brown / reddish brown
- base: dark brown
- central display panel: cream / pale beige
- optional thin trim/shadow lines: darker brown
- avoid bright rainbow colors on this asset
- keep colors consistent with sell stall and upgrades stall environment

Display panel guidance:
- the center panel must remain cream-colored
- do not add internal rectangular boxes
- do not add fake leaderboard rows
- do not add text
- do not add icons
- leave the panel clean so real UI can be placed later
- panel should be flat, readable, and large

Stud usage:
- studs are part of the identity, not optional decoration
- major visible surfaces should look studded
- brown frame, cream panel, and dark base should all visibly use studs
- do not make the asset fully smooth
- do not add manual stud geometry
- the studded look should come from surface/texture treatment only

Collision and gameplay:
- static leaderboard parts should be Anchored = true
- main base and frame can collide
- purely visual trim and rear support pieces may be CanCollide = false if needed
- board should not block important player movement unless intentionally placed as scenery
- keep enough space in front for players to view it

Do not add:
- internal leaderboard row boxes
- placeholder names
- placeholder scores
- fake avatars
- text labels
- money icons
- realistic wood grain
- realistic stone or metal detail
- tiny clutter props
- muted colors
- organic curves
- detailed mesh ornaments
- overly thin supports
- fancy realistic architecture

Important quality rules:
- do not manually model studs as separate little parts
- use studded surfaces / studded texture treatment only
- do not leave visible gaps between connected parts
- structural parts that should touch must connect cleanly
- the leaderboard should look clean, connected, and professionally block-built
- the central cream panel must stay clean and empty

Studio inspection checklist:
1. Does the model immediately read as a leaderboard/display board?
2. Does it match the reference images from multiple angles?
3. Is the central cream panel clean and empty?
4. Are there no internal row boxes or placeholder text?
5. Are studs visible on the frame, display panel, and base?
6. Are the colors consistent with modern Roblox simulator style?
7. Is the silhouette chunky and simple?
8. Does the top crown/stepped frame shape match the references?
9. Does it look Roblox-first instead of generic-3D-first?
10. Is the model hierarchy clean?
11. Would the asset fit beside bright green baseplates, orange studded walls, tan paths, sell stall, and upgrades stall?

Reject and rebuild if:
- it has internal rectangular row boxes
- it has placeholder text or icons
- it looks realistic
- it looks like generic low-poly instead of Roblox-studded
- the studs are missing from major surfaces
- manual stud parts were added
- there are visible gaps between connected parts
- the central cream panel is not clean and empty
- the colors are dull or muted
- the model uses too much tiny detail
- the structure is not readable from a zoomed-out camera
- it would not visually fit in a bright modern Roblox simulator map