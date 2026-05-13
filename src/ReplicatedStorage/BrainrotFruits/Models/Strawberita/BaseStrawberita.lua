local BaseStrawberita = {}

BaseStrawberita.TemplateName = "BaseStrawberita"
BaseStrawberita.ReferencePath = "art/references/Strawberita/strawberita_voxel_reference.png"
BaseStrawberita.ReferenceDescription = "Approved 4-view voxel Strawberita reference sheet"
BaseStrawberita.TemplateVersion = "VoxelReferenceRebuild_V3"
BaseStrawberita.EstimatedHeightStuds = 6.49

local ZERO = Vector3.new(0, 0, 0)
local ONE = Vector3.new(1, 1, 1)

BaseStrawberita.Palette = {
	Body = Color3.fromRGB(240, 48, 58),
	BodyDark = Color3.fromRGB(206, 35, 45),
	BodyShade = Color3.fromRGB(182, 30, 40),
	FacePanel = Color3.fromRGB(255, 201, 175),
	Skin = Color3.fromRGB(255, 201, 175),
	Seed = Color3.fromRGB(255, 219, 38),
	Leaf = Color3.fromRGB(96, 183, 27),
	LeafShadow = Color3.fromRGB(67, 139, 24),
	Stem = Color3.fromRGB(88, 147, 40),
	Cheek = Color3.fromRGB(255, 122, 150),
	EyeFrame = Color3.fromRGB(14, 15, 15),
	EyeWhite = Color3.fromRGB(255, 255, 255),
	EyePupil = Color3.fromRGB(47, 145, 45),
	Smile = Color3.fromRGB(18, 18, 18),
	Sock = Color3.fromRGB(255, 151, 177),
	SockCuff = Color3.fromRGB(255, 242, 244),
	Shoe = Color3.fromRGB(225, 38, 47),
	ShoePanel = Color3.fromRGB(255, 242, 244),
	BeltStud = Color3.fromRGB(255, 242, 244),
	Bow = Color3.fromRGB(255, 86, 105),
	BerryIcon = Color3.fromRGB(225, 38, 48),
}

local function angles(x, y, z)
	return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0))
end

local function part(name, role, size, offset, color, material, rotation, className)
	return {
		name = name,
		role = role,
		size = size,
		offset = offset,
		color = color,
		material = material,
		rotation = rotation,
		className = className,
	}
end

local function frontSeed(name, x, y)
	return part(name, "Seed", Vector3.new(0.3, 0.3, 0.16), Vector3.new(x, y, -1.66), BaseStrawberita.Palette.Seed)
end

local function sideSeed(name, x, y, z)
	return part(name, "Seed", Vector3.new(0.16, 0.3, 0.3), Vector3.new(x, y, z), BaseStrawberita.Palette.Seed)
end

local function backSeed(name, x, y)
	return part(name, "Seed", Vector3.new(0.3, 0.3, 0.16), Vector3.new(x, y, 1.66), BaseStrawberita.Palette.Seed)
end

