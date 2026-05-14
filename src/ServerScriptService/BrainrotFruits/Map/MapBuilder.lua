local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local CatapultModelBuilder = require(script.Parent.CatapultModelBuilder)
local PlotModelBuilder = require(script.Parent.PlotModelBuilder)
local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local BlockStyle = require(brainrotFruits.Shared.BlockStyle)

local MapBuilder = {}

MapBuilder.MapName = "BrainrotMap"
MapBuilder.MapVersion = "IslandReferenceMap_V2"
MapBuilder.PlotCount = 6
MapBuilder.PlotSize = PlotModelBuilder.PlotSize
MapBuilder.SharedLaneLength = 540
MapBuilder.SlotCount = 12
MapBuilder.DebugMode = false

local COLORS = {
	Grass = Color3.fromRGB(74, 176, 83),
	GrassLight = Color3.fromRGB(120, 210, 91),
	GrassDark = Color3.fromRGB(42, 125, 70),
	Path = Color3.fromRGB(224, 199, 139),
	PathEdge = Color3.fromRGB(154, 127, 83),
	Stone = Color3.fromRGB(104, 113, 122),
	StoneDark = Color3.fromRGB(65, 73, 84),
	Water = Color3.fromRGB(24, 146, 226),
	WaterDeep = Color3.fromRGB(8, 95, 184),
	Wood = Color3.fromRGB(126, 82, 42),
	WoodDark = Color3.fromRGB(78, 50, 31),
	White = Color3.fromRGB(255, 255, 245),
	Black = Color3.fromRGB(28, 29, 34),
}

local PLOT_THEMES = {
	{ name = "Berry", color = Color3.fromRGB(232, 68, 74), accent = Color3.fromRGB(255, 139, 112), roof = Color3.fromRGB(190, 55, 49) },
	{ name = "Citrus", color = Color3.fromRGB(244, 141, 36), accent = Color3.fromRGB(255, 198, 75), roof = Color3.fromRGB(224, 102, 28) },
	{ name = "Sun", color = Color3.fromRGB(239, 194, 42), accent = Color3.fromRGB(255, 230, 98), roof = Color3.fromRGB(214, 154, 34) },
	{ name = "Melon", color = Color3.fromRGB(64, 185, 75), accent = Color3.fromRGB(126, 224, 108), roof = Color3.fromRGB(48, 145, 65) },
	{ name = "Splash", color = Color3.fromRGB(51, 139, 226), accent = Color3.fromRGB(116, 204, 255), roof = Color3.fromRGB(34, 109, 191) },
	{ name = "Grape", color = Color3.fromRGB(142, 78, 215), accent = Color3.fromRGB(199, 136, 255), roof = Color3.fromRGB(116, 54, 190) },
}

local PLOT_LAYOUTS = {
	Vector3.new(-88, 0, -82),
	Vector3.new(-128, 0, -2),
	Vector3.new(-88, 0, 82),
	Vector3.new(88, 0, -82),
	Vector3.new(128, 0, -2),
	Vector3.new(88, 0, 82),
}

local function getOrCreateFolder(parent, name)
	local folder = parent:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end
	return folder
end

local function createPart(parent, name, size, cframe, color, material, transparency)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Transparency = transparency or 0
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	BlockStyle.applyStuddedStyle(part)
	part.Parent = parent
	return part
end

local function createWedge(parent, name, size, cframe, color, material, transparency)
	local wedge = Instance.new("WedgePart")
	wedge.Name = name
	wedge.Size = size
	wedge.CFrame = cframe
	wedge.Color = color
	wedge.Material = material or Enum.Material.SmoothPlastic
	wedge.Transparency = transparency or 0
	wedge.Anchored = true
	wedge.TopSurface = Enum.SurfaceType.Smooth
	wedge.BottomSurface = Enum.SurfaceType.Smooth
	BlockStyle.applyStuddedStyle(wedge)
	wedge.Parent = parent
	return wedge
end

local function localToWorld(frame, x, y, z)
	return frame * CFrame.new(x, y, z)
end

local function addSurfaceText(part, text, face, textColor, backgroundColor)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "SurfaceText"
	surface.Face = face or Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 42
	surface.LightInfluence = 0.15
	surface.AlwaysOnTop = false
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundColor3 = backgroundColor or COLORS.Black
	label.BackgroundTransparency = backgroundColor and 0.12 or 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = textColor or COLORS.White
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0.25
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface

	return label
end

