local CharacterRegistry = require(script.Parent.CharacterRegistry)
local CharacterVariantService = require(script.Parent.CharacterVariantService)

local CharacterModelFactory = {}

CharacterModelFactory.Version = "CharacterPlaceholderFactory_V1"

local DEFAULT_SCALE = 0.92

local PALETTE = {
	White = Color3.fromRGB(255, 255, 245),
	Black = Color3.fromRGB(20, 20, 24),
	Skin = Color3.fromRGB(255, 201, 175),
	Cheek = Color3.fromRGB(255, 122, 150),
}

local function scaled(vector, scale)
	return Vector3.new(vector.X * scale, vector.Y * scale, vector.Z * scale)
end

local function angles(x, y, z)
	return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
end

local function setupPart(model, root, config, scale)
	local part = Instance.new(config.className or "Part")
	part.Name = config.name
	part.Size = scaled(config.size, scale)
	part.CFrame = root.CFrame * CFrame.new(scaled(config.offset, scale)) * (config.rotation or CFrame.new())
	part.Color = config.color
	part.Material = config.material or Enum.Material.SmoothPlastic
	part.Transparency = config.transparency or 0
	part.Anchored = root.Anchored
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part:SetAttribute("BrainrotCharacterPart", true)
	part:SetAttribute("CharacterPartRole", config.role or "Detail")
	part:SetAttribute("AnimationRole", config.animationRole or config.role or "Detail")
	part:SetAttribute("VariantColorRole", config.colorRole or "Accessory")
	part:SetAttribute("StrawberitaRole", config.legacyStrawberitaRole or config.role or "Detail")
	part:SetAttribute("BaseColor", config.color)
	part:SetAttribute("BaseMaterial", part.Material.Name)
	part.Parent = model

	local weld = Instance.new("WeldConstraint")
	weld.Name = "BaseTemplateWeld"
	weld.Part0 = root
	weld.Part1 = part
	weld.Parent = part

	return part
end

local function add(parts, name, role, colorRole, size, offset, color, material, rotation, className, animationRole)
	table.insert(parts, {
		name = name,
		role = role,
		colorRole = colorRole,
		size = size,
		offset = offset,
		color = color,
		material = material,
		rotation = rotation,
		className = className,
		animationRole = animationRole,
	})
end

local function addFace(parts, y, z, faceColor, eyeColor, smileColor)
	add(parts, "FacePanel", "Face", "Face", Vector3.new(2.55, 1.22, 0.14), Vector3.new(0, y, z), faceColor or PALETTE.Skin)
	add(parts, "LeftEye", "Eye", "Eye", Vector3.new(0.42, 0.48, 0.15), Vector3.new(-0.55, y + 0.18, z - 0.08), eyeColor or PALETTE.Black, Enum.Material.SmoothPlastic, nil, nil, "EyeLeft")
	add(parts, "RightEye", "Eye", "Eye", Vector3.new(0.42, 0.48, 0.15), Vector3.new(0.55, y + 0.18, z - 0.08), eyeColor or PALETTE.Black, Enum.Material.SmoothPlastic, nil, nil, "EyeRight")
	add(parts, "LeftEyeHighlight", "Eye", "Eye", Vector3.new(0.13, 0.13, 0.16), Vector3.new(-0.67, y + 0.34, z - 0.16), PALETTE.White, Enum.Material.Neon)
	add(parts, "RightEyeHighlight", "Eye", "Eye", Vector3.new(0.13, 0.13, 0.16), Vector3.new(0.43, y + 0.34, z - 0.16), PALETTE.White, Enum.Material.Neon)
	add(parts, "LeftCheek", "Cheek", "Face", Vector3.new(0.34, 0.16, 0.13), Vector3.new(-0.95, y - 0.24, z - 0.09), PALETTE.Cheek)
	add(parts, "RightCheek", "Cheek", "Face", Vector3.new(0.34, 0.16, 0.13), Vector3.new(0.95, y - 0.24, z - 0.09), PALETTE.Cheek)
	add(parts, "Smile", "Mouth", "Eye", Vector3.new(0.36, 0.08, 0.14), Vector3.new(0, y - 0.42, z - 0.12), smileColor or PALETTE.Black)
end

