local CharacterRegistry = require(script.Parent.CharacterRegistry)
local CharacterVariantService = require(script.Parent.CharacterVariantService)

local BrainrotModelFactory = {}

BrainrotModelFactory.Version = "BrainrotModelFactory_PremiumShowcaseMascots_V2"

local DEFAULT_SCALE = 0.92

local PALETTE = {
	White = Color3.fromRGB(255, 255, 245),
	Black = Color3.fromRGB(18, 18, 24),
	Ink = Color3.fromRGB(36, 30, 42),
	Cheek = Color3.fromRGB(255, 122, 150),
	Skin = Color3.fromRGB(255, 211, 182),
	Gold = Color3.fromRGB(255, 211, 73),
	Cyan = Color3.fromRGB(124, 235, 255),
	Purple = Color3.fromRGB(112, 78, 230),
}

local function scaled(vector, scale)
	return Vector3.new(vector.X * scale, vector.Y * scale, vector.Z * scale)
end

local function angles(x, y, z)
	return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
end

local function add(parts, config)
	table.insert(parts, config)
end

local function addPart(parts, name, role, colorRole, size, offset, color, options)
	options = options or {}
	add(parts, {
		name = name,
		role = role,
		colorRole = colorRole,
		size = size,
		offset = offset,
		color = color,
		material = options.material,
		rotation = options.rotation,
		className = options.className,
		shape = options.shape,
		transparency = options.transparency,
		animationRole = options.animationRole or role,
	})
end

local function addSphere(parts, name, role, colorRole, size, offset, color, options)
	options = options or {}
	options.shape = Enum.PartType.Ball
	addPart(parts, name, role, colorRole, size, offset, color, options)
end

local function addCylinder(parts, name, role, colorRole, size, offset, color, options)
	options = options or {}
	options.shape = Enum.PartType.Cylinder
	addPart(parts, name, role, colorRole, size, offset, color, options)
end

local function setupPart(model, root, config, scale)
	local part = Instance.new(config.className or "Part")
	part.Name = config.name
	if part:IsA("Part") and config.shape then
		part.Shape = config.shape
	end
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
	part:SetAttribute("StrawberitaRole", config.role or "Detail")
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

local function addEye(parts, name, x, y, z, eyeColor, style)
	if style == "shades" then
		return
	end
	local animationRole = name == "Left" and "EyeLeft" or "EyeRight"
	addSphere(parts, `{name}EyeWhite`, "Eye", "Eye", Vector3.new(0.38, 0.46, 0.09), Vector3.new(x, y, z), PALETTE.White, { animationRole = animationRole })
	addSphere(parts, `{name}Pupil`, "Eye", "Eye", Vector3.new(0.2, 0.25, 0.1), Vector3.new(x, y - 0.01, z - 0.055), eyeColor or PALETTE.Black, { animationRole = animationRole })
	addPart(parts, `{name}EyeSpark`, "Eye", "Eye", Vector3.new(0.08, 0.08, 0.035), Vector3.new(x - 0.07, y + 0.1, z - 0.11), PALETTE.White, { material = Enum.Material.Neon, animationRole = animationRole })
end

local function addFace(parts, options)
	local y = options.y
	local z = options.z
	local width = options.width or 2.15
	local height = options.height or 1.08
	local panelColor = options.panelColor or PALETTE.Skin
	local eyeColor = options.eyeColor or PALETTE.Black
	local mouthColor = options.mouthColor or PALETTE.Black
	local style = options.style or "cute"
	local frameColor = options.frameColor or eyeColor:Lerp(PALETTE.Black, 0.25)

	addPart(parts, "FacePanel", "Face", "Face", Vector3.new(width, height, 0.11), Vector3.new(0, y, z), panelColor, { animationRole = "Face" })
	addPart(parts, "FaceFrameTop", "Face", "Eye", Vector3.new(width + 0.18, 0.08, 0.08), Vector3.new(0, y + height * 0.5 + 0.03, z - 0.08), frameColor, { animationRole = "Face" })
	addPart(parts, "FaceFrameBottom", "Face", "Eye", Vector3.new(width + 0.1, 0.07, 0.08), Vector3.new(0, y - height * 0.5 - 0.03, z - 0.08), frameColor, { animationRole = "Face" })
	addPart(parts, "FaceFrameLeft", "Face", "Eye", Vector3.new(0.08, height + 0.12, 0.08), Vector3.new(-width * 0.5 - 0.05, y, z - 0.08), frameColor, { animationRole = "Face" })
	addPart(parts, "FaceFrameRight", "Face", "Eye", Vector3.new(0.08, height + 0.12, 0.08), Vector3.new(width * 0.5 + 0.05, y, z - 0.08), frameColor, { animationRole = "Face" })

	if style == "bandit" then
		addPart(parts, "BanditEyeMask", "Face", "Accessory", Vector3.new(width + 0.2, 0.45, 0.08), Vector3.new(0, y + 0.2, z - 0.08), Color3.fromRGB(45, 32, 26), { animationRole = "Face" })
	elseif style == "shades" then
		addPart(parts, "SunglassesLeft", "Shades", "Accessory", Vector3.new(0.78, 0.36, 0.12), Vector3.new(-0.48, y + 0.22, z - 0.1), PALETTE.Black, { animationRole = "Sunglasses" })
		addPart(parts, "SunglassesRight", "Shades", "Accessory", Vector3.new(0.78, 0.36, 0.12), Vector3.new(0.48, y + 0.22, z - 0.1), PALETTE.Black, { animationRole = "Sunglasses" })
		addPart(parts, "SunglassesBridge", "Shades", "Accessory", Vector3.new(0.22, 0.12, 0.12), Vector3.new(0, y + 0.22, z - 0.13), PALETTE.Black, { animationRole = "Sunglasses" })
	end

	addEye(parts, "Left", -0.48, y + 0.2, z - 0.09, eyeColor, style)
	addEye(parts, "Right", 0.48, y + 0.2, z - 0.09, eyeColor, style)

	if style == "runner" then
		addPart(parts, "LeftBrow", "Brow", "Eye", Vector3.new(0.5, 0.08, 0.08), Vector3.new(-0.5, y + 0.55, z - 0.1), eyeColor, { rotation = angles(0, 0, -12), animationRole = "Face" })
		addPart(parts, "RightBrow", "Brow", "Eye", Vector3.new(0.5, 0.08, 0.08), Vector3.new(0.5, y + 0.55, z - 0.1), eyeColor, { rotation = angles(0, 0, 12), animationRole = "Face" })
	elseif style == "silly" then
		addPart(parts, "SillyBrowLeft", "Brow", "Eye", Vector3.new(0.42, 0.07, 0.08), Vector3.new(-0.48, y + 0.53, z - 0.1), eyeColor, { rotation = angles(0, 0, 9), animationRole = "Face" })
		addPart(parts, "SillyBrowRight", "Brow", "Eye", Vector3.new(0.42, 0.07, 0.08), Vector3.new(0.48, y + 0.5, z - 0.1), eyeColor, { rotation = angles(0, 0, -7), animationRole = "Face" })
	elseif style == "wobble" then
		addPart(parts, "HappyBrowLeft", "Brow", "Eye", Vector3.new(0.44, 0.07, 0.08), Vector3.new(-0.5, y + 0.53, z - 0.1), eyeColor, { rotation = angles(0, 0, -6), animationRole = "Face" })
		addPart(parts, "HappyBrowRight", "Brow", "Eye", Vector3.new(0.44, 0.07, 0.08), Vector3.new(0.5, y + 0.53, z - 0.1), eyeColor, { rotation = angles(0, 0, 6), animationRole = "Face" })
	end

	addPart(parts, "LeftCheek", "Cheek", "Face", Vector3.new(0.32, 0.15, 0.08), Vector3.new(-0.86, y - 0.21, z - 0.08), PALETTE.Cheek, { animationRole = "Cheek" })
	addPart(parts, "RightCheek", "Cheek", "Face", Vector3.new(0.32, 0.15, 0.08), Vector3.new(0.86, y - 0.21, z - 0.08), PALETTE.Cheek, { animationRole = "Cheek" })

	local smileRotation = style == "bandit" and angles(0, 0, -8) or CFrame.new()
	local smileWidth = style == "shades" and 0.52 or (style == "wobble" and 0.5 or 0.38)
	addPart(parts, "Smile", "Mouth", "Eye", Vector3.new(smileWidth, 0.08, 0.08), Vector3.new(0, y - 0.38, z - 0.1), mouthColor, { rotation = smileRotation, animationRole = "Mouth" })
	if style == "silly" then
		addPart(parts, "TinyTooth", "Mouth", "Face", Vector3.new(0.12, 0.14, 0.06), Vector3.new(0.12, y - 0.46, z - 0.14), PALETTE.White, { animationRole = "Mouth" })
	elseif style == "cute" then
		addPart(parts, "SmileDimple", "Mouth", "Eye", Vector3.new(0.12, 0.06, 0.06), Vector3.new(0.24, y - 0.36, z - 0.12), mouthColor, { rotation = angles(0, 0, -20), animationRole = "Mouth" })
	end