local function addSmallBillboard(part, name, text, size, offset, maxDistance)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = name
	billboard.Size = size or UDim2.fromOffset(132, 38)
	billboard.StudsOffset = offset or Vector3.new(0, 2.8, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = maxDistance or 70
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.TextColor3 = COLORS.White
	label.TextScaled = true
	label.TextStrokeTransparency = 0.25
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard

	return label
end

local function createFacingSign(parent, name, text, cframe, color, size, textColor)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local boardSize = size or Vector3.new(14, 4.4, 0.65)
	local board = createPart(model, "Board", boardSize, cframe, color, Enum.Material.SmoothPlastic)
	board.CanCollide = false
	addSurfaceText(board, text, Enum.NormalId.Front, textColor or COLORS.White, COLORS.Black)

	createPart(model, "Trim", boardSize + Vector3.new(0.8, 0.55, 0.18), cframe * CFrame.new(0, 0, 0.08), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "LeftPost", Vector3.new(0.45, 3.2, 0.45), cframe * CFrame.new(-boardSize.X * 0.38, -boardSize.Y * 0.5 - 1.35, 0), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "RightPost", Vector3.new(0.45, 3.2, 0.45), cframe * CFrame.new(boardSize.X * 0.38, -boardSize.Y * 0.5 - 1.35, 0), COLORS.WoodDark, Enum.Material.Wood)
	model.PrimaryPart = board

	return model
end

local function createTopTextPad(parent, name, text, size, cframe, color, textColor)
	local pad = createPart(parent, name, size, cframe, color, Enum.Material.SmoothPlastic)
	addSurfaceText(pad, text, Enum.NormalId.Top, textColor or COLORS.White)
	return pad
end

local function createLamp(parent, name, position, scale)
	scale = scale or 1
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "Post", Vector3.new(0.34, 3.8, 0.34) * scale, CFrame.new(position + Vector3.new(0, 1.9 * scale, 0)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "TopCap", Vector3.new(1.15, 0.25, 1.15) * scale, CFrame.new(position + Vector3.new(0, 3.95 * scale, 0)), COLORS.StoneDark, Enum.Material.SmoothPlastic)
	local lantern = createPart(model, "Lantern", Vector3.new(0.8, 0.8, 0.8) * scale, CFrame.new(position + Vector3.new(0, 3.45 * scale, 0)), Color3.fromRGB(255, 223, 91), Enum.Material.Neon)

	local light = Instance.new("PointLight")
	light.Name = "WarmLight"
	light.Color = Color3.fromRGB(255, 219, 132)
	light.Brightness = 0.65
	light.Range = 14 * scale
	light.Parent = lantern

	model.PrimaryPart = lantern
	return model
end

local function createVoxelTree(parent, name, position, scale, color)
	scale = scale or 1
	color = color or Color3.fromRGB(55, 160, 67)

	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "Trunk", Vector3.new(1.2, 3.5, 1.2) * scale, CFrame.new(position + Vector3.new(0, 1.75 * scale, 0)), COLORS.Wood, Enum.Material.Wood)
	createPart(model, "LeafBlockLow", Vector3.new(5.2, 1.8, 5.2) * scale, CFrame.new(position + Vector3.new(0, 4.1 * scale, 0)), color, Enum.Material.Grass)
	createPart(model, "LeafBlockMid", Vector3.new(4.0, 1.8, 4.0) * scale, CFrame.new(position + Vector3.new(0, 5.3 * scale, 0)), color:Lerp(COLORS.White, 0.08), Enum.Material.Grass)
	createPart(model, "LeafBlockTop", Vector3.new(2.6, 1.5, 2.6) * scale, CFrame.new(position + Vector3.new(0, 6.45 * scale, 0)), color:Lerp(COLORS.White, 0.16), Enum.Material.Grass)

	model.PrimaryPart = model:FindFirstChild("Trunk")
	return model
end

local function createBush(parent, name, position, scale, color)
	scale = scale or 1
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "BushCore", Vector3.new(2.4, 1.1, 2.2) * scale, CFrame.new(position + Vector3.new(0, 0.55 * scale, 0)), color or COLORS.GrassLight, Enum.Material.Grass)
	createPart(model, "BushLeft", Vector3.new(1.5, 0.9, 1.5) * scale, CFrame.new(position + Vector3.new(-0.95 * scale, 0.45 * scale, 0.18 * scale)), COLORS.Grass, Enum.Material.Grass)
	createPart(model, "BushRight", Vector3.new(1.5, 0.9, 1.5) * scale, CFrame.new(position + Vector3.new(0.95 * scale, 0.45 * scale, -0.18 * scale)), COLORS.Grass, Enum.Material.Grass)

	return model
end

local function createRock(parent, name, position, scale)
	scale = scale or 1
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "RockBase", Vector3.new(2.9, 1.2, 2.2) * scale, CFrame.new(position + Vector3.new(0, 0.6 * scale, 0)), COLORS.Stone, Enum.Material.Slate)
	createPart(model, "RockTop", Vector3.new(1.8, 0.85, 1.5) * scale, CFrame.new(position + Vector3.new(0.25 * scale, 1.45 * scale, -0.1 * scale)), COLORS.StoneDark, Enum.Material.Slate)

	return model
end

local function createFlowerPatch(parent, name, position, color)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	for index, offset in ipairs({
		Vector3.new(-0.85, 0, -0.25),
		Vector3.new(0, 0, 0.35),
		Vector3.new(0.8, 0, -0.1),
	}) do
		createPart(model, `Stem{index}`, Vector3.new(0.12, 0.58, 0.12), CFrame.new(position + offset + Vector3.new(0, 0.29, 0)), Color3.fromRGB(45, 146, 57), Enum.Material.Grass)
		createPart(model, `Flower{index}`, Vector3.new(0.46, 0.28, 0.46), CFrame.new(position + offset + Vector3.new(0, 0.72, 0)), color, Enum.Material.SmoothPlastic)
	end

	return model
end

local function createCrateStack(parent, name, position)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "CrateA", Vector3.new(2.2, 2, 2.2), CFrame.new(position + Vector3.new(0, 1, 0)), COLORS.Wood, Enum.Material.WoodPlanks)
	createPart(model, "CrateB", Vector3.new(1.8, 1.7, 1.8), CFrame.new(position + Vector3.new(1.6, 0.85, -0.8)), COLORS.Wood, Enum.Material.WoodPlanks)
	createPart(model, "Barrel", Vector3.new(1.4, 2, 1.4), CFrame.new(position + Vector3.new(-1.7, 1, 0.5)), Color3.fromRGB(111, 70, 39), Enum.Material.Wood)

	return model
end

local function createFruitStatue(parent, name, position, color, accent)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "Pedestal", Vector3.new(4.2, 0.65, 4.2), CFrame.new(position + Vector3.new(0, 0.33, 0)), COLORS.Stone, Enum.Material.Slate)
	createPart(model, "FruitBlock", Vector3.new(2.25, 2.15, 2.05), CFrame.new(position + Vector3.new(0, 1.75, 0)), color, Enum.Material.SmoothPlastic)
	createPart(model, "FruitTop", Vector3.new(1.55, 0.55, 1.35), CFrame.new(position + Vector3.new(0, 3.08, 0)), color:Lerp(COLORS.White, 0.08), Enum.Material.SmoothPlastic)
	createPart(model, "LeafLeft", Vector3.new(1.15, 0.3, 0.78), CFrame.new(position + Vector3.new(-0.58, 3.45, 0)), accent, Enum.Material.Grass)
	createPart(model, "LeafRight", Vector3.new(1.15, 0.3, 0.78), CFrame.new(position + Vector3.new(0.58, 3.45, 0)), accent, Enum.Material.Grass)
	createPart(model, "GlowTile", Vector3.new(3.15, 0.12, 3.15), CFrame.new(position + Vector3.new(0, 0.72, 0)), color, Enum.Material.Neon, 0.55)

	return model