local function addChibiLimbs(parts, armColor, skinColor, sockColor, shoeColor)
	add(parts, "LeftArmBlock", "Arm", "Fruit", Vector3.new(0.42, 0.82, 0.42), Vector3.new(-1.62, -0.55, -0.08), armColor, nil, angles(0, 0, -12), nil, "LeftArm")
	add(parts, "RightArmBlock", "Arm", "Fruit", Vector3.new(0.42, 0.82, 0.42), Vector3.new(1.62, -0.55, -0.08), armColor, nil, angles(0, 0, 12), nil, "RightArm")
	add(parts, "LeftHandBlock", "Hand", "Skin", Vector3.new(0.35, 0.28, 0.36), Vector3.new(-1.75, -1.1, -0.12), skinColor or PALETTE.Skin, nil, nil, nil, "LeftArm")
	add(parts, "RightHandBlock", "Hand", "Skin", Vector3.new(0.35, 0.28, 0.36), Vector3.new(1.75, -1.1, -0.12), skinColor or PALETTE.Skin, nil, nil, nil, "RightArm")
	add(parts, "LeftLegBlock", "Leg", "Outfit", Vector3.new(0.36, 0.48, 0.36), Vector3.new(-0.48, -1.52, -0.02), sockColor or PALETTE.White, nil, nil, nil, "LeftLeg")
	add(parts, "RightLegBlock", "Leg", "Outfit", Vector3.new(0.36, 0.48, 0.36), Vector3.new(0.48, -1.52, -0.02), sockColor or PALETTE.White, nil, nil, nil, "RightLeg")
	add(parts, "LeftFootBlock", "Foot", "Shoe", Vector3.new(0.7, 0.38, 0.8), Vector3.new(-0.55, -1.92, -0.16), shoeColor, nil, nil, nil, "LeftFoot")
	add(parts, "RightFootBlock", "Foot", "Shoe", Vector3.new(0.7, 0.38, 0.8), Vector3.new(0.55, -1.92, -0.16), shoeColor, nil, nil, nil, "RightFoot")
end

