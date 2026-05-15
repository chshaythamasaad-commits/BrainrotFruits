local StrawberitaVoxelData = {}

StrawberitaVoxelData.Version = "StrawberitaVoxelSixAngleReference_20260515_V3"
StrawberitaVoxelData.ReferencePath = "references/modelreferences/CharactersRefs/Characters/Strawberita"
StrawberitaVoxelData.BlueprintPath = "references/modelreferences/CharactersRefs/Characters/Strawberita/BUILD_BLUEPRINT.md"
StrawberitaVoxelData.ReferenceDescription = "Six-angle LEGO/voxel Strawberita reference folder with CHARACTER_NOTES.md."
StrawberitaVoxelData.EstimatedHeightStuds = 8.4
StrawberitaVoxelData.SinglePreviewEstimatedHeightStuds = 8.44
StrawberitaVoxelData.SinglePreviewEstimatedWidthStuds = 9.44
StrawberitaVoxelData.SinglePreviewEstimatedDepthStuds = 5.72
StrawberitaVoxelData.SOURCE_MODEL_SCALE = 1.0
StrawberitaVoxelData.PREVIEW_SCALE = 1.0
StrawberitaVoxelData.GAMEPLAY_FOLLOW_SCALE = 0.65

local Palette = {
	Red = Color3.fromRGB(238, 38, 32),
	RedLight = Color3.fromRGB(255, 58, 38),
	RedDark = Color3.fromRGB(179, 25, 27),
	RedSeam = Color3.fromRGB(128, 18, 20),
	Seed = Color3.fromRGB(255, 202, 27),
	Green = Color3.fromRGB(75, 181, 28),
	GreenLight = Color3.fromRGB(101, 213, 48),
	GreenDark = Color3.fromRGB(42, 122, 20),
	Stem = Color3.fromRGB(68, 154, 34),
	Pink = Color3.fromRGB(255, 71, 141),
	PinkLight = Color3.fromRGB(255, 111, 177),
	White = Color3.fromRGB(255, 249, 244),
	WhiteShade = Color3.fromRGB(222, 216, 214),
	Black = Color3.fromRGB(16, 16, 17),
	EyeBlack = Color3.fromRGB(13, 14, 15),
	Peach = Color3.fromRGB(255, 197, 166),
	PeachShade = Color3.fromRGB(231, 139, 105),
}

local function angles(x, y, z)
	return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
end

local function addPart(parts, name, role, colorRole, size, offset, color, options)
	options = options or {}
	table.insert(parts, {
		name = name,
		role = role,
		colorRole = colorRole,
		size = size,
		offset = offset,
		color = color,
		material = options.material,
		rotation = options.rotation,
		className = options.className,
		transparency = options.transparency,
		animationRole = options.animationRole or role,
	})
end

local function addBodyRows(parts)
	local rows = {
		{ "TopCap", 4.35, 0.38, 3.55, 3.28 },
		{ "TopShoulder", 5.25, 0.42, 3.9, 2.89 },
		{ "BrowRow", 5.78, 0.45, 4.08, 2.47 },
		{ "EyeRow", 6.08, 0.48, 4.18, 2.02 },
		{ "UpperFaceRow", 6.18, 0.48, 4.22, 1.55 },
		{ "CenterFaceRow", 6.18, 0.5, 4.22, 1.07 },
		{ "GrinRow", 6.06, 0.5, 4.16, 0.58 },
		{ "LowerBodyRow", 5.8, 0.48, 4.02, 0.1 },
		{ "LowerTaperRow", 5.42, 0.44, 3.82, -0.35 },
		{ "SkirtSeatRow", 4.72, 0.4, 3.42, -0.75 },
	}

	for index, row in ipairs(rows) do
		local name, width, height, depth, y = row[1], row[2], row[3], row[4], row[5]
		local color = (index <= 2) and Palette.RedLight or Palette.Red
		addPart(
			parts,
			`Berry{name}`,
			"Head",
			"Fruit",
			Vector3.new(width, height, depth),
			Vector3.new(0, y, 0),
			color,
			{ animationRole = "Head" }
		)

		addPart(
			parts,
			`Berry{name}LeftShade`,
			"BodyDark",
			"FruitDark",
			Vector3.new(0.24, height + 0.02, depth - 0.16),
			Vector3.new(-width * 0.5 + 0.12, y, 0.02),
			Palette.RedDark,
			{ animationRole = "Head" }
		)
		addPart(
			parts,
			`Berry{name}RightShade`,
			"BodyDark",
			"FruitDark",
			Vector3.new(0.24, height + 0.02, depth - 0.16),
			Vector3.new(width * 0.5 - 0.12, y, 0.02),
			Palette.RedDark,
			{ animationRole = "Head" }
		)
	end

	for _, data in ipairs({
		{ "LeftUpperCorner", -3.08, 2.3, 0.34, 1.25, 3.42 },
		{ "RightUpperCorner", 3.08, 2.3, 0.34, 1.25, 3.42 },
		{ "LeftMiddleCorner", -3.18, 1.18, 0.3, 1.8, 3.56 },
		{ "RightMiddleCorner", 3.18, 1.18, 0.3, 1.8, 3.56 },
		{ "LeftLowerCorner", -2.92, -0.08, 0.32, 0.9, 3.16 },
		{ "RightLowerCorner", 2.92, -0.08, 0.32, 0.9, 3.16 },
	}) do
		addPart(
			parts,
			`Berry{data[1]}`,
			"BodyDark",
			"FruitDark",
			Vector3.new(data[4], data[5], data[6]),
			Vector3.new(data[2], data[3], 0),
			Palette.RedDark,
			{ animationRole = "Head" }
		)
	end
end

local function addGridSurface(parts)
	local frontZ = -2.13
	local backZ = 2.13
	for index, data in ipairs({
		{ 3.08, 4.34 },
		{ 2.64, 5.32 },
		{ 2.18, 5.88 },
		{ 1.72, 6.16 },
		{ 1.25, 6.18 },
		{ 0.78, 6.08 },
		{ 0.3, 5.86 },
		{ -0.18, 5.5 },
		{ -0.58, 4.82 },
	}) do
		addPart(parts, `FrontGridHorizontal{index}`, "BodyShade", "FruitDark", Vector3.new(data[2], 0.045, 0.055), Vector3.new(0, data[1], frontZ), Palette.RedSeam, { animationRole = "Head" })
		addPart(parts, `BackGridHorizontal{index}`, "BodyShade", "FruitDark", Vector3.new(data[2], 0.045, 0.055), Vector3.new(0, data[1], backZ), Palette.RedSeam, { animationRole = "Head" })
	end

	for index, x in ipairs({ -2.52, -1.96, -1.4, -0.84, -0.28, 0.28, 0.84, 1.4, 1.96, 2.52 }) do
		local height = math.abs(x) > 2.3 and 2.9 or 3.72
		local y = math.abs(x) > 2.3 and 1.16 or 1.28
		addPart(parts, `FrontGridVertical{index}`, "BodyShade", "FruitDark", Vector3.new(0.045, height, 0.055), Vector3.new(x, y, frontZ - 0.01), Palette.RedSeam, { animationRole = "Head" })
		addPart(parts, `BackGridVertical{index}`, "BodyShade", "FruitDark", Vector3.new(0.045, height, 0.055), Vector3.new(x, y, backZ + 0.01), Palette.RedSeam, { animationRole = "Head" })
	end

	for index, y in ipairs({ 2.72, 2.0, 1.28, 0.56, -0.16 }) do
		addPart(parts, `LeftSideGridHorizontal{index}`, "BodyShade", "FruitDark", Vector3.new(0.055, 0.045, 3.52), Vector3.new(-3.08, y, 0), Palette.RedSeam, { animationRole = "Head" })
		addPart(parts, `RightSideGridHorizontal{index}`, "BodyShade", "FruitDark", Vector3.new(0.055, 0.045, 3.52), Vector3.new(3.08, y, 0), Palette.RedSeam, { animationRole = "Head" })
	end
	for index, z in ipairs({ -1.45, -0.72, 0, 0.72, 1.45 }) do
		addPart(parts, `LeftSideGridVertical{index}`, "BodyShade", "FruitDark", Vector3.new(0.055, 3.35, 0.045), Vector3.new(-3.09, 1.24, z), Palette.RedSeam, { animationRole = "Head" })
		addPart(parts, `RightSideGridVertical{index}`, "BodyShade", "FruitDark", Vector3.new(0.055, 3.35, 0.045), Vector3.new(3.09, 1.24, z), Palette.RedSeam, { animationRole = "Head" })
	end
end

local function addSeed(parts, name, x, y, z, side)
	local size = side and Vector3.new(0.12, 0.3, 0.28) or Vector3.new(0.3, 0.3, 0.12)
	addPart(parts, name, "Seed", "Seed", size, Vector3.new(x, y, z), Palette.Seed, { animationRole = "Seed" })
end

local function addSeeds(parts)
	for index, seed in ipairs({
		{ -2.36, 2.84 }, { -1.18, 2.96 }, { 0.15, 2.82 }, { 1.42, 2.94 }, { 2.48, 2.72 },
		{ -2.72, 2.18 }, { -0.28, 2.22 }, { 1.32, 2.2 }, { 2.6, 2.12 },
		{ -2.64, 1.42 }, { -1.7, 1.12 }, { 1.7, 1.12 }, { 2.6, 1.42 },
		{ -2.42, 0.62 }, { -1.3, 0.34 }, { 1.28, 0.34 }, { 2.42, 0.62 },
		{ -2.0, -0.16 }, { -0.72, -0.3 }, { 0.72, -0.3 }, { 2.0, -0.16 },
	}) do
		addSeed(parts, `FrontSeed{index}`, seed[1], seed[2], -2.15, false)
	end

	for index, seed in ipairs({
		{ -3.16, 2.48, -1.15 }, { -3.2, 1.66, 0.05 }, { -3.16, 0.82, 1.16 }, { -3.0, -0.08, -0.82 },
		{ 3.16, 2.48, -1.15 }, { 3.2, 1.66, 0.05 }, { 3.16, 0.82, 1.16 }, { 3.0, -0.08, -0.82 },
	}) do
		addSeed(parts, `SideSeed{index}`, seed[1], seed[2], seed[3], true)
	end

	for index, seed in ipairs({
		{ -2.0, 2.74 }, { -0.6, 2.92 }, { 0.9, 2.72 }, { 2.22, 2.42 },
		{ -2.42, 1.72 }, { -1.08, 1.36 }, { 0.42, 1.58 }, { 1.9, 1.34 },
		{ -2.02, 0.58 }, { -0.45, 0.26 }, { 1.1, 0.48 },
	}) do
		addSeed(parts, `BackSeed{index}`, seed[1], seed[2], 2.15, false)
	end
end