end

local function createPath(parent, name, size, cframe)
	local path = createPart(parent, name, size, cframe, COLORS.Path, Enum.Material.Sand)
	path.CanCollide = false
	createPart(parent, `{name}LeftEdge`, Vector3.new(size.X, 0.18, 0.35), cframe * CFrame.new(0, 0.09, -size.Z / 2 - 0.18), COLORS.PathEdge, Enum.Material.SmoothPlastic)
	createPart(parent, `{name}RightEdge`, Vector3.new(size.X, 0.18, 0.35), cframe * CFrame.new(0, 0.09, size.Z / 2 + 0.18), COLORS.PathEdge, Enum.Material.SmoothPlastic)
	return path
end

local function createLaneFlag(parent, name, position, side, color)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local poleX = side * 17.2
	createPart(model, "Pole", Vector3.new(0.35, 4.4, 0.35), CFrame.new(poleX, 3.1, position.Z), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "Flag", Vector3.new(3.1, 1.6, 0.28), CFrame.new(poleX + side * 1.65, 4.35, position.Z), color, Enum.Material.SmoothPlastic)
	createPart(model, "FlagTip", Vector3.new(0.55, 0.55, 0.36), CFrame.new(poleX + side * 3.25, 4.35, position.Z), color:Lerp(COLORS.White, 0.25), Enum.Material.Neon, 0.1)

	return model
end

local function createMilestoneArch(parent, distance, z, color)
	local model = Instance.new("Model")
	model.Name = `MilestoneArch_{distance}`
	model:SetAttribute("DistanceStuds", distance)
	model.Parent = parent

	createPart(model, "LeftPost", Vector3.new(1.1, 8.2, 1.1), CFrame.new(-15.2, 4.65, z), COLORS.StoneDark, Enum.Material.Slate)
	createPart(model, "RightPost", Vector3.new(1.1, 8.2, 1.1), CFrame.new(15.2, 4.65, z), COLORS.StoneDark, Enum.Material.Slate)
	createPart(model, "TopBeam", Vector3.new(32, 1.15, 1.25), CFrame.new(0, 8.92, z), color, Enum.Material.SmoothPlastic)
	local sign = createPart(model, "DistanceSign", Vector3.new(11, 2.1, 0.55), CFrame.new(0, 7.45, z - 0.82), color:Lerp(COLORS.Black, 0.18), Enum.Material.SmoothPlastic)
	addSurfaceText(sign, `{distance} STUDS`, Enum.NormalId.Front, COLORS.White, COLORS.Black)
	createPart(model, "GlowLine", Vector3.new(24, 0.14, 0.58), CFrame.new(0, 1.25, z), color, Enum.Material.Neon, 0.18)

	return model
end

local function createBooth(parent, name, position, yawDegrees, color, accent)
	local model = Instance.new("Model")
	model.Name = `{name}Stand`
	model.Parent = parent

	local frame = CFrame.new(position) * CFrame.Angles(0, math.rad(yawDegrees or 0), 0)
	local base = createPart(model, "Base", Vector3.new(12, 0.9, 9), frame, color:Lerp(COLORS.Stone, 0.16), Enum.Material.SmoothPlastic)
	createPart(model, "Counter", Vector3.new(10.5, 2.5, 2.1), frame * CFrame.new(0, 1.55, -3.1), color, Enum.Material.SmoothPlastic)
	local sign = createPart(model, "BackSign", Vector3.new(10.8, 3.1, 0.7), frame * CFrame.new(0, 4.45, -4.45), color:Lerp(COLORS.Black, 0.12), Enum.Material.SmoothPlastic)
	addSurfaceText(sign, name, Enum.NormalId.Front, COLORS.White, COLORS.Black)

	createPart(model, "AwningBase", Vector3.new(12, 0.48, 3.2), frame * CFrame.new(0, 5.95, -3.1), accent, Enum.Material.SmoothPlastic)
	for stripe = -2, 2 do
		createPart(model, `AwningStripe{stripe}`, Vector3.new(1.2, 0.55, 3.35), frame * CFrame.new(stripe * 2.2, 6.04, -3.1), color, Enum.Material.SmoothPlastic)
	end

	createPart(model, "DisplayBlock", Vector3.new(1.4, 1.4, 1.4), frame * CFrame.new(3.5, 1.85, 1.35), accent, Enum.Material.Neon, 0.05)
	createCrateStack(model, "BoothCrates", (frame * CFrame.new(-3.5, 0, 1.3)).Position)

	model.PrimaryPart = base
	return model
end

local function createLeaderboard(parent, name, title, rows, cframe, accentColor)
	local model = Instance.new("Model")
	model.Name = name
	model:SetAttribute("Type", "GlobalLeaderboard")
	model:SetAttribute("LeaderboardName", title)
	model.Parent = parent

	local board = createPart(model, "Board", Vector3.new(20, 11.5, 0.75), cframe, COLORS.Black, Enum.Material.SmoothPlastic)
	board.CanCollide = false
	local trimColor = accentColor or Color3.fromRGB(255, 213, 84)
	createPart(model, "BackPlate", Vector3.new(21.6, 12.8, 0.55), cframe * CFrame.new(0, 0, 0.22), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "TopBeam", Vector3.new(22.6, 1, 1.2), cframe * CFrame.new(0, 6.7, 0.12), COLORS.Wood, Enum.Material.Wood)
	createPart(model, "BottomBeam", Vector3.new(22.4, 0.8, 1.1), cframe * CFrame.new(0, -6.45, 0.12), COLORS.Wood, Enum.Material.Wood)
	createPart(model, "LeftPost", Vector3.new(1, 14, 1), cframe * CFrame.new(-10.9, -0.65, 0.12), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "RightPost", Vector3.new(1, 14, 1), cframe * CFrame.new(10.9, -0.65, 0.12), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "Crown", Vector3.new(4.2, 1.4, 0.75), cframe * CFrame.new(0, 8.0, -0.08), trimColor, Enum.Material.Neon, 0.04)
	createPart(model, "GlowStrip", Vector3.new(17.5, 0.22, 0.18), cframe * CFrame.new(0, 4.3, -0.46), trimColor, Enum.Material.Neon, 0.08)

	local textLines = { title }
	for index, row in ipairs(rows) do
		table.insert(textLines, `{index}. {row}`)
	end
	addSurfaceText(board, table.concat(textLines, "\n"), Enum.NormalId.Front, trimColor, COLORS.Black)

	model.PrimaryPart = board
	return model