local function strawberryParts()
	local parts = {}
	local red = Color3.fromRGB(239, 52, 61)
	local redDark = Color3.fromRGB(207, 39, 49)
	local green = Color3.fromRGB(93, 181, 28)
	local pink = Color3.fromRGB(255, 82, 110)

	add(parts, "HeadRowBottom", "Head", "Fruit", Vector3.new(3.0, 0.52, 2.35), Vector3.new(0, 0.25, 0), red)
	add(parts, "HeadRowMiddle", "Head", "Fruit", Vector3.new(4.25, 1.22, 2.9), Vector3.new(0, 1.18, 0), red)
	add(parts, "HeadRowUpper", "Head", "Fruit", Vector3.new(3.75, 0.86, 2.7), Vector3.new(0, 2.26, 0), red)
	add(parts, "HeadTop", "Head", "Fruit", Vector3.new(2.8, 0.48, 2.18), Vector3.new(0, 2.92, 0), red)
	add(parts, "LeftHeadSideMass", "Head", "FruitDark", Vector3.new(0.5, 1.8, 2.45), Vector3.new(-2.25, 1.35, 0), redDark)
	add(parts, "RightHeadSideMass", "Head", "FruitDark", Vector3.new(0.5, 1.8, 2.45), Vector3.new(2.25, 1.35, 0), redDark)
	addFace(parts, 1.36, -1.64, Color3.fromRGB(255, 199, 174))

	for index, data in ipairs({
		{ -1.25, 2.25 }, { 0, 2.48 }, { 1.25, 2.25 },
		{ -1.7, 1.55 }, { 1.7, 1.55 }, { -1.22, 0.52 }, { 1.22, 0.52 },
	}) do
		add(parts, `Seed{index}`, "Seed", "Seed", Vector3.new(0.22, 0.22, 0.12), Vector3.new(data[1], data[2], -1.54), Color3.fromRGB(255, 221, 45), Enum.Material.SmoothPlastic)
	end

	add(parts, "LeafFrontShelf", "Leaf", "Leaf", Vector3.new(3.35, 0.34, 1.05), Vector3.new(0, 3.2, -0.42), green, Enum.Material.Grass, nil, nil, "Leaf")
	add(parts, "LeafBackShelf", "Leaf", "Leaf", Vector3.new(3.45, 0.32, 1.1), Vector3.new(0, 3.17, 0.48), green:Lerp(Color3.fromRGB(20, 90, 20), 0.2), Enum.Material.Grass, nil, nil, "Leaf")
	add(parts, "LeafLeftBlock", "Leaf", "Leaf", Vector3.new(0.9, 0.36, 1.1), Vector3.new(-1.2, 3.33, -0.45), green, Enum.Material.Grass, angles(-5, -25, 0), "WedgePart", "Leaf")
	add(parts, "LeafRightBlock", "Leaf", "Leaf", Vector3.new(0.9, 0.36, 1.1), Vector3.new(1.2, 3.33, -0.45), green, Enum.Material.Grass, angles(-5, 25, 0), "WedgePart", "Leaf")
	add(parts, "StemBlock", "Stem", "Leaf", Vector3.new(0.42, 0.6, 0.42), Vector3.new(0, 3.78, 0.05), Color3.fromRGB(76, 142, 33), Enum.Material.Wood, nil, nil, "Leaf")

	add(parts, "BowKnot", "Bow", "Accent", Vector3.new(0.34, 0.34, 0.14), Vector3.new(-1.35, 2.52, -1.75), pink, nil, nil, nil, "Head")
	add(parts, "BowLeftLoop", "Bow", "Accent", Vector3.new(0.58, 0.45, 0.14), Vector3.new(-1.78, 2.54, -1.74), pink, nil, angles(0, 0, 8), nil, "Head")
	add(parts, "BowRightLoop", "Bow", "Accent", Vector3.new(0.58, 0.45, 0.14), Vector3.new(-0.92, 2.54, -1.74), pink, nil, angles(0, 0, -8), nil, "Head")
	add(parts, "DressBlock", "Body", "Outfit", Vector3.new(2.25, 0.85, 1.5), Vector3.new(0, -0.62, 0), red)
	add(parts, "SkirtTrim", "Detail", "Face", Vector3.new(2.55, 0.18, 0.16), Vector3.new(0, -1.08, -0.78), PALETTE.White)
	addChibiLimbs(parts, red, PALETTE.Skin, Color3.fromRGB(255, 177, 202), Color3.fromRGB(232, 40, 49))
	return parts
end

local function bananitoParts()
	local parts = {}
	local yellow = Color3.fromRGB(255, 218, 72)
	local yellowDark = Color3.fromRGB(226, 171, 44)
	local brown = Color3.fromRGB(112, 72, 39)
	local red = Color3.fromRGB(198, 54, 48)

	add(parts, "BananaBodyLower", "Head", "Fruit", Vector3.new(2.35, 1.15, 1.8), Vector3.new(0, 0.25, 0), yellow)
	add(parts, "BananaBodyMid", "Head", "Fruit", Vector3.new(2.65, 1.55, 1.95), Vector3.new(0, 1.2, 0), yellow)
	add(parts, "BananaBodyTop", "Head", "Fruit", Vector3.new(2.05, 0.95, 1.65), Vector3.new(0, 2.35, 0), yellow)
	add(parts, "LeftPeelSide", "Head", "FruitDark", Vector3.new(0.36, 2.5, 1.72), Vector3.new(-1.45, 1.45, 0), yellowDark)
	add(parts, "RightPeelSide", "Head", "FruitDark", Vector3.new(0.36, 2.5, 1.72), Vector3.new(1.45, 1.45, 0), yellowDark)
	add(parts, "PeelCrownLeft", "Leaf", "Accent", Vector3.new(0.46, 0.86, 0.46), Vector3.new(-0.55, 3.12, -0.1), yellowDark, nil, angles(0, 0, -18), nil, "Leaf")
	add(parts, "PeelCrownRight", "Leaf", "Accent", Vector3.new(0.46, 0.86, 0.46), Vector3.new(0.55, 3.12, -0.1), yellowDark, nil, angles(0, 0, 18), nil, "Leaf")
	addFace(parts, 1.28, -1.05, Color3.fromRGB(255, 236, 168), Color3.fromRGB(42, 31, 20))
	add(parts, "CowboyHatBrim", "Hat", "Accessory", Vector3.new(3.1, 0.25, 2.2), Vector3.new(0, 3.25, 0), brown, Enum.Material.Wood, nil, nil, "Hat")
	add(parts, "CowboyHatCrown", "Hat", "Accessory", Vector3.new(1.55, 0.72, 1.35), Vector3.new(0, 3.68, 0), brown, Enum.Material.Wood, nil, nil, "Hat")
	add(parts, "Bandana", "Outfit", "Outfit", Vector3.new(2.25, 0.34, 0.18), Vector3.new(0, -0.1, -0.92), red)
	add(parts, "Belt", "Outfit", "Accessory", Vector3.new(2.35, 0.26, 0.2), Vector3.new(0, -0.83, -0.83), brown)
	add(parts, "Buckle", "Outfit", "Accent", Vector3.new(0.44, 0.38, 0.22), Vector3.new(0, -0.83, -0.96), Color3.fromRGB(255, 204, 69), Enum.Material.Metal)
	addChibiLimbs(parts, yellow, Color3.fromRGB(255, 225, 148), Color3.fromRGB(247, 213, 88), brown)
	return parts