local function addFace(parts)
	addPart(parts, "LeftEyeWhiteBlock", "EyeWhite", "Eye", Vector3.new(1.08, 0.88, 0.13), Vector3.new(-1.06, 1.42, -2.17), Palette.White, { animationRole = "EyeLeft" })
	addPart(parts, "RightEyeWhiteBlock", "EyeWhite", "Eye", Vector3.new(1.08, 0.88, 0.13), Vector3.new(1.06, 1.42, -2.17), Palette.White, { animationRole = "EyeRight" })
	addPart(parts, "LeftEyeBlackPupil", "EyePupil", "Eye", Vector3.new(0.42, 0.62, 0.14), Vector3.new(-0.88, 1.36, -2.27), Palette.EyeBlack, { animationRole = "EyeLeft" })
	addPart(parts, "RightEyeBlackPupil", "EyePupil", "Eye", Vector3.new(0.42, 0.62, 0.14), Vector3.new(0.88, 1.36, -2.27), Palette.EyeBlack, { animationRole = "EyeRight" })
	addPart(parts, "LeftEyeSpark", "EyeWhite", "Eye", Vector3.new(0.16, 0.16, 0.15), Vector3.new(-0.74, 1.62, -2.36), Palette.White, { material = Enum.Material.Neon, animationRole = "EyeLeft" })
	addPart(parts, "RightEyeSpark", "EyeWhite", "Eye", Vector3.new(0.16, 0.16, 0.15), Vector3.new(0.74, 1.62, -2.36), Palette.White, { material = Enum.Material.Neon, animationRole = "EyeRight" })
	addPart(parts, "LeftEyeOuterCorner", "EyeFrame", "Eye", Vector3.new(0.16, 0.54, 0.13), Vector3.new(-1.56, 1.32, -2.28), Palette.Black, { rotation = angles(0, 0, -8), animationRole = "EyeLeft" })
	addPart(parts, "RightEyeOuterCorner", "EyeFrame", "Eye", Vector3.new(0.16, 0.54, 0.13), Vector3.new(1.56, 1.32, -2.28), Palette.Black, { rotation = angles(0, 0, 8), animationRole = "EyeRight" })
	addPart(parts, "LeftEyelidShadow", "EyeFrame", "Eye", Vector3.new(0.98, 0.18, 0.14), Vector3.new(-1.08, 1.8, -2.28), Palette.Black, { rotation = angles(0, 0, -13), animationRole = "EyeLeft" })
	addPart(parts, "RightEyelidShadow", "EyeFrame", "Eye", Vector3.new(0.98, 0.18, 0.14), Vector3.new(1.08, 1.8, -2.28), Palette.Black, { rotation = angles(0, 0, 13), animationRole = "EyeRight" })
	addPart(parts, "LeftDeviousBrow", "EyeFrame", "Eye", Vector3.new(1.72, 0.3, 0.18), Vector3.new(-1.23, 2.02, -2.36), Palette.Black, { rotation = angles(0, 0, -22), animationRole = "EyeLeft" })
	addPart(parts, "RightDeviousBrow", "EyeFrame", "Eye", Vector3.new(1.72, 0.3, 0.18), Vector3.new(1.23, 2.02, -2.36), Palette.Black, { rotation = angles(0, 0, 22), animationRole = "EyeRight" })

	addPart(parts, "SmugGrinBlackBack", "Smile", "Eye", Vector3.new(2.72, 0.74, 0.12), Vector3.new(0, 0.58, -2.19), Palette.Black, { animationRole = "Mouth" })
	addPart(parts, "SmugGrinWhiteTeeth", "Smile", "Face", Vector3.new(2.36, 0.44, 0.13), Vector3.new(0, 0.63, -2.29), Palette.White, { animationRole = "Mouth" })
	for index, x in ipairs({ -0.78, -0.26, 0.26, 0.78 }) do
		addPart(parts, `SmugGrinToothLine{index}`, "Smile", "Face", Vector3.new(0.04, 0.38, 0.14), Vector3.new(x, 0.61, -2.39), Palette.WhiteShade, { animationRole = "Mouth" })
	end
	addPart(parts, "SmugGrinLowerShadow", "Smile", "Eye", Vector3.new(2.0, 0.14, 0.14), Vector3.new(0, 0.28, -2.35), Palette.Black, { animationRole = "Mouth" })
	addPart(parts, "SmugGrinLeftHook", "Smile", "Eye", Vector3.new(0.58, 0.16, 0.14), Vector3.new(-1.42, 0.64, -2.34), Palette.Black, { rotation = angles(0, 0, -44), animationRole = "Mouth" })
	addPart(parts, "SmugGrinRightHook", "Smile", "Eye", Vector3.new(0.58, 0.16, 0.14), Vector3.new(1.42, 0.64, -2.34), Palette.Black, { rotation = angles(0, 0, 44), animationRole = "Mouth" })
	addPart(parts, "SmugGrinLeftDimple", "Smile", "Eye", Vector3.new(0.18, 0.22, 0.14), Vector3.new(-1.52, 0.52, -2.36), Palette.Black, { rotation = angles(0, 0, -18), animationRole = "Mouth" })
	addPart(parts, "SmugGrinRightDimple", "Smile", "Eye", Vector3.new(0.18, 0.22, 0.14), Vector3.new(1.52, 0.52, -2.36), Palette.Black, { rotation = angles(0, 0, 18), animationRole = "Mouth" })
end

local function addLeafCrown(parts)
	addPart(parts, "LeafBasePad", "Leaf", "Leaf", Vector3.new(2.4, 0.28, 1.72), Vector3.new(0, 3.56, -0.08), Palette.Green, { animationRole = "Leaf" })
	addPart(parts, "LeafBackShelf", "LeafShadow", "Leaf", Vector3.new(5.7, 0.34, 1.48), Vector3.new(0, 3.58, 0.82), Palette.GreenDark, { className = "WedgePart", rotation = angles(4, 180, 0), animationRole = "Leaf" })
	addPart(parts, "LeafFrontShelf", "Leaf", "Leaf", Vector3.new(5.55, 0.38, 1.54), Vector3.new(0, 3.6, -0.82), Palette.Green, { className = "WedgePart", rotation = angles(-7, 0, 0), animationRole = "Leaf" })
	addPart(parts, "LeafCenterDrop", "Leaf", "Leaf", Vector3.new(1.48, 0.58, 1.58), Vector3.new(0, 3.55, -1.5), Palette.GreenLight, { className = "WedgePart", rotation = angles(-19, 0, 0), animationRole = "Leaf" })
	addPart(parts, "LeafLeftWideBlade", "LeafShadow", "Leaf", Vector3.new(1.92, 0.36, 1.5), Vector3.new(-2.32, 3.58, -0.18), Palette.GreenDark, { className = "WedgePart", rotation = angles(-5, -38, 0), animationRole = "Leaf" })
	addPart(parts, "LeafRightWideBlade", "LeafShadow", "Leaf", Vector3.new(1.92, 0.36, 1.5), Vector3.new(2.32, 3.58, -0.18), Palette.GreenDark, { className = "WedgePart", rotation = angles(-5, 38, 0), animationRole = "Leaf" })
	addPart(parts, "LeafLeftFrontBlade", "Leaf", "Leaf", Vector3.new(1.42, 0.38, 1.3), Vector3.new(-1.18, 3.76, -1.22), Palette.Green, { className = "WedgePart", rotation = angles(-10, -22, 0), animationRole = "Leaf" })
	addPart(parts, "LeafRightFrontBlade", "Leaf", "Leaf", Vector3.new(1.42, 0.38, 1.3), Vector3.new(1.18, 3.76, -1.22), Palette.Green, { className = "WedgePart", rotation = angles(-10, 22, 0), animationRole = "Leaf" })
	addPart(parts, "LeafLeftSideTip", "Leaf", "Leaf", Vector3.new(1.22, 0.32, 1.22), Vector3.new(-2.72, 3.68, -1.08), Palette.GreenLight, { className = "WedgePart", rotation = angles(-8, -58, 0), animationRole = "Leaf" })
	addPart(parts, "LeafRightSideTip", "Leaf", "Leaf", Vector3.new(1.22, 0.32, 1.22), Vector3.new(2.72, 3.68, -1.08), Palette.GreenLight, { className = "WedgePart", rotation = angles(-8, 58, 0), animationRole = "Leaf" })
	addPart(parts, "LeafLeftBackBlade", "LeafShadow", "Leaf", Vector3.new(1.42, 0.32, 1.34), Vector3.new(-1.28, 3.66, 1.34), Palette.GreenDark, { className = "WedgePart", rotation = angles(5, -142, 0), animationRole = "Leaf" })
	addPart(parts, "LeafRightBackBlade", "LeafShadow", "Leaf", Vector3.new(1.42, 0.32, 1.34), Vector3.new(1.28, 3.66, 1.34), Palette.GreenDark, { className = "WedgePart", rotation = angles(5, 142, 0), animationRole = "Leaf" })
	addPart(parts, "LeafTopCenterBlock", "Leaf", "Leaf", Vector3.new(0.9, 0.36, 0.9), Vector3.new(0, 4.02, -0.08), Palette.GreenLight, { animationRole = "Leaf" })

	addPart(parts, "StemBlock", "Stem", "Leaf", Vector3.new(0.46, 1.08, 0.46), Vector3.new(0.24, 4.52, 0.18), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "StemCurlTop", "Stem", "Leaf", Vector3.new(0.95, 0.42, 0.42), Vector3.new(-0.1, 5.13, 0.18), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "StemCurlDown", "Stem", "Leaf", Vector3.new(0.4, 0.68, 0.4), Vector3.new(-0.62, 4.84, 0.18), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "StemCurlTip", "Stem", "Leaf", Vector3.new(0.54, 0.3, 0.38), Vector3.new(-0.82, 4.48, 0.18), Palette.Stem, { material = Enum.Material.Wood, rotation = angles(0, 0, -18), animationRole = "Stem" })
end

