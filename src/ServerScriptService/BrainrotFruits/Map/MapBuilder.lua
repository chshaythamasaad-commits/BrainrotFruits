local Workspace = game:GetService("Workspace")

local MapBuilder = {}

MapBuilder.MapName = "BrainrotMap"
MapBuilder.MapVersion = "IslandReferenceMap_V2"
MapBuilder.PlotCount = 6
MapBuilder.PlotSize = Vector3.new(54, 1, 58)
MapBuilder.SharedLaneLength = 132
MapBuilder.SlotCount = 10
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
	Vector3.new(-104, 0, -98),
	Vector3.new(-155, 0, -2),
	Vector3.new(-104, 0, 96),
	Vector3.new(104, 0, -98),
	Vector3.new(155, 0, -2),
	Vector3.new(104, 0, 96),
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

local function createPath(parent, name, size, cframe)
	local path = createPart(parent, name, size, cframe, COLORS.Path, Enum.Material.Sand)
	path.CanCollide = false
	createPart(parent, `{name}LeftEdge`, Vector3.new(size.X, 0.18, 0.35), cframe * CFrame.new(0, 0.09, -size.Z / 2 - 0.18), COLORS.PathEdge, Enum.Material.SmoothPlastic)
	createPart(parent, `{name}RightEdge`, Vector3.new(size.X, 0.18, 0.35), cframe * CFrame.new(0, 0.09, size.Z / 2 + 0.18), COLORS.PathEdge, Enum.Material.SmoothPlastic)
	return path
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