BaseStrawberita.Parts = {
	-- Large voxel strawberry costume/head, built as stepped cuboids with real side and back depth.
	part("HeadRowBottom", "Body", Vector3.new(3.15, 0.48, 2.52), Vector3.new(0, 0.25, 0), BaseStrawberita.Palette.Body),
	part("HeadRowLower", "Body", Vector3.new(4.1, 0.7, 2.88), Vector3.new(0, 0.8, 0), BaseStrawberita.Palette.Body),
	part("HeadRowMiddle", "Body", Vector3.new(4.62, 1.06, 3.18), Vector3.new(0, 1.55, 0), BaseStrawberita.Palette.Body),
	part("HeadRowUpper", "Body", Vector3.new(4.2, 0.82, 2.98), Vector3.new(0, 2.45, 0), BaseStrawberita.Palette.Body),
	part("HeadRowTop", "Body", Vector3.new(3.24, 0.5, 2.48), Vector3.new(0, 3.04, 0), BaseStrawberita.Palette.Body),
	part("LeftHeadSideMass", "BodyDark", Vector3.new(0.56, 2.02, 2.62), Vector3.new(-2.42, 1.58, 0.04), BaseStrawberita.Palette.BodyDark),
	part("RightHeadSideMass", "BodyDark", Vector3.new(0.56, 2.02, 2.62), Vector3.new(2.42, 1.58, 0.04), BaseStrawberita.Palette.BodyDark),
	part("LeftHeadUpperStep", "Body", Vector3.new(0.7, 0.64, 2.36), Vector3.new(-1.95, 2.78, 0.02), BaseStrawberita.Palette.Body),
	part("RightHeadUpperStep", "Body", Vector3.new(0.7, 0.64, 2.36), Vector3.new(1.95, 2.78, 0.02), BaseStrawberita.Palette.Body),
	part("LeftFrontStrawberryStep", "Body", Vector3.new(0.42, 0.92, 0.42), Vector3.new(-2.26, 2.04, -1.7), BaseStrawberita.Palette.Body),
	part("RightFrontStrawberryStep", "Body", Vector3.new(0.42, 0.92, 0.42), Vector3.new(2.26, 2.04, -1.7), BaseStrawberita.Palette.Body),
	part("LeftBackStrawberryStep", "BodyDark", Vector3.new(0.42, 0.92, 0.42), Vector3.new(-2.26, 2.04, 1.7), BaseStrawberita.Palette.BodyDark),
	part("RightBackStrawberryStep", "BodyDark", Vector3.new(0.42, 0.92, 0.42), Vector3.new(2.26, 2.04, 1.7), BaseStrawberita.Palette.BodyDark),
	part("LeftHeadLowerTaper", "BodyShade", Vector3.new(0.62, 0.96, 2.38), Vector3.new(-1.88, 0.48, 0), BaseStrawberita.Palette.BodyShade, nil, angles(0, 0, 180), "WedgePart"),
	part("RightHeadLowerTaper", "BodyShade", Vector3.new(0.62, 0.96, 2.38), Vector3.new(1.88, 0.48, 0), BaseStrawberita.Palette.BodyShade, nil, nil, "WedgePart"),
	part("BackStrawberryPlate", "Body", Vector3.new(3.78, 2.38, 0.38), Vector3.new(0, 1.64, 1.62), BaseStrawberita.Palette.Body),

	-- Smaller red dress/body underneath the huge strawberry costume, matching the toy-like reference proportions.
	part("DressUpperBlock", "Body", Vector3.new(2.4, 0.72, 1.72), Vector3.new(0, -0.43, 0), BaseStrawberita.Palette.Body),
	part("DressLowerBlock", "Body", Vector3.new(2.78, 0.5, 1.88), Vector3.new(0, -0.9, 0), BaseStrawberita.Palette.Body),
	part("DressLeftSide", "BodyDark", Vector3.new(0.28, 0.84, 1.5), Vector3.new(-1.52, -0.62, 0), BaseStrawberita.Palette.BodyDark),
	part("DressRightSide", "BodyDark", Vector3.new(0.28, 0.84, 1.5), Vector3.new(1.52, -0.62, 0), BaseStrawberita.Palette.BodyDark),

	-- Big flat peach face panel: about 70% of body width and easy to read from avatar height.
	part("FacePanelLarge", "FacePanel", Vector3.new(3.42, 1.84, 0.2), Vector3.new(0, 1.42, -1.76), BaseStrawberita.Palette.FacePanel),
	part("FacePanelBottomLip", "FacePanel", Vector3.new(3.18, 0.22, 0.18), Vector3.new(0, 0.42, -1.75), BaseStrawberita.Palette.FacePanel),
	part("FacePanelLeftLip", "FacePanel", Vector3.new(0.22, 1.56, 0.18), Vector3.new(-1.82, 1.33, -1.75), BaseStrawberita.Palette.FacePanel),
	part("FacePanelRightLip", "FacePanel", Vector3.new(0.22, 1.56, 0.18), Vector3.new(1.82, 1.33, -1.75), BaseStrawberita.Palette.FacePanel),

	-- Cute symmetric voxel eyes: black block base, one white highlight, one green lower accent.
	part("LeftEyeBlackBase", "EyeFrame", Vector3.new(0.74, 0.9, 0.14), Vector3.new(-0.9, 1.66, -1.92), BaseStrawberita.Palette.EyeFrame),
	part("RightEyeBlackBase", "EyeFrame", Vector3.new(0.74, 0.9, 0.14), Vector3.new(0.9, 1.66, -1.92), BaseStrawberita.Palette.EyeFrame),
	part("LeftEyeWhiteSquare", "EyeWhite", Vector3.new(0.22, 0.22, 0.15), Vector3.new(-1.1, 1.98, -2.01), BaseStrawberita.Palette.EyeWhite),
	part("RightEyeWhiteSquare", "EyeWhite", Vector3.new(0.22, 0.22, 0.15), Vector3.new(0.7, 1.98, -2.01), BaseStrawberita.Palette.EyeWhite),
	part("LeftEyeGreenLower", "EyePupil", Vector3.new(0.26, 0.24, 0.15), Vector3.new(-0.76, 1.28, -2.01), BaseStrawberita.Palette.EyePupil),
	part("RightEyeGreenLower", "EyePupil", Vector3.new(0.26, 0.24, 0.15), Vector3.new(1.04, 1.28, -2.01), BaseStrawberita.Palette.EyePupil),
	part("LeftCheekBlock", "Cheek", Vector3.new(0.42, 0.22, 0.14), Vector3.new(-1.35, 0.88, -1.95), BaseStrawberita.Palette.Cheek),
	part("RightCheekBlock", "Cheek", Vector3.new(0.42, 0.22, 0.14), Vector3.new(1.35, 0.88, -1.95), BaseStrawberita.Palette.Cheek),
	part("SmileCenter", "Smile", Vector3.new(0.38, 0.08, 0.15), Vector3.new(0, 0.78, -2.02), BaseStrawberita.Palette.Smile),
	part("SmileLeftCorner", "Smile", Vector3.new(0.1, 0.16, 0.15), Vector3.new(-0.28, 0.84, -2.02), BaseStrawberita.Palette.Smile),
	part("SmileRightCorner", "Smile", Vector3.new(0.1, 0.16, 0.15), Vector3.new(0.28, 0.84, -2.02), BaseStrawberita.Palette.Smile),

	-- Yellow cube seeds placed across the visible costume, sides, and back.
	frontSeed("FrontSeedTopLeft", -1.34, 2.64),
	frontSeed("FrontSeedTopCenter", -0.3, 2.8),
	frontSeed("FrontSeedTopRight", 1.24, 2.62),
	frontSeed("FrontSeedMidLeft", -1.82, 1.94),
	frontSeed("FrontSeedMidRight", 1.82, 1.94),
	frontSeed("FrontSeedLowerLeft", -1.48, 0.5),
	frontSeed("FrontSeedLowerRight", 1.48, 0.5),
	sideSeed("LeftSideSeedTop", -2.62, 2.36, -0.58),
	sideSeed("LeftSideSeedMiddle", -2.62, 1.38, 0.72),
	sideSeed("LeftSideSeedLower", -2.38, 0.5, -0.22),
	sideSeed("RightSideSeedTop", 2.62, 2.36, -0.58),
	sideSeed("RightSideSeedMiddle", 2.62, 1.38, 0.72),
	sideSeed("RightSideSeedLower", 2.38, 0.5, -0.22),
	backSeed("BackSeedTopLeft", -1.22, 2.62),
	backSeed("BackSeedTopRight", 1.24, 2.5),
	backSeed("BackSeedMidLeft", -1.72, 1.56),
	backSeed("BackSeedMidCenter", 0, 1.78),
	backSeed("BackSeedMidRight", 1.72, 1.42),
	backSeed("BackSeedLowerLeft", -1.1, 0.54),
	backSeed("BackSeedLowerRight", 1.1, 0.54),

	-- Layered chunky strawberry leaf crown with front, sides, and back coverage.
	part("LeafBackShelf", "LeafShadow", Vector3.new(3.9, 0.38, 1.42), Vector3.new(0, 3.25, 0.56), BaseStrawberita.Palette.LeafShadow),
	part("LeafFrontShelf", "Leaf", Vector3.new(3.58, 0.42, 1.32), Vector3.new(0, 3.28, -0.58), BaseStrawberita.Palette.Leaf),
	part("LeafCenterFrontBlock", "Leaf", Vector3.new(1.0, 0.56, 1.34), Vector3.new(0, 3.5, -1.08), BaseStrawberita.Palette.Leaf, nil, angles(-6, 0, 0), "WedgePart"),
	part("LeafLeftFrontBlock", "Leaf", Vector3.new(0.98, 0.48, 1.22), Vector3.new(-1.0, 3.44, -0.86), BaseStrawberita.Palette.Leaf, nil, angles(-6, -22, 0), "WedgePart"),
	part("LeafRightFrontBlock", "Leaf", Vector3.new(0.98, 0.48, 1.22), Vector3.new(1.0, 3.44, -0.86), BaseStrawberita.Palette.Leaf, nil, angles(-6, 22, 0), "WedgePart"),
	part("LeafLeftWideBlock", "LeafShadow", Vector3.new(1.02, 0.44, 1.3), Vector3.new(-1.82, 3.32, -0.04), BaseStrawberita.Palette.LeafShadow, nil, angles(-4, -40, 0), "WedgePart"),
	part("LeafRightWideBlock", "LeafShadow", Vector3.new(1.02, 0.44, 1.3), Vector3.new(1.82, 3.32, -0.04), BaseStrawberita.Palette.LeafShadow, nil, angles(-4, 40, 0), "WedgePart"),
	part("LeafBackBlock", "LeafShadow", Vector3.new(1.02, 0.42, 1.2), Vector3.new(0, 3.34, 1.14), BaseStrawberita.Palette.LeafShadow, nil, angles(4, 180, 0), "WedgePart"),
	part("StemBlock", "Stem", Vector3.new(0.52, 0.68, 0.52), Vector3.new(0, 3.98, 0.05), BaseStrawberita.Palette.Stem, Enum.Material.Wood),

	-- Pink bow mounted on upper-left strawberry, large enough to read like the reference.
	part("BowKnot", "Bow", Vector3.new(0.38, 0.38, 0.18), Vector3.new(-1.62, 2.76, -1.9), BaseStrawberita.Palette.Bow),
	part("BowLeftLoop", "Bow", Vector3.new(0.66, 0.54, 0.18), Vector3.new(-2.08, 2.78, -1.88), BaseStrawberita.Palette.Bow, nil, angles(0, 0, 10)),
	part("BowRightLoop", "Bow", Vector3.new(0.66, 0.54, 0.18), Vector3.new(-1.16, 2.78, -1.88), BaseStrawberita.Palette.Bow, nil, angles(0, 0, -10)),
	part("BowLeftTail", "Bow", Vector3.new(0.28, 0.38, 0.16), Vector3.new(-1.84, 2.36, -1.87), BaseStrawberita.Palette.Bow, nil, angles(0, 0, -10)),
	part("BowRightTail", "Bow", Vector3.new(0.28, 0.38, 0.16), Vector3.new(-1.4, 2.36, -1.87), BaseStrawberita.Palette.Bow, nil, angles(0, 0, 10)),

	-- Chest berry emblem and skirt/band trim.
	part("ChestBerryBlock", "BerryIcon", Vector3.new(0.48, 0.48, 0.13), Vector3.new(0, -0.42, -1.02), BaseStrawberita.Palette.BerryIcon),
	part("ChestBerryLeaf", "Leaf", Vector3.new(0.34, 0.14, 0.13), Vector3.new(0, -0.08, -1.05), BaseStrawberita.Palette.Leaf),
	part("ChestBerrySeedLeft", "Seed", Vector3.new(0.08, 0.08, 0.14), Vector3.new(-0.13, -0.38, -1.11), BaseStrawberita.Palette.Seed, Enum.Material.Neon),
	part("ChestBerrySeedRight", "Seed", Vector3.new(0.08, 0.08, 0.14), Vector3.new(0.13, -0.55, -1.11), BaseStrawberita.Palette.Seed, Enum.Material.Neon),
	part("SkirtBandFront", "BodyDark", Vector3.new(3.2, 0.34, 0.22), Vector3.new(0, -1.18, -0.96), BaseStrawberita.Palette.BodyDark),
	part("SkirtBandBack", "BodyDark", Vector3.new(3.2, 0.34, 0.22), Vector3.new(0, -1.18, 0.96), BaseStrawberita.Palette.BodyDark),
	part("SkirtBandLeft", "BodyDark", Vector3.new(0.22, 0.34, 1.72), Vector3.new(-1.6, -1.18, 0), BaseStrawberita.Palette.BodyDark),
	part("SkirtBandRight", "BodyDark", Vector3.new(0.22, 0.34, 1.72), Vector3.new(1.6, -1.18, 0), BaseStrawberita.Palette.BodyDark),
	part("TrimSquareOne", "BeltStud", Vector3.new(0.24, 0.24, 0.11), Vector3.new(-1.18, -1.18, -1.1), BaseStrawberita.Palette.BeltStud),
	part("TrimSquareTwo", "BeltStud", Vector3.new(0.24, 0.24, 0.11), Vector3.new(-0.4, -1.18, -1.1), BaseStrawberita.Palette.BeltStud),
	part("TrimSquareThree", "BeltStud", Vector3.new(0.24, 0.24, 0.11), Vector3.new(0.4, -1.18, -1.1), BaseStrawberita.Palette.BeltStud),
	part("TrimSquareFour", "BeltStud", Vector3.new(0.24, 0.24, 0.11), Vector3.new(1.18, -1.18, -1.1), BaseStrawberita.Palette.BeltStud),

	-- Chibi limbs: short red arms, peach hands, block legs, red boots with white panels.
	part("LeftArmBlock", "Body", Vector3.new(0.5, 0.9, 0.48), Vector3.new(-1.96, -0.58, -0.12), BaseStrawberita.Palette.Body, nil, angles(0, 0, -18)),
	part("RightArmBlock", "Body", Vector3.new(0.5, 0.9, 0.48), Vector3.new(1.96, -0.58, -0.12), BaseStrawberita.Palette.Body, nil, angles(0, 0, 18)),
	part("LeftHandBlock", "Skin", Vector3.new(0.42, 0.34, 0.4), Vector3.new(-2.16, -1.18, -0.18), BaseStrawberita.Palette.Skin, nil, angles(0, 0, -8)),
	part("RightHandBlock", "Skin", Vector3.new(0.42, 0.34, 0.4), Vector3.new(2.16, -1.18, -0.18), BaseStrawberita.Palette.Skin, nil, angles(0, 0, 8)),
	part("LeftLegBlock", "Sock", Vector3.new(0.42, 0.58, 0.42), Vector3.new(-0.58, -1.62, -0.02), BaseStrawberita.Palette.Sock),
	part("RightLegBlock", "Sock", Vector3.new(0.42, 0.58, 0.42), Vector3.new(0.58, -1.62, -0.02), BaseStrawberita.Palette.Sock),
	part("LeftLegCuff", "SockCuff", Vector3.new(0.48, 0.16, 0.46), Vector3.new(-0.58, -1.31, -0.02), BaseStrawberita.Palette.SockCuff),
	part("RightLegCuff", "SockCuff", Vector3.new(0.48, 0.16, 0.46), Vector3.new(0.58, -1.31, -0.02), BaseStrawberita.Palette.SockCuff),
	part("LeftBootBlock", "Shoe", Vector3.new(0.78, 0.48, 0.88), Vector3.new(-0.66, -2.02, -0.14), BaseStrawberita.Palette.Shoe),
	part("RightBootBlock", "Shoe", Vector3.new(0.78, 0.48, 0.88), Vector3.new(0.66, -2.02, -0.14), BaseStrawberita.Palette.Shoe),
	part("LeftBootWhitePanel", "ShoePanel", Vector3.new(0.5, 0.14, 0.1), Vector3.new(-0.66, -1.98, -0.64), BaseStrawberita.Palette.ShoePanel),
	part("RightBootWhitePanel", "ShoePanel", Vector3.new(0.5, 0.14, 0.1), Vector3.new(0.66, -1.98, -0.64), BaseStrawberita.Palette.ShoePanel),
}