local function addBow(parts)
	addPart(parts, "BowBackPlate", "Bow", "Accent", Vector3.new(1.9, 1.02, 0.12), Vector3.new(2.18, 2.56, -2.08), Palette.Pink, { animationRole = "Head" })
	addPart(parts, "BowKnot", "Bow", "Accent", Vector3.new(0.5, 0.56, 0.24), Vector3.new(2.18, 2.58, -2.15), Palette.Pink, { animationRole = "Head" })
	addPart(parts, "BowLeftLoop", "Bow", "Accent", Vector3.new(0.96, 0.78, 0.24), Vector3.new(1.55, 2.62, -2.14), Palette.PinkLight, { rotation = angles(0, 0, 12), animationRole = "Head" })
	addPart(parts, "BowRightLoop", "Bow", "Accent", Vector3.new(0.96, 0.78, 0.24), Vector3.new(2.82, 2.6, -2.14), Palette.PinkLight, { rotation = angles(0, 0, -12), animationRole = "Head" })
	addPart(parts, "BowLeftTail", "Bow", "Accent", Vector3.new(0.46, 0.6, 0.22), Vector3.new(1.88, 2.1, -2.13), Palette.Pink, { rotation = angles(0, 0, -12), animationRole = "Head" })
	addPart(parts, "BowRightTail", "Bow", "Accent", Vector3.new(0.46, 0.6, 0.22), Vector3.new(2.48, 2.1, -2.13), Palette.Pink, { rotation = angles(0, 0, 12), animationRole = "Head" })

	for index, dot in ipairs({
		{ 1.34, 2.78 }, { 1.7, 2.44 }, { 2.62, 2.8 }, { 2.98, 2.42 }, { 2.18, 2.6 },
	}) do
		addPart(parts, `BowDot{index}`, "Bow", "Face", Vector3.new(0.16, 0.16, 0.06), Vector3.new(dot[1], dot[2], -2.29), Palette.White, { animationRole = "Head" })
	end
end