end

local function addChibiLimbs(parts, options)
	local armColor = options.armColor
	local handColor = options.handColor or PALETTE.Skin
	local legColor = options.legColor or PALETTE.White
	local shoeColor = options.shoeColor
	local armY = options.armY or -0.22
	local footY = options.footY or -1.78
	local armSpread = options.armSpread or 1.62

	addCylinder(parts, "LeftArmBlock", "Arm", options.armRole or "Fruit", Vector3.new(0.36, 0.9, 0.36), Vector3.new(-armSpread, armY, -0.02), armColor, { rotation = angles(0, 0, -14), animationRole = "LeftArm" })
	addCylinder(parts, "RightArmBlock", "Arm", options.armRole or "Fruit", Vector3.new(0.36, 0.9, 0.36), Vector3.new(armSpread, armY, -0.02), armColor, { rotation = angles(0, 0, 14), animationRole = "RightArm" })
	addSphere(parts, "LeftHandBlock", "Hand", "Skin", Vector3.new(0.36, 0.3, 0.36), Vector3.new(-armSpread - 0.15, armY - 0.52, -0.02), handColor, { animationRole = "LeftArm" })
	addSphere(parts, "RightHandBlock", "Hand", "Skin", Vector3.new(0.36, 0.3, 0.36), Vector3.new(armSpread + 0.15, armY - 0.52, -0.02), handColor, { animationRole = "RightArm" })
	addCylinder(parts, "LeftLegBlock", "Leg", "Outfit", Vector3.new(0.34, 0.48, 0.34), Vector3.new(-0.45, footY + 0.42, 0.02), legColor, { animationRole = "LeftLeg" })
	addCylinder(parts, "RightLegBlock", "Leg", "Outfit", Vector3.new(0.34, 0.48, 0.34), Vector3.new(0.45, footY + 0.42, 0.02), legColor, { animationRole = "RightLeg" })
	addSphere(parts, "LeftFootBlock", "Foot", "Shoe", Vector3.new(0.72, 0.38, 0.86), Vector3.new(-0.5, footY, -0.18), shoeColor, { animationRole = "LeftFoot" })
	addSphere(parts, "RightFootBlock", "Foot", "Shoe", Vector3.new(0.72, 0.38, 0.86), Vector3.new(0.5, footY, -0.18), shoeColor, { animationRole = "RightFoot" })
end

local function addSeeds(parts, points, color)
	for index, point in ipairs(points) do
		addPart(parts, `Seed{index}`, "Seed", "Seed", Vector3.new(point[3] or 0.18, point[3] or 0.18, 0.06), Vector3.new(point[1], point[2], point[4] or -1.45), color, { material = Enum.Material.SmoothPlastic, animationRole = "Seed" })
	end
end

