# Grass Side Block 4x2 Reference Notes

Use the images in this folder as the main visual/style reference for the Grass Side Block.

Reference images:
- grass_side_block_front_left.png
- grass_side_block_front.png
- grass_side_block_front_right.png
- grass_side_block_rear_right.png

Goal:
- bright modern classic Roblox grass side block
- one clean modular rectangular block
- used to build the hanging / stepped grass edge on the side of the dirt wall
- bright plastic grass green
- visible studs on every visible face
- clean toy-like Roblox construction
- matches the grass lip / side edge from the reference screenshots

This is a single modular building block.
Do not make a wall.
Do not make terrain.
Do not make a full grass platform.
Do not make multiple blocks together.

Important:
This block is not the full top grass cube.
This is the side grass piece used for the green overhang / downward step shape on the wall.

Core dimensions:
- 4 studs long
- 4 studs tall
- 2 studs deep / thick

In other words:
- a 4 x 4 front face
- a 4 x 2 top face
- a 2 x 4 side face

Visual style:
- Modern Studded Roblox Simulator Style
- classic Roblox studs as a major visual feature
- bright plastic material
- clean blocky rectangular shape
- readable from a zoomed-out camera
- not realistic
- not Minecraft
- not terrain noise
- not a rough rock shape
- not cluttered

Color direction:
- one uniform bright grass green for this variant
- estimated hex: #6FD92F
- estimated RGB: 111, 217, 47
- if it looks too neon in Studio lighting, slightly adjust toward #67CF2F
- do not add multiple green shades on this single asset
- do not add checkerboard variation
- do not add random dark patches

Shape requirements:
- clean rectangular prism
- dimensions must stay exact
- no bevels that change the silhouette
- no rounded corners unless extremely subtle
- no grass blades
- no noise
- no cracks
- no extra trim
- no attached dirt
- no extra parts attached

Stud requirements:
- front face should visually show exactly 4 x 4 studs
- back face should visually show exactly 4 x 4 studs
- top face should visually show exactly 4 x 2 studs
- bottom face should visually show exactly 4 x 2 studs
- each side face should visually show exactly 2 x 4 studs
- studs should be evenly spaced
- studs should align to the block grid
- studs should be the same green color as the block, or only slightly changed by lighting
- preferred method: studded surface / texture / decal / SurfaceAppearance treatment
- avoid separate physical stud geometry because it can create messy spacing and bad tiling

Construction guidance:
- use a single reusable block model
- name it `GrassSideBlock_4x2`
- anchor it by default
- use Plastic material by default
- keep pivot/origin centered
- keep orientation simple and grid-aligned
- front, back, left, right, top, and bottom should all use the correct stud pattern for their face dimensions
- the block must be easy to duplicate into a stepped grass edge

Suggested hierarchy:
GrassSideBlock_4x2
- CoreBlock
- StudTextureFront
- StudTextureBack
- StudTextureLeft
- StudTextureRight
- StudTextureTop
- StudTextureBottom

If the stud treatment can be applied directly to the CoreBlock without separate texture objects, that is preferred.

Approximate Roblox settings:
- Size: Vector3.new(4, 4, 2)
- Material: Plastic
- Color: Color3.fromRGB(111, 217, 47)
- Anchored: true
- CanCollide: true
- CanTouch: false unless needed
- CanQuery: true

Usage goal:
This block will be duplicated many times to build the green side grass edge / overhang on the dirt wall.
It should work as the modular piece that creates the stepped downward silhouette under the top grass layer.

Placement / tiling rules:
- adjacent blocks should touch exactly edge-to-edge
- no gaps between blocks
- no overlap between blocks
- grid placement should use 4-stud increments horizontally and vertically where intended
- the 2-stud thickness should stay consistent
- block centers and edges should align cleanly to the project grid
- the block should be easy to place in a stepped pattern using simple offsets or noise-based placement logic

Design intent:
- this piece is meant to sit along the top edge / side edge of the wall
- repeated copies form the jagged green overhang silhouette
- the top grass layer remains uniform
- this side block creates the visible hanging grass shape seen in the screenshots

Do not add:
- dirt color
- attached dirt block
- grass blades
- realistic grass texture
- checkerboard shading
- cracks
- rocks
- mesh clutter
- extra trims
- labels or text
- any wall generation logic in the asset itself

Studio inspection checklist:
1. Is the block exactly 4 x 4 x 2 studs?
2. Is it a clean rectangular prism?
3. Does the front face show exactly 4 x 4 studs?
4. Does the top face show exactly 4 x 2 studs?
5. Do the side faces show exactly 2 x 4 studs?
6. Is the color one uniform bright green shade?
7. Does it visually match the grass side edge from the screenshots?
8. Does it tile perfectly with copies?
9. Are there no gaps when blocks touch?
10. Are there no inconsistent manually placed studs?
11. Is the model clean and reusable?

Reject and rebuild if:
- it is not exactly 4 x 4 x 2
- it is not a clean rectangular prism
- the face stud counts are wrong
- it uses multiple green shades on this asset
- it has attached dirt
- it has grass blades or realistic grass texture
- it has noisy or random surface detail
- it has gaps when tiled
- it does not visually match the green side grass edge reference