local function scaledVector(vector, scale)
	return Vector3.new(vector.X * scale, vector.Y * scale, vector.Z * scale)
end

local function createBrick(model, root, properties, scale)
	local brick = Instance.new(properties.className or "Part")
	brick.Name = properties.name
	brick.Size = scaledVector(properties.size or ONE, scale)
	brick.CFrame = root.CFrame
		* CFrame.new(scaledVector(properties.offset or ZERO, scale))
		* (properties.rotation or CFrame.new())
	brick.Color = properties.color
	brick.Material = properties.material or Enum.Material.SmoothPlastic
	brick.Transparency = properties.transparency or 0
	brick.Reflectance = properties.reflectance or 0
	brick.CanCollide = false
	brick.CanTouch = false
	brick.CanQuery = false
	brick.Massless = true
	brick.Anchored = root.Anchored
	brick.TopSurface = Enum.SurfaceType.Smooth
	brick.BottomSurface = Enum.SurfaceType.Smooth
	brick:SetAttribute("StrawberitaRole", properties.role or "Uncategorized")
	brick:SetAttribute("CanonicalBasePart", true)
	brick.Parent = model

	local weld = Instance.new("WeldConstraint")
	weld.Name = "BaseTemplateWeld"
	weld.Part0 = root
	weld.Part1 = brick
	weld.Parent = brick

	return brick