local function strawberitaParts()
	local parts = {}
	local red = Color3.fromRGB(238, 49, 62)
	local redDark = Color3.fromRGB(195, 35, 48)
	local green = Color3.fromRGB(83, 184, 48)
	local pink = Color3.fromRGB(255, 82, 132)

	addSphere(parts, "BerryBody", "Head", "Fruit", Vector3.new(3.55, 4.05, 2.95), Vector3.new(0, 1.15, 0), red, { animationRole = "Head" })
	addSphere(parts, "BerryLowerTaper", "Head", "FruitDark", Vector3.new(2.65, 1.25, 2.25), Vector3.new(0, -0.6, 0.02), redDark, { animationRole = "Head" })
	addSphere(parts, "BerryTopShoulder", "Head", "Fruit", Vector3.new(3.05, 0.72, 2.55), Vector3.new(0, 2.92, -0.02), red:Lerp(PALETTE.White, 0.06), { animationRole = "Head" })
	addSphere(parts, "BerryLeftCheekMass", "Head", "FruitDark", Vector3.new(0.82, 2.2, 2.24), Vector3.new(-1.72, 1.2, 0.03), redDark, { animationRole = "Head" })
	addSphere(parts, "BerryRightCheekMass", "Head", "FruitDark", Vector3.new(0.82, 2.2, 2.24), Vector3.new(1.72, 1.2, 0.03), redDark, { animationRole = "Head" })
	addPart(parts, "BerryFrontShine", "Detail", "Accent", Vector3.new(0.22, 1.22, 0.08), Vector3.new(-1.18, 1.84, -1.5), Color3.fromRGB(255, 101, 111), { transparency = 0.12, animationRole = "Head" })
	addFace(parts, { y = 1.32, z = -1.5, width = 2.18, height = 1.08, panelColor = Color3.fromRGB(255, 205, 181), eyeColor = Color3.fromRGB(35, 84, 38), style = "cute" })
	addSeeds(parts, {
		{ -1.12, 2.35, 0.18 }, { 0, 2.55, 0.18 }, { 1.12, 2.35, 0.18 },
		{ -1.45, 1.65, 0.18 }, { 1.45, 1.65, 0.18 }, { -1.05, 0.55, 0.16 }, { 1.05, 0.55, 0.16 },
		{ -1.55, 0.95, 0.14, -0.82 }, { 1.55, 0.95, 0.14, -0.82 },
	}, Color3.fromRGB(255, 224, 61))
	addPart(parts, "LeafFront", "Leaf", "Leaf", Vector3.new(2.9, 0.3, 0.8), Vector3.new(0, 3.2, -0.42), green, { className = "WedgePart", material = Enum.Material.Grass, rotation = angles(-4, 0, 0), animationRole = "Leaf" })
	addPart(parts, "LeafLeft", "Leaf", "Leaf", Vector3.new(1.25, 0.32, 0.9), Vector3.new(-0.98, 3.22, -0.08), green, { className = "WedgePart", material = Enum.Material.Grass, rotation = angles(-4, -38, 0), animationRole = "Leaf" })
	addPart(parts, "LeafRight", "Leaf", "Leaf", Vector3.new(1.25, 0.32, 0.9), Vector3.new(0.98, 3.22, -0.08), green, { className = "WedgePart", material = Enum.Material.Grass, rotation = angles(-4, 38, 0), animationRole = "Leaf" })
	addPart(parts, "LeafBackFan", "Leaf", "Leaf", Vector3.new(2.25, 0.28, 0.76), Vector3.new(0, 3.16, 0.42), green:Lerp(PALETTE.Black, 0.18), { className = "WedgePart", material = Enum.Material.Grass, rotation = angles(8, 180, 0), animationRole = "Leaf" })
	addPart(parts, "LeafTinyFrontLeft", "Leaf", "Leaf", Vector3.new(0.88, 0.22, 0.62), Vector3.new(-0.46, 3.34, -0.82), green:Lerp(PALETTE.White, 0.05), { className = "WedgePart", material = Enum.Material.Grass, rotation = angles(-10, -18, 0), animationRole = "Leaf" })
	addPart(parts, "LeafTinyFrontRight", "Leaf", "Leaf", Vector3.new(0.88, 0.22, 0.62), Vector3.new(0.46, 3.34, -0.82), green:Lerp(PALETTE.White, 0.05), { className = "WedgePart", material = Enum.Material.Grass, rotation = angles(-10, 18, 0), animationRole = "Leaf" })
	addCylinder(parts, "StemBlock", "Stem", "Leaf", Vector3.new(0.36, 0.58, 0.36), Vector3.new(0, 3.67, 0.05), Color3.fromRGB(66, 143, 38), { material = Enum.Material.Wood, animationRole = "Stem" })
	addSphere(parts, "BowKnot", "Bow", "Accent", Vector3.new(0.34, 0.34, 0.16), Vector3.new(-1.2, 2.48, -1.55), pink, { animationRole = "Head" })
	addPart(parts, "BowLeftLoop", "Bow", "Accent", Vector3.new(0.65, 0.45, 0.12), Vector3.new(-1.65, 2.5, -1.56), pink, { rotation = angles(0, 0, 8), animationRole = "Head" })
	addPart(parts, "BowRightLoop", "Bow", "Accent", Vector3.new(0.65, 0.45, 0.12), Vector3.new(-0.78, 2.5, -1.56), pink, { rotation = angles(0, 0, -8), animationRole = "Head" })
	addPart(parts, "BowTailLeft", "Bow", "Accent", Vector3.new(0.24, 0.44, 0.1), Vector3.new(-1.42, 2.17, -1.57), pink:Lerp(red, 0.15), { rotation = angles(0, 0, -14), animationRole = "Head" })
	addPart(parts, "BowTailRight", "Bow", "Accent", Vector3.new(0.24, 0.44, 0.1), Vector3.new(-1.04, 2.17, -1.57), pink:Lerp(red, 0.15), { rotation = angles(0, 0, 14), animationRole = "Head" })
	addCylinder(parts, "SkirtRing", "Body", "Outfit", Vector3.new(2.35, 0.32, 1.65), Vector3.new(0, -0.72, 0), Color3.fromRGB(226, 38, 54), { animationRole = "Body" })
	addPart(parts, "SkirtTrim", "Detail", "Face", Vector3.new(2.3, 0.14, 0.12), Vector3.new(0, -0.86, -0.86), PALETTE.White, { animationRole = "Body" })
	addPart(parts, "SkirtPleatLeft", "Detail", "Outfit", Vector3.new(0.22, 0.38, 0.1), Vector3.new(-0.68, -0.9, -0.86), redDark, { rotation = angles(0, 0, 8), animationRole = "Body" })
	addPart(parts, "SkirtPleatRight", "Detail", "Outfit", Vector3.new(0.22, 0.38, 0.1), Vector3.new(0.68, -0.9, -0.86), redDark, { rotation = angles(0, 0, -8), animationRole = "Body" })
	addChibiLimbs(parts, { armColor = red, handColor = PALETTE.Skin, legColor = Color3.fromRGB(255, 177, 202), shoeColor = Color3.fromRGB(217, 37, 50), armY = -0.18, footY = -1.92 })
	return parts
end

local function bananaBanditoParts()
	local parts = {}
	local yellow = Color3.fromRGB(255, 221, 72)
	local yellowDark = Color3.fromRGB(222, 168, 43)
	local brown = Color3.fromRGB(104, 66, 38)
	local red = Color3.fromRGB(196, 53, 49)

	addSphere(parts, "BananaBody", "Head", "Fruit", Vector3.new(2.28, 3.7, 1.72), Vector3.new(0, 1.22, 0), yellow, { rotation = angles(0, 0, -4), animationRole = "Head" })
	addSphere(parts, "BananaCurveTop", "Head", "Fruit", Vector3.new(1.54, 1.2, 1.36), Vector3.new(-0.28, 2.86, -0.02), yellow:Lerp(PALETTE.White, 0.04), { rotation = angles(0, 0, -18), animationRole = "Head" })
	addSphere(parts, "BananaCurveBottom", "Head", "FruitDark", Vector3.new(1.72, 1.18, 1.38), Vector3.new(0.36, -0.45, 0.02), yellowDark:Lerp(yellow, 0.2), { rotation = angles(0, 0, 11), animationRole = "Head" })
	addSphere(parts, "BananaBellyHighlight", "Detail", "Accent", Vector3.new(1.35, 2.6, 0.12), Vector3.new(0.18, 1.26, -0.9), Color3.fromRGB(255, 239, 144), { animationRole = "Head" })
	addPart(parts, "LeftPeelStripe", "Stripe", "FruitDark", Vector3.new(0.24, 2.8, 0.12), Vector3.new(-0.92, 1.34, -0.78), yellowDark, { rotation = angles(0, 0, -7), animationRole = "Head" })
	addPart(parts, "RightPeelStripe", "Stripe", "FruitDark", Vector3.new(0.24, 2.8, 0.12), Vector3.new(1.02, 1.25, -0.74), yellowDark, { rotation = angles(0, 0, 7), animationRole = "Head" })
	addPart(parts, "CenterPeelGroove", "Stripe", "FruitDark", Vector3.new(0.16, 2.48, 0.09), Vector3.new(0.05, 1.26, -0.94), yellowDark:Lerp(PALETTE.Black, 0.08), { rotation = angles(0, 0, -2), animationRole = "Head" })
	addPart(parts, "PeelCrownLeft", "Leaf", "Accent", Vector3.new(0.48, 0.9, 0.42), Vector3.new(-0.48, 3.16, -0.06), yellowDark, { rotation = angles(0, 0, -22), animationRole = "Leaf" })
	addPart(parts, "PeelCrownRight", "Leaf", "Accent", Vector3.new(0.48, 0.9, 0.42), Vector3.new(0.48, 3.16, -0.06), yellowDark, { rotation = angles(0, 0, 22), animationRole = "Leaf" })
	addPart(parts, "PeelCrownBack", "Leaf", "Accent", Vector3.new(0.42, 0.72, 0.42), Vector3.new(0, 3.28, 0.34), yellowDark:Lerp(brown, 0.25), { rotation = angles(13, 0, 0), animationRole = "Leaf" })
	addFace(parts, { y = 1.35, z = -0.93, width = 1.85, height = 1.02, panelColor = Color3.fromRGB(255, 236, 168), eyeColor = Color3.fromRGB(35, 25, 18), style = "bandit" })
	addCylinder(parts, "CowboyHatBrim", "Hat", "Accessory", Vector3.new(2.95, 0.18, 1.85), Vector3.new(0, 3.32, 0), brown, { material = Enum.Material.Wood, rotation = angles(0, 0, 90), animationRole = "Hat" })
	addPart(parts, "CowboyHatCrown", "Hat", "Accessory", Vector3.new(1.35, 0.62, 1.18), Vector3.new(0, 3.67, 0), brown, { material = Enum.Material.Wood, animationRole = "Hat" })
	addPart(parts, "CowboyHatBand", "Hat", "Outfit", Vector3.new(1.48, 0.14, 1.24), Vector3.new(0, 3.5, -0.01), red:Lerp(brown, 0.15), { animationRole = "Hat" })
	addPart(parts, "MaskTieLeft", "Face", "Accessory", Vector3.new(0.42, 0.18, 0.08), Vector3.new(-1.12, 1.53, -0.94), brown, { rotation = angles(0, 0, -18), animationRole = "Face" })
	addPart(parts, "MaskTieRight", "Face", "Accessory", Vector3.new(0.42, 0.18, 0.08), Vector3.new(1.12, 1.53, -0.94), brown, { rotation = angles(0, 0, 18), animationRole = "Face" })
	addPart(parts, "Bandana", "Outfit", "Outfit", Vector3.new(1.95, 0.32, 0.16), Vector3.new(0, -0.23, -0.88), red, { animationRole = "Body" })
	addPart(parts, "BandanaKnot", "Outfit", "Outfit", Vector3.new(0.42, 0.34, 0.15), Vector3.new(0.72, -0.24, -0.92), red:Lerp(PALETTE.Black, 0.08), { rotation = angles(0, 0, 12), animationRole = "Body" })
	addPart(parts, "Belt", "Outfit", "Accessory", Vector3.new(2.08, 0.24, 0.16), Vector3.new(0, -0.78, -0.82), brown, { animationRole = "Body" })
	addPart(parts, "Buckle", "Outfit", "Accent", Vector3.new(0.42, 0.34, 0.18), Vector3.new(0, -0.78, -0.92), PALETTE.Gold, { material = Enum.Material.Metal, animationRole = "Body" })
	addSphere(parts, "MoneyBag", "Prop", "Accessory", Vector3.new(0.58, 0.66, 0.42), Vector3.new(-1.72, -0.82, -0.22), Color3.fromRGB(147, 108, 59), { animationRole = "LeftArm" })
	addPart(parts, "MoneyBagPatch", "Prop", "Accent", Vector3.new(0.24, 0.22, 0.08), Vector3.new(-1.72, -0.82, -0.48), PALETTE.Gold, { material = Enum.Material.Metal, animationRole = "LeftArm" })
	addChibiLimbs(parts, { armColor = yellow, handColor = Color3.fromRGB(255, 225, 148), legColor = yellowDark, shoeColor = brown, armY = -0.22, footY = -1.82, armSpread = 1.38 })
	return parts
