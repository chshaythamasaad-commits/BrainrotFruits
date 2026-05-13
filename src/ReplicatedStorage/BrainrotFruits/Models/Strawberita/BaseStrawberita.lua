local BaseStrawberita = {}

BaseStrawberita.TemplateName = "BaseStrawberita"
BaseStrawberita.ReferencePath = "references/references/Strawberita/strawberita_source_reference.png"
BaseStrawberita.ReferenceDescription = "Approved blocky front/angle/side/back Strawberita reference sheet"
BaseStrawberita.TemplateVersion = "2026-05-14-blocky-reference-v1"

local ZERO = Vector3.new(0, 0, 0)
local ONE = Vector3.new(1, 1, 1)

BaseStrawberita.Palette = {
	Body = Color3.fromRGB(239, 52, 61),
	BodyDark = Color3.fromRGB(209, 39, 49),
	FacePanel = Color3.fromRGB(255, 199, 174),
	Skin = Color3.fromRGB(255, 199, 174),
	Seed = Color3.fromRGB(255, 221, 45),
	Leaf = Color3.fromRGB(93, 181, 28),
	LeafShadow = Color3.fromRGB(68, 143, 26),
	Stem = Color3.fromRGB(86, 142, 40),
	Cheek = Color3.fromRGB(255, 124, 151),
	EyeFrame = Color3.fromRGB(20, 20, 20),
	EyeWhite = Color3.fromRGB(255, 255, 255),
	EyePupil = Color3.fromRGB(42, 111, 41),
	EyeHighlight = Color3.fromRGB(255, 255, 255),
	Smile = Color3.fromRGB(24, 22, 22),
	Sock = Color3.fromRGB(255, 153, 178),
	SockCuff = Color3.fromRGB(255, 241, 244),
	Shoe = Color3.fromRGB(232, 40, 49),
	ShoePanel = Color3.fromRGB(255, 241, 244),
	BeltStud = Color3.fromRGB(255, 241, 244),
	Bow = Color3.fromRGB(255, 82, 100),
	BerryIcon = Color3.fromRGB(233, 42, 52),
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

BaseStrawberita.Parts = {
	part("LowerDressBlock", "Body", Vector3.new(1.72, 0.58, 1.08), Vector3.new(0, 0.58, 0), BaseStrawberita.Palette.Body),
	part("DressSkirtBlock", "BodyDark", Vector3.new(2.04, 0.34, 1.14), Vector3.new(0, 0.98, 0), BaseStrawberita.Palette.BodyDark),
	part("StrawberryHeadLower", "Body", Vector3.new(2.34, 0.74, 1.22), Vector3.new(0, 1.36, 0), BaseStrawberita.Palette.Body),
	part("StrawberryHeadCore", "Body", Vector3.new(2.76, 1.06, 1.3), Vector3.new(0, 2.05, 0), BaseStrawberita.Palette.Body),
	part("StrawberryHeadCap", "Body", Vector3.new(2.34, 0.52, 1.22), Vector3.new(0, 2.78, 0), BaseStrawberita.Palette.Body),
	part("LeftHeadRoundBlock", "BodyDark", Vector3.new(0.42, 0.9, 1.15), Vector3.new(-1.54, 2.03, 0.02), BaseStrawberita.Palette.BodyDark),
	part("RightHeadRoundBlock", "BodyDark", Vector3.new(0.42, 0.9, 1.15), Vector3.new(1.54, 2.03, 0.02), BaseStrawberita.Palette.BodyDark),
	part("LeftHeadLowerTaper", "Body", Vector3.new(0.52, 0.98, 1.14), Vector3.new(-1.27, 1.48, 0.01), BaseStrawberita.Palette.Body, nil, angles(0, 0, 180), "WedgePart"),
	part("RightHeadLowerTaper", "Body", Vector3.new(0.52, 0.98, 1.14), Vector3.new(1.27, 1.48, 0.01), BaseStrawberita.Palette.Body, nil, nil, "WedgePart"),

	part("FlatFacePanel", "FacePanel", Vector3.new(1.86, 1.08, 0.1), Vector3.new(0, 1.82, -0.72), BaseStrawberita.Palette.FacePanel),
	part("LeftSideArmPanel", "BodyDark", Vector3.new(0.2, 0.92, 0.7), Vector3.new(-1.66, 1.35, -0.04), BaseStrawberita.Palette.BodyDark),
	part("RightSideArmPanel", "BodyDark", Vector3.new(0.2, 0.92, 0.7), Vector3.new(1.66, 1.35, -0.04), BaseStrawberita.Palette.BodyDark),

	part("SeedTopLeft", "Seed", Vector3.new(0.16, 0.21, 0.07), Vector3.new(-0.93, 2.58, -0.72), BaseStrawberita.Palette.Seed, nil, angles(0, 0, -4)),
	part("SeedTopCenter", "Seed", Vector3.new(0.16, 0.21, 0.07), Vector3.new(-0.25, 2.64, -0.73), BaseStrawberita.Palette.Seed, nil, angles(0, 0, 6)),
	part("SeedTopRight", "Seed", Vector3.new(0.16, 0.21, 0.07), Vector3.new(0.75, 2.54, -0.72), BaseStrawberita.Palette.Seed, nil, angles(0, 0, 2)),
	part("SeedMidLeft", "Seed", Vector3.new(0.16, 0.21, 0.07), Vector3.new(-1.22, 2.13, -0.72), BaseStrawberita.Palette.Seed, nil, angles(0, 0, 8)),
	part("SeedMidRight", "Seed", Vector3.new(0.16, 0.21, 0.07), Vector3.new(1.16, 2.13, -0.72), BaseStrawberita.Palette.Seed, nil, angles(0, 0, -7)),
	part("SeedLowerLeft", "Seed", Vector3.new(0.16, 0.21, 0.07), Vector3.new(-1.02, 1.1, -0.68), BaseStrawberita.Palette.Seed, nil, angles(0, 0, -7)),
	part("SeedLowerRight", "Seed", Vector3.new(0.16, 0.21, 0.07), Vector3.new(1.03, 1.1, -0.68), BaseStrawberita.Palette.Seed, nil, angles(0, 0, 7)),

	part("LeftEyeFrame", "EyeFrame", Vector3.new(0.36, 0.52, 0.055), Vector3.new(-0.45, 1.95, -0.805), BaseStrawberita.Palette.EyeFrame),
	part("RightEyeFrame", "EyeFrame", Vector3.new(0.36, 0.52, 0.055), Vector3.new(0.45, 1.95, -0.805), BaseStrawberita.Palette.EyeFrame),
	part("LeftEyePupil", "EyePupil", Vector3.new(0.22, 0.34, 0.065), Vector3.new(-0.45, 1.85, -0.85), BaseStrawberita.Palette.EyePupil),
	part("RightEyePupil", "EyePupil", Vector3.new(0.22, 0.34, 0.065), Vector3.new(0.45, 1.85, -0.85), BaseStrawberita.Palette.EyePupil),
	part("LeftEyeHighlight", "EyeHighlight", Vector3.new(0.1, 0.1, 0.07), Vector3.new(-0.52, 2.09, -0.89), BaseStrawberita.Palette.EyeHighlight, Enum.Material.Neon),
	part("RightEyeHighlight", "EyeHighlight", Vector3.new(0.1, 0.1, 0.07), Vector3.new(0.38, 2.09, -0.89), BaseStrawberita.Palette.EyeHighlight, Enum.Material.Neon),
	part("LeftCheekBlock", "Cheek", Vector3.new(0.24, 0.13, 0.055), Vector3.new(-0.72, 1.56, -0.82), BaseStrawberita.Palette.Cheek),
	part("RightCheekBlock", "Cheek", Vector3.new(0.24, 0.13, 0.055), Vector3.new(0.72, 1.56, -0.82), BaseStrawberita.Palette.Cheek),
	part("SmileCenterPixel", "Smile", Vector3.new(0.25, 0.07, 0.065), Vector3.new(0, 1.42, -0.86), BaseStrawberita.Palette.Smile),
	part("SmileLeftPixel", "Smile", Vector3.new(0.08, 0.14, 0.065), Vector3.new(-0.17, 1.47, -0.86), BaseStrawberita.Palette.Smile),
	part("SmileRightPixel", "Smile", Vector3.new(0.08, 0.14, 0.065), Vector3.new(0.17, 1.47, -0.86), BaseStrawberita.Palette.Smile),

	part("LeafBaseBack", "LeafShadow", Vector3.new(2.04, 0.26, 0.84), Vector3.new(0, 3.02, 0.1), BaseStrawberita.Palette.LeafShadow),
	part("LeafFrontCenter", "Leaf", Vector3.new(0.72, 0.34, 0.95), Vector3.new(0, 3.08, -0.45), BaseStrawberita.Palette.Leaf, nil, angles(-7, 0, 0), "WedgePart"),
	part("LeafFrontLeft", "Leaf", Vector3.new(0.72, 0.32, 0.88), Vector3.new(-0.62, 3.08, -0.28), BaseStrawberita.Palette.Leaf, nil, angles(-6, -24, 0), "WedgePart"),
	part("LeafFrontRight", "Leaf", Vector3.new(0.72, 0.32, 0.88), Vector3.new(0.62, 3.08, -0.28), BaseStrawberita.Palette.Leaf, nil, angles(-6, 24, 0), "WedgePart"),
	part("LeafSideLeft", "LeafShadow", Vector3.new(0.62, 0.3, 0.88), Vector3.new(-1.05, 3.0, 0.08), BaseStrawberita.Palette.LeafShadow, nil, angles(-4, -42, 0), "WedgePart"),
	part("LeafSideRight", "LeafShadow", Vector3.new(0.62, 0.3, 0.88), Vector3.new(1.05, 3.0, 0.08), BaseStrawberita.Palette.LeafShadow, nil, angles(-4, 42, 0), "WedgePart"),
	part("BlockyStem", "Stem", Vector3.new(0.34, 0.58, 0.34), Vector3.new(0, 3.42, 0.02), BaseStrawberita.Palette.Stem, Enum.Material.Wood),

	part("LeftSleeve", "Body", Vector3.new(0.34, 0.48, 0.34), Vector3.new(-1.36, 0.98, -0.02), BaseStrawberita.Palette.Body, nil, angles(0, 0, -24)),
	part("RightSleeve", "Body", Vector3.new(0.34, 0.48, 0.34), Vector3.new(1.36, 0.98, -0.02), BaseStrawberita.Palette.Body, nil, angles(0, 0, 24)),
	part("LeftBlockHand", "Skin", Vector3.new(0.34, 0.28, 0.32), Vector3.new(-1.52, 0.72, -0.04), BaseStrawberita.Palette.Skin, nil, angles(0, 0, -12)),
	part("RightBlockHand", "Skin", Vector3.new(0.34, 0.28, 0.32), Vector3.new(1.52, 0.72, -0.04), BaseStrawberita.Palette.Skin, nil, angles(0, 0, 12)),
	part("LeftSock", "Sock", Vector3.new(0.34, 0.46, 0.36), Vector3.new(-0.43, 0.05, -0.01), BaseStrawberita.Palette.Sock),
	part("RightSock", "Sock", Vector3.new(0.34, 0.46, 0.36), Vector3.new(0.43, 0.05, -0.01), BaseStrawberita.Palette.Sock),
	part("LeftSockCuff", "SockCuff", Vector3.new(0.38, 0.15, 0.38), Vector3.new(-0.43, 0.31, -0.01), BaseStrawberita.Palette.SockCuff),
	part("RightSockCuff", "SockCuff", Vector3.new(0.38, 0.15, 0.38), Vector3.new(0.43, 0.31, -0.01), BaseStrawberita.Palette.SockCuff),
	part("LeftSquareShoe", "Shoe", Vector3.new(0.58, 0.28, 0.64), Vector3.new(-0.46, -0.25, -0.08), BaseStrawberita.Palette.Shoe),
	part("RightSquareShoe", "Shoe", Vector3.new(0.58, 0.28, 0.64), Vector3.new(0.46, -0.25, -0.08), BaseStrawberita.Palette.Shoe),
	part("LeftShoePanel", "ShoePanel", Vector3.new(0.38, 0.12, 0.07), Vector3.new(-0.46, -0.25, -0.43), BaseStrawberita.Palette.ShoePanel),
	part("RightShoePanel", "ShoePanel", Vector3.new(0.38, 0.12, 0.07), Vector3.new(0.46, -0.25, -0.43), BaseStrawberita.Palette.ShoePanel),

	part("BlockBowKnot", "Bow", Vector3.new(0.22, 0.22, 0.085), Vector3.new(-0.77, 2.77, -0.79), BaseStrawberita.Palette.Bow),
	part("BlockBowLeftWing", "Bow", Vector3.new(0.34, 0.28, 0.08), Vector3.new(-1.03, 2.77, -0.78), BaseStrawberita.Palette.Bow, nil, angles(0, 0, 10)),
	part("BlockBowRightWing", "Bow", Vector3.new(0.34, 0.28, 0.08), Vector3.new(-0.51, 2.77, -0.78), BaseStrawberita.Palette.Bow, nil, angles(0, 0, -10)),
	part("BowLeftTail", "Bow", Vector3.new(0.16, 0.22, 0.075), Vector3.new(-0.9, 2.52, -0.78), BaseStrawberita.Palette.Bow, nil, angles(0, 0, -10)),
	part("BowRightTail", "Bow", Vector3.new(0.16, 0.22, 0.075), Vector3.new(-0.64, 2.52, -0.78), BaseStrawberita.Palette.Bow, nil, angles(0, 0, 10)),

	part("MiniBerryBadge", "BerryIcon", Vector3.new(0.34, 0.34, 0.08), Vector3.new(0, 0.86, -0.63), BaseStrawberita.Palette.BerryIcon),
	part("MiniBerryLeaf", "Leaf", Vector3.new(0.22, 0.11, 0.085), Vector3.new(0, 1.1, -0.65), BaseStrawberita.Palette.Leaf),
	part("MiniBerrySeedOne", "Seed", Vector3.new(0.07, 0.07, 0.09), Vector3.new(-0.07, 0.9, -0.69), BaseStrawberita.Palette.Seed, Enum.Material.Neon),
	part("MiniBerrySeedTwo", "Seed", Vector3.new(0.07, 0.07, 0.09), Vector3.new(0.08, 0.78, -0.69), BaseStrawberita.Palette.Seed, Enum.Material.Neon),

	part("BeltStudLeftOuter", "BeltStud", Vector3.new(0.18, 0.18, 0.08), Vector3.new(-0.78, 0.45, -0.61), BaseStrawberita.Palette.BeltStud),
	part("BeltStudLeftInner", "BeltStud", Vector3.new(0.18, 0.18, 0.08), Vector3.new(-0.28, 0.45, -0.61), BaseStrawberita.Palette.BeltStud),
	part("BeltStudRightInner", "BeltStud", Vector3.new(0.18, 0.18, 0.08), Vector3.new(0.28, 0.45, -0.61), BaseStrawberita.Palette.BeltStud),
	part("BeltStudRightOuter", "BeltStud", Vector3.new(0.18, 0.18, 0.08), Vector3.new(0.78, 0.45, -0.61), BaseStrawberita.Palette.BeltStud),
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
	model:SetAttribute("Style", "ApprovedBlockyStrawberita")

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