end

local function coconuttoParts()
	local parts = {}
	local brown = Color3.fromRGB(116, 73, 43)
	local dark = Color3.fromRGB(68, 43, 30)
	local cream = Color3.fromRGB(255, 236, 190)
	local tunic = Color3.fromRGB(184, 120, 49)

	add(parts, "CoconutLower", "Head", "Fruit", Vector3.new(3.05, 1.15, 2.65), Vector3.new(0, 0.28, 0), brown)
	add(parts, "CoconutMid", "Head", "Fruit", Vector3.new(3.45, 1.45, 2.95), Vector3.new(0, 1.2, 0), brown)
	add(parts, "CoconutUpper", "Head", "Fruit", Vector3.new(3.0, 0.95, 2.5), Vector3.new(0, 2.28, 0), brown)
	add(parts, "CoconutCreamTop", "Head", "Accent", Vector3.new(2.25, 0.34, 1.8), Vector3.new(0, 2.9, -0.02), cream)
	add(parts, "CrackLineA", "Detail", "FruitDark", Vector3.new(0.16, 1.0, 0.12), Vector3.new(-0.85, 1.95, -1.45), dark, nil, angles(0, 0, -18), nil, "Head")
	add(parts, "CrackLineB", "Detail", "FruitDark", Vector3.new(0.14, 0.75, 0.12), Vector3.new(0.82, 1.8, -1.48), dark, nil, angles(0, 0, 24), nil, "Head")
	addFace(parts, 1.25, -1.52, Color3.fromRGB(236, 180, 126), Color3.fromRGB(30, 21, 15))
	add(parts, "TunicBlock", "Outfit", "Outfit", Vector3.new(2.35, 0.9, 1.5), Vector3.new(0, -0.65, 0), tunic)
	add(parts, "TunicSpotA", "Detail", "Accent", Vector3.new(0.3, 0.22, 0.12), Vector3.new(-0.58, -0.5, -0.82), dark)
	add(parts, "TunicSpotB", "Detail", "Accent", Vector3.new(0.34, 0.22, 0.12), Vector3.new(0.62, -0.82, -0.82), dark)
	add(parts, "ClubHandle", "Club", "Accessory", Vector3.new(0.22, 1.2, 0.22), Vector3.new(1.95, -0.55, -0.1), Color3.fromRGB(117, 70, 39), Enum.Material.Wood, angles(0, 0, -20), nil, "RightArm")
	add(parts, "ClubHead", "Club", "Accessory", Vector3.new(0.52, 0.68, 0.52), Vector3.new(2.18, 0.03, -0.1), Color3.fromRGB(88, 55, 34), Enum.Material.Wood, angles(0, 0, -20), nil, "RightArm")
	addChibiLimbs(parts, brown, Color3.fromRGB(225, 168, 119), Color3.fromRGB(184, 120, 49), dark)
	return parts
end