end

local function coconuttoParts()
	local parts = {}
	local brown = Color3.fromRGB(111, 70, 43)
	local dark = Color3.fromRGB(58, 38, 27)
	local cream = Color3.fromRGB(255, 236, 190)
	local tunic = Color3.fromRGB(181, 119, 53)

	addSphere(parts, "CoconutShell", "Head", "Fruit", Vector3.new(3.25, 3.45, 2.85), Vector3.new(0, 1.12, 0), brown, { animationRole = "Head" })
	addSphere(parts, "CoconutLeftShoulder", "Head", "FruitDark", Vector3.new(0.8, 2.45, 2.35), Vector3.new(-1.54, 1.05, 0.02), brown:Lerp(dark, 0.35), { animationRole = "Head" })
	addSphere(parts, "CoconutRightShoulder", "Head", "FruitDark", Vector3.new(0.8, 2.45, 2.35), Vector3.new(1.54, 1.05, 0.02), brown:Lerp(dark, 0.35), { animationRole = "Head" })
	addSphere(parts, "CoconutBellyBulge", "Detail", "Fruit", Vector3.new(2.35, 1.1, 0.24), Vector3.new(0, 0.32, -1.34), brown:Lerp(Color3.fromRGB(150, 96, 60), 0.24), { animationRole = "Head" })
	addCylinder(parts, "CoconutCreamCap", "Head", "Accent", Vector3.new(2.25, 0.28, 1.78), Vector3.new(0, 2.86, -0.02), cream, { rotation = angles(0, 0, 90), animationRole = "Head" })
	addPart(parts, "CreamFrontDrip", "Head", "Accent", Vector3.new(0.46, 0.42, 0.12), Vector3.new(-0.62, 2.6, -1.34), cream:Lerp(PALETTE.White, 0.18), { animationRole = "Head" })
	addPart(parts, "CreamSideDrip", "Head", "Accent", Vector3.new(0.34, 0.32, 0.1), Vector3.new(0.78, 2.54, -1.28), cream:Lerp(PALETTE.White, 0.1), { animationRole = "Head" })
	addFace(parts, { y = 1.28, z = -1.48, width = 2.0, height = 1.08, panelColor = Color3.fromRGB(232, 178, 126), eyeColor = Color3.fromRGB(30, 21, 15), style = "silly" })
	addPart(parts, "CrackLineA", "Detail", "FruitDark", Vector3.new(0.12, 0.92, 0.08), Vector3.new(-0.78, 2.05, -1.42), dark, { rotation = angles(0, 0, -18), animationRole = "Head" })
	addPart(parts, "CrackLineB", "Detail", "FruitDark", Vector3.new(0.12, 0.68, 0.08), Vector3.new(0.82, 1.85, -1.44), dark, { rotation = angles(0, 0, 24), animationRole = "Head" })
	addPart(parts, "CrackLineC", "Detail", "FruitDark", Vector3.new(0.12, 0.54, 0.08), Vector3.new(-1.1, 0.82, -1.36), dark, { rotation = angles(0, 0, 32), animationRole = "Head" })
	addSphere(parts, "CoconutPoreA", "Detail", "FruitDark", Vector3.new(0.18, 0.18, 0.08), Vector3.new(0.38, 2.24, -1.43), dark, { animationRole = "Head" })
	addSphere(parts, "CoconutPoreB", "Detail", "FruitDark", Vector3.new(0.16, 0.16, 0.08), Vector3.new(0.68, 2.08, -1.43), dark, { animationRole = "Head" })
	addPart(parts, "PalmLeafA", "Leaf", "Leaf", Vector3.new(0.9, 0.18, 0.48), Vector3.new(-0.52, 3.1, -0.1), Color3.fromRGB(70, 190, 84), { className = "WedgePart", rotation = angles(0, -28, 8), animationRole = "Leaf" })
	addPart(parts, "FlowerPetal", "Accessory", "Accent", Vector3.new(0.34, 0.2, 0.1), Vector3.new(0.58, 2.92, -1.22), Color3.fromRGB(255, 118, 170), { animationRole = "Head" })
	addPart(parts, "FlowerPetalTop", "Accessory", "Accent", Vector3.new(0.26, 0.26, 0.1), Vector3.new(0.58, 3.08, -1.2), Color3.fromRGB(255, 176, 94), { rotation = angles(0, 0, 45), animationRole = "Head" })
	addPart(parts, "PalmLeafB", "Leaf", "Leaf", Vector3.new(0.82, 0.16, 0.46), Vector3.new(-0.12, 3.18, 0.04), Color3.fromRGB(61, 170, 75), { className = "WedgePart", rotation = angles(0, 24, -9), animationRole = "Leaf" })
	addCylinder(parts, "TunicWrap", "Outfit", "Outfit", Vector3.new(2.35, 0.62, 1.55), Vector3.new(0, -0.55, -0.02), tunic, { rotation = angles(0, 0, 90), animationRole = "Body" })
	addPart(parts, "TunicSpotA", "Detail", "Accent", Vector3.new(0.3, 0.22, 0.08), Vector3.new(-0.58, -0.43, -0.83), dark, { animationRole = "Body" })
	addPart(parts, "TunicSpotB", "Detail", "Accent", Vector3.new(0.32, 0.22, 0.08), Vector3.new(0.62, -0.7, -0.83), dark, { animationRole = "Body" })
	addPart(parts, "TunicToothLeft", "Detail", "Outfit", Vector3.new(0.42, 0.3, 0.1), Vector3.new(-0.72, -0.92, -0.8), tunic:Lerp(PALETTE.Black, 0.08), { rotation = angles(0, 0, 10), animationRole = "Body" })
	addPart(parts, "TunicToothRight", "Detail", "Outfit", Vector3.new(0.42, 0.3, 0.1), Vector3.new(0.72, -0.92, -0.8), tunic:Lerp(PALETTE.Black, 0.08), { rotation = angles(0, 0, -10), animationRole = "Body" })
	addCylinder(parts, "ClubHandle", "Club", "Accessory", Vector3.new(0.18, 1.18, 0.18), Vector3.new(1.86, -0.52, -0.12), Color3.fromRGB(112, 69, 39), { material = Enum.Material.Wood, rotation = angles(0, 0, -22), animationRole = "RightArm" })
	addSphere(parts, "ClubHead", "Club", "Accessory", Vector3.new(0.56, 0.68, 0.5), Vector3.new(2.1, 0.06, -0.12), Color3.fromRGB(82, 53, 35), { material = Enum.Material.Wood, animationRole = "RightArm" })
	addPart(parts, "ClubWrap", "Club", "Accent", Vector3.new(0.44, 0.1, 0.16), Vector3.new(2.08, 0.28, -0.18), cream:Lerp(tunic, 0.3), { material = Enum.Material.Wood, rotation = angles(0, 0, -22), animationRole = "RightArm" })
	addChibiLimbs(parts, { armColor = brown, handColor = Color3.fromRGB(225, 168, 119), legColor = tunic, shoeColor = dark, armY = -0.22, footY = -1.82 })
	return parts