end

function BaseStrawberita.ensurePrimaryPart(model)
	local root = model:FindFirstChild("Root")
	if root and root:IsA("BasePart") then
		model.PrimaryPart = root
		return root
	end

	local firstPart = model:FindFirstChildWhichIsA("BasePart", true)
	if firstPart then
		model.PrimaryPart = firstPart
	end

	return firstPart
end

function BaseStrawberita.setAnchored(model, anchored)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = anchored
		end
	end
end

function BaseStrawberita.create(options)
	options = options or {}

	local scale = options.scale or 1
	local pivot = options.pivot or CFrame.new()
	local anchored = options.anchored ~= false

	local model = Instance.new("Model")
	model.Name = options.name or BaseStrawberita.TemplateName
	model:SetAttribute("CanonicalBaseName", BaseStrawberita.TemplateName)
	model:SetAttribute("CanonicalBaseVersion", BaseStrawberita.TemplateVersion)
	model:SetAttribute("CanonicalReferencePath", BaseStrawberita.ReferencePath)
	model:SetAttribute("CanonicalReferenceDescription", BaseStrawberita.ReferenceDescription)
	model:SetAttribute("EstimatedHeightStuds", BaseStrawberita.EstimatedHeightStuds * scale)
	model:SetAttribute("Style", "VoxelStrawberryMascot")

	local root = Instance.new("Part")
	root.Name = "Root"
	root.Size = Vector3.new(1, 1, 1) * scale
	root.CFrame = pivot
	root.Transparency = 1
	root.CanCollide = false
	root.CanTouch = false
	root.CanQuery = false
	root.Anchored = anchored
	root:SetAttribute("StrawberitaRole", "Root")
	root:SetAttribute("CanonicalBasePart", true)
	root.Parent = model
	model.PrimaryPart = root

	for _, definition in ipairs(BaseStrawberita.Parts) do
		createBrick(model, root, definition, scale)
	end

	return model
end

return BaseStrawberita