local function lemonaldoParts()
	local parts = {}
	local yellow = Color3.fromRGB(255, 223, 63)
	local yellowDark = Color3.fromRGB(228, 181, 37)
	local green = Color3.fromRGB(68, 178, 78)
	local outfit = Color3.fromRGB(56, 190, 92)

	add(parts, "LemonLower", "Head", "Fruit", Vector3.new(2.65, 1.05, 2.0), Vector3.new(0, 0.35, 0), yellow)
	add(parts, "LemonMid", "Head", "Fruit", Vector3.new(3.15, 1.42, 2.25), Vector3.new(0, 1.32, 0), yellow)
	add(parts, "LemonUpper", "Head", "Fruit", Vector3.new(2.55, 0.88, 1.95), Vector3.new(0, 2.38, 0), yellow)
	add(parts, "LeftLemonPoint", "Head", "FruitDark", Vector3.new(0.5, 0.8, 1.65), Vector3.new(-1.68, 1.35, 0), yellowDark)
	add(parts, "RightLemonPoint", "Head", "FruitDark", Vector3.new(0.5, 0.8, 1.65), Vector3.new(1.68, 1.35, 0), yellowDark)
	add(parts, "HeadbandFront", "Outfit", "Outfit", Vector3.new(2.9, 0.22, 0.16), Vector3.new(0, 2.18, -1.14), PALETTE.White, nil, nil, nil, "Head")
	add(parts, "HeadbandStripe", "Outfit", "Accent", Vector3.new(2.0, 0.12, 0.17), Vector3.new(0, 2.18, -1.24), green, Enum.Material.Neon, nil, nil, "Head")
	add(parts, "LeafTop", "Leaf", "Leaf", Vector3.new(0.88, 0.32, 0.76), Vector3.new(0.42, 3.02, -0.08), green, Enum.Material.Grass, angles(0, 25, 8), "WedgePart", "Leaf")
	add(parts, "StemBlock", "Stem", "Leaf", Vector3.new(0.32, 0.48, 0.32), Vector3.new(-0.2, 3.1, 0), green:Lerp(Color3.fromRGB(40, 90, 35), 0.35), Enum.Material.Wood, nil, nil, "Leaf")
	addFace(parts, 1.28, -1.14, Color3.fromRGB(255, 239, 156), Color3.fromRGB(45, 90, 40))
	add(parts, "TankTop", "Outfit", "Outfit", Vector3.new(2.0, 0.86, 1.35), Vector3.new(0, -0.58, 0), outfit)
	add(parts, "Shorts", "Outfit", "FruitDark", Vector3.new(1.8, 0.38, 1.26), Vector3.new(0, -1.05, 0), Color3.fromRGB(48, 112, 210))
	addChibiLimbs(parts, yellow, Color3.fromRGB(255, 226, 135), Color3.fromRGB(255, 255, 245), Color3.fromRGB(47, 143, 238))
	return parts
end

local function watermeloniParts()
	local parts = {}
	local green = Color3.fromRGB(72, 178, 75)
	local dark = Color3.fromRGB(33, 107, 55)
	local red = Color3.fromRGB(221, 64, 55)

	add(parts, "WatermelonBase", "Head", "Fruit", Vector3.new(3.85, 1.15, 3.05), Vector3.new(0, 0.18, 0), green)
	add(parts, "WatermelonMid", "Head", "Fruit", Vector3.new(4.3, 1.45, 3.35), Vector3.new(0, 1.15, 0), green)
	add(parts, "WatermelonTop", "Head", "Fruit", Vector3.new(3.6, 0.88, 2.8), Vector3.new(0, 2.25, 0), green)
	for index, x in ipairs({ -1.45, -0.48, 0.48, 1.45 }) do
		add(parts, `Stripe{index}`, "Stripe", "FruitDark", Vector3.new(0.26, 2.6, 0.16), Vector3.new(x, 1.28, -1.72), dark, nil, nil, nil, "Head")
	end
	add(parts, "StemBlock", "Stem", "Leaf", Vector3.new(0.42, 0.46, 0.42), Vector3.new(0, 3.05, 0), dark, Enum.Material.Wood, nil, nil, "Leaf")
	addFace(parts, 1.26, -1.84, Color3.fromRGB(255, 220, 188), Color3.fromRGB(25, 47, 30))
	add(parts, "SumoBeltFront", "Outfit", "Outfit", Vector3.new(3.65, 0.44, 0.2), Vector3.new(0, -0.58, -1.52), red)
	add(parts, "SumoBeltKnot", "Outfit", "Accent", Vector3.new(0.78, 0.62, 0.22), Vector3.new(0, -0.54, -1.68), Color3.fromRGB(255, 103, 91))
	addChibiLimbs(parts, green, Color3.fromRGB(255, 210, 174), Color3.fromRGB(55, 143, 62), dark)
	return parts