end

local function lemonaldoParts()
	local parts = {}
	local yellow = Color3.fromRGB(255, 223, 63)
	local yellowDark = Color3.fromRGB(226, 181, 37)
	local green = Color3.fromRGB(56, 190, 92)
	local blue = Color3.fromRGB(48, 112, 210)

	addSphere(parts, "LemonBody", "Head", "Fruit", Vector3.new(3.05, 3.35, 2.15), Vector3.new(0, 1.3, 0), yellow, { rotation = angles(0, 0, -3), animationRole = "Head" })
	addSphere(parts, "LemonFrontBelly", "Head", "Accent", Vector3.new(2.18, 2.35, 0.18), Vector3.new(0.08, 1.28, -1.08), yellow:Lerp(PALETTE.White, 0.18), { rotation = angles(0, 0, -3), transparency = 0.05, animationRole = "Head" })
	addPart(parts, "LeftLemonPoint", "Head", "FruitDark", Vector3.new(0.58, 0.9, 1.42), Vector3.new(-1.56, 1.3, 0), yellowDark, { className = "WedgePart", rotation = angles(0, 90, 0), animationRole = "Head" })
	addPart(parts, "RightLemonPoint", "Head", "FruitDark", Vector3.new(0.58, 0.9, 1.42), Vector3.new(1.56, 1.3, 0), yellowDark, { className = "WedgePart", rotation = angles(0, -90, 0), animationRole = "Head" })
	addSphere(parts, "LemonSkinDotA", "Detail", "Seed", Vector3.new(0.14, 0.14, 0.05), Vector3.new(-0.9, 1.9, -1.18), yellowDark:Lerp(PALETTE.White, 0.08), { animationRole = "Head" })
	addSphere(parts, "LemonSkinDotB", "Detail", "Seed", Vector3.new(0.12, 0.12, 0.05), Vector3.new(0.92, 1.72, -1.18), yellowDark:Lerp(PALETTE.White, 0.08), { animationRole = "Head" })
	addSphere(parts, "LemonSkinDotC", "Detail", "Seed", Vector3.new(0.12, 0.12, 0.05), Vector3.new(-0.36, 0.54, -1.18), yellowDark:Lerp(PALETTE.White, 0.08), { animationRole = "Head" })
	addPart(parts, "HeadbandMain", "Outfit", "Outfit", Vector3.new(2.55, 0.22, 0.13), Vector3.new(0, 2.35, -1.12), PALETTE.White, { animationRole = "Head" })
	addPart(parts, "HeadbandStripe", "Outfit", "Accent", Vector3.new(1.72, 0.11, 0.14), Vector3.new(0, 2.35, -1.19), green, { material = Enum.Material.SmoothPlastic, animationRole = "Head" })
	addPart(parts, "HeadbandKnot", "Outfit", "Accent", Vector3.new(0.38, 0.24, 0.12), Vector3.new(1.12, 2.33, -1.12), green:Lerp(PALETTE.White, 0.12), { rotation = angles(0, 0, -16), animationRole = "Head" })
	addPart(parts, "HeadbandTail", "Outfit", "Accent", Vector3.new(0.18, 0.46, 0.1), Vector3.new(1.32, 2.12, -1.08), green:Lerp(PALETTE.White, 0.12), { rotation = angles(0, 0, -24), animationRole = "Head" })
	addPart(parts, "LeafTop", "Leaf", "Leaf", Vector3.new(0.78, 0.22, 0.68), Vector3.new(0.42, 3.05, -0.06), green, { className = "WedgePart", rotation = angles(0, 25, 8), material = Enum.Material.Grass, animationRole = "Leaf" })
	addCylinder(parts, "StemBlock", "Stem", "Leaf", Vector3.new(0.28, 0.42, 0.28), Vector3.new(-0.18, 3.12, 0), Color3.fromRGB(58, 128, 39), { material = Enum.Material.Wood, animationRole = "Stem" })
	addFace(parts, { y = 1.3, z = -1.13, width = 2.0, height = 1.04, panelColor = Color3.fromRGB(255, 239, 156), eyeColor = Color3.fromRGB(45, 90, 40), style = "runner" })
	addPart(parts, "SportTank", "Outfit", "Outfit", Vector3.new(1.9, 0.78, 1.2), Vector3.new(0, -0.48, -0.03), green, { animationRole = "Body" })
	addPart(parts, "SportChestStripe", "Outfit", "Accent", Vector3.new(1.1, 0.15, 0.1), Vector3.new(0, -0.24, -0.66), PALETTE.White, { animationRole = "Body" })
	addPart(parts, "Shorts", "Outfit", "FruitDark", Vector3.new(1.72, 0.36, 1.12), Vector3.new(0, -0.94, -0.02), blue, { animationRole = "Body" })
	addPart(parts, "LeftSockStripe", "Detail", "Accent", Vector3.new(0.28, 0.08, 0.08), Vector3.new(-0.45, -1.28, -0.34), green, { animationRole = "LeftLeg" })
	addPart(parts, "RightSockStripe", "Detail", "Accent", Vector3.new(0.28, 0.08, 0.08), Vector3.new(0.45, -1.28, -0.34), green, { animationRole = "RightLeg" })
	addPart(parts, "LeftShoeStripe", "Detail", "Accent", Vector3.new(0.38, 0.08, 0.08), Vector3.new(-0.5, -1.78, -0.62), PALETTE.White, { animationRole = "LeftFoot" })
	addPart(parts, "RightShoeStripe", "Detail", "Accent", Vector3.new(0.38, 0.08, 0.08), Vector3.new(0.5, -1.78, -0.62), PALETTE.White, { animationRole = "RightFoot" })
	addPart(parts, "SpeedBoltLeft", "Detail", "Accent", Vector3.new(0.16, 0.5, 0.08), Vector3.new(-1.58, 0.18, -0.82), blue:Lerp(PALETTE.White, 0.2), { rotation = angles(0, 0, -24), animationRole = "LeftArm" })
	addPart(parts, "SpeedBoltRight", "Detail", "Accent", Vector3.new(0.16, 0.5, 0.08), Vector3.new(1.58, 0.18, -0.82), blue:Lerp(PALETTE.White, 0.2), { rotation = angles(0, 0, 24), animationRole = "RightArm" })
	addChibiLimbs(parts, { armColor = yellow, handColor = Color3.fromRGB(255, 226, 135), legColor = PALETTE.White, shoeColor = Color3.fromRGB(47, 143, 238), armY = -0.18, footY = -1.82, armSpread = 1.48 })
	return parts
