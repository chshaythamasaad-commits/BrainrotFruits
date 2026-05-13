local BaseStrawberita = {}

BaseStrawberita.TemplateName = "BaseStrawberita"
BaseStrawberita.ReferencePath = "art/references/Strawberita/strawberita_voxel_reference.png"
BaseStrawberita.ReferenceDescription = "Approved 4-view voxel Strawberita reference sheet"
BaseStrawberita.TemplateVersion = "2026-05-14-voxel-reference-rebuild-v2"
BaseStrawberita.EstimatedHeightStuds = 6.05

local ZERO = Vector3.new(0, 0, 0)
local ONE = Vector3.new(1, 1, 1)

BaseStrawberita.Palette = {
	Body = Color3.fromRGB(239, 52, 61),
	BodyDark = Color3.fromRGB(202, 35, 45),
	FacePanel = Color3.fromRGB(255, 199, 174),
	Skin = Color3.fromRGB(255, 199, 174),
	Seed = Color3.fromRGB(255, 221, 45),
	Leaf = Color3.fromRGB(93, 181, 28),
	LeafShadow = Color3.fromRGB(68, 143, 26),
	Stem = Color3.fromRGB(86, 142, 40),
	Cheek = Color3.fromRGB(255, 124, 151),
	EyeFrame = Color3.fromRGB(18, 18, 18),
	EyeWhite = Color3.fromRGB(255, 255, 255),
	EyePupil = Color3.fromRGB(49, 139, 45),
	EyeHighlight = Color3.fromRGB(255, 255, 255),
	Smile = Color3.fromRGB(24, 22, 22),
	Sock = Color3.fromRGB(255, 153, 178),
	SockCuff = Color3.fromRGB(255, 241, 244),
	Shoe = Color3.fromRGB(232, 40, 49),
	ShoePanel = Color3.fromRGB(255, 241, 244),
	BeltStud = Color3.fromRGB(255, 241, 244),
	Bow = Color3.fromRGB(255, 83, 103),
	BerryIcon = Color3.fromRGB(226, 39, 49),
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

local function seed(name, offset, rotation)
	return part(name, "Seed", Vector3.new(0.24, 0.24, 0.13), offset, BaseStrawberita.Palette.Seed, nil, rotation)
end

local function sideSeed(name, offset)
	return part(name, "Seed", Vector3.new(0.13, 0.24, 0.24), offset, BaseStrawberita.Palette.Seed)
end

BaseStrawberita.Parts = {
	-- Chunky strawberry body: wide, deep, and tapered like the reference instead of a flat mascot card.
	part("StrawberryBottomBlock", "Body", Vector3.new(2.55, 0.62, 2.15), Vector3.new(0, -0.03, 0), BaseStrawberita.Palette.Body),
	part("StrawberryLowerBlock", "Body", Vector3.new(3.25, 0.88, 2.55), Vector3.new(0, 0.55, 0), BaseStrawberita.Palette.Body),
	part("StrawberryCoreBlock", "Body", Vector3.new(3.95, 1.15, 2.9), Vector3.new(0, 1.42, 0), BaseStrawberita.Palette.Body),
	part("StrawberryShoulderBlock", "Body", Vector3.new(3.55, 0.92, 2.74), Vector3.new(0, 2.32, 0), BaseStrawberita.Palette.Body),
	part("StrawberryTopBlock", "Body", Vector3.new(2.82, 0.58, 2.35), Vector3.new(0, 2.94, 0), BaseStrawberita.Palette.Body),
	part("LeftRoundedSideBlock", "BodyDark", Vector3.new(0.46, 1.76, 2.34), Vector3.new(-2.16, 1.55, 0), BaseStrawberita.Palette.BodyDark),
	part("RightRoundedSideBlock", "BodyDark", Vector3.new(0.46, 1.76, 2.34), Vector3.new(2.16, 1.55, 0), BaseStrawberita.Palette.BodyDark),
	part("LeftLowerTaper", "Body", Vector3.new(0.54, 1.05, 2.22), Vector3.new(-1.58, 0.55, 0), BaseStrawberita.Palette.Body, nil, angles(0, 0, 180), "WedgePart"),
	part("RightLowerTaper", "Body", Vector3.new(0.54, 1.05, 2.22), Vector3.new(1.58, 0.55, 0), BaseStrawberita.Palette.Body, nil, nil, "WedgePart"),
	part("BackBodyPanel", "Body", Vector3.new(3.3, 1.8, 0.36), Vector3.new(0, 1.68, 1.54), BaseStrawberita.Palette.Body),

	-- Large square face tile and simple pixel expression.
	part("FlatFacePanel", "FacePanel", Vector3.new(2.82, 1.78, 0.16), Vector3.new(0, 1.72, -1.52), BaseStrawberita.Palette.FacePanel),
	part("LeftEyeBlackBlock", "EyeFrame", Vector3.new(0.56, 0.76, 0.08), Vector3.new(-0.72, 1.92, -1.64), BaseStrawberita.Palette.EyeFrame),
	part("RightEyeBlackBlock", "EyeFrame", Vector3.new(0.56, 0.76, 0.08), Vector3.new(0.72, 1.92, -1.64), BaseStrawberita.Palette.EyeFrame),
	part("LeftEyeWhiteHighlight", "EyeWhite", Vector3.new(0.18, 0.18, 0.09), Vector3.new(-0.85, 2.18, -1.7), BaseStrawberita.Palette.EyeWhite),
	part("RightEyeWhiteHighlight", "EyeWhite", Vector3.new(0.18, 0.18, 0.09), Vector3.new(0.59, 2.18, -1.7), BaseStrawberita.Palette.EyeWhite),
	part("LeftEyeGreenAccent", "EyePupil", Vector3.new(0.18, 0.18, 0.09), Vector3.new(-0.66, 1.66, -1.7), BaseStrawberita.Palette.EyePupil),
	part("RightEyeGreenAccent", "EyePupil", Vector3.new(0.18, 0.18, 0.09), Vector3.new(0.78, 1.66, -1.7), BaseStrawberita.Palette.EyePupil),
	part("LeftCheekBlock", "Cheek", Vector3.new(0.34, 0.18, 0.08), Vector3.new(-1.12, 1.34, -1.65), BaseStrawberita.Palette.Cheek),
	part("RightCheekBlock", "Cheek", Vector3.new(0.34, 0.18, 0.08), Vector3.new(1.12, 1.34, -1.65), BaseStrawberita.Palette.Cheek),
	part("SmileCenterPixel", "Smile", Vector3.new(0.34, 0.07, 0.09), Vector3.new(0, 1.24, -1.7), BaseStrawberita.Palette.Smile),
	part("SmileLeftPixel", "Smile", Vector3.new(0.08, 0.15, 0.09), Vector3.new(-0.23, 1.31, -1.7), BaseStrawberita.Palette.Smile),
	part("SmileRightPixel", "Smile", Vector3.new(0.08, 0.15, 0.09), Vector3.new(0.23, 1.31, -1.7), BaseStrawberita.Palette.Smile),

	-- Seed cubes wrap around the front, sides, and back so the model reads from every angle.
	seed("FrontSeedUpperLeft", Vector3.new(-1.34, 2.6, -1.52), angles(0, 0, -6)),
	seed("FrontSeedUpperCenter", Vector3.new(-0.24, 2.75, -1.54), angles(0, 0, 4)),
	seed("FrontSeedUpperRight", Vector3.new(1.22, 2.58, -1.52), angles(0, 0, 7)),
	seed("FrontSeedMidLeft", Vector3.new(-1.66, 1.98, -1.55), angles(0, 0, 8)),
	seed("FrontSeedMidRight", Vector3.new(1.64, 1.98, -1.55), angles(0, 0, -8)),
	seed("FrontSeedLowerLeft", Vector3.new(-1.42, 0.55, -1.38), angles(0, 0, -8)),
	seed("FrontSeedLowerRight", Vector3.new(1.42, 0.55, -1.38), angles(0, 0, 8)),
	sideSeed("LeftSideSeedUpper", Vector3.new(-2.42, 2.32, -0.55)),
	sideSeed("LeftSideSeedLower", Vector3.new(-2.42, 1.1, 0.54)),
	sideSeed("RightSideSeedUpper", Vector3.new(2.42, 2.32, -0.55)),
	sideSeed("RightSideSeedLower", Vector3.new(2.42, 1.1, 0.54)),
	seed("BackSeedUpperLeft", Vector3.new(-1.05, 2.52, 1.76), angles(0, 0, -5)),
	seed("BackSeedUpperRight", Vector3.new(1.08, 2.42, 1.76), angles(0, 0, 6)),
	seed("BackSeedMidCenter", Vector3.new(0, 1.66, 1.78), angles(0, 0, -4)),
	seed("BackSeedLowerLeft", Vector3.new(-1.26, 0.72, 1.68), angles(0, 0, 7)),
	seed("BackSeedLowerRight", Vector3.new(1.3, 0.72, 1.68), angles(0, 0, -7)),

	-- Leaf cap is intentionally layered and chunky like stacked voxel leaf blocks.
	part("LeafBackPlate", "LeafShadow", Vector3.new(3.45, 0.34, 1.58), Vector3.new(0, 3.24, 0.36), BaseStrawberita.Palette.LeafShadow),
	part("LeafFrontPlate", "Leaf", Vector3.new(3.12, 0.38, 1.42), Vector3.new(0, 3.28, -0.56), BaseStrawberita.Palette.Leaf),
	part("LeafCenterFront", "Leaf", Vector3.new(0.82, 0.46, 1.36), Vector3.new(0, 3.48, -1.0), BaseStrawberita.Palette.Leaf, nil, angles(-6, 0, 0), "WedgePart"),
	part("LeafLeftFront", "Leaf", Vector3.new(0.8, 0.42, 1.28), Vector3.new(-0.88, 3.42, -0.78), BaseStrawberita.Palette.Leaf, nil, angles(-5, -24, 0), "WedgePart"),
	part("LeafRightFront", "Leaf", Vector3.new(0.8, 0.42, 1.28), Vector3.new(0.88, 3.42, -0.78), BaseStrawberita.Palette.Leaf, nil, angles(-5, 24, 0), "WedgePart"),
	part("LeafLeftSide", "LeafShadow", Vector3.new(0.78, 0.38, 1.24), Vector3.new(-1.55, 3.34, 0.06), BaseStrawberita.Palette.LeafShadow, nil, angles(-4, -42, 0), "WedgePart"),
	part("LeafRightSide", "LeafShadow", Vector3.new(0.78, 0.38, 1.24), Vector3.new(1.55, 3.34, 0.06), BaseStrawberita.Palette.LeafShadow, nil, angles(-4, 42, 0), "WedgePart"),
	part("LeafBackCenter", "LeafShadow", Vector3.new(0.78, 0.38, 1.2), Vector3.new(0, 3.34, 0.96), BaseStrawberita.Palette.LeafShadow, nil, angles(5, 180, 0), "WedgePart"),
	part("BlockyStem", "Stem", Vector3.new(0.48, 0.7, 0.48), Vector3.new(0, 4.08, 0.05), BaseStrawberita.Palette.Stem, Enum.Material.Wood),

	-- Bow, chest emblem, skirt band, and boots mirror the reference's collectible costume details.
	part("BlockBowKnot", "Bow", Vector3.new(0.34, 0.34, 0.14), Vector3.new(-1.48, 2.7, -1.72), BaseStrawberita.Palette.Bow),
	part("BlockBowLeftWing", "Bow", Vector3.new(0.54, 0.42, 0.13), Vector3.new(-1.84, 2.72, -1.7), BaseStrawberita.Palette.Bow, nil, angles(0, 0, 9)),
	part("BlockBowRightWing", "Bow", Vector3.new(0.54, 0.42, 0.13), Vector3.new(-1.12, 2.72, -1.7), BaseStrawberita.Palette.Bow, nil, angles(0, 0, -9)),
	part("BowLeftTail", "Bow", Vector3.new(0.24, 0.32, 0.12), Vector3.new(-1.68, 2.34, -1.69), BaseStrawberita.Palette.Bow, nil, angles(0, 0, -10)),
	part("BowRightTail", "Bow", Vector3.new(0.24, 0.32, 0.12), Vector3.new(-1.3, 2.34, -1.69), BaseStrawberita.Palette.Bow, nil, angles(0, 0, 10)),
	part("MiniBerryBadge", "BerryIcon", Vector3.new(0.48, 0.48, 0.13), Vector3.new(0, 0.52, -1.45), BaseStrawberita.Palette.BerryIcon),
	part("MiniBerryLeaf", "Leaf", Vector3.new(0.34, 0.14, 0.13), Vector3.new(0, 0.88, -1.49), BaseStrawberita.Palette.Leaf),
	part("MiniBerrySeedOne", "Seed", Vector3.new(0.08, 0.08, 0.14), Vector3.new(-0.12, 0.54, -1.55), BaseStrawberita.Palette.Seed, Enum.Material.Neon),
	part("MiniBerrySeedTwo", "Seed", Vector3.new(0.08, 0.08, 0.14), Vector3.new(0.12, 0.38, -1.55), BaseStrawberita.Palette.Seed, Enum.Material.Neon),
	part("SkirtBandFront", "BodyDark", Vector3.new(3.14, 0.36, 0.22), Vector3.new(0, -0.42, -1.17), BaseStrawberita.Palette.BodyDark),
	part("SkirtBandBack", "BodyDark", Vector3.new(3.14, 0.36, 0.22), Vector3.new(0, -0.42, 1.17), BaseStrawberita.Palette.BodyDark),
	part("SkirtBandLeft", "BodyDark", Vector3.new(0.22, 0.36, 2.08), Vector3.new(-1.62, -0.42, 0), BaseStrawberita.Palette.BodyDark),
	part("SkirtBandRight", "BodyDark", Vector3.new(0.22, 0.36, 2.08), Vector3.new(1.62, -0.42, 0), BaseStrawberita.Palette.BodyDark),
	part("BeltStudLeftOuter", "BeltStud", Vector3.new(0.22, 0.22, 0.11), Vector3.new(-1.08, -0.42, -1.32), BaseStrawberita.Palette.BeltStud),
	part("BeltStudLeftInner", "BeltStud", Vector3.new(0.22, 0.22, 0.11), Vector3.new(-0.36, -0.42, -1.32), BaseStrawberita.Palette.BeltStud),
	part("BeltStudRightInner", "BeltStud", Vector3.new(0.22, 0.22, 0.11), Vector3.new(0.36, -0.42, -1.32), BaseStrawberita.Palette.BeltStud),
	part("BeltStudRightOuter", "BeltStud", Vector3.new(0.22, 0.22, 0.11), Vector3.new(1.08, -0.42, -1.32), BaseStrawberita.Palette.BeltStud),

	part("LeftSleeve", "Body", Vector3.new(0.46, 0.98, 0.48), Vector3.new(-2.0, 0.12, -0.22), BaseStrawberita.Palette.Body, nil, angles(0, 0, -18)),
	part("RightSleeve", "Body", Vector3.new(0.46, 0.98, 0.48), Vector3.new(2.0, 0.12, -0.22), BaseStrawberita.Palette.Body, nil, angles(0, 0, 18)),
	part("LeftBlockHand", "Skin", Vector3.new(0.42, 0.36, 0.4), Vector3.new(-2.14, -0.55, -0.28), BaseStrawberita.Palette.Skin, nil, angles(0, 0, -8)),
	part("RightBlockHand", "Skin", Vector3.new(0.42, 0.36, 0.4), Vector3.new(2.14, -0.55, -0.28), BaseStrawberita.Palette.Skin, nil, angles(0, 0, 8)),
	part("LeftSock", "Sock", Vector3.new(0.42, 0.72, 0.44), Vector3.new(-0.55, -0.92, -0.02), BaseStrawberita.Palette.Sock),
	part("RightSock", "Sock", Vector3.new(0.42, 0.72, 0.44), Vector3.new(0.55, -0.92, -0.02), BaseStrawberita.Palette.Sock),
	part("LeftSockCuff", "SockCuff", Vector3.new(0.48, 0.16, 0.48), Vector3.new(-0.55, -0.52, -0.02), BaseStrawberita.Palette.SockCuff),
	part("RightSockCuff", "SockCuff", Vector3.new(0.48, 0.16, 0.48), Vector3.new(0.55, -0.52, -0.02), BaseStrawberita.Palette.SockCuff),
	part("LeftSquareShoe", "Shoe", Vector3.new(0.74, 0.52, 0.86), Vector3.new(-0.62, -1.38, -0.12), BaseStrawberita.Palette.Shoe),
	part("RightSquareShoe", "Shoe", Vector3.new(0.74, 0.52, 0.86), Vector3.new(0.62, -1.38, -0.12), BaseStrawberita.Palette.Shoe),
	part("LeftShoePanel", "ShoePanel", Vector3.new(0.48, 0.14, 0.09), Vector3.new(-0.62, -1.36, -0.6), BaseStrawberita.Palette.ShoePanel),
	part("RightShoePanel", "ShoePanel", Vector3.new(0.48, 0.14, 0.09), Vector3.new(0.62, -1.36, -0.6), BaseStrawberita.Palette.ShoePanel),
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