local function addSkirt(parts)
	addPart(parts, "SkirtBandFront", "Body", "Outfit", Vector3.new(5.36, 0.36, 0.26), Vector3.new(0, -1.02, -1.82), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SkirtBandBack", "Body", "Outfit", Vector3.new(5.36, 0.36, 0.26), Vector3.new(0, -1.02, 1.82), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SkirtBandLeft", "Body", "Outfit", Vector3.new(0.26, 0.36, 3.48), Vector3.new(-2.8, -1.02, 0), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SkirtBandRight", "Body", "Outfit", Vector3.new(0.26, 0.36, 3.48), Vector3.new(2.8, -1.02, 0), Palette.Pink, { animationRole = "Body" })

	for index, x in ipairs({ -2.08, -1.38, -0.68, 0, 0.68, 1.38, 2.08 }) do
		addPart(parts, `SkirtBandFrontStud{index}`, "SockCuff", "Face", Vector3.new(0.24, 0.22, 0.07), Vector3.new(x, -1.0, -1.99), Palette.PinkLight, { animationRole = "Body" })
	end

	for index, x in ipairs({ -2.16, -1.54, -0.92, -0.31, 0.31, 0.92, 1.54, 2.16 }) do
		local rotation = (index % 2 == 0) and angles(0, 0, -5) or angles(0, 0, 5)
		addPart(parts, `FrontRuffleBlock{index}`, "SockCuff", "Face", Vector3.new(0.54, 0.3, 0.42), Vector3.new(x, -1.36, -1.84), Palette.White, { rotation = rotation, animationRole = "Body" })
	end
	for index, x in ipairs({ -1.8, -0.9, 0, 0.9, 1.8 }) do
		addPart(parts, `BackRuffleBlock{index}`, "SockCuff", "Face", Vector3.new(0.54, 0.24, 0.32), Vector3.new(x, -1.36, 1.84), Palette.WhiteShade, { animationRole = "Body" })
	end
end

local function addArms(parts)
	addPart(parts, "LeftShoulderSocket", "Arm", "FruitDark", Vector3.new(0.42, 0.84, 0.82), Vector3.new(-2.98, 0.78, -0.08), Palette.RedDark, { rotation = angles(0, 0, -12), animationRole = "LeftArm" })
	addPart(parts, "RightShoulderSocket", "Arm", "FruitDark", Vector3.new(0.42, 0.84, 0.82), Vector3.new(2.98, 0.78, -0.08), Palette.RedDark, { rotation = angles(0, 0, 12), animationRole = "RightArm" })
	addPart(parts, "LeftUpperArmBlock", "Arm", "Fruit", Vector3.new(0.78, 1.14, 0.7), Vector3.new(-3.25, 0.34, -0.2), Palette.Red, { rotation = angles(0, 0, -18), animationRole = "LeftArm" })
	addPart(parts, "RightUpperArmBlock", "Arm", "Fruit", Vector3.new(0.78, 1.14, 0.7), Vector3.new(3.25, 0.34, -0.2), Palette.Red, { rotation = angles(0, 0, 18), animationRole = "RightArm" })
	addPart(parts, "LeftLowerArmBlock", "Arm", "FruitDark", Vector3.new(0.82, 0.9, 0.72), Vector3.new(-3.55, -0.38, -0.3), Palette.RedDark, { rotation = angles(0, 0, 24), animationRole = "LeftArm" })
	addPart(parts, "RightLowerArmBlock", "Arm", "FruitDark", Vector3.new(0.82, 0.9, 0.72), Vector3.new(3.55, -0.38, -0.3), Palette.RedDark, { rotation = angles(0, 0, -24), animationRole = "RightArm" })
	addPart(parts, "LeftFistBlock", "Hand", "Fruit", Vector3.new(1.18, 0.98, 0.96), Vector3.new(-3.88, -0.88, -0.38), Palette.Red, { rotation = angles(0, 0, -12), animationRole = "LeftArm" })
	addPart(parts, "RightFistBlock", "Hand", "Fruit", Vector3.new(1.18, 0.98, 0.96), Vector3.new(3.88, -0.88, -0.38), Palette.Red, { rotation = angles(0, 0, 12), animationRole = "RightArm" })

	for _, side in ipairs({ { "Left", -1 }, { "Right", 1 } }) do
		local sideName, sign = side[1], side[2]
		for index, y in ipairs({ -0.52, -0.84, -1.16 }) do
			addPart(parts, `{sideName}FistFinger{index}`, "Hand", "FruitDark", Vector3.new(0.26, 0.25, 0.32), Vector3.new(sign * 3.62, y, -0.9), Palette.RedDark, { animationRole = `{sideName}Arm` })
		end
		addSeed(parts, `{sideName}ArmSeedTop`, sign * 3.36, 0.12, -0.58, false)
		addSeed(parts, `{sideName}FistSeed`, sign * 4.0, -0.68, -0.9, false)
	end
end

local function addLegsAndShoes(parts)
	for _, side in ipairs({ { "Left", -0.88 }, { "Right", 0.88 } }) do
		local sideName, x = side[1], side[2]
		addPart(parts, `{sideName}SockUpperPink`, "Sock", "Outfit", Vector3.new(0.6, 0.3, 0.52), Vector3.new(x, -1.54, -0.04), Palette.Pink, { animationRole = `{sideName}Leg` })
		addPart(parts, `{sideName}SockWhiteStripeUpper`, "SockCuff", "Face", Vector3.new(0.62, 0.32, 0.54), Vector3.new(x, -1.83, -0.04), Palette.White, { animationRole = `{sideName}Leg` })
		addPart(parts, `{sideName}SockPinkStripeLower`, "Sock", "Outfit", Vector3.new(0.62, 0.32, 0.54), Vector3.new(x, -2.12, -0.04), Palette.Pink, { animationRole = `{sideName}Leg` })
		addPart(parts, `{sideName}ShoeBlock`, "Shoe", "Shoe", Vector3.new(1.18, 0.56, 1.34), Vector3.new(x, -2.3, -0.28), Palette.Red, { animationRole = `{sideName}Foot` })
		addPart(parts, `{sideName}ShoeFrontToe`, "Shoe", "Shoe", Vector3.new(1.28, 0.38, 0.48), Vector3.new(x, -2.19, -1.05), Palette.RedLight, { animationRole = `{sideName}Foot` })
		addPart(parts, `{sideName}ShoeWhiteSole`, "ShoePanel", "Face", Vector3.new(1.32, 0.22, 1.46), Vector3.new(x, -2.58, -0.28), Palette.WhiteShade, { animationRole = `{sideName}Foot` })
		addPart(parts, `{sideName}ShoeToeWhiteTrim`, "ShoePanel", "Face", Vector3.new(1.1, 0.18, 0.14), Vector3.new(x, -2.13, -1.31), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `{sideName}ShoeLaceOne`, "ShoePanel", "Face", Vector3.new(0.5, 0.09, 0.09), Vector3.new(x - 0.22, -2.0, -1.34), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `{sideName}ShoeLaceTwo`, "ShoePanel", "Face", Vector3.new(0.5, 0.09, 0.09), Vector3.new(x + 0.22, -2.0, -1.34), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `{sideName}ShoeSideStripe`, "ShoePanel", "Face", Vector3.new(0.12, 0.18, 0.48), Vector3.new(x + (x < 0 and -0.66 or 0.66), -2.26, -0.2), Palette.White, { animationRole = `{sideName}Foot` })
		addSeed(parts, `{sideName}ShoeSideSeed`, x + (x < 0 and -0.68 or 0.68), -2.18, -0.24, true)
	end
end

local function createLegacySharedParts()
	local parts = {}
	local frontZ = -2.16
	local backZ = 2.16
	local cellX = 0.52
	local cellZ = 0.52
	local layerHeight = 0.5
	local bodyLayers = {
		{ -0.61, 10, 6, Palette.RedDark },
		{ -0.16, 11, 7, Palette.Red },
		{ 0.29, 12, 7, Palette.Red },
		{ 0.74, 12, 8, Palette.Red },
		{ 1.19, 12, 8, Palette.Red },
		{ 1.64, 12, 8, Palette.Red },
		{ 2.09, 12, 7, Palette.Red },
		{ 2.54, 11, 7, Palette.RedLight },
		{ 2.99, 10, 6, Palette.RedLight },
	}

	for layerIndex, layer in ipairs(bodyLayers) do
		local y, widthCells, depthCells, color = layer[1], layer[2], layer[3], layer[4]
		local halfDepth = (depthCells - 1) * 0.5
		for depthIndex = 1, depthCells do
			local edgeDistance = math.min(depthIndex - 1, depthCells - depthIndex)
			-- BUILD_BLUEPRINT: flat mascot slab with only slight block-rounded corners.
			local cornerCut = edgeDistance == 0 and 1 or 0

			local rowCells = math.max(widthCells - cornerCut * 2, 1)
			local z = (depthIndex - 1 - halfDepth) * cellZ
			local rowColor = color
			if depthIndex == 1 or depthIndex == depthCells then
				rowColor = color:Lerp(Palette.RedSeam, 0.16)
			elseif cornerCut > 0 then
				rowColor = color:Lerp(Palette.RedDark, 0.08)
			end

			addPart(parts, `SingleBodyLayer{layerIndex}_DepthRow{depthIndex}`, "Head", "Fruit", Vector3.new(rowCells * cellX, layerHeight, cellZ + 0.04), Vector3.new(0, y, z), rowColor, { animationRole = "Head" })
		end
	end

	for layerIndex, layer in ipairs(bodyLayers) do
		local y, widthCells, depthCells = layer[1], layer[2], layer[3]
		for columnIndex = 1, widthCells do
			local x = (columnIndex - 1 - (widthCells - 1) * 0.5) * cellX
			local color = ((layerIndex + columnIndex) % 3 == 0) and Palette.RedLight or Palette.Red
			if layerIndex <= 2 then
				color = color:Lerp(Palette.RedDark, 0.1)
			end
			addPart(parts, `SingleFrontTile{layerIndex}_{columnIndex}`, "Head", "Fruit", Vector3.new(cellX - 0.04, layerHeight - 0.08, 0.16), Vector3.new(x, y, frontZ - 0.02), color, { animationRole = "Head" })
		end

		for columnIndex = 1, widthCells do
			local x = (columnIndex - 1 - (widthCells - 1) * 0.5) * cellX
			local color = ((layerIndex + columnIndex) % 2 == 0) and Palette.Red or Palette.RedDark
			addPart(parts, `SingleBackTile{layerIndex}_{columnIndex}`, "Head", "Fruit", Vector3.new(cellX - 0.04, layerHeight - 0.08, 0.14), Vector3.new(x, y, backZ + 0.02), color, { animationRole = "Head" })
		end

		for depthIndex = 1, depthCells do
			local z = (depthIndex - 1 - (depthCells - 1) * 0.5) * cellZ
			local edgeDistance = math.min(depthIndex - 1, depthCells - depthIndex)
			local cornerCut = edgeDistance == 0 and 1 or 0

			local rowCells = math.max(widthCells - cornerCut * 2, 1)
			local sideX = (rowCells * cellX) * 0.5 - 0.04
			addPart(parts, `SingleLeftSideTile{layerIndex}_{depthIndex}`, "BodyDark", "FruitDark", Vector3.new(0.16, layerHeight - 0.08, cellZ - 0.04), Vector3.new(-sideX, y, z), Palette.RedDark, { animationRole = "Head" })
			addPart(parts, `SingleRightSideTile{layerIndex}_{depthIndex}`, "BodyDark", "FruitDark", Vector3.new(0.16, layerHeight - 0.08, cellZ - 0.04), Vector3.new(sideX, y, z), Palette.RedDark, { animationRole = "Head" })
		end
	end

	for index, seed in ipairs({
		{ -2.42, 2.74 }, { -1.18, 2.88 }, { 0.12, 2.78 }, { 1.42, 2.88 }, { 2.48, 2.66 },
		{ -2.82, 2.08 }, { -0.34, 2.18 }, { 1.2, 2.14 }, { 2.74, 2.02 },
		{ -2.72, 1.32 }, { -1.88, 1.0 }, { 1.86, 1.0 }, { 2.76, 1.34 },
		{ -2.5, 0.54 }, { -1.34, 0.28 }, { 1.32, 0.28 }, { 2.52, 0.56 },
		{ -2.1, -0.18 }, { -0.72, -0.34 }, { 0.72, -0.34 }, { 2.08, -0.16 },
	}) do
		addPart(parts, `SingleFrontSeed{index}`, "Seed", "Seed", Vector3.new(0.3, 0.3, 0.2), Vector3.new(seed[1], seed[2], frontZ - 0.18), Palette.Seed, { animationRole = "Seed" })
	end

	for index, seed in ipairs({
		{ -2.2, 2.58 }, { -1.1, 2.78 }, { 0.12, 2.62 }, { 1.24, 2.78 }, { 2.34, 2.52 },
		{ -2.66, 1.94 }, { -1.48, 1.72 }, { -0.28, 1.96 }, { 0.92, 1.72 }, { 2.18, 1.94 },
		{ -2.44, 1.2 }, { -1.16, 0.98 }, { 0.16, 1.18 }, { 1.42, 0.96 }, { 2.54, 1.18 },
		{ -2.18, 0.38 }, { -0.86, 0.22 }, { 0.54, 0.26 }, { 1.86, 0.4 },
		{ -1.5, -0.28 }, { 0, -0.42 }, { 1.5, -0.28 },
	}) do
		addPart(parts, `SingleBackSeed{index}`, "Seed", "Seed", Vector3.new(0.3, 0.3, 0.18), Vector3.new(seed[1], seed[2], backZ + 0.2), Palette.Seed, { animationRole = "Seed" })
	end

	for index, seed in ipairs({
		{ -3.08, 2.46, -1.34 }, { -3.08, 2.1, -0.12 }, { -3.08, 1.62, 1.0 }, { -3.08, 0.82, -0.7 }, { -3.0, 0.18, 0.68 },
		{ 3.08, 2.46, -1.34 }, { 3.08, 2.1, -0.12 }, { 3.08, 1.62, 1.0 }, { 3.08, 0.82, -0.7 }, { 3.0, 0.18, 0.68 },
	}) do
		addPart(parts, `SingleSideSeed{index}`, "Seed", "Seed", Vector3.new(0.14, 0.3, 0.3), Vector3.new(seed[1], seed[2], seed[3]), Palette.Seed, { animationRole = "Seed" })
	end

	addPart(parts, "SingleLeftEyeWhite", "EyeWhite", "Eye", Vector3.new(1.14, 0.96, 0.34), Vector3.new(-1.08, 1.45, frontZ - 0.28), Palette.White, { animationRole = "EyeLeft" })
	addPart(parts, "SingleRightEyeWhite", "EyeWhite", "Eye", Vector3.new(1.14, 0.96, 0.34), Vector3.new(1.08, 1.45, frontZ - 0.28), Palette.White, { animationRole = "EyeRight" })
	addPart(parts, "SingleLeftEyeInnerShade", "EyeFrame", "Eye", Vector3.new(0.18, 0.78, 0.3), Vector3.new(-0.48, 1.38, frontZ - 0.37), Palette.Black, { animationRole = "EyeLeft" })
	addPart(parts, "SingleRightEyeInnerShade", "EyeFrame", "Eye", Vector3.new(0.18, 0.78, 0.3), Vector3.new(0.48, 1.38, frontZ - 0.37), Palette.Black, { animationRole = "EyeRight" })
	addPart(parts, "SingleLeftEyeOuterCut", "EyeFrame", "Eye", Vector3.new(0.2, 0.62, 0.3), Vector3.new(-1.66, 1.32, frontZ - 0.38), Palette.Black, { rotation = angles(0, 0, -8), animationRole = "EyeLeft" })
	addPart(parts, "SingleRightEyeOuterCut", "EyeFrame", "Eye", Vector3.new(0.2, 0.62, 0.3), Vector3.new(1.66, 1.32, frontZ - 0.38), Palette.Black, { rotation = angles(0, 0, 8), animationRole = "EyeRight" })
	addPart(parts, "SingleLeftPupil", "EyePupil", "Eye", Vector3.new(0.42, 0.66, 0.32), Vector3.new(-0.86, 1.34, frontZ - 0.47), Palette.EyeBlack, { animationRole = "EyeLeft" })
	addPart(parts, "SingleRightPupil", "EyePupil", "Eye", Vector3.new(0.42, 0.66, 0.32), Vector3.new(0.86, 1.34, frontZ - 0.47), Palette.EyeBlack, { animationRole = "EyeRight" })
	addPart(parts, "SingleLeftEyeSpark", "EyeWhite", "Eye", Vector3.new(0.16, 0.16, 0.24), Vector3.new(-0.72, 1.62, frontZ - 0.58), Palette.White, { material = Enum.Material.Neon, animationRole = "EyeLeft" })
	addPart(parts, "SingleRightEyeSpark", "EyeWhite", "Eye", Vector3.new(0.16, 0.16, 0.24), Vector3.new(0.72, 1.62, frontZ - 0.58), Palette.White, { material = Enum.Material.Neon, animationRole = "EyeRight" })
	addPart(parts, "SingleLeftEyelidPeach", "Face", "Face", Vector3.new(0.96, 0.16, 0.26), Vector3.new(-1.1, 1.9, frontZ - 0.36), Color3.fromRGB(231, 139, 105), { rotation = angles(0, 0, -14), animationRole = "EyeLeft" })
	addPart(parts, "SingleRightEyelidPeach", "Face", "Face", Vector3.new(0.96, 0.16, 0.26), Vector3.new(1.1, 1.9, frontZ - 0.36), Color3.fromRGB(231, 139, 105), { rotation = angles(0, 0, 14), animationRole = "EyeRight" })
	addPart(parts, "SingleLeftBrow", "EyeFrame", "Eye", Vector3.new(1.9, 0.34, 0.36), Vector3.new(-1.32, 2.1, frontZ - 0.52), Palette.Black, { rotation = angles(0, 0, -24), animationRole = "EyeLeft" })
	addPart(parts, "SingleRightBrow", "EyeFrame", "Eye", Vector3.new(1.9, 0.34, 0.36), Vector3.new(1.32, 2.1, frontZ - 0.52), Palette.Black, { rotation = angles(0, 0, 24), animationRole = "EyeRight" })

	addPart(parts, "SingleGrinBlackBack", "Smile", "Eye", Vector3.new(3.02, 0.68, 0.32), Vector3.new(0, 0.48, frontZ - 0.34), Palette.Black, { animationRole = "Mouth" })
	addPart(parts, "SingleGrinTeethCenter", "Smile", "Face", Vector3.new(2.52, 0.32, 0.28), Vector3.new(0, 0.58, frontZ - 0.48), Palette.White, { animationRole = "Mouth" })
	addPart(parts, "SingleGrinTeethLeftLift", "Smile", "Face", Vector3.new(0.7, 0.22, 0.28), Vector3.new(-1.1, 0.7, frontZ - 0.49), Palette.White, { rotation = angles(0, 0, 8), animationRole = "Mouth" })
	addPart(parts, "SingleGrinTeethRightLift", "Smile", "Face", Vector3.new(0.7, 0.22, 0.28), Vector3.new(1.1, 0.7, frontZ - 0.49), Palette.White, { rotation = angles(0, 0, -8), animationRole = "Mouth" })
	for index, x in ipairs({ -0.82, -0.28, 0.28, 0.82 }) do
		addPart(parts, `SingleToothLine{index}`, "Smile", "Face", Vector3.new(0.04, 0.3, 0.22), Vector3.new(x, 0.58, frontZ - 0.59), Palette.WhiteShade, { animationRole = "Mouth" })
	end
	addPart(parts, "SingleGrinBottomShadow", "Smile", "Eye", Vector3.new(2.18, 0.14, 0.24), Vector3.new(0, 0.25, frontZ - 0.56), Palette.Black, { animationRole = "Mouth" })
	addPart(parts, "SingleGrinLeftHook", "Smile", "Eye", Vector3.new(0.66, 0.18, 0.24), Vector3.new(-1.58, 0.6, frontZ - 0.56), Palette.Black, { rotation = angles(0, 0, -48), animationRole = "Mouth" })
	addPart(parts, "SingleGrinRightHook", "Smile", "Eye", Vector3.new(0.66, 0.18, 0.24), Vector3.new(1.58, 0.6, frontZ - 0.56), Palette.Black, { rotation = angles(0, 0, 48), animationRole = "Mouth" })

	addPart(parts, "SingleLeafBasePad", "Leaf", "Leaf", Vector3.new(3.0, 0.26, 1.95), Vector3.new(0, 3.58, -0.02), Palette.Green, { animationRole = "Leaf" })
	for index, leaf in ipairs({
		{ "FrontCenter", 0, 3.58, -1.5, 1.52, 0.52, 1.78, -21, 0, Palette.GreenLight },
		{ "FrontLeft", -1.14, 3.72, -1.22, 1.42, 0.38, 1.5, -13, -25, Palette.Green },
		{ "FrontRight", 1.14, 3.72, -1.22, 1.42, 0.38, 1.5, -13, 25, Palette.Green },
		{ "SideLeft", -2.48, 3.68, -0.66, 1.64, 0.34, 1.54, -8, -62, Palette.GreenLight },
		{ "SideRight", 2.48, 3.68, -0.66, 1.64, 0.34, 1.54, -8, 62, Palette.GreenLight },
		{ "WideLeft", -2.18, 3.54, 0.28, 1.92, 0.34, 1.62, -4, -41, Palette.GreenDark },
		{ "WideRight", 2.18, 3.54, 0.28, 1.92, 0.34, 1.62, -4, 41, Palette.GreenDark },
		{ "BackLeft", -1.12, 3.6, 1.28, 1.34, 0.32, 1.34, 5, -142, Palette.GreenDark },
		{ "BackRight", 1.12, 3.6, 1.28, 1.34, 0.32, 1.34, 5, 142, Palette.GreenDark },
	}) do
		addPart(parts, `SingleLeaf{leaf[1]}`, "Leaf", "Leaf", Vector3.new(leaf[5], leaf[6], leaf[7]), Vector3.new(leaf[2], leaf[3], leaf[4]), leaf[10], { className = "WedgePart", rotation = angles(leaf[8], leaf[9], 0), animationRole = "Leaf" })
	end
	for index, nub in ipairs({ { -1.3, 3.98, -0.72 }, { 0, 4.05, -0.62 }, { 1.3, 3.98, -0.72 }, { -1.95, 3.82, 0.26 }, { 1.95, 3.82, 0.26 } }) do
		addPart(parts, `SingleLeafStud{index}`, "Leaf", "Leaf", Vector3.new(0.32, 0.18, 0.32), Vector3.new(nub[1], nub[2], nub[3]), Palette.GreenLight, { animationRole = "Leaf" })
	end
	addPart(parts, "SingleLeafTopTile", "Leaf", "Leaf", Vector3.new(1.08, 0.3, 1.02), Vector3.new(0, 4.0, -0.06), Palette.GreenLight, { animationRole = "Leaf" })
	addPart(parts, "SingleStemBlock", "Stem", "Leaf", Vector3.new(0.48, 1.16, 0.48), Vector3.new(0.2, 4.5, 0.12), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "SingleStemCurlTop", "Stem", "Leaf", Vector3.new(0.94, 0.42, 0.42), Vector3.new(-0.12, 5.14, 0.12), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "SingleStemCurlDrop", "Stem", "Leaf", Vector3.new(0.4, 0.62, 0.4), Vector3.new(-0.62, 4.88, 0.12), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "SingleStemCurlTip", "Stem", "Leaf", Vector3.new(0.5, 0.28, 0.38), Vector3.new(-0.84, 4.56, 0.12), Palette.Stem, { material = Enum.Material.Wood, rotation = angles(0, 0, -18), animationRole = "Stem" })

	addPart(parts, "SingleBowShadow", "Bow", "Accent", Vector3.new(1.64, 0.72, 0.1), Vector3.new(2.34, 2.62, frontZ - 0.12), Color3.fromRGB(197, 38, 104), { animationRole = "Head" })
	addPart(parts, "SingleBowKnot", "Bow", "Accent", Vector3.new(0.48, 0.54, 0.28), Vector3.new(2.34, 2.58, frontZ - 0.24), Palette.Pink, { animationRole = "Head" })
	addPart(parts, "SingleBowLeftLoopTop", "Bow", "Accent", Vector3.new(0.84, 0.42, 0.26), Vector3.new(1.7, 2.78, frontZ - 0.22), Palette.PinkLight, { rotation = angles(0, 0, 13), animationRole = "Head" })
	addPart(parts, "SingleBowLeftLoopBottom", "Bow", "Accent", Vector3.new(0.82, 0.4, 0.26), Vector3.new(1.7, 2.43, frontZ - 0.22), Palette.PinkLight, { rotation = angles(0, 0, -13), animationRole = "Head" })
	addPart(parts, "SingleBowRightLoopTop", "Bow", "Accent", Vector3.new(0.84, 0.42, 0.26), Vector3.new(2.98, 2.78, frontZ - 0.22), Palette.PinkLight, { rotation = angles(0, 0, -13), animationRole = "Head" })
	addPart(parts, "SingleBowRightLoopBottom", "Bow", "Accent", Vector3.new(0.82, 0.4, 0.26), Vector3.new(2.98, 2.43, frontZ - 0.22), Palette.PinkLight, { rotation = angles(0, 0, 13), animationRole = "Head" })
	addPart(parts, "SingleBowLeftTail", "Bow", "Accent", Vector3.new(0.44, 0.52, 0.24), Vector3.new(2.02, 2.12, frontZ - 0.22), Palette.Pink, { rotation = angles(0, 0, -12), animationRole = "Head" })
	addPart(parts, "SingleBowRightTail", "Bow", "Accent", Vector3.new(0.44, 0.52, 0.24), Vector3.new(2.66, 2.12, frontZ - 0.22), Palette.Pink, { rotation = angles(0, 0, 12), animationRole = "Head" })
	for index, dot in ipairs({ { 1.48, 2.84 }, { 1.82, 2.48 }, { 2.86, 2.84 }, { 3.16, 2.48 }, { 2.34, 2.58 } }) do
		addPart(parts, `SingleBowDot{index}`, "Bow", "Face", Vector3.new(0.14, 0.14, 0.08), Vector3.new(dot[1], dot[2], frontZ - 0.39), Palette.White, { animationRole = "Head" })
	end

	addPart(parts, "SingleSkirtBandFront", "Body", "Outfit", Vector3.new(5.34, 0.36, 0.3), Vector3.new(0, -1.08, -1.86), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SingleSkirtBandBack", "Body", "Outfit", Vector3.new(5.02, 0.34, 0.24), Vector3.new(0, -1.08, 1.72), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SingleSkirtBandLeft", "Body", "Outfit", Vector3.new(0.28, 0.34, 3.25), Vector3.new(-2.7, -1.08, 0), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SingleSkirtBandRight", "Body", "Outfit", Vector3.new(0.28, 0.34, 3.25), Vector3.new(2.7, -1.08, 0), Palette.Pink, { animationRole = "Body" })
	for index, x in ipairs({ -2.22, -1.58, -0.94, -0.31, 0.31, 0.94, 1.58, 2.22 }) do
		addPart(parts, `SingleRuffle{index}`, "SockCuff", "Face", Vector3.new(0.5, 0.28, 0.5), Vector3.new(x, -1.4, -1.9), index % 2 == 0 and Palette.WhiteShade or Palette.White, { rotation = angles(0, 0, index % 2 == 0 and -5 or 5), animationRole = "Body" })
	end

	for _, side in ipairs({ { "Left", -1 }, { "Right", 1 } }) do
		local sideName, sign = side[1], side[2]
		addPart(parts, `Single{sideName}ShoulderSocket`, "Arm", "FruitDark", Vector3.new(0.58, 0.92, 0.9), Vector3.new(sign * 2.96, 0.48, -0.04), Palette.RedDark, { rotation = angles(0, 0, sign * 8), animationRole = `{sideName}Arm` })
		addPart(parts, `Single{sideName}UpperArm`, "Arm", "Fruit", Vector3.new(0.78, 1.12, 0.76), Vector3.new(sign * 3.32, -0.1, -0.2), Palette.Red, { rotation = angles(0, 0, sign * 16), animationRole = `{sideName}Arm` })
		addPart(parts, `Single{sideName}LowerArm`, "Arm", "FruitDark", Vector3.new(0.86, 0.9, 0.78), Vector3.new(sign * 3.66, -0.78, -0.28), Palette.RedDark, { rotation = angles(0, 0, sign * -18), animationRole = `{sideName}Arm` })
		addPart(parts, `Single{sideName}FistCore`, "Hand", "Fruit", Vector3.new(1.1, 0.98, 0.98), Vector3.new(sign * 3.94, -1.15, -0.36), Palette.Red, { rotation = angles(0, 0, sign * 10), animationRole = `{sideName}Arm` })
		addPart(parts, `Single{sideName}FistPalm`, "Hand", "Fruit", Vector3.new(0.74, 0.72, 0.42), Vector3.new(sign * 3.86, -1.12, -0.94), Palette.RedLight, { animationRole = `{sideName}Arm` })
		for fingerIndex, finger in ipairs({ { -0.76, -0.55 }, { -1.08, -0.55 }, { -1.38, -0.52 } }) do
			addPart(parts, `Single{sideName}FistFinger{fingerIndex}`, "Hand", "FruitDark", Vector3.new(0.26, 0.24, 0.4), Vector3.new(sign * 3.68, finger[1], -1.04 + finger[2] * 0.08), Palette.RedDark, { animationRole = `{sideName}Arm` })
		end
		addPart(parts, `Single{sideName}FistStudTop`, "Hand", "Fruit", Vector3.new(0.34, 0.16, 0.34), Vector3.new(sign * 4.02, -0.66, -0.58), Palette.RedLight, { animationRole = `{sideName}Arm` })
	end

	for _, side in ipairs({ { "Left", -0.92 }, { "Right", 0.92 } }) do
		local sideName, x = side[1], side[2]
		addPart(parts, `Single{sideName}LegRedTop`, "Sock", "FruitDark", Vector3.new(0.68, 0.22, 0.58), Vector3.new(x, -1.58, -0.02), Palette.RedDark, { animationRole = `{sideName}Leg` })
		addPart(parts, `Single{sideName}SockPinkTop`, "Sock", "Outfit", Vector3.new(0.68, 0.34, 0.58), Vector3.new(x, -1.78, -0.02), Palette.Pink, { animationRole = `{sideName}Leg` })
		addPart(parts, `Single{sideName}SockWhiteStripe`, "SockCuff", "Face", Vector3.new(0.7, 0.36, 0.6), Vector3.new(x, -2.08, -0.02), Palette.White, { animationRole = `{sideName}Leg` })
		addPart(parts, `Single{sideName}SockPinkLower`, "Sock", "Outfit", Vector3.new(0.7, 0.32, 0.6), Vector3.new(x, -2.38, -0.02), Palette.Pink, { animationRole = `{sideName}Leg` })
		addPart(parts, `Single{sideName}ShoeBlock`, "Shoe", "Shoe", Vector3.new(1.38, 0.58, 1.42), Vector3.new(x, -2.62, -0.28), Palette.Red, { animationRole = `{sideName}Foot` })
		addPart(parts, `Single{sideName}ShoeToe`, "Shoe", "Shoe", Vector3.new(1.48, 0.44, 0.58), Vector3.new(x, -2.48, -1.08), Palette.RedLight, { animationRole = `{sideName}Foot` })
		addPart(parts, `Single{sideName}ShoeSole`, "ShoePanel", "Face", Vector3.new(1.52, 0.24, 1.58), Vector3.new(x, -2.93, -0.28), Palette.WhiteShade, { animationRole = `{sideName}Foot` })
		addPart(parts, `Single{sideName}ShoeFrontSole`, "ShoePanel", "Face", Vector3.new(1.42, 0.2, 0.22), Vector3.new(x, -2.78, -1.38), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `Single{sideName}ShoeToeTrim`, "ShoePanel", "Face", Vector3.new(1.18, 0.18, 0.16), Vector3.new(x, -2.38, -1.42), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `Single{sideName}ShoeLaceA`, "ShoePanel", "Face", Vector3.new(0.48, 0.09, 0.12), Vector3.new(x - 0.24, -2.24, -1.44), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `Single{sideName}ShoeLaceB`, "ShoePanel", "Face", Vector3.new(0.48, 0.09, 0.12), Vector3.new(x + 0.24, -2.24, -1.44), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `Single{sideName}ShoeSideDot`, "ShoePanel", "Seed", Vector3.new(0.14, 0.24, 0.24), Vector3.new(x + (x > 0 and -0.78 or 0.78), -2.56, -0.76), Palette.Seed, { animationRole = `{sideName}Foot` })
	end

	return parts
end

function StrawberitaVoxelData.createParts()
	return createLegacySharedParts()
end

StrawberitaVoxelData.SinglePreviewVersion = "StrawberitaSingleCommon_SourceScaleDetail_V5"

function StrawberitaVoxelData.createSinglePreviewParts()
	local parts = {}
	local frontZ = -2.28
	local backZ = 2.28
	local cellX = 0.52
	local cellZ = 0.54
	local layerHeight = 0.56
	local bodyLayers = {
		{ -1.16, 10, 6, Palette.RedDark },
		{ -0.62, 11, 7, Palette.Red },
		{ -0.08, 12, 8, Palette.Red },
		{ 0.46, 13, 8, Palette.Red },
		{ 1.0, 13, 8, Palette.Red },
		{ 1.54, 13, 8, Palette.Red },
		{ 2.08, 13, 8, Palette.Red },
		{ 2.62, 12, 8, Palette.Red },
		{ 3.12, 12, 7, Palette.RedLight },
		{ 3.55, 11, 7, Palette.RedLight },
		{ 3.9, 9, 6, Palette.RedLight },
	}

	for layerIndex, layer in ipairs(bodyLayers) do
		local y, widthCells, depthCells, color = layer[1], layer[2], layer[3], layer[4]
		local halfDepth = (depthCells - 1) * 0.5
		for depthIndex = 1, depthCells do
			local edgeDistance = math.min(depthIndex - 1, depthCells - depthIndex)
			local cornerCut = edgeDistance == 0 and 1 or 0
			local rowCells = math.max(widthCells - cornerCut * 2, 1)
			local z = (depthIndex - 1 - halfDepth) * cellZ
			local rowColor = color
			if depthIndex == 1 then
				rowColor = color:Lerp(Palette.RedLight, 0.08)
			elseif depthIndex == depthCells then
				rowColor = color:Lerp(Palette.RedDark, 0.14)
			elseif cornerCut > 0 then
				rowColor = color:Lerp(Palette.RedDark, 0.08)
			end

			addPart(
				parts,
				`SingleSourceBodyLayer{layerIndex}_DepthRow{depthIndex}`,
				"Head",
				"Fruit",
				Vector3.new(rowCells * cellX, layerHeight, cellZ + 0.06),
				Vector3.new(0, y, z),
				rowColor,
				{ animationRole = "Head" }
			)
		end
	end

	for layerIndex, layer in ipairs(bodyLayers) do
		local y, widthCells, depthCells, color = layer[1], layer[2], layer[3], layer[4]
		local frontCells = math.max(widthCells - 2, 1)
		for columnIndex = 1, frontCells do
			local x = (columnIndex - 1 - (frontCells - 1) * 0.5) * cellX
			local tileColor = ((layerIndex + columnIndex) % 4 == 0) and color:Lerp(Palette.RedLight, 0.2) or color
			if layerIndex <= 2 then
				tileColor = tileColor:Lerp(Palette.RedDark, 0.08)
			end
			addPart(parts, `SingleSourceFrontTile{layerIndex}_{columnIndex}`, "Head", "Fruit", Vector3.new(cellX - 0.04, layerHeight - 0.08, 0.2), Vector3.new(x, y, frontZ - 0.03), tileColor, { animationRole = "Head" })
		end

		local backCells = math.max(widthCells - 2, 1)
		for columnIndex = 1, backCells do
			local x = (columnIndex - 1 - (backCells - 1) * 0.5) * cellX
			local tileColor = ((layerIndex + columnIndex) % 2 == 0) and Palette.Red or Palette.RedDark
			addPart(parts, `SingleSourceBackTile{layerIndex}_{columnIndex}`, "Head", "Fruit", Vector3.new(cellX - 0.04, layerHeight - 0.08, 0.18), Vector3.new(x, y, backZ + 0.03), tileColor, { animationRole = "Head" })
		end

		for depthIndex = 1, depthCells do
			local z = (depthIndex - 1 - (depthCells - 1) * 0.5) * cellZ
			local edgeDistance = math.min(depthIndex - 1, depthCells - depthIndex)
			local cornerCut = edgeDistance == 0 and 1 or 0
			local rowCells = math.max(widthCells - cornerCut * 2, 1)
			local sideX = (rowCells * cellX) * 0.5 - 0.04
			addPart(parts, `SingleSourceLeftSideTile{layerIndex}_{depthIndex}`, "BodyDark", "FruitDark", Vector3.new(0.18, layerHeight - 0.08, cellZ - 0.04), Vector3.new(-sideX, y, z), Palette.RedDark, { animationRole = "Head" })
			addPart(parts, `SingleSourceRightSideTile{layerIndex}_{depthIndex}`, "BodyDark", "FruitDark", Vector3.new(0.18, layerHeight - 0.08, cellZ - 0.04), Vector3.new(sideX, y, z), Palette.RedDark, { animationRole = "Head" })
		end
	end

	addPart(parts, "SingleSourceFacePanelCore", "Face", "Face", Vector3.new(4.46, 2.34, 0.16), Vector3.new(0, 1.48, frontZ - 0.16), Palette.Peach, { animationRole = "Face" })
	addPart(parts, "SingleSourceFacePanelTopStep", "Face", "Face", Vector3.new(3.86, 0.28, 0.18), Vector3.new(0, 2.78, frontZ - 0.17), Palette.Peach, { animationRole = "Face" })
	addPart(parts, "SingleSourceFacePanelBottomStep", "Face", "Face", Vector3.new(3.78, 0.28, 0.18), Vector3.new(0, 0.18, frontZ - 0.17), Palette.PeachShade, { animationRole = "Face" })
	addPart(parts, "SingleSourceFacePanelLeftStep", "Face", "Face", Vector3.new(0.32, 1.78, 0.18), Vector3.new(-2.36, 1.44, frontZ - 0.18), Palette.PeachShade, { animationRole = "Face" })
	addPart(parts, "SingleSourceFacePanelRightStep", "Face", "Face", Vector3.new(0.32, 1.78, 0.18), Vector3.new(2.36, 1.44, frontZ - 0.18), Palette.PeachShade, { animationRole = "Face" })

	addPart(parts, "SingleSourceLeftEyeWhite", "EyeWhite", "Eye", Vector3.new(1.24, 1.08, 0.34), Vector3.new(-1.16, 1.72, frontZ - 0.34), Palette.White, { animationRole = "EyeLeft" })
	addPart(parts, "SingleSourceRightEyeWhite", "EyeWhite", "Eye", Vector3.new(1.24, 1.08, 0.34), Vector3.new(1.16, 1.72, frontZ - 0.34), Palette.White, { animationRole = "EyeRight" })
	addPart(parts, "SingleSourceLeftEyeInnerShade", "EyeFrame", "Eye", Vector3.new(0.22, 0.86, 0.32), Vector3.new(-0.5, 1.62, frontZ - 0.47), Palette.Black, { animationRole = "EyeLeft" })
	addPart(parts, "SingleSourceRightEyeInnerShade", "EyeFrame", "Eye", Vector3.new(0.22, 0.86, 0.32), Vector3.new(0.5, 1.62, frontZ - 0.47), Palette.Black, { animationRole = "EyeRight" })
	addPart(parts, "SingleSourceLeftEyeOuterCut", "EyeFrame", "Eye", Vector3.new(0.24, 0.74, 0.32), Vector3.new(-1.82, 1.58, frontZ - 0.48), Palette.Black, { rotation = angles(0, 0, -9), animationRole = "EyeLeft" })
	addPart(parts, "SingleSourceRightEyeOuterCut", "EyeFrame", "Eye", Vector3.new(0.24, 0.74, 0.32), Vector3.new(1.82, 1.58, frontZ - 0.48), Palette.Black, { rotation = angles(0, 0, 9), animationRole = "EyeRight" })
	addPart(parts, "SingleSourceLeftPupil", "EyePupil", "Eye", Vector3.new(0.48, 0.72, 0.34), Vector3.new(-0.96, 1.58, frontZ - 0.58), Palette.EyeBlack, { animationRole = "EyeLeft" })
	addPart(parts, "SingleSourceRightPupil", "EyePupil", "Eye", Vector3.new(0.48, 0.72, 0.34), Vector3.new(0.96, 1.58, frontZ - 0.58), Palette.EyeBlack, { animationRole = "EyeRight" })
	addPart(parts, "SingleSourceLeftEyeSpark", "EyeWhite", "Eye", Vector3.new(0.18, 0.18, 0.24), Vector3.new(-0.78, 1.88, frontZ - 0.72), Palette.White, { material = Enum.Material.Neon, animationRole = "EyeLeft" })
	addPart(parts, "SingleSourceRightEyeSpark", "EyeWhite", "Eye", Vector3.new(0.18, 0.18, 0.24), Vector3.new(0.78, 1.88, frontZ - 0.72), Palette.White, { material = Enum.Material.Neon, animationRole = "EyeRight" })
	addPart(parts, "SingleSourceLeftEyelidPeach", "Face", "Face", Vector3.new(1.08, 0.18, 0.28), Vector3.new(-1.18, 2.16, frontZ - 0.48), Palette.PeachShade, { rotation = angles(0, 0, -15), animationRole = "EyeLeft" })
	addPart(parts, "SingleSourceRightEyelidPeach", "Face", "Face", Vector3.new(1.08, 0.18, 0.28), Vector3.new(1.18, 2.16, frontZ - 0.48), Palette.PeachShade, { rotation = angles(0, 0, 15), animationRole = "EyeRight" })
	addPart(parts, "SingleSourceLeftBrow", "EyeFrame", "Eye", Vector3.new(2.04, 0.38, 0.38), Vector3.new(-1.42, 2.46, frontZ - 0.66), Palette.Black, { rotation = angles(0, 0, -25), animationRole = "EyeLeft" })
	addPart(parts, "SingleSourceRightBrow", "EyeFrame", "Eye", Vector3.new(2.04, 0.38, 0.38), Vector3.new(1.42, 2.46, frontZ - 0.66), Palette.Black, { rotation = angles(0, 0, 25), animationRole = "EyeRight" })

	addPart(parts, "SingleSourceGrinBlackBack", "Smile", "Eye", Vector3.new(3.38, 0.86, 0.34), Vector3.new(0, 0.58, frontZ - 0.42), Palette.Black, { animationRole = "Mouth" })
	addPart(parts, "SingleSourceGrinTeethCenter", "Smile", "Face", Vector3.new(2.84, 0.4, 0.3), Vector3.new(0, 0.68, frontZ - 0.6), Palette.White, { animationRole = "Mouth" })
	addPart(parts, "SingleSourceGrinTeethLeftLift", "Smile", "Face", Vector3.new(0.78, 0.26, 0.3), Vector3.new(-1.22, 0.82, frontZ - 0.62), Palette.White, { rotation = angles(0, 0, 8), animationRole = "Mouth" })
	addPart(parts, "SingleSourceGrinTeethRightLift", "Smile", "Face", Vector3.new(0.78, 0.26, 0.3), Vector3.new(1.22, 0.82, frontZ - 0.62), Palette.White, { rotation = angles(0, 0, -8), animationRole = "Mouth" })
	addPart(parts, "SingleSourceLeftFang", "Smile", "Face", Vector3.new(0.26, 0.38, 0.32), Vector3.new(-0.58, 0.42, frontZ - 0.66), Palette.White, { animationRole = "Mouth" })
	addPart(parts, "SingleSourceRightFang", "Smile", "Face", Vector3.new(0.26, 0.34, 0.32), Vector3.new(0.58, 0.44, frontZ - 0.66), Palette.White, { animationRole = "Mouth" })
	for index, x in ipairs({ -1.08, -0.54, 0, 0.54, 1.08 }) do
		addPart(parts, `SingleSourceToothLine{index}`, "Smile", "Face", Vector3.new(0.05, 0.38, 0.24), Vector3.new(x, 0.66, frontZ - 0.72), Palette.WhiteShade, { animationRole = "Mouth" })
	end
	addPart(parts, "SingleSourceGrinBottomShadow", "Smile", "Eye", Vector3.new(2.46, 0.16, 0.26), Vector3.new(0, 0.18, frontZ - 0.68), Palette.Black, { animationRole = "Mouth" })
	addPart(parts, "SingleSourceGrinLeftHook", "Smile", "Eye", Vector3.new(0.74, 0.2, 0.26), Vector3.new(-1.74, 0.68, frontZ - 0.68), Palette.Black, { rotation = angles(0, 0, -50), animationRole = "Mouth" })
	addPart(parts, "SingleSourceGrinRightHook", "Smile", "Eye", Vector3.new(0.74, 0.2, 0.26), Vector3.new(1.74, 0.68, frontZ - 0.68), Palette.Black, { rotation = angles(0, 0, 50), animationRole = "Mouth" })
	addPart(parts, "SingleSourceLeftCheekSlash", "Cheek", "Face", Vector3.new(0.5, 0.18, 0.18), Vector3.new(-1.88, 0.42, frontZ - 0.42), Palette.PinkLight, { rotation = angles(0, 0, -9), animationRole = "Face" })
	addPart(parts, "SingleSourceRightCheekSlash", "Cheek", "Face", Vector3.new(0.5, 0.18, 0.18), Vector3.new(1.88, 0.42, frontZ - 0.42), Palette.PinkLight, { rotation = angles(0, 0, 9), animationRole = "Face" })

	for index, seed in ipairs({
		{ -2.26, 3.48 }, { -1.24, 3.62 }, { -0.18, 3.52 }, { 0.9, 3.64 }, { 2.0, 3.44 },
		{ -2.74, 2.8 }, { 2.72, 2.78 }, { -2.88, 2.08 }, { 2.88, 2.08 },
		{ -2.92, 1.34 }, { 2.92, 1.34 }, { -2.8, 0.56 }, { 2.8, 0.56 },
		{ -2.38, -0.24 }, { -1.36, -0.66 }, { -0.24, -0.8 }, { 0.94, -0.68 }, { 2.12, -0.28 },
		{ -2.0, -1.08 }, { 0, -1.22 }, { 2.0, -1.08 },
	}) do
		addPart(parts, `SingleSourceFrontSeed{index}`, "Seed", "Seed", Vector3.new(0.32, 0.32, 0.22), Vector3.new(seed[1], seed[2], frontZ - 0.24), Palette.Seed, { animationRole = "Seed" })
	end

	for index, seed in ipairs({
		{ -2.32, 3.44 }, { -1.08, 3.62 }, { 0.22, 3.5 }, { 1.46, 3.6 }, { 2.42, 3.28 },
		{ -2.76, 2.68 }, { -1.52, 2.42 }, { -0.22, 2.66 }, { 1.08, 2.42 }, { 2.48, 2.58 },
		{ -2.9, 1.82 }, { -1.64, 1.46 }, { -0.28, 1.72 }, { 1.16, 1.46 }, { 2.74, 1.72 },
		{ -2.64, 0.82 }, { -1.3, 0.48 }, { 0.16, 0.72 }, { 1.52, 0.48 }, { 2.62, 0.82 },
		{ -2.18, -0.26 }, { -0.68, -0.54 }, { 0.84, -0.52 }, { 2.16, -0.24 },
	}) do
		addPart(parts, `SingleSourceBackSeed{index}`, "Seed", "Seed", Vector3.new(0.32, 0.32, 0.2), Vector3.new(seed[1], seed[2], backZ + 0.22), Palette.Seed, { animationRole = "Seed" })
	end

	for index, seed in ipairs({
		{ -3.44, 3.22, -1.22 }, { -3.48, 2.46, 0.12 }, { -3.48, 1.58, 1.28 }, { -3.42, 0.74, -0.82 }, { -3.2, -0.32, 0.64 },
		{ 3.44, 3.22, -1.22 }, { 3.48, 2.46, 0.12 }, { 3.48, 1.58, 1.28 }, { 3.42, 0.74, -0.82 }, { 3.2, -0.32, 0.64 },
	}) do
		addPart(parts, `SingleSourceSideSeed{index}`, "Seed", "Seed", Vector3.new(0.16, 0.32, 0.32), Vector3.new(seed[1], seed[2], seed[3]), Palette.Seed, { animationRole = "Seed" })
	end

	addPart(parts, "SingleSourceLeafBasePad", "Leaf", "Leaf", Vector3.new(4.38, 0.32, 2.3), Vector3.new(0, 4.12, -0.02), Palette.Green, { animationRole = "Leaf" })
	for index, leaf in ipairs({
		{ "FrontCenter", 0, 4.2, -1.64, 1.72, 0.56, 1.92, -21, 0, Palette.GreenLight },
		{ "FrontLeft", -1.24, 4.26, -1.38, 1.58, 0.42, 1.66, -14, -24, Palette.Green },
		{ "FrontRight", 1.24, 4.26, -1.38, 1.58, 0.42, 1.66, -14, 24, Palette.Green },
		{ "SideLeft", -2.66, 4.18, -0.78, 1.82, 0.38, 1.72, -8, -60, Palette.GreenLight },
		{ "SideRight", 2.66, 4.18, -0.78, 1.82, 0.38, 1.72, -8, 60, Palette.GreenLight },
		{ "WideLeft", -2.22, 4.08, 0.32, 2.08, 0.38, 1.78, -4, -42, Palette.GreenDark },
		{ "WideRight", 2.22, 4.08, 0.32, 2.08, 0.38, 1.78, -4, 42, Palette.GreenDark },
		{ "BackCenter", 0, 4.1, 1.5, 1.56, 0.34, 1.6, 5, 180, Palette.GreenDark },
		{ "BackLeft", -1.34, 4.1, 1.36, 1.5, 0.34, 1.46, 5, -142, Palette.GreenDark },
		{ "BackRight", 1.34, 4.1, 1.36, 1.5, 0.34, 1.46, 5, 142, Palette.GreenDark },
	}) do
		addPart(parts, `SingleSourceLeaf{leaf[1]}`, "Leaf", "Leaf", Vector3.new(leaf[5], leaf[6], leaf[7]), Vector3.new(leaf[2], leaf[3], leaf[4]), leaf[10], { className = "WedgePart", rotation = angles(leaf[8], leaf[9], 0), animationRole = "Leaf" })
	end
	for index, nub in ipairs({ { -1.58, 4.46, -0.78 }, { -0.52, 4.56, -0.88 }, { 0.56, 4.56, -0.88 }, { 1.58, 4.46, -0.78 }, { -2.08, 4.34, 0.22 }, { 2.08, 4.34, 0.22 } }) do
		addPart(parts, `SingleSourceLeafStud{index}`, "Leaf", "Leaf", Vector3.new(0.34, 0.2, 0.34), Vector3.new(nub[1], nub[2], nub[3]), Palette.GreenLight, { animationRole = "Leaf" })
	end
	addPart(parts, "SingleSourceLeafTopTile", "Leaf", "Leaf", Vector3.new(1.24, 0.34, 1.14), Vector3.new(0, 4.52, -0.04), Palette.GreenLight, { animationRole = "Leaf" })
	addPart(parts, "SingleSourceStemBlock", "Stem", "Leaf", Vector3.new(0.52, 0.84, 0.52), Vector3.new(0.24, 4.76, 0.16), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "SingleSourceStemCurlTop", "Stem", "Leaf", Vector3.new(1.0, 0.42, 0.44), Vector3.new(-0.12, 5.03, 0.16), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "SingleSourceStemCurlDrop", "Stem", "Leaf", Vector3.new(0.42, 0.52, 0.42), Vector3.new(-0.66, 4.78, 0.16), Palette.Stem, { material = Enum.Material.Wood, animationRole = "Stem" })
	addPart(parts, "SingleSourceStemCurlTip", "Stem", "Leaf", Vector3.new(0.52, 0.28, 0.38), Vector3.new(-0.88, 4.52, 0.16), Palette.Stem, { material = Enum.Material.Wood, rotation = angles(0, 0, -18), animationRole = "Stem" })

	addPart(parts, "SingleSourceBowShadow", "Bow", "Accent", Vector3.new(1.9, 0.86, 0.12), Vector3.new(2.16, 3.18, frontZ - 0.14), Color3.fromRGB(197, 38, 104), { animationRole = "Head" })
	addPart(parts, "SingleSourceBowKnot", "Bow", "Accent", Vector3.new(0.54, 0.62, 0.3), Vector3.new(2.16, 3.16, frontZ - 0.3), Palette.Pink, { animationRole = "Head" })
	addPart(parts, "SingleSourceBowLeftLoopTop", "Bow", "Accent", Vector3.new(0.94, 0.48, 0.28), Vector3.new(1.44, 3.4, frontZ - 0.28), Palette.PinkLight, { rotation = angles(0, 0, 13), animationRole = "Head" })
	addPart(parts, "SingleSourceBowLeftLoopBottom", "Bow", "Accent", Vector3.new(0.94, 0.46, 0.28), Vector3.new(1.46, 3.0, frontZ - 0.28), Palette.PinkLight, { rotation = angles(0, 0, -13), animationRole = "Head" })
	addPart(parts, "SingleSourceBowRightLoopTop", "Bow", "Accent", Vector3.new(0.94, 0.48, 0.28), Vector3.new(2.88, 3.4, frontZ - 0.28), Palette.PinkLight, { rotation = angles(0, 0, -13), animationRole = "Head" })
	addPart(parts, "SingleSourceBowRightLoopBottom", "Bow", "Accent", Vector3.new(0.94, 0.46, 0.28), Vector3.new(2.86, 3.0, frontZ - 0.28), Palette.PinkLight, { rotation = angles(0, 0, 13), animationRole = "Head" })
	addPart(parts, "SingleSourceBowLeftTail", "Bow", "Accent", Vector3.new(0.5, 0.62, 0.26), Vector3.new(1.82, 2.58, frontZ - 0.28), Palette.Pink, { rotation = angles(0, 0, -12), animationRole = "Head" })
	addPart(parts, "SingleSourceBowRightTail", "Bow", "Accent", Vector3.new(0.5, 0.62, 0.26), Vector3.new(2.52, 2.58, frontZ - 0.28), Palette.Pink, { rotation = angles(0, 0, 12), animationRole = "Head" })
	for index, dot in ipairs({ { 1.24, 3.46 }, { 1.68, 3.06 }, { 2.68, 3.48 }, { 3.12, 3.06 }, { 2.16, 3.16 } }) do
		addPart(parts, `SingleSourceBowDot{index}`, "Bow", "Face", Vector3.new(0.16, 0.16, 0.08), Vector3.new(dot[1], dot[2], frontZ - 0.44), Palette.White, { animationRole = "Head" })
	end

	addPart(parts, "SingleSourceSkirtBandFront", "Body", "Outfit", Vector3.new(5.7, 0.38, 0.32), Vector3.new(0, -1.42, -1.9), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SingleSourceSkirtBandBack", "Body", "Outfit", Vector3.new(5.36, 0.36, 0.26), Vector3.new(0, -1.42, 1.78), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SingleSourceSkirtBandLeft", "Body", "Outfit", Vector3.new(0.3, 0.36, 3.42), Vector3.new(-2.86, -1.42, 0), Palette.Pink, { animationRole = "Body" })
	addPart(parts, "SingleSourceSkirtBandRight", "Body", "Outfit", Vector3.new(0.3, 0.36, 3.42), Vector3.new(2.86, -1.42, 0), Palette.Pink, { animationRole = "Body" })
	for index, x in ipairs({ -2.36, -1.68, -1.0, -0.34, 0.34, 1.0, 1.68, 2.36 }) do
		addPart(parts, `SingleSourceSkirtStud{index}`, "SockCuff", "Face", Vector3.new(0.26, 0.22, 0.08), Vector3.new(x, -1.38, -2.1), Palette.PinkLight, { animationRole = "Body" })
	end
	for index, x in ipairs({ -2.28, -1.62, -0.96, -0.32, 0.32, 0.96, 1.62, 2.28 }) do
		addPart(parts, `SingleSourceRuffle{index}`, "SockCuff", "Face", Vector3.new(0.54, 0.32, 0.52), Vector3.new(x, -1.76, -1.92), index % 2 == 0 and Palette.WhiteShade or Palette.White, { rotation = angles(0, 0, index % 2 == 0 and -5 or 5), animationRole = "Body" })
	end
	for index, x in ipairs({ -1.82, -0.92, 0, 0.92, 1.82 }) do
		addPart(parts, `SingleSourceBackRuffle{index}`, "SockCuff", "Face", Vector3.new(0.56, 0.26, 0.34), Vector3.new(x, -1.76, 1.84), Palette.WhiteShade, { animationRole = "Body" })
	end

	for _, side in ipairs({ { "Left", -1 }, { "Right", 1 } }) do
		local sideName, sign = side[1], side[2]
		addPart(parts, `SingleSource{sideName}ShoulderSocket`, "Arm", "FruitDark", Vector3.new(0.64, 1.02, 0.96), Vector3.new(sign * 3.18, 0.82, -0.02), Palette.RedDark, { rotation = angles(0, 0, sign * 8), animationRole = `{sideName}Arm` })
		addPart(parts, `SingleSource{sideName}UpperArm`, "Arm", "Fruit", Vector3.new(0.88, 1.22, 0.82), Vector3.new(sign * 3.52, 0.12, -0.2), Palette.Red, { rotation = angles(0, 0, sign * 16), animationRole = `{sideName}Arm` })
		addPart(parts, `SingleSource{sideName}LowerArm`, "Arm", "FruitDark", Vector3.new(0.92, 0.96, 0.84), Vector3.new(sign * 3.84, -0.58, -0.3), Palette.RedDark, { rotation = angles(0, 0, sign * -18), animationRole = `{sideName}Arm` })
		addPart(parts, `SingleSource{sideName}FistCore`, "Hand", "Fruit", Vector3.new(1.28, 1.08, 1.06), Vector3.new(sign * 4.08, -1.08, -0.36), Palette.Red, { rotation = angles(0, 0, sign * 10), animationRole = `{sideName}Arm` })
		addPart(parts, `SingleSource{sideName}FistPalm`, "Hand", "Fruit", Vector3.new(0.82, 0.78, 0.46), Vector3.new(sign * 3.98, -1.06, -0.98), Palette.RedLight, { animationRole = `{sideName}Arm` })
		for fingerIndex, fingerY in ipairs({ -0.72, -1.04, -1.34 }) do
			addPart(parts, `SingleSource{sideName}FistFinger{fingerIndex}`, "Hand", "FruitDark", Vector3.new(0.28, 0.26, 0.42), Vector3.new(sign * 3.78, fingerY, -1.08), Palette.RedDark, { animationRole = `{sideName}Arm` })
		end
		addPart(parts, `SingleSource{sideName}FistStudTop`, "Hand", "Fruit", Vector3.new(0.38, 0.18, 0.38), Vector3.new(sign * 4.16, -0.54, -0.58), Palette.RedLight, { animationRole = `{sideName}Arm` })
		addPart(parts, `SingleSource{sideName}ArmSeed`, "Seed", "Seed", Vector3.new(0.26, 0.26, 0.12), Vector3.new(sign * 3.72, -0.08, -0.7), Palette.Seed, { animationRole = `{sideName}Arm` })
	end

	for _, side in ipairs({ { "Left", -0.98 }, { "Right", 0.98 } }) do
		local sideName, x = side[1], side[2]
		addPart(parts, `SingleSource{sideName}LegRedTop`, "Sock", "FruitDark", Vector3.new(0.72, 0.22, 0.62), Vector3.new(x, -1.9, -0.02), Palette.RedDark, { animationRole = `{sideName}Leg` })
		addPart(parts, `SingleSource{sideName}SockPinkTop`, "Sock", "Outfit", Vector3.new(0.72, 0.3, 0.62), Vector3.new(x, -2.08, -0.02), Palette.Pink, { animationRole = `{sideName}Leg` })
		addPart(parts, `SingleSource{sideName}SockWhiteStripe`, "SockCuff", "Face", Vector3.new(0.74, 0.32, 0.64), Vector3.new(x, -2.34, -0.02), Palette.White, { animationRole = `{sideName}Leg` })
		addPart(parts, `SingleSource{sideName}SockPinkLower`, "Sock", "Outfit", Vector3.new(0.72, 0.28, 0.62), Vector3.new(x, -2.6, -0.02), Palette.Pink, { animationRole = `{sideName}Leg` })
		addPart(parts, `SingleSource{sideName}ShoeBlock`, "Shoe", "Shoe", Vector3.new(1.46, 0.56, 1.46), Vector3.new(x, -2.78, -0.28), Palette.Red, { animationRole = `{sideName}Foot` })
		addPart(parts, `SingleSource{sideName}ShoeToe`, "Shoe", "Shoe", Vector3.new(1.56, 0.42, 0.62), Vector3.new(x, -2.64, -1.12), Palette.RedLight, { animationRole = `{sideName}Foot` })
		addPart(parts, `SingleSource{sideName}ShoeSole`, "ShoePanel", "Face", Vector3.new(1.62, 0.24, 1.62), Vector3.new(x, -3.08, -0.28), Palette.WhiteShade, { animationRole = `{sideName}Foot` })
		addPart(parts, `SingleSource{sideName}ShoeFrontSole`, "ShoePanel", "Face", Vector3.new(1.5, 0.2, 0.22), Vector3.new(x, -2.92, -1.42), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `SingleSource{sideName}ShoeToeTrim`, "ShoePanel", "Face", Vector3.new(1.24, 0.18, 0.16), Vector3.new(x, -2.54, -1.46), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `SingleSource{sideName}ShoeLaceA`, "ShoePanel", "Face", Vector3.new(0.5, 0.09, 0.12), Vector3.new(x - 0.26, -2.4, -1.48), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `SingleSource{sideName}ShoeLaceB`, "ShoePanel", "Face", Vector3.new(0.5, 0.09, 0.12), Vector3.new(x + 0.26, -2.4, -1.48), Palette.White, { animationRole = `{sideName}Foot` })
		addPart(parts, `SingleSource{sideName}ShoeSideDot`, "ShoePanel", "Seed", Vector3.new(0.14, 0.24, 0.24), Vector3.new(x + (x > 0 and -0.82 or 0.82), -2.72, -0.78), Palette.Seed, { animationRole = `{sideName}Foot` })
	end

	return parts
end

return StrawberitaVoxelData