end

local function watermeloniParts()
	local parts = {}
	local green = Color3.fromRGB(72, 178, 75)
	local dark = Color3.fromRGB(28, 103, 52)
	local red = Color3.fromRGB(221, 64, 55)

	addSphere(parts, "WatermelonBody", "Head", "Fruit", Vector3.new(4.05, 3.35, 3.25), Vector3.new(0, 1.05, 0), green, { animationRole = "Head" })
	addSphere(parts, "WatermelonBellyRound", "Head", "Fruit", Vector3.new(3.15, 1.65, 0.34), Vector3.new(0, 0.58, -1.58), green:Lerp(PALETTE.White, 0.08), { animationRole = "Head" })
	addSphere(parts, "WatermelonLeftRindCap", "Head", "FruitDark", Vector3.new(0.92, 2.7, 2.75), Vector3.new(-1.82, 1.08, 0.02), dark, { animationRole = "Head" })
	addSphere(parts, "WatermelonRightRindCap", "Head", "FruitDark", Vector3.new(0.92, 2.7, 2.75), Vector3.new(1.82, 1.08, 0.02), dark, { animationRole = "Head" })
	for index, x in ipairs({ -1.45, -0.55, 0.55, 1.45 }) do
		addPart(parts, `RindStripe{index}`, "Stripe", "FruitDark", Vector3.new(0.22, 2.65, 0.12), Vector3.new(x, 1.12, -1.66), dark, { rotation = angles(0, 0, index % 2 == 0 and 4 or -4), animationRole = "Head" })
	end
	for index, x in ipairs({ -1.0, 0, 1.0 }) do
		addPart(parts, `RindMiniStripe{index}`, "Stripe", "FruitDark", Vector3.new(0.14, 1.5, 0.1), Vector3.new(x, 2.05, -1.7), dark:Lerp(PALETTE.White, 0.08), { rotation = angles(0, 0, index == 2 and 0 or x * 4), animationRole = "Head" })
	end
	addCylinder(parts, "StemBlock", "Stem", "Leaf", Vector3.new(0.36, 0.42, 0.36), Vector3.new(0, 2.95, 0), dark, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "TopLeafStub", "Leaf", "Leaf", Vector3.new(0.76, 0.2, 0.42), Vector3.new(0.34, 3.02, -0.1), Color3.fromRGB(58, 152, 65), { className = "WedgePart", rotation = angles(0, 28, 8), animationRole = "Leaf" })
	addFace(parts, { y = 1.22, z = -1.76, width = 2.12, height = 1.02, panelColor = Color3.fromRGB(255, 220, 188), eyeColor = Color3.fromRGB(25, 47, 30), style = "wobble" })
	addCylinder(parts, "SumoBeltWrap", "Outfit", "Outfit", Vector3.new(3.35, 0.42, 2.4), Vector3.new(0, -0.5, 0), red, { rotation = angles(0, 0, 90), animationRole = "Body" })
	addPart(parts, "SumoBeltKnot", "Outfit", "Accent", Vector3.new(0.78, 0.58, 0.18), Vector3.new(0, -0.52, -1.66), Color3.fromRGB(255, 103, 91), { animationRole = "Body" })
	addPart(parts, "SumoBeltTieLeft", "Outfit", "Accent", Vector3.new(0.28, 0.42, 0.12), Vector3.new(-0.44, -0.74, -1.7), Color3.fromRGB(255, 103, 91), { rotation = angles(0, 0, 16), animationRole = "Body" })
	addPart(parts, "SumoBeltTieRight", "Outfit", "Accent", Vector3.new(0.28, 0.42, 0.12), Vector3.new(0.44, -0.74, -1.7), Color3.fromRGB(255, 103, 91), { rotation = angles(0, 0, -16), animationRole = "Body" })
	addPart(parts, "InnerSliceAccent", "Detail", "Accent", Vector3.new(1.35, 0.18, 0.08), Vector3.new(0, 0.05, -1.72), Color3.fromRGB(255, 91, 98), { animationRole = "Head" })
	addPart(parts, "InnerSliceGlow", "Detail", "Accent", Vector3.new(0.92, 0.1, 0.08), Vector3.new(0, 0.2, -1.76), Color3.fromRGB(255, 137, 139), { material = Enum.Material.Neon, transparency = 0.24, animationRole = "Head" })
	addChibiLimbs(parts, { armColor = green, handColor = Color3.fromRGB(255, 210, 174), legColor = Color3.fromRGB(55, 143, 62), shoeColor = dark, armY = -0.2, footY = -1.72, armSpread = 1.9 })
	return parts
end