local function buildSharedCatapult(parent)
	local catapult = Instance.new("Model")
	catapult.Name = "Catapult"
	catapult:SetAttribute("SharedLaunch", true)
	catapult.Parent = parent

	createPart(catapult, "StoneBase", Vector3.new(16, 0.7, 12), CFrame.new(0, 1.05, 54), COLORS.StoneDark, Enum.Material.Slate)
	createPart(catapult, "WoodenBase", Vector3.new(9, 0.75, 7), CFrame.new(0, 1.75, 54), COLORS.Wood, Enum.Material.Wood)
	createPart(catapult, "LeftWheel", Vector3.new(2.1, 2.1, 1.0), CFrame.new(-5.2, 2.25, 52), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "RightWheel", Vector3.new(2.1, 2.1, 1.0), CFrame.new(5.2, 2.25, 52), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "LeftSupport", Vector3.new(0.6, 4.2, 0.6), CFrame.new(-2.6, 3.95, 54) * CFrame.Angles(0, 0, math.rad(-12)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "RightSupport", Vector3.new(0.6, 4.2, 0.6), CFrame.new(2.6, 3.95, 54) * CFrame.Angles(0, 0, math.rad(12)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "HingeBlock", Vector3.new(5.8, 0.7, 0.7), CFrame.new(0, 5.55, 55.1), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "LaunchArm", Vector3.new(0.7, 0.5, 10.5), CFrame.new(0, 5.95, 60.2) * CFrame.Angles(math.rad(-10), 0, 0), Color3.fromRGB(147, 94, 52), Enum.Material.Wood)
	createPart(catapult, "BasketCup", Vector3.new(3.2, 0.7, 3.1), CFrame.new(0, 6.8, 66.1), Color3.fromRGB(151, 94, 52), Enum.Material.Wood)
	createPart(catapult, "BasketLip", Vector3.new(3.6, 0.32, 3.5), CFrame.new(0, 7.25, 66.3), COLORS.WoodDark, Enum.Material.Wood)

	local interactZone = createPart(catapult, "InteractZone", Vector3.new(13, 4, 12), CFrame.new(0, 3.3, 45), Color3.fromRGB(82, 185, 255), Enum.Material.ForceField, 0.78)
	interactZone.CanCollide = false
	interactZone:SetAttribute("SharedLaunch", true)
	interactZone:SetAttribute("LaunchOrigin", Vector3.new(0, 6.4, 69))
	interactZone:SetAttribute("LaunchDirection", Vector3.new(0, 0, 1))

	catapult.PrimaryPart = interactZone
	return catapult
end

local function buildSharedLaunchArea(map)
	local launchArea = getOrCreateFolder(map, "SharedLaunchArea")
	launchArea:ClearAllChildren()

	createPart(launchArea, "LaunchPlaza", Vector3.new(58, 0.4, 42), CFrame.new(0, 0.46, 48), COLORS.Stone, Enum.Material.Slate)
	createPart(launchArea, "LaunchPlazaInset", Vector3.new(42, 0.18, 27), CFrame.new(0, 0.78, 48), Color3.fromRGB(84, 94, 104), Enum.Material.SmoothPlastic)
	createPath(launchArea, "HubToLaunchPath", Vector3.new(14, 0.18, 44), CFrame.new(0, 0.9, 28) * CFrame.Angles(0, math.rad(90), 0))
	createFacingSign(launchArea, "SharedLaunchSign", "SHARED LAUNCH", CFrame.new(0, 7.1, 32) * CFrame.Angles(0, math.rad(180), 0), COLORS.Black, Vector3.new(18, 4.2, 0.7))

	buildSharedCatapult(launchArea)

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
	lane.Parent = launchArea

	createPart(lane, "LaneFloor", Vector3.new(24, 0.32, MapBuilder.SharedLaneLength), CFrame.new(0, 0.62, 136), Color3.fromRGB(76, 166, 76), Enum.Material.Grass)
	createPart(lane, "LaneCenterStripe", Vector3.new(1, 0.08, MapBuilder.SharedLaneLength - 10), CFrame.new(0, 0.84, 138), Color3.fromRGB(241, 255, 211), Enum.Material.SmoothPlastic)
	for _, x in ipairs({ -12.6, 12.6 }) do
		createPart(lane, "LaneStoneCurb", Vector3.new(0.8, 0.65, MapBuilder.SharedLaneLength), CFrame.new(x, 1.05, 136), COLORS.StoneDark, Enum.Material.Slate)
		createPart(lane, "LaneFenceRail", Vector3.new(0.35, 0.45, MapBuilder.SharedLaneLength - 8), CFrame.new(x, 2.15, 138), COLORS.Wood, Enum.Material.Wood)
		for index = 0, 9 do
			createPart(lane, "LaneFencePost", Vector3.new(0.45, 2, 0.45), CFrame.new(x, 1.75, 78 + index * 13), COLORS.WoodDark, Enum.Material.Wood)
		end
	end

	for _, distance in ipairs({ 20, 40, 60, 80, 100 }) do
		local z = 70 + distance
		createPart(lane, `DistanceLine_{distance}`, Vector3.new(22, 0.12, 0.42), CFrame.new(0, 0.98, z), COLORS.White, Enum.Material.SmoothPlastic)
		createTopTextPad(lane, `DistanceMarker_{distance}`, tostring(distance), Vector3.new(7, 0.15, 3.2), CFrame.new(0, 1.08, z + 2.4), Color3.fromRGB(58, 139, 68), COLORS.White):SetAttribute("DistanceStuds", distance)
	end

	createPart(lane, "RevealZoneBase", Vector3.new(54, 2.6, 42), CFrame.new(0, -0.35, 224), COLORS.StoneDark, Enum.Material.Slate)
	local revealPlatform = createTopTextPad(lane, "LandingZone", "REVEAL ZONE", Vector3.new(45, 0.45, 34), CFrame.new(0, 1.16, 224), Color3.fromRGB(137, 78, 222), COLORS.White)
	revealPlatform.Material = Enum.Material.Neon
	revealPlatform.Transparency = 0.12
	revealPlatform:SetAttribute("Role", "LandingZone")
	createFacingSign(lane, "RevealZoneSign", "REVEAL ZONE", CFrame.new(0, 5.4, 205) * CFrame.Angles(0, math.rad(180), 0), Color3.fromRGB(111, 61, 197), Vector3.new(19, 4, 0.75))

	for _, position in ipairs({
		Vector3.new(-24, 0, 207),
		Vector3.new(24, 0, 207),
		Vector3.new(-24, 0, 238),
		Vector3.new(24, 0, 238),
	}) do
		createLamp(lane, "RevealLamp", position, 0.88)
	end

	return launchArea
end

local function makeDisplaySlots(plot, plotFrame, plotId, theme)
	local slotsFolder = Instance.new("Folder")
	slotsFolder.Name = "FruitSlots"
	slotsFolder.Parent = plot

	local visualFolder = Instance.new("Folder")
	visualFolder.Name = "FruitSlotVisuals"
	visualFolder.Parent = plot

	local slotPositions = {
		Vector3.new(-18, 1.05, -15),
		Vector3.new(-9, 1.05, -15),
		Vector3.new(0, 1.05, -15),
		Vector3.new(9, 1.05, -15),
		Vector3.new(18, 1.05, -15),
		Vector3.new(-18, 1.05, -5),
		Vector3.new(-9, 1.05, -5),
		Vector3.new(0, 1.05, -5),
		Vector3.new(9, 1.05, -5),
		Vector3.new(18, 1.05, -5),
	}

	for slotIndex, localPosition in ipairs(slotPositions) do
		local slotFrame = plotFrame * CFrame.new(localPosition)
		local slot = createPart(slotsFolder, `Slot{slotIndex}`, Vector3.new(6, 0.38, 6), slotFrame, theme.accent, Enum.Material.SmoothPlastic)
		slot:SetAttribute("PlotId", plotId)
		slot:SetAttribute("SlotIndex", slotIndex)
		slot:SetAttribute("Occupied", false)

		createPart(visualFolder, `Slot{slotIndex}Inset`, Vector3.new(4.1, 0.18, 4.1), slotFrame * CFrame.new(0, 0.31, 0), theme.color, Enum.Material.Neon, 0.14)

		if MapBuilder.DebugMode then
			addSmallBillboard(slot, "SlotLabel", `Slot {slotIndex}`, UDim2.fromOffset(92, 24), Vector3.new(0, 2, 0), 45)
		end
	end

	return slotsFolder
end

local function makeFence(plot, plotFrame, theme)
	local fence = Instance.new("Folder")
	fence.Name = "Borders"
	fence.Parent = plot

	local halfX = MapBuilder.PlotSize.X / 2
	local halfZ = MapBuilder.PlotSize.Z / 2
	local railColor = theme.color:Lerp(COLORS.Wood, 0.42)

	for _, localPosition in ipairs({
		Vector3.new(-halfX, 0, -halfZ),
		Vector3.new(halfX, 0, -halfZ),
		Vector3.new(-halfX, 0, halfZ),
		Vector3.new(halfX, 0, halfZ),
		Vector3.new(-halfX, 0, 0),
		Vector3.new(halfX, 0, 0),
		Vector3.new(-15, 0, -halfZ),
		Vector3.new(15, 0, -halfZ),
	}) do
		createPart(fence, "FencePost", Vector3.new(0.8, 2.8, 0.8), localToWorld(plotFrame, localPosition.X, 1.85, localPosition.Z), COLORS.WoodDark, Enum.Material.Wood)
	end

	createPart(fence, "OuterRail", Vector3.new(MapBuilder.PlotSize.X, 0.48, 0.48), localToWorld(plotFrame, 0, 2.2, halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "LeftRail", Vector3.new(0.48, 0.48, MapBuilder.PlotSize.Z), localToWorld(plotFrame, -halfX, 2.2, 0), railColor, Enum.Material.Wood)
	createPart(fence, "RightRail", Vector3.new(0.48, 0.48, MapBuilder.PlotSize.Z), localToWorld(plotFrame, halfX, 2.2, 0), railColor, Enum.Material.Wood)
	createPart(fence, "HubRailLeft", Vector3.new(18, 0.48, 0.48), localToWorld(plotFrame, -18, 2.2, -halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "HubRailRight", Vector3.new(18, 0.48, 0.48), localToWorld(plotFrame, 18, 2.2, -halfZ), railColor, Enum.Material.Wood)
end

local function makePlotHouse(plot, plotFrame, theme)
	local model = Instance.new("Model")
	model.Name = "DecorHouse"
	model.Parent = plot

	local frame = plotFrame * CFrame.new(-19, 1.1, 16)
	createPart(model, "HouseBase", Vector3.new(9, 4.5, 7.5), frame * CFrame.new(0, 2.1, 0), Color3.fromRGB(232, 190, 119), Enum.Material.WoodPlanks)
	createPart(model, "Door", Vector3.new(2.1, 3.1, 0.32), frame * CFrame.new(0, 1.35, -3.9), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "WindowLeft", Vector3.new(1.35, 1.35, 0.28), frame * CFrame.new(-2.7, 2.6, -3.95), Color3.fromRGB(130, 215, 255), Enum.Material.Glass, 0.1)
	createPart(model, "WindowRight", Vector3.new(1.35, 1.35, 0.28), frame * CFrame.new(2.7, 2.6, -3.95), Color3.fromRGB(130, 215, 255), Enum.Material.Glass, 0.1)
	createPart(model, "RoofBlock", Vector3.new(10.5, 1.4, 8.5), frame * CFrame.new(0, 5.1, 0), theme.roof, Enum.Material.SmoothPlastic)
	createWedge(model, "RoofFrontSlope", Vector3.new(10.6, 2.2, 4.4), frame * CFrame.new(0, 5.45, -2.3) * CFrame.Angles(0, math.rad(180), 0), theme.roof, Enum.Material.SmoothPlastic)
	createWedge(model, "RoofBackSlope", Vector3.new(10.6, 2.2, 4.4), frame * CFrame.new(0, 5.45, 2.3), theme.roof, Enum.Material.SmoothPlastic)

	return model
end

local function decoratePlot(plot, plotFrame, theme)
	createBush(plot, "PlotBushA", (plotFrame * CFrame.new(20, 0.55, 18)).Position, 0.75, theme.accent:Lerp(COLORS.Grass, 0.55))
	createBush(plot, "PlotBushB", (plotFrame * CFrame.new(-23, 0.55, -21)).Position, 0.68, COLORS.GrassLight)
	createRock(plot, "PlotRock", (plotFrame * CFrame.new(23, 0.55, -20)).Position, 0.7)
	createFlowerPatch(plot, "PlotFlowers", (plotFrame * CFrame.new(15, 0.55, 18)).Position, theme.accent)
	createCrateStack(plot, "PlotCrates", (plotFrame * CFrame.new(22, 0, 10)).Position)
end

local function makePlot(plotsFolder, plotId)
	local center = PLOT_LAYOUTS[plotId]
	local plotFrame = CFrame.lookAt(center, Vector3.new(0, 0, 0))
	local theme = PLOT_THEMES[plotId]

	local plot = Instance.new("Model")
	plot.Name = `Plot{plotId}`
	plot:SetAttribute("PlotId", plotId)
	plot:SetAttribute("OwnerUserId", 0)
	plot:SetAttribute("OwnerName", "")
	plot:SetAttribute("Status", "Unclaimed")
	plot:SetAttribute("Theme", theme.name)
	plot.Parent = plotsFolder

	local base = createPart(plot, "PlotBase", MapBuilder.PlotSize, localToWorld(plotFrame, 0, 0.2, 0), COLORS.GrassLight:Lerp(theme.color, 0.18), Enum.Material.Grass)
	base:SetAttribute("PlotId", plotId)
	plot.PrimaryPart = base

	createPart(plot, "PlotDirtInset", Vector3.new(46, 0.16, 42), localToWorld(plotFrame, 0, 0.82, -4), Color3.fromRGB(194, 161, 104), Enum.Material.Ground)
	createPart(plot, "PlotPathToHub", Vector3.new(12, 0.14, 18), localToWorld(plotFrame, 0, 1, -25), COLORS.Path, Enum.Material.Sand)

	makeFence(plot, plotFrame, theme)

	local sign = createPart(plot, "OwnerSignPost", Vector3.new(10.8, 3.7, 0.6), localToWorld(plotFrame, 0, 3.35, -28.2), theme.color, Enum.Material.SmoothPlastic)
	sign.CanCollide = false
	sign:SetAttribute("Role", "OwnerSign")
	addSurfaceText(sign, `PLOT {plotId}`, Enum.NormalId.Front, COLORS.White, COLORS.Black)
	addSmallBillboard(sign, "OwnerBillboard", `Plot {plotId}\nUnclaimed Plot`, UDim2.fromOffset(150, 44), Vector3.new(0, 2.55, 0), 62)

	local spawnPad = createTopTextPad(plot, "SpawnPad", "SPAWN", Vector3.new(11, 0.38, 7.4), localToWorld(plotFrame, 0, 0.95, 20), theme.color, COLORS.White)
	spawnPad.Material = Enum.Material.Neon
	spawnPad.Transparency = 0.14
	spawnPad:SetAttribute("PlotId", plotId)
	spawnPad:SetAttribute("Role", "SpawnPad")

	makeDisplaySlots(plot, plotFrame, plotId, theme)
	makePlotHouse(plot, plotFrame, theme)
	decoratePlot(plot, plotFrame, theme)

	getOrCreateFolder(plot, "ActiveCrates")
	getOrCreateFolder(plot, "RevealedRewards")
	getOrCreateFolder(plot, "ChaosHazards")

	return plot
end

local function buildHub(map)
	local hub = getOrCreateFolder(map, "CentralHub")
	hub:ClearAllChildren()

	createPart(hub, "HubStonePlaza", Vector3.new(92, 0.45, 84), CFrame.new(0, 0.42, 0), COLORS.Stone, Enum.Material.Slate)
	createPart(hub, "SafeZoneGrass", Vector3.new(63, 0.2, 56), CFrame.new(0, 0.78, -4), COLORS.Grass, Enum.Material.Grass)
	createPart(hub, "SafeZoneRingNorth", Vector3.new(63, 0.18, 4), CFrame.new(0, 0.94, -32), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingSouth", Vector3.new(63, 0.18, 4), CFrame.new(0, 0.94, 24), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingWest", Vector3.new(4, 0.18, 56), CFrame.new(-31.5, 0.94, -4), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingEast", Vector3.new(4, 0.18, 56), CFrame.new(31.5, 0.94, -4), COLORS.Path, Enum.Material.Sand)

	createTopTextPad(hub, "SafeZoneTextPad", "SAFE ZONE", Vector3.new(22, 0.16, 5), CFrame.new(0, 1.06, 20), Color3.fromRGB(57, 160, 71), COLORS.White)
	createFacingSign(hub, "MapV2ActiveSign", "MAP V2 ACTIVE", CFrame.new(-34, 5, 34) * CFrame.Angles(0, math.rad(145), 0), Color3.fromRGB(44, 151, 94), Vector3.new(12, 3.4, 0.65))
	createFacingSign(hub, "HubTitleSign", "BRAINROT FRUITS", CFrame.new(0, 7.2, -39), Color3.fromRGB(234, 74, 108), Vector3.new(23, 5.2, 0.8))

	createBooth(hub, "SHOP", Vector3.new(-37, 0.95, -13), 30, Color3.fromRGB(211, 57, 46), Color3.fromRGB(255, 245, 232))
	createBooth(hub, "SELL", Vector3.new(-33, 0.95, 21), 145, Color3.fromRGB(214, 151, 42), Color3.fromRGB(255, 241, 147))
	createBooth(hub, "UPGRADES", Vector3.new(35, 0.95, -13), -30, Color3.fromRGB(130, 72, 219), Color3.fromRGB(245, 226, 255))
	createBooth(hub, "INDEX", Vector3.new(33, 0.95, 21), -145, Color3.fromRGB(42, 128, 214), Color3.fromRGB(215, 241, 255))

	local pedestal = createPart(hub, "ShowcasePedestal", Vector3.new(18, 3.2, 18), CFrame.new(0, 2, -8), Color3.fromRGB(50, 53, 70), Enum.Material.SmoothPlastic)
	pedestal:SetAttribute("Role", "RarestFruitShowcase")
	createPart(hub, "ShowcaseGlow", Vector3.new(14, 0.24, 14), CFrame.new(0, 3.72, -8), Color3.fromRGB(153, 86, 255), Enum.Material.Neon, 0.25)
	createFacingSign(hub, "ShowcaseSign", "RAREST FRUIT\nSHOWCASE", CFrame.new(0, 7.2, -24), Color3.fromRGB(38, 39, 44), Vector3.new(18, 4.6, 0.7), Color3.fromRGB(255, 235, 79))

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
		local target = Vector3.new(center.X * 0.46, 0, center.Z * 0.46)
		local direction = Vector3.new(center.X, 0, center.Z).Unit
		createPath(hub, `PathToPlot{plotId}`, Vector3.new(11, 0.16, 93), CFrame.lookAt(target, target + direction) * CFrame.new(0, 0.88, 0))
	end
end

local function createIslandPiece(parent, name, size, position, color)
	createPart(parent, `{name}Stone`, Vector3.new(size.X + 8, 4.2, size.Z + 8), CFrame.new(position + Vector3.new(0, -2.3, 0)), COLORS.StoneDark, Enum.Material.Slate)
	createPart(parent, name, size, CFrame.new(position), color or COLORS.Grass, Enum.Material.Grass)
end

local function buildIslandBase(map)
	createPart(map, "Ocean", Vector3.new(570, 0.3, 620), CFrame.new(0, -3.35, 20), COLORS.Water, Enum.Material.SmoothPlastic, 0.04)
	createPart(map, "DeepOcean", Vector3.new(650, 0.25, 700), CFrame.new(0, -3.7, 20), COLORS.WaterDeep, Enum.Material.SmoothPlastic, 0.12)

	local island = getOrCreateFolder(map, "IslandBase")
	island:ClearAllChildren()

	createIslandPiece(island, "CoreGrass", Vector3.new(240, 0.7, 185), Vector3.new(0, -0.08, -8), COLORS.Grass)
	createIslandPiece(island, "LeftPlotLobe", Vector3.new(115, 0.7, 230), Vector3.new(-132, -0.08, -2), COLORS.GrassLight)
	createIslandPiece(island, "RightPlotLobe", Vector3.new(115, 0.7, 230), Vector3.new(132, -0.08, -2), COLORS.GrassLight)
	createIslandPiece(island, "BackLobe", Vector3.new(220, 0.7, 92), Vector3.new(0, -0.08, -130), COLORS.Grass)
	createIslandPiece(island, "LaunchPeninsula", Vector3.new(86, 0.7, 185), Vector3.new(0, -0.08, 156), COLORS.Grass)
	createIslandPiece(island, "RevealPlatformIsland", Vector3.new(110, 0.7, 70), Vector3.new(0, -0.08, 230), COLORS.GrassDark)

	local edges = getOrCreateFolder(map, "IslandEdges")
	edges:ClearAllChildren()

	for index, data in ipairs({
		{ pos = Vector3.new(-206, -1.7, -95), size = Vector3.new(16, 5.5, 88) },
		{ pos = Vector3.new(206, -1.7, -95), size = Vector3.new(16, 5.5, 88) },
		{ pos = Vector3.new(-206, -1.7, 82), size = Vector3.new(16, 5.5, 96) },
		{ pos = Vector3.new(206, -1.7, 82), size = Vector3.new(16, 5.5, 96) },
		{ pos = Vector3.new(-70, -1.7, -184), size = Vector3.new(120, 5.5, 16) },
		{ pos = Vector3.new(70, -1.7, -184), size = Vector3.new(120, 5.5, 16) },
		{ pos = Vector3.new(-58, -1.7, 272), size = Vector3.new(72, 5.5, 16) },
		{ pos = Vector3.new(58, -1.7, 272), size = Vector3.new(72, 5.5, 16) },
	}) do
		createPart(edges, `CliffBlock{index}`, data.size, CFrame.new(data.pos), COLORS.StoneDark, Enum.Material.Slate)
	end

	for index, position in ipairs({
		Vector3.new(-224, -2.2, -132),
		Vector3.new(224, -2.2, -128),
		Vector3.new(-232, -2.2, 44),
		Vector3.new(232, -2.2, 56),
		Vector3.new(-76, -2.2, 287),
		Vector3.new(80, -2.2, 287),
	}) do
		createRock(edges, `EdgeRock{index}`, position, 1.45)
	end

	for index, position in ipairs({
		Vector3.new(-213, -1.1, 121),
		Vector3.new(213, -1.1, -118),
		Vector3.new(89, -1.1, 276),
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
end

function MapBuilder.build()
	local existingMap = Workspace:FindFirstChild(MapBuilder.MapName)
	if existingMap then
		existingMap:Destroy()
	end

	local map = Instance.new("Folder")
	map.Name = MapBuilder.MapName
	map:SetAttribute("MapVersion", MapBuilder.MapVersion)
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

	return map
end

function MapBuilder.getMap()
	return Workspace:FindFirstChild(MapBuilder.MapName)
end

return MapBuilder
