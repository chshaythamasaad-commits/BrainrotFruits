# Dirt Block 4x4 Reference Notes

Use the images in this folder as the main visual/style reference for the Dirt Block.

Reference images:
- dirt_block_front_left.png
- dirt_block_front.png
- dirt_block_front_right.png
- dirt_block_rear_right.png

Goal:
- bright modern classic Roblox dirt block
- one clean cube
- exactly 4 studs long
- exactly 4 studs wide
- exactly 4 studs tall
- one uniform orange dirt color
- visible 4x4 stud pattern on every visible face
- clean toy-like Roblox construction
- matches the dirt wall blocks from the reference screenshots

This is a single modular building block.
Do not make a wall.
Do not make terrain.
Do not make a panel.
Do not make a rectangular slab.
Do not make multiple blocks together.

Important:
The block must be a true cube:
- Size: 4 x 4 x 4 studs
- Every face should visually show a 4 x 4 stud grid
- Total visual studs per face: 16
- Same color across the whole block
- No checkerboard shading
- No second dirt shade on this asset

Visual style:
- Modern Studded Roblox Simulator Style
- classic Roblox studs as a major visual feature
- bright plastic material
- clean blocky cube
- readable from a zoomed-out camera
- not realistic
- not Minecraft
- not low-poly terrain
- not noisy
- not textured like real dirt

Color direction:
- single uniform orange dirt shade
- estimated hex: #E18B4D
- estimated RGB: 225, 139, 77
- if this looks too bright in Studio lighting, slightly adjust toward #D98C4A
- do not use multiple dirt shades on this block
- do not add random dark patches or noise

Shape requirements:
- perfect cube
- no bevels that change the silhouette
- no rounded cube corners unless extremely subtle
- no cracks
- no dirt noise
- no grass
- no side decorations
- no edge trim
- no extra parts attached

Stud requirements:
- each face should visually show exactly 4 studs by 4 studs
- studs should be evenly spaced
- studs should align to the block grid
- studs should be the same color as the block or very slightly shaded by lighting only
- studs should look like the wall reference: raised square/rounded-square Roblox-style studs
- do not manually place individual stud parts unless absolutely unavoidable
- preferred method: studded surface / texture / decal / SurfaceAppearance treatment
- avoid separate physical stud geometry because it can create inconsistent spacing and messy results

Construction guidance:
- use a single reusable block model
- name it `DirtBlock_4x4`
- anchor it by default
- use Plastic material by default
- keep pivot/origin centered
- keep orientation simple and grid-aligned
- front, back, left, right, top, and bottom should all use the same stud pattern
- the block must be easy to duplicate into a wall grid

Suggested hierarchy:
DirtBlock_4x4
- CoreBlock
- StudTextureFront
- StudTextureBack
- StudTextureLeft
- StudTextureRight
- StudTextureTop
- StudTextureBottom

If the stud treatment can be applied directly to the CoreBlock without separate texture objects, that is preferred.

Approximate Roblox settings:
- Size: Vector3.new(4, 4, 4)
- Material: Plastic
- Color: Color3.fromRGB(225, 139, 77)
- Anchored: true
- CanCollide: true
- CanTouch: false unless needed
- CanQuery: true

Usage goal:
This block will be duplicated many times to build the orange dirt wall.
It must tile perfectly with no gaps when placed next to another 4x4 block.

Tiling rules:
- adjacent blocks should touch exactly edge-to-edge
- no gaps between blocks
- no overlap between blocks
- grid placement should use 4-stud increments
- block centers should align on a 4-stud grid
- texture/stud pattern should remain consistent across repeated blocks

Do not add:
- grass
- multiple colors
- manual random shading
- real dirt texture
- cracks
- rocks
- mesh clutter
- extra trims
- extra studs beyond 4x4 per face
- any labels or text

Studio inspection checklist:
1. Is the block exactly 4 x 4 x 4 studs?
2. Is it a true cube, not a slab or panel?
3. Does each visible face show exactly 4 x 4 studs?
4. Is the color one uniform orange dirt shade?
5. Does it match the orange dirt wall from the screenshots?
6. Does it tile perfectly with copies on a 4-stud grid?
7. Are there no gaps when blocks touch?
8. Are there no manually inconsistent studs?
9. Does it look Roblox-first instead of generic 3D?
10. Is the model clean and reusable?

Reject and rebuild if:
- it is not a 4x4x4 cube
- it has more or fewer than 4x4 studs per face
- it uses multiple dirt shades
- it has checkerboard coloring
- it has grass
- it has realistic dirt texture
- it has noisy surface detail
- it has gaps when tiled with copies
- it does not visually match the orange studded wall reference