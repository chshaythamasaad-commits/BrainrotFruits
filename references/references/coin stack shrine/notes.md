# Coin Stack Shrine Reference Notes

Use the images in this folder as the main visual/style reference for the Coin Stack Shrine.

Reference images:
- coin_stack_front.png
- coin_stack_top.png
- coin_stack_side.png
- coin_stack_back.png

Goal:
- bright modern classic Roblox coin stack shrine
- classic Roblox look modernized
- visible studs on major surfaces
- chunky block-built coin platforms
- simple octagonal coin-stack construction
- multiple golden coin stacks arranged as a small shrine/display
- taller central coin stack
- shorter surrounding coin stacks
- clean toy-like Roblox construction
- readable from a zoomed-out simulator camera

Do not directly copy another game's exact asset.
Use the references for shape language, proportions, color blocking, stud usage, coin-stack layout, and simulator-style readability only.

Important player-readability goals:
1. Player should instantly understand this is a coin / reward / group-join shrine.
2. Player should instantly see the taller central coin stack as the focal point.
3. Player should understand the surrounding coin stacks are part of one grouped display.
4. Player should distinguish this shrine from stalls, leaderboards, pads, and regular decoration.
5. The model should look rewarding, shiny, and important without needing text.

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

Coin stack shrine structure:
- group of octagonal golden coin stacks
- one taller central stack
- four or more shorter surrounding stacks
- stacks arranged in a compact cluster
- coins should be thick, chunky, and layered
- each coin layer should have an octagonal silhouette
- each stack should have visible horizontal layers
- top surfaces should be flat and readable
- top coin faces can include a simple raised currency symbol
- no characters or brainrot models on top
- no text signs
- no floating labels
- no gift icon

Approximate scale target:
- full shrine width: 22 to 32 studs
- full shrine depth: 18 to 28 studs
- central stack height: 8 to 14 studs
- surrounding stack height: 3 to 7 studs
- individual coin diameter: 7 to 12 studs
- coin layer thickness: 0.8 to 1.5 studs
- central stack should be clearly taller than the others

Construction guidance:
- use Roblox Parts as the primary building method
- use simple octagonal construction made from blocky parts
- use Plastic material by default
- use gold/yellow color family
- use visible studded surfaces or studded texture treatment on major parts
- use studs from surface/texture treatment only
- do not manually model studs as separate little blocks
- use clean grid-aligned dimensions
- keep the coin stacks chunky and toy-like
- keep the silhouette big and readable
- keep the hierarchy clean and modular

Suggested hierarchy:
CoinStackShrine
- CentralStack
  - CoinLayer01
  - CoinLayer02
  - CoinLayer03
  - CoinLayer04
  - CoinLayer05
  - CoinLayer06
  - TopCoin
  - CurrencySymbol
- FrontStack
  - CoinLayers
  - TopCoin
  - CurrencySymbol
- LeftStack
  - CoinLayers
  - TopCoin
  - CurrencySymbol
- RightStack
  - CoinLayers
  - TopCoin
  - CurrencySymbol
- BackStack
  - CoinLayers
  - TopCoin
  - CurrencySymbol
- OptionalSideStacks
  - CoinLayers
- BaseConnection
  - HiddenSupportParts

Color direction:
- main coin color: bright golden yellow
- side shading / lower layers: slightly darker gold
- raised currency symbols: deeper gold / orange-gold
- optional highlight strips: bright yellow
- avoid dull brown, realistic metal, or dirty coin colors
- keep everything bright and reward-like

Currency symbol guidance:
- top coin faces may have a simple raised symbol
- symbol should be large and simple
- symbol should be made from clean blocky parts or a decal/surface element
- symbol should not contain readable text
- symbol should not be over-detailed
- symbol should not make the model look realistic

Stud usage:
- studs are part of the identity, not optional decoration
- major visible surfaces should look studded
- top faces and side faces should show the classic Roblox studded look
- do not add manual stud geometry
- the studded look should come from surface/texture treatment only

Layout guidance:
- central stack should sit slightly behind or in the middle of the surrounding stacks
- front stack should be lower so the central stack remains visible
- side stacks should frame the central stack
- back stack can be partially hidden behind the central stack
- avoid perfectly flat height across all stacks
- avoid spreading stacks too far apart
- keep the shrine compact and readable as one grouped object

Collision and gameplay:
- static shrine parts should be Anchored = true
- main coin stacks can collide if players are not meant to walk through them
- decorative currency symbols can be CanCollide = false
- hidden support parts should be invisible or avoided if possible
- shrine should not block important player paths unless intentionally placed as a display object
- keep enough space around it for players to walk and view it

Do not add:
- brainrot creatures
- NPCs
- characters
- text
- floating labels
- gift icons
- realistic coin engraving
- realistic metal scratches
- tiny clutter props
- treasure chests
- gems
- random barrels or crates
- muted colors
- organic curves
- detailed mesh ornaments

Important quality rules:
- do not manually model studs as separate little parts
- use studded surfaces / studded texture treatment only
- do not leave visible gaps between connected coin layers
- coin layers that should touch must connect cleanly
- keep octagonal coin shapes consistent
- keep the stack heights intentional
- the shrine should look clean, connected, and professionally block-built
- no brainrots or creatures should appear on top of the coins

Studio inspection checklist:
1. Does the model immediately read as a coin stack shrine?
2. Does it match the reference images from front, top, side, and back views?
3. Is the taller central stack clearly the focal point?
4. Are the surrounding coin stacks arranged cleanly around it?
5. Are the coin shapes chunky and octagonal?
6. Are studs visible on major coin surfaces?
7. Are there no brainrot creatures, NPCs, text, or gift icons?
8. Are there no manual stud parts?
9. Are there no visible gaps between connected coin layers?
10. Are the colors bright, golden, and simulator-like?
11. Does it look Roblox-first instead of generic-3D-first?
12. Is the model hierarchy clean?
13. Would the asset fit beside bright green baseplates, orange studded walls, tan paths, sell stall, upgrades stalls, and leaderboard?

Reject and rebuild if:
- brainrots or characters are added
- text or labels are added
- it looks realistic
- it looks like generic low-poly instead of Roblox-studded
- the studs are missing from major surfaces
- manual stud parts were added
- there are visible gaps between connected coin layers
- coin stacks are not chunky or readable
- the central stack does not stand out
- the colors are dull or muted
- the model uses too much tiny detail
- the structure is not readable from a zoomed-out camera
- it would not visually fit in a bright modern Roblox simulator map