end

local function buildSharedCatapult(parent)
	local catapult = CatapultModelBuilder.createCatapult({
		parent = parent,
		name = "Catapult",
		cframe = CFrame.new(0, 0.95, 54) * CFrame.Angles(0, math.rad(180), 0),
		scale = 1.35,
		plotId = 0,
		isSharedLauncher = true,
		decorative = false,
		launchOrigin = Vector3.new(0, 11.1, 70),
		launchDirection = Vector3.new(0, 0, 1),
	})
	catapult:SetAttribute("OrientationCorrected", true)
	catapult:SetAttribute("FacesLaunchLane", true)
	catapult:SetAttribute("LaunchFacingFixed", true)
	return catapult
end

local function buildSharedLaunchArea(map)
	local launchArea = getOrCreateFolder(map, "SharedLaunchArea")
	launchArea:ClearAllChildren()

	createPart(launchArea, "LaunchPlaza", Vector3.new(58, 0.4, 42), CFrame.new(0, 0.46, 48), COLORS.Stone, Enum.Material.Slate)
	createPart(launchArea, "LaunchPlazaInset", Vector3.new(42, 0.18, 27), CFrame.new(0, 0.78, 48), Color3.fromRGB(84, 94, 104), Enum.Material.SmoothPlastic)
	createPath(launchArea, "HubToLaunchPath", Vector3.new(14, 0.18, 44), CFrame.new(0, 0.9, 28) * CFrame.Angles(0, math.rad(90), 0))
	createFacingSign(launchArea, "MainLaunchSign", "MAIN LAUNCH", CFrame.new(0, 7.1, 32) * CFrame.Angles(0, math.rad(180), 0), COLORS.Black, Vector3.new(18, 4.2, 0.7))
	createPart(launchArea, "MainLaunchGlow", Vector3.new(34, 0.15, 6.5), CFrame.new(0, 1.04, 31.5), Color3.fromRGB(255, 198, 51), Enum.Material.Neon, 0.65)

	buildSharedCatapult(launchArea)
	createTopTextPad(launchArea, "LaunchDirectionArrow", "LAUNCH >>", Vector3.new(18, 0.16, 4.2), CFrame.new(0, 1.12, 69), Color3.fromRGB(234, 74, 108), COLORS.White)

	for _, position in ipairs({
		Vector3.new(-24, 0, 35),
		Vector3.new(24, 0, 35),
		Vector3.new(-23, 0, 65),
		Vector3.new(23, 0, 65),
	}) do
		createLamp(launchArea, "LaunchLamp", position, 0.9)
	end

	local lane = Instance.new("Folder")
	lane.Name = "LaunchLane"
	lane:SetAttribute("LaunchLaneVersion", "ExtendedDecoratedLane_V1")
	lane.Parent = launchArea

	local laneStartZ = 70
	local laneEndZ = laneStartZ + MapBuilder.SharedLaneLength
	local laneCenterZ = (laneStartZ + laneEndZ) / 2
	local revealZ = laneEndZ + 18
	lane:SetAttribute("LaneStartZ", laneStartZ)
	lane:SetAttribute("LaneEndZ", laneEndZ)
	lane:SetAttribute("RevealZoneZ", revealZ)

	createPart(lane, "LaneFloor", Vector3.new(24, 0.32, MapBuilder.SharedLaneLength), CFrame.new(0, 0.62, laneCenterZ), Color3.fromRGB(76, 166, 76), Enum.Material.Grass)
	createPart(lane, "LaneCenterStripe", Vector3.new(1, 0.08, MapBuilder.SharedLaneLength - 10), CFrame.new(0, 0.84, laneCenterZ), Color3.fromRGB(241, 255, 211), Enum.Material.SmoothPlastic)
	for stripeIndex = 0, 8 do
		local stripeZ = laneStartZ + 34 + stripeIndex * 58
		local stripeColor = stripeIndex % 2 == 0 and Color3.fromRGB(92, 190, 92) or Color3.fromRGB(66, 151, 83)
		createPart(lane, `LaneProgressStrip{stripeIndex}`, Vector3.new(22.4, 0.05, 7.5), CFrame.new(0, 0.88, stripeZ), stripeColor, Enum.Material.SmoothPlastic, 0.08)
	end
	for _, x in ipairs({ -12.6, 12.6 }) do
		createPart(lane, "LaneStoneCurb", Vector3.new(0.8, 0.65, MapBuilder.SharedLaneLength), CFrame.new(x, 1.05, laneCenterZ), COLORS.StoneDark, Enum.Material.Slate)
		createPart(lane, "LaneFenceRail", Vector3.new(0.35, 0.45, MapBuilder.SharedLaneLength - 8), CFrame.new(x, 2.15, laneCenterZ), COLORS.Wood, Enum.Material.Wood)
		local postIndex = 0
		for z = laneStartZ + 8, laneEndZ - 8, 28 do
			postIndex += 1
			createPart(lane, "LaneFencePost", Vector3.new(0.45, 2, 0.45), CFrame.new(x, 1.75, z), COLORS.WoodDark, Enum.Material.Wood)
			if postIndex % 2 == 0 then
				createPart(lane, "FencePostCap", Vector3.new(0.72, 0.32, 0.72), CFrame.new(x, 2.92, z), Color3.fromRGB(255, 224, 91), Enum.Material.Neon, 0.18)
			end
		end
	end

	for _, distance in ipairs({ 25, 50, 75, 100, 150, 200, 300, 400, 500 }) do
		local z = 70 + distance
		createPart(lane, `DistanceLine_{distance}`, Vector3.new(22, 0.12, 0.42), CFrame.new(0, 0.98, z), COLORS.White, Enum.Material.SmoothPlastic)
		createTopTextPad(lane, `DistanceMarker_{distance}`, tostring(distance), Vector3.new(7, 0.15, 3.2), CFrame.new(0, 1.08, z + 2.4), Color3.fromRGB(58, 139, 68), COLORS.White):SetAttribute("DistanceStuds", distance)
		if distance == 100 or distance == 200 or distance == 300 or distance == 400 or distance == 500 then
			createMilestoneArch(lane, distance, z + 8, Color3.fromRGB(255, 181, 70):Lerp(Color3.fromRGB(130, 72, 219), math.clamp(distance / 520, 0, 1)))
		end
	end

	for index, z in ipairs({ 104, 156, 218, 278, 338, 398, 458, 518, 578 }) do
		local side = index % 2 == 0 and 1 or -1
		local color = PLOT_THEMES[((index - 1) % #PLOT_THEMES) + 1].color
		createLaneFlag(lane, `LaneFlag{index}`, Vector3.new(0, 0, z), side, color)
		createLamp(lane, `LaneLamp{index}`, Vector3.new(-side * 20.2, 0, z + 12), 0.72)
		if index % 3 == 0 then
			createTopTextPad(lane, `LaneArrow{index}`, ">>", Vector3.new(6.4, 0.13, 3.4), CFrame.new(0, 1.06, z + 24), Color3.fromRGB(234, 74, 108), COLORS.White)
		end
	end

	for index, position in ipairs({
		Vector3.new(-28, 0.5, 172),
		Vector3.new(28, 0.5, 246),
		Vector3.new(-30, 0.5, 344),
		Vector3.new(30, 0.5, 438),
		Vector3.new(-30, 0.5, 536),
	}) do
		createRock(lane, `LaneRock{index}`, position, 0.75)
	end

	for index, position in ipairs({
		Vector3.new(-28, 0.55, 132),
		Vector3.new(29, 0.55, 300),
		Vector3.new(-29, 0.55, 492),
	}) do
		createBush(lane, `LaneBush{index}`, position, 0.72, COLORS.GrassLight)
	end

	createPart(lane, "RevealZoneBase", Vector3.new(58, 2.6, 46), CFrame.new(0, -0.35, revealZ), COLORS.StoneDark, Enum.Material.Slate)
	local revealPlatform = createTopTextPad(lane, "LandingZone", "REVEAL ZONE", Vector3.new(49, 0.45, 37), CFrame.new(0, 1.16, revealZ), Color3.fromRGB(137, 78, 222), COLORS.White)
	revealPlatform.Material = Enum.Material.Neon
	revealPlatform.Transparency = 0.12
	revealPlatform:SetAttribute("Role", "LandingZone")
	local revealAttachment = Instance.new("Attachment")
	revealAttachment.Name = "RevealSparkleAttachment"
	revealAttachment.Parent = revealPlatform
	local revealSparkles = Instance.new("ParticleEmitter")
	revealSparkles.Name = "RevealZoneSparkles"
	revealSparkles.Color = ColorSequence.new(Color3.fromRGB(255, 231, 120), Color3.fromRGB(190, 116, 255))
	revealSparkles.LightEmission = 0.55
	revealSparkles.Rate = 8
	revealSparkles.Lifetime = NumberRange.new(1.2, 2.1)
	revealSparkles.Speed = NumberRange.new(0.35, 1.2)
	revealSparkles.SpreadAngle = Vector2.new(180, 180)
	revealSparkles.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.22),
		NumberSequenceKeypoint.new(0.55, 0.16),
		NumberSequenceKeypoint.new(1, 0),
	})
	revealSparkles.Parent = revealAttachment
	createFacingSign(lane, "RevealZoneSign", "REVEAL ZONE", CFrame.new(0, 5.4, revealZ - 21) * CFrame.Angles(0, math.rad(180), 0), Color3.fromRGB(111, 61, 197), Vector3.new(19, 4, 0.75))

	for _, position in ipairs({
		Vector3.new(-25, 0, revealZ - 17),
		Vector3.new(25, 0, revealZ - 17),
		Vector3.new(-25, 0, revealZ + 18),
		Vector3.new(25, 0, revealZ + 18),
	}) do
		createLamp(lane, "RevealLamp", position, 0.88)
	end

	return launchArea