end

local function dragonfruttoParts()
	local parts = {}
	local pink = Color3.fromRGB(235, 64, 145)
	local pinkDark = Color3.fromRGB(184, 43, 119)
	local green = Color3.fromRGB(66, 216, 116)
	local black = Color3.fromRGB(18, 18, 24)

	add(parts, "DragonfruitLower", "Head", "Fruit", Vector3.new(3.0, 1.1, 2.35), Vector3.new(0, 0.25, 0), pink)
	add(parts, "DragonfruitMid", "Head", "Fruit", Vector3.new(3.55, 1.4, 2.65), Vector3.new(0, 1.25, 0), pink)
	add(parts, "DragonfruitUpper", "Head", "Fruit", Vector3.new(3.0, 0.95, 2.25), Vector3.new(0, 2.32, 0), pink)
	add(parts, "LeftFruitSide", "Head", "FruitDark", Vector3.new(0.42, 1.9, 2.25), Vector3.new(-1.9, 1.35, 0), pinkDark)
	add(parts, "RightFruitSide", "Head", "FruitDark", Vector3.new(0.42, 1.9, 2.25), Vector3.new(1.9, 1.35, 0), pinkDark)
	for index, data in ipairs({ { -1.1, 2.25 }, { 0.2, 2.45 }, { 1.1, 2.0 }, { -1.3, 1.25 }, { 1.3, 1.1 }, { -0.45, 0.45 }, { 0.75, 0.42 } }) do
		add(parts, `BlackSeed{index}`, "Seed", "Seed", Vector3.new(0.16, 0.16, 0.12), Vector3.new(data[1], data[2], -1.35), black)
	end
	for index, data in ipairs({ { -1.55, 2.65, -0.5, -28 }, { 1.55, 2.62, -0.35, 28 }, { -1.92, 1.55, 0.15, -38 }, { 1.92, 1.48, 0.15, 38 }, { 0, 3.08, 0, 0 } }) do
		add(parts, `GreenSpike{index}`, "Leaf", "Leaf", Vector3.new(0.58, 0.32, 0.9), Vector3.new(data[1], data[2], data[3]), green, Enum.Material.Grass, angles(-5, data[4], 0), "WedgePart", "Leaf")
	end
	addFace(parts, 1.22, -1.42, Color3.fromRGB(255, 178, 214), black)
	add(parts, "SunglassesLeft", "Shades", "Accessory", Vector3.new(0.7, 0.34, 0.16), Vector3.new(-0.5, 1.52, -1.55), black, Enum.Material.SmoothPlastic, nil, nil, "Sunglasses")
	add(parts, "SunglassesRight", "Shades", "Accessory", Vector3.new(0.7, 0.34, 0.16), Vector3.new(0.5, 1.52, -1.55), black, Enum.Material.SmoothPlastic, nil, nil, "Sunglasses")
	add(parts, "SunglassesBridge", "Shades", "Accessory", Vector3.new(0.22, 0.12, 0.16), Vector3.new(0, 1.52, -1.56), black, nil, nil, nil, "Sunglasses")
	add(parts, "DripJacket", "Outfit", "Outfit", Vector3.new(2.25, 0.88, 1.45), Vector3.new(0, -0.58, 0), Color3.fromRGB(36, 31, 51))
	add(parts, "GoldChain", "Detail", "Accent", Vector3.new(1.15, 0.16, 0.14), Vector3.new(0, -0.25, -0.82), Color3.fromRGB(255, 211, 73), Enum.Material.Metal)
	addChibiLimbs(parts, pink, Color3.fromRGB(255, 178, 214), Color3.fromRGB(40, 35, 52), Color3.fromRGB(31, 26, 45))
	return parts
end