local function dragonfruttoParts()
	local parts = {}
	local pink = Color3.fromRGB(235, 64, 145)
	local pinkDark = Color3.fromRGB(184, 43, 119)
	local green = Color3.fromRGB(66, 216, 116)

	addSphere(parts, "DragonfruitBody", "Head", "Fruit", Vector3.new(3.35, 3.65, 2.65), Vector3.new(0, 1.15, 0), pink, { animationRole = "Head" })
	addSphere(parts, "DragonfruitLowerGlow", "Head", "FruitDark", Vector3.new(2.5, 1.15, 2.1), Vector3.new(0, -0.52, 0.02), pinkDark, { animationRole = "Head" })
	addSphere(parts, "DragonfruitSideLeft", "Head", "FruitDark", Vector3.new(0.72, 2.35, 2.1), Vector3.new(-1.62, 1.08, 0), pinkDark:Lerp(pink, 0.22), { animationRole = "Head" })
	addSphere(parts, "DragonfruitSideRight", "Head", "FruitDark", Vector3.new(0.72, 2.35, 2.1), Vector3.new(1.62, 1.08, 0), pinkDark:Lerp(pink, 0.22), { animationRole = "Head" })
	addPart(parts, "DragonfruitFrontShine", "Detail", "Accent", Vector3.new(0.2, 1.1, 0.08), Vector3.new(-1.08, 1.82, -1.34), Color3.fromRGB(255, 112, 183), { transparency = 0.08, animationRole = "Head" })
	addSeeds(parts, {
		{ -1.1, 2.22, 0.13 }, { 0.12, 2.46, 0.13 }, { 1.05, 2.0, 0.13 },
		{ -1.25, 1.2, 0.13 }, { 1.25, 1.08, 0.13 }, { -0.45, 0.42, 0.12 }, { 0.75, 0.38, 0.12 },
	}, PALETTE.Black)
	for index, data in ipairs({
		{ -1.45, 2.65, -0.42, -28 },
		{ 1.45, 2.62, -0.35, 28 },
		{ -1.85, 1.58, 0.08, -38 },
		{ 1.85, 1.5, 0.08, 38 },
		{ 0, 3.08, 0, 0 },
		{ -0.9, 0.18, 0.14, -48 },
		{ 0.9, 0.16, 0.14, 48 },
	}) do
		addPart(parts, `GreenSpike{index}`, "Leaf", "Leaf", Vector3.new(0.62, 0.3, 0.86), Vector3.new(data[1], data[2], data[3]), green, { className = "WedgePart", rotation = angles(-5, data[4], 0), material = Enum.Material.Grass, animationRole = "Leaf" })
	end
	addFace(parts, { y = 1.2, z = -1.36, width = 2.05, height = 1.0, panelColor = Color3.fromRGB(255, 178, 214), eyeColor = PALETTE.Black, style = "shades" })
	addPart(parts, "SunglassesGlint", "Shades", "Accent", Vector3.new(0.26, 0.07, 0.08), Vector3.new(-0.67, 1.58, -1.48), PALETTE.Cyan, { material = Enum.Material.Neon, rotation = angles(0, 0, -18), animationRole = "Sunglasses" })
	addPart(parts, "DripJacket", "Outfit", "Outfit", Vector3.new(2.12, 0.78, 1.28), Vector3.new(0, -0.48, -0.02), Color3.fromRGB(36, 31, 51), { animationRole = "Body" })
	addPart(parts, "JacketLeftLapelle", "Outfit", "Accent", Vector3.new(0.28, 0.52, 0.1), Vector3.new(-0.46, -0.34, -0.72), Color3.fromRGB(68, 54, 104), { rotation = angles(0, 0, -18), animationRole = "Body" })
	addPart(parts, "JacketRightLapelle", "Outfit", "Accent", Vector3.new(0.28, 0.52, 0.1), Vector3.new(0.46, -0.34, -0.72), Color3.fromRGB(68, 54, 104), { rotation = angles(0, 0, 18), animationRole = "Body" })
	addPart(parts, "GoldChain", "Detail", "Accent", Vector3.new(1.1, 0.14, 0.1), Vector3.new(0, -0.2, -0.75), PALETTE.Gold, { material = Enum.Material.Metal, rotation = angles(0, 0, -6), animationRole = "Body" })
	addSphere(parts, "ChainCharm", "Detail", "Accent", Vector3.new(0.22, 0.22, 0.08), Vector3.new(0.28, -0.3, -0.8), PALETTE.Gold, { material = Enum.Material.Metal, animationRole = "Body" })
	addPart(parts, "CoolPoseHand", "Hand", "Skin", Vector3.new(0.26, 0.18, 0.1), Vector3.new(1.56, 0.42, -0.86), Color3.fromRGB(255, 178, 214), { rotation = angles(0, 0, -18), animationRole = "RightArm" })
	addPart(parts, "ShoeShineLeft", "Detail", "Accent", Vector3.new(0.34, 0.08, 0.08), Vector3.new(-0.5, -1.84, -0.64), Color3.fromRGB(255, 98, 170), { animationRole = "LeftFoot" })
	addPart(parts, "ShoeShineRight", "Detail", "Accent", Vector3.new(0.34, 0.08, 0.08), Vector3.new(0.5, -1.84, -0.64), Color3.fromRGB(255, 98, 170), { animationRole = "RightFoot" })
	addChibiLimbs(parts, { armColor = pink, handColor = Color3.fromRGB(255, 178, 214), legColor = Color3.fromRGB(40, 35, 52), shoeColor = Color3.fromRGB(31, 26, 45), armY = -0.18, footY = -1.9, armSpread = 1.55 })
	return parts
end

local PART_BUILDERS = {
	BananaBandito = bananaBanditoParts,
	BananitoBandito = bananaBanditoParts,
	CoconuttoBonkini = coconuttoParts,
	DragonfruttoDrippo = dragonfruttoParts,
	LemonaldoSprintini = lemonaldoParts,
	Strawberita = strawberitaParts,
	WatermeloniWobblino = watermeloniParts,
}

local RARITY_LABEL_COLORS = {
	Common = Color3.fromRGB(255, 245, 248),
	Uncommon = Color3.fromRGB(163, 255, 153),
	Rare = Color3.fromRGB(255, 211, 73),
	Epic = Color3.fromRGB(184, 116, 255),
	Legendary = Color3.fromRGB(142, 236, 255),
	Mythic = Color3.fromRGB(132, 104, 255),
}

local function getRarityColor(rarity)
	return RARITY_LABEL_COLORS[rarity or "Common"] or PALETTE.White
end

local VARIANT_PREMIUM_ACCENTS = {
	Golden = {
		color = Color3.fromRGB(255, 213, 79),
		secondary = Color3.fromRGB(255, 246, 165),
		material = Enum.Material.Metal,
		ringTransparency = 0.52,
	},
	Diamond = {
		color = Color3.fromRGB(142, 236, 255),
		secondary = Color3.fromRGB(244, 255, 255),
		material = Enum.Material.Glass,
		ringTransparency = 0.46,
	},
	Galaxy = {
		color = Color3.fromRGB(122, 96, 255),
		secondary = Color3.fromRGB(115, 245, 255),
		material = Enum.Material.Neon,
		ringTransparency = 0.5,
	},
	Cosmic = {
		color = Color3.fromRGB(112, 86, 245),
		secondary = Color3.fromRGB(116, 245, 255),
		material = Enum.Material.Neon,
		ringTransparency = 0.48,
	},
	Rainbow = {
		color = Color3.fromRGB(104, 238, 255),
		secondary = Color3.fromRGB(255, 112, 170),
		material = Enum.Material.Neon,
		ringTransparency = 0.5,
	},
	Toxic = {
		color = Color3.fromRGB(126, 255, 64),
		secondary = Color3.fromRGB(178, 91, 255),
		material = Enum.Material.Neon,
		ringTransparency = 0.56,
	},
}