end

local function makePlot(plotsFolder, plotId)
	local center = PLOT_LAYOUTS[plotId]
	local theme = PLOT_THEMES[plotId]
	local plotFrame = CFrame.lookAt(center, Vector3.new(0, 0, 0))

	return PlotModelBuilder.createPlot({
		parent = plotsFolder,
		plotId = plotId,
		position = center,
		plotFrame = plotFrame,
		theme = theme,
		ownerName = nil,
		ownerUserId = 0,
		debugMode = MapBuilder.DebugMode,
	})
end

local function buildHub(map)
	local hub = getOrCreateFolder(map, "CentralHub")
	hub:ClearAllChildren()

	createPart(hub, "HubStonePlaza", Vector3.new(82, 0.45, 76), CFrame.new(0, 0.42, -2), COLORS.Stone, Enum.Material.Slate)
	createPart(hub, "SafeZoneGrass", Vector3.new(56, 0.2, 50), CFrame.new(0, 0.78, -5), COLORS.Grass, Enum.Material.Grass)
	createPart(hub, "SafeZoneRingNorth", Vector3.new(58, 0.18, 4), CFrame.new(0, 0.94, -31), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingSouth", Vector3.new(58, 0.18, 4), CFrame.new(0, 0.94, 21), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingWest", Vector3.new(4, 0.18, 52), CFrame.new(-29, 0.94, -5), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingEast", Vector3.new(4, 0.18, 52), CFrame.new(29, 0.94, -5), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "CenterShowcaseRing", Vector3.new(34, 0.16, 34), CFrame.new(0, 1.02, -8), Color3.fromRGB(255, 224, 91), Enum.Material.Neon, 0.72)
	createPart(hub, "CenterShowcaseWalkRing", Vector3.new(42, 0.14, 42), CFrame.new(0, 0.98, -8), COLORS.Path, Enum.Material.Sand)

	createTopTextPad(hub, "SafeZoneTextPad", "SAFE ZONE", Vector3.new(22, 0.16, 5), CFrame.new(0, 1.06, 20), Color3.fromRGB(57, 160, 71), COLORS.White)
	if MapBuilder.DebugMode then
		createFacingSign(hub, "MapV2ActiveSign", "MAP V2 ACTIVE", CFrame.new(-34, 5, 34) * CFrame.Angles(0, math.rad(145), 0), Color3.fromRGB(44, 151, 94), Vector3.new(12, 3.4, 0.65))
	end
	createFacingSign(hub, "HubTitleSign", "BRAINROT FRUITS", CFrame.new(0, 7.2, -39), Color3.fromRGB(234, 74, 108), Vector3.new(23, 5.2, 0.8))

	createLeaderboard(
		hub,
		"TopLaunchesLeaderboard",
		"TOP LAUNCHES",
		{ "FruitRocket 982", "BananaBoss 821", "BerryBandit 744", "MelonMan 630", "LaunchKing 512" },
		CFrame.new(-34, 7.4, -28) * CFrame.Angles(0, math.rad(15), 0),
		Color3.fromRGB(255, 213, 84)
	)
	createLeaderboard(
		hub,
		"TopDistanceLeaderboard",
		"TOP DISTANCE",
		{ "PlayerOne 500", "FruitMaster 420", "SkyHighBot 360", "VoidLauncher 310", "ChunkyCat 275" },
		CFrame.new(34, 7.4, -28) * CFrame.Angles(0, math.rad(-15), 0),
		Color3.fromRGB(130, 239, 255)
	)

	createBooth(hub, "SHOP", Vector3.new(-58, 0.95, -6), 82, Color3.fromRGB(211, 57, 46), Color3.fromRGB(255, 245, 232))
	createBooth(hub, "SELL", Vector3.new(-53, 0.95, 31), 122, Color3.fromRGB(214, 151, 42), Color3.fromRGB(255, 241, 147))
	createBooth(hub, "UPGRADES", Vector3.new(58, 0.95, -6), -82, Color3.fromRGB(130, 72, 219), Color3.fromRGB(245, 226, 255))
	createBooth(hub, "INDEX", Vector3.new(53, 0.95, 31), -122, Color3.fromRGB(42, 128, 214), Color3.fromRGB(215, 241, 255))

	local pedestal = createPart(hub, "ShowcasePedestal", Vector3.new(16, 3.2, 16), CFrame.new(0, 2, -8), Color3.fromRGB(50, 53, 70), Enum.Material.SmoothPlastic)
	pedestal:SetAttribute("Role", "RarestFruitShowcase")
	createPart(hub, "ShowcaseGlow", Vector3.new(13, 0.24, 13), CFrame.new(0, 3.72, -8), Color3.fromRGB(153, 86, 255), Enum.Material.Neon, 0.18)
	createPart(hub, "ShowcaseOuterGlow", Vector3.new(22, 0.14, 22), CFrame.new(0, 3.58, -8), Color3.fromRGB(255, 91, 231), Enum.Material.Neon, 0.75)
	createFacingSign(hub, "ShowcaseSign", "RAREST FRUIT", CFrame.new(0, 6.1, -23.5), Color3.fromRGB(38, 39, 44), Vector3.new(15, 3.5, 0.7), Color3.fromRGB(255, 235, 79))

	for _, position in ipairs({
		Vector3.new(-45, 0, -31),
		Vector3.new(45, 0, -31),
		Vector3.new(-45, 0, 29),
		Vector3.new(45, 0, 29),
		Vector3.new(-18, 0, -36),
		Vector3.new(18, 0, -36),
	}) do
		createLamp(hub, "HubLamp", position, 0.82)
	end

	for plotId, center in ipairs(PLOT_LAYOUTS) do
		local target = Vector3.new(center.X * 0.42, 0, center.Z * 0.42)
		local direction = Vector3.new(center.X, 0, center.Z).Unit
		local pathLength = math.max(58, Vector3.new(center.X, 0, center.Z).Magnitude * 0.58)
		createPath(hub, `PathToPlot{plotId}`, Vector3.new(10, 0.16, pathLength), CFrame.lookAt(target, target + direction) * CFrame.new(0, 0.88, 0))
	end
end

local function createIslandPiece(parent, name, size, position, color)
	createPart(parent, `{name}Stone`, Vector3.new(size.X + 8, 4.2, size.Z + 8), CFrame.new(position + Vector3.new(0, -2.3, 0)), COLORS.StoneDark, Enum.Material.Slate)
	createPart(parent, name, size, CFrame.new(position), color or COLORS.Grass, Enum.Material.Grass)
end

local function buildIslandBase(map)
	createPart(map, "Ocean", Vector3.new(620, 0.3, 1160), CFrame.new(0, -3.35, 190), COLORS.Water, Enum.Material.SmoothPlastic, 0.04)
	createPart(map, "DeepOcean", Vector3.new(720, 0.25, 1260), CFrame.new(0, -3.7, 190), COLORS.WaterDeep, Enum.Material.SmoothPlastic, 0.12)

	local island = getOrCreateFolder(map, "IslandBase")
	island:ClearAllChildren()

	createIslandPiece(island, "CoreGrass", Vector3.new(214, 0.7, 166), Vector3.new(0, -0.08, -8), COLORS.Grass)
	createIslandPiece(island, "LeftPlotLobe", Vector3.new(105, 0.7, 205), Vector3.new(-112, -0.08, -2), COLORS.GrassLight)
	createIslandPiece(island, "RightPlotLobe", Vector3.new(105, 0.7, 205), Vector3.new(112, -0.08, -2), COLORS.GrassLight)
	createIslandPiece(island, "BackLobe", Vector3.new(196, 0.7, 82), Vector3.new(0, -0.08, -112), COLORS.Grass)
	createIslandPiece(island, "LaunchPeninsula", Vector3.new(88, 0.7, 260), Vector3.new(0, -0.08, 190), COLORS.Grass)
	createIslandPiece(island, "ExtendedLaunchCauseway", Vector3.new(76, 0.7, 330), Vector3.new(0, -0.08, 435), COLORS.GrassLight)
	createIslandPiece(island, "RevealPlatformIsland", Vector3.new(132, 0.7, 94), Vector3.new(0, -0.08, 628), COLORS.GrassDark)

	local edges = getOrCreateFolder(map, "IslandEdges")
	edges:ClearAllChildren()

	for index, data in ipairs({
		{ pos = Vector3.new(-178, -1.7, -82), size = Vector3.new(16, 5.5, 82) },
		{ pos = Vector3.new(178, -1.7, -82), size = Vector3.new(16, 5.5, 82) },
		{ pos = Vector3.new(-178, -1.7, 72), size = Vector3.new(16, 5.5, 88) },
		{ pos = Vector3.new(178, -1.7, 72), size = Vector3.new(16, 5.5, 88) },
		{ pos = Vector3.new(-60, -1.7, -157), size = Vector3.new(104, 5.5, 16) },
		{ pos = Vector3.new(60, -1.7, -157), size = Vector3.new(104, 5.5, 16) },
		{ pos = Vector3.new(-48, -1.7, 364), size = Vector3.new(14, 5.5, 245) },
		{ pos = Vector3.new(48, -1.7, 364), size = Vector3.new(14, 5.5, 245) },
		{ pos = Vector3.new(-65, -1.7, 672), size = Vector3.new(88, 5.5, 16) },
		{ pos = Vector3.new(65, -1.7, 672), size = Vector3.new(88, 5.5, 16) },
	}) do
		createPart(edges, `CliffBlock{index}`, data.size, CFrame.new(data.pos), COLORS.StoneDark, Enum.Material.Slate)
	end

	for index, position in ipairs({
		Vector3.new(-195, -2.2, -112),
		Vector3.new(195, -2.2, -108),
		Vector3.new(-198, -2.2, 38),
		Vector3.new(198, -2.2, 48),
		Vector3.new(-62, -2.2, 568),
		Vector3.new(64, -2.2, 604),
		Vector3.new(-96, -2.2, 680),
		Vector3.new(96, -2.2, 680),
	}) do
		createRock(edges, `EdgeRock{index}`, position, 1.45)
	end

	for index, position in ipairs({
		Vector3.new(-188, -1.1, 104),
		Vector3.new(188, -1.1, -104),
		Vector3.new(89, -1.1, 646),
	}) do
		createPart(edges, `Waterfall{index}`, Vector3.new(7, 5.2, 1.1), CFrame.new(position), Color3.fromRGB(91, 206, 255), Enum.Material.Neon, 0.35)
		createPart(edges, `WaterfallFoam{index}`, Vector3.new(10, 0.2, 4.5), CFrame.new(position + Vector3.new(0, -2.7, 2.2)), COLORS.White, Enum.Material.SmoothPlastic, 0.18)
	end
end

local function buildWorldDecorations(map)
	local decor = getOrCreateFolder(map, "Decorations")
	decor:ClearAllChildren()

	for index, position in ipairs({
		Vector3.new(-186, 0, -55),
		Vector3.new(-174, 0, 67),
		Vector3.new(-108, 0, -151),
		Vector3.new(-50, 0, 115),
		Vector3.new(54, 0, -146),
		Vector3.new(113, 0, 120),
		Vector3.new(181, 0, -52),
		Vector3.new(176, 0, 73),
		Vector3.new(31, 0, 176),
		Vector3.new(-31, 0, 176),
	}) do
		local treeColor = index % 2 == 0 and Color3.fromRGB(70, 174, 70) or Color3.fromRGB(51, 145, 68)
		createVoxelTree(decor, `IslandTree{index}`, position, index % 3 == 0 and 0.9 or 0.76, treeColor)
	end

	for index, position in ipairs({
		Vector3.new(-86, 0.55, 35),
		Vector3.new(-65, 0.55, -52),
		Vector3.new(65, 0.55, 43),
		Vector3.new(88, 0.55, -53),
		Vector3.new(137, 0.55, 20),
		Vector3.new(-137, 0.55, -24),
		Vector3.new(0, 0.55, 96),
	}) do
		createBush(decor, `IslandBush{index}`, position, 0.82, COLORS.GrassLight)
	end

	for index, position in ipairs({
		Vector3.new(-103, 0.55, 8),
		Vector3.new(-56, 0.55, 76),
		Vector3.new(53, 0.55, 78),
		Vector3.new(87, 0.55, -82),
		Vector3.new(139, 0.55, -29),
		Vector3.new(-150, 0.55, 42),
	}) do
		createFlowerPatch(decor, `IslandFlowers{index}`, position, PLOT_THEMES[((index - 1) % #PLOT_THEMES) + 1].accent)
	end

	for index, position in ipairs({
		Vector3.new(-114, 0.5, -83),
		Vector3.new(116, 0.5, 97),
		Vector3.new(165, 0.5, -68),
		Vector3.new(-175, 0.5, 82),
		Vector3.new(44, 0.5, 137),
	}) do
		createRock(decor, `IslandRock{index}`, position, 0.9)
	end

	for index, position in ipairs({
		Vector3.new(-58, 0.55, -14),
		Vector3.new(58, 0.55, -14),
		Vector3.new(-54, 0.55, 24),
		Vector3.new(54, 0.55, 24),
		Vector3.new(-18, 0.55, 47),
		Vector3.new(18, 0.55, 47),
		Vector3.new(-88, 0.55, 150),
		Vector3.new(88, 0.55, 150),
		Vector3.new(-68, 0.55, 320),
		Vector3.new(68, 0.55, 320),
		Vector3.new(-72, 0.55, 510),
		Vector3.new(72, 0.55, 510),
	}) do
		local theme = PLOT_THEMES[((index - 1) % #PLOT_THEMES) + 1]
		createFlowerPatch(decor, `PolishFlowers{index}`, position, theme.accent)
	end

	for index, position in ipairs({
		Vector3.new(-74, 0, 58),
		Vector3.new(74, 0, 58),
		Vector3.new(-92, 0, -58),
		Vector3.new(92, 0, -58),
		Vector3.new(-55, 0, 214),
		Vector3.new(55, 0, 214),
		Vector3.new(-58, 0, 420),
		Vector3.new(58, 0, 420),
		Vector3.new(-38, 0, 655),
		Vector3.new(38, 0, 655),
	}) do
		createBush(decor, `PolishBush{index}`, position, 0.78, COLORS.GrassLight)
	end

	for index, position in ipairs({
		Vector3.new(-25, 0, 57),
		Vector3.new(25, 0, 57),
		Vector3.new(-42, 0, 262),
		Vector3.new(42, 0, 262),
		Vector3.new(-42, 0, 468),
		Vector3.new(42, 0, 468),
	}) do
		createCrateStack(decor, `PolishCrates{index}`, position)
	end

	for index, data in ipairs({
		{ position = Vector3.new(-23, 0, -48), color = Color3.fromRGB(234, 74, 108), accent = Color3.fromRGB(93, 181, 28) },
		{ position = Vector3.new(23, 0, -48), color = Color3.fromRGB(255, 198, 51), accent = Color3.fromRGB(49, 170, 79) },
		{ position = Vector3.new(-32, 0, 612), color = Color3.fromRGB(124, 232, 255), accent = Color3.fromRGB(41, 214, 189) },
		{ position = Vector3.new(32, 0, 612), color = Color3.fromRGB(93, 54, 169), accent = Color3.fromRGB(69, 228, 158) },
	}) do
		createFruitStatue(decor, `SmallFruitStatue{index}`, data.position, data.color, data.accent)
	end
end

function MapBuilder.build()
	local existingMap = Workspace:FindFirstChild(MapBuilder.MapName)
	if existingMap then
		existingMap:Destroy()
	end

	local map = Instance.new("Folder")
	map.Name = MapBuilder.MapName
	map:SetAttribute("MapVersion", MapBuilder.MapVersion)
	map:SetAttribute("GameplayVersion", "StrawberitaReturnTool_V2")
	map:SetAttribute("LaunchLaneVersion", "ExtendedDecoratedLane_V1")
	map:SetAttribute("VisualPolishVersion", "CleanKidFriendlyUI_V1")
	map:SetAttribute("CenterAreaVersion", "MainLaunchHub_V1")
	map:SetAttribute("IslandLayoutVersion", "CompactSocialIsland_V1")
	map:SetAttribute("PlotPolishVersion", "InvitingPlots_V2")
	map:SetAttribute("StrawberitaAnimationVersion", "FunBouncyMotion_V1")
	map:SetAttribute("StrawberitaPlatformAnimationVersion", "PlatformBounce_V1")
	map:SetAttribute("BlockStyleVersion", BlockStyle.Version)
	map:SetAttribute("DebugMode", MapBuilder.DebugMode)
	map.Parent = Workspace

	buildIslandBase(map)
	buildHub(map)
	buildSharedLaunchArea(map)

	local plotsFolder = getOrCreateFolder(map, "Plots")
	plotsFolder:ClearAllChildren()

	for plotId = 1, MapBuilder.PlotCount do
		makePlot(plotsFolder, plotId)
	end

	buildWorldDecorations(map)

	getOrCreateFolder(map, "ActiveCrates")
	getOrCreateFolder(map, "RevealedRewards")
	getOrCreateFolder(map, "ChaosHazards")

	print("[BrainrotFruits] MAP V2 ACTIVE - island reference layout loaded")
	print("[BrainrotFruits] POLISHED PLOT V2 ACTIVE - base reference layout loaded")
	print("[BrainrotFruits] InvisibleCenterSpawn_V1 active")
	print("[BrainrotFruits] Catapult orientation corrected")
	print("[BrainrotFruits] CenterAreaPolish_V1 active")
	print("[BrainrotFruits] Main catapult rotated and aligned")
	print("[BrainrotFruits] CompactSocialIslandLayout_V1 active")
	print("[BrainrotFruits] PlotPolish_V2 active")
	print("[BrainrotFruits] LaunchLaneExtended_V1 active")
	print("[BrainrotFruits] CleanKidFriendlyUI_V1 active")
	print("[BrainrotFruits] Debug visual markers hidden in normal mode")
	print("[BrainrotFruits] Map decorations polish active")
	print("[BrainrotFruits] MapPolish_KidFriendly_V1 active")
	print("[BrainrotFruits] StrawberitaFunAnimation_V1 active")
	print("[BrainrotFruits] Strawberita idle/walk animation active")
	print("[BrainrotFruits] Strawberita return-run trail active")
	print("[BrainrotFruits] PlatformIdleBounce_V1 active")
	print("[BrainrotFruits] StuddedBlockStyle_V1 active")

	return map
end

function MapBuilder.getMap()
	return Workspace:FindFirstChild(MapBuilder.MapName)
end

return MapBuilder