local PART_BUILDERS = {
	-- Final imported meshes can replace these placeholder builders later.
	-- Keep CharacterId, VariantColorRole, AnimationRole, and Root/PrimaryPart conventions intact.
	Strawberita = strawberryParts,
	BananitoBandito = bananitoParts,
	CoconuttoBonkini = coconuttoParts,
	LemonaldoSprintini = lemonaldoParts,
	WatermeloniWobblino = watermeloniParts,
	DragonfruttoDrippo = dragonfruttoParts,
}

local function addPreviewLabel(root, text, rarity, scale)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PreviewLabel"
	billboard.Size = UDim2.fromOffset(150, 42)
	billboard.StudsOffset = Vector3.new(0, 4.7 * (scale or 1), 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 52
	billboard.Parent = root

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = `{text}\n{rarity or "Common"}`
	label.TextColor3 = PALETTE.White
	label.TextScaled = true
	label.TextStrokeTransparency = 0.28
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard
end

function CharacterModelFactory.create(characterId, variantId, options)
	options = options or {}
	local character = CharacterRegistry.getCharacter(characterId)
	local normalizedVariantId = CharacterRegistry.normalizeVariantId(variantId or options.variantId)
	local variant = CharacterRegistry.getVariant(character.Id, normalizedVariantId)
	local scale = options.scale or DEFAULT_SCALE
	local pivot = options.pivot or CFrame.new()
	local anchored = options.anchored ~= false

	local model = Instance.new("Model")
	model.Name = character.DisplayName
	model:SetAttribute("CharacterId", character.Id)
	model:SetAttribute("DisplayName", variant.DisplayName or character.DisplayName)
	model:SetAttribute("BaseDisplayName", character.DisplayName)
	model:SetAttribute("BaseFruit", character.BaseFruit)
	model:SetAttribute("VariantId", normalizedVariantId)
	model:SetAttribute("VariantName", normalizedVariantId)
	model:SetAttribute("Rarity", variant.Rarity or character.Rarity)
	model:SetAttribute("Style", "VoxelChibiTurnaround")
	model:SetAttribute("CharacterRegistryVersion", CharacterRegistry.Version)
	model:SetAttribute("CharacterModelFactoryVersion", CharacterModelFactory.Version)
	model:SetAttribute("ReferenceFolderPath", character.ReferenceFolderPath)
	model:SetAttribute("BaseReferenceImagePath", character.BaseReferenceImagePath)
	model:SetAttribute("NotesPath", character.NotesPath)
	model:SetAttribute("PlaceholderModelName", character.PlaceholderModelName)
	model:SetAttribute("AnimationStyle", character.AnimationStyle)
	model:SetAttribute("IncomeMultiplier", character.IncomeMultiplier * (variant.IncomeMultiplierModifier or 1))

	local root = Instance.new("Part")
	root.Name = "Root"
	root.Size = Vector3.new(1, 1, 1) * scale
	root.CFrame = pivot
	root.Transparency = 1
	root.Anchored = anchored
	root.CanCollide = false
	root.CanTouch = false
	root.CanQuery = false
	root.Massless = true
	root:SetAttribute("BrainrotCharacterPart", true)
	root:SetAttribute("CharacterPartRole", "Root")
	root:SetAttribute("AnimationRole", "Root")
	root:SetAttribute("VariantColorRole", "None")
	root.Parent = model
	model.PrimaryPart = root

	local partBuilder = PART_BUILDERS[character.Id] or PART_BUILDERS.Strawberita
	for _, partConfig in ipairs(partBuilder()) do
		setupPart(model, root, partConfig, scale)
	end

	CharacterVariantService.applyVariantVFX(model, character.Id, normalizedVariantId, options.context or "Model")
	model:PivotTo(pivot)

	if options.label then
		addPreviewLabel(root, variant.DisplayName or character.DisplayName, variant.Rarity or character.Rarity, scale)
	end

	return model
end

function CharacterModelFactory.createPreviewLineup(parent, characterIds, origin, variantId)
	local created = {}
	local line = characterIds or CharacterRegistry.CharacterOrder
	for index, characterId in ipairs(line) do
		local model = CharacterModelFactory.create(characterId, variantId or "Base", {
			anchored = true,
			label = true,
			pivot = origin * CFrame.new((index - 1) * 8.5, 0, 0),
		})
		model.Parent = parent
		table.insert(created, model)
	end
	return created
end

return CharacterModelFactory