local function addPremiumVariantAccents(model, root, character, variantId, scale)
	local accent = VARIANT_PREMIUM_ACCENTS[variantId]
	if not accent then
		return
	end

	model:SetAttribute("PremiumVariantAccents", "Active")

	local ringY = character.Id == "WatermeloniWobblino" and -1.96 or -2.1
	local ringSize = character.Id == "WatermeloniWobblino" and Vector3.new(0.08, 4.5, 4.5) or Vector3.new(0.08, 3.75, 3.75)
	local function addAccentPart(config)
		local part = setupPart(model, root, config, scale)
		part:SetAttribute("PremiumVariantAccent", true)
		part:SetAttribute("VariantColorRole", "Accent")
		return part
	end

	addAccentPart({
		name = "PremiumVariantGlowDisk",
		role = "VariantAccent",
		colorRole = "Accent",
		size = ringSize,
		offset = Vector3.new(0, ringY, 0),
		color = accent.color,
		material = Enum.Material.Neon,
		shape = Enum.PartType.Cylinder,
		rotation = angles(0, 0, 90),
		transparency = accent.ringTransparency,
		animationRole = "VariantAccent",
	})
	addAccentPart({
		name = "PremiumChestBadge",
		role = "VariantAccent",
		colorRole = "Accent",
		size = Vector3.new(0.38, 0.32, 0.12),
		offset = Vector3.new(0, -0.16, -0.88),
		color = accent.secondary,
		material = accent.material,
		rotation = angles(0, 0, 45),
		animationRole = "Body",
	})

	if variantId == "Golden" then
		addAccentPart({
			name = "GoldenCrownLeft",
			role = "VariantAccent",
			colorRole = "Accent",
			size = Vector3.new(0.26, 0.44, 0.16),
			offset = Vector3.new(-0.42, 3.85, -0.02),
			color = accent.secondary,
			material = Enum.Material.Metal,
			rotation = angles(0, 0, -18),
			animationRole = "Leaf",
		})
		addAccentPart({
			name = "GoldenCrownRight",
			role = "VariantAccent",
			colorRole = "Accent",
			size = Vector3.new(0.26, 0.44, 0.16),
			offset = Vector3.new(0.42, 3.85, -0.02),
			color = accent.secondary,
			material = Enum.Material.Metal,
			rotation = angles(0, 0, 18),
			animationRole = "Leaf",
		})
	elseif variantId == "Diamond" then
		for index, data in ipairs({
			{ -1.58, 0.7, -0.45, -18 },
			{ 1.58, 0.72, -0.45, 18 },
			{ 0, 3.58, 0.06, 0 },
		}) do
			addAccentPart({
				name = `DiamondShard{index}`,
				role = "VariantAccent",
				colorRole = "Accent",
				size = Vector3.new(0.28, 0.62, 0.18),
				offset = Vector3.new(data[1], data[2], data[3]),
				color = index == 3 and accent.secondary or accent.color,
				material = Enum.Material.Glass,
				rotation = angles(0, 0, data[4]),
				animationRole = index == 3 and "Leaf" or "Head",
			})
		end
	elseif variantId == "Galaxy" or variantId == "Cosmic" then
		for index, data in ipairs({
			{ -1.25, 2.15, -1.2 },
			{ 1.2, 1.55, -1.2 },
			{ -0.52, 0.22, -1.15 },
			{ 0.65, 2.72, -0.72 },
		}) do
			addAccentPart({
				name = `CosmicStarChip{index}`,
				role = "VariantAccent",
				colorRole = "Accent",
				size = Vector3.new(0.16, 0.16, 0.08),
				offset = Vector3.new(data[1], data[2], data[3]),
				color = index % 2 == 0 and accent.secondary or accent.color,
				material = Enum.Material.Neon,
				rotation = angles(0, 0, 45),
				animationRole = "Head",
			})
		end
		addAccentPart({
			name = "CosmicOrbitFront",
			role = "VariantAccent",
			colorRole = "Accent",
			size = Vector3.new(2.3, 0.08, 0.08),
			offset = Vector3.new(0, 0.34, -1.24),
			color = accent.secondary,
			material = Enum.Material.Neon,
			transparency = 0.18,
			rotation = angles(0, 0, -8),
			animationRole = "Head",
		})
	elseif variantId == "Rainbow" then
		for index, color in ipairs({
			Color3.fromRGB(255, 95, 124),
			Color3.fromRGB(255, 213, 82),
			Color3.fromRGB(107, 235, 116),
			Color3.fromRGB(104, 238, 255),
		}) do
			addAccentPart({
				name = `RainbowShowcaseStripe{index}`,
				role = "VariantAccent",
				colorRole = "Accent",
				size = Vector3.new(0.58, 0.12, 0.08),
				offset = Vector3.new(-0.9 + (index - 1) * 0.6, -0.04, -1.08),
				color = color,
				material = Enum.Material.Neon,
				animationRole = "Body",
			})
		end
	elseif variantId == "Toxic" then
		for index, data in ipairs({
			{ -1.08, 1.95, -1.22, accent.color },
			{ 1.0, 0.58, -1.16, accent.secondary },
			{ 0.3, 2.72, -0.78, accent.color },
		}) do
			addAccentPart({
				name = `ToxicBubbleGem{index}`,
				role = "VariantAccent",
				colorRole = "Accent",
				size = Vector3.new(0.24, 0.24, 0.1),
				offset = Vector3.new(data[1], data[2], data[3]),
				color = data[4],
				material = Enum.Material.Neon,
				shape = Enum.PartType.Ball,
				transparency = 0.18,
				animationRole = "Head",
			})
		end
	end
end

local function addPreviewLabel(root, text, rarity, scale)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CharacterLabel"
	billboard.Size = UDim2.fromOffset(178, 56)
	billboard.StudsOffset = Vector3.new(0, 5.15 * (scale or 1), 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 64
	billboard.LightInfluence = 0.15
	billboard.Parent = root

	local frame = Instance.new("Frame")
	frame.Name = "LabelPlate"
	frame.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
	frame.BackgroundTransparency = 0.18
	frame.BorderSizePixel = 0
	frame.Size = UDim2.fromScale(1, 1)
	frame.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Name = "LabelStroke"
	stroke.Color = getRarityColor(rarity)
	stroke.Thickness = 2
	stroke.Transparency = 0.08
	stroke.Parent = frame

	local strip = Instance.new("Frame")
	strip.Name = "RarityStrip"
	strip.BackgroundColor3 = getRarityColor(rarity)
	strip.BorderSizePixel = 0
	strip.Size = UDim2.new(1, 0, 0, 5)
	strip.Parent = frame

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = `{text}\n{rarity or "Common"}`
	label.TextColor3 = getRarityColor(rarity)
	label.TextScaled = true
	label.TextStrokeColor3 = PALETTE.Black
	label.TextStrokeTransparency = 0.08
	label.TextWrapped = true
	label.Position = UDim2.fromOffset(6, 4)
	label.Size = UDim2.new(1, -12, 1, -8)
	label.Parent = frame

	local constraint = Instance.new("UITextSizeConstraint")
	constraint.MinTextSize = 8
	constraint.MaxTextSize = 18
	constraint.Parent = label
end

function BrainrotModelFactory.create(characterId, variantId, options)
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
	model:SetAttribute("Style", "PremiumVoxelChibiMascot")
	model:SetAttribute("ShowcaseVisualTier", "PremiumPartBuilt_V2")
	model:SetAttribute("CharacterRegistryVersion", CharacterRegistry.Version)
	model:SetAttribute("BrainrotModelFactoryVersion", BrainrotModelFactory.Version)
	model:SetAttribute("CharacterModelFactoryVersion", BrainrotModelFactory.Version)
	model:SetAttribute("ReferencePath", character.ReferencePath)
	model:SetAttribute("ReferenceFolderPath", character.ReferenceFolderPath)
	model:SetAttribute("BaseReferenceImagePath", character.BaseReferenceImagePath)
	model:SetAttribute("NotesPath", character.NotesPath)
	model:SetAttribute("PlaceholderModelName", character.PlaceholderModelName)
	model:SetAttribute("AnimationStyle", character.AnimationStyle)
	model:SetAttribute("BaseIncome", character.BaseIncome or 1)
	model:SetAttribute("SellValue", character.SellValue or 0)
	model:SetAttribute("IncomeMultiplier", (character.IncomeMultiplier or 1) * (variant.IncomeMultiplierModifier or 1))

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
	if options.variantAccents ~= false then
		addPremiumVariantAccents(model, root, character, normalizedVariantId, scale)
	end
	model:PivotTo(pivot)

	if options.label ~= false then
		addPreviewLabel(root, variant.DisplayName or character.DisplayName, variant.Rarity or character.Rarity, scale)
	end

	return model
end

function BrainrotModelFactory.createPreviewLineup(parent, characterIds, origin, variantId)
	local created = {}
	local line = characterIds or CharacterRegistry.CharacterOrder
	origin = origin or CFrame.new()
	for index, characterId in ipairs(line) do
		local model = BrainrotModelFactory.create(characterId, variantId or "Base", {
			anchored = true,
			label = true,
			pivot = origin * CFrame.new((index - 1) * 8.5, 0, 0),
		})
		model.Parent = parent
		table.insert(created, model)
	end
	return created
end

return BrainrotModelFactory
