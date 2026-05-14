local Workspace = game:GetService("Workspace")

local MapBuilder = {}

MapBuilder.MapName = "BrainrotMap"
MapBuilder.PlotCount = 6
MapBuilder.PlotRadius = 150
MapBuilder.PlotAngleOffset = math.rad(30)
MapBuilder.PlotSize = Vector3.new(58, 1, 64)
MapBuilder.SharedLaneLength = 132
MapBuilder.SlotCount = 10
MapBuilder.DebugMode = false

local COLORS = {
	Grass = Color3.fromRGB(78, 176, 91),
	GrassDark = Color3.fromRGB(48, 132, 76),
	GrassLight = Color3.fromRGB(113, 205, 96),
	Path = Color3.fromRGB(229, 206, 145),
	PathEdge = Color3.fromRGB(172, 142, 91),
	Stone = Color3.fromRGB(103, 111, 121),
	StoneDark = Color3.fromRGB(70, 78, 89),
	Water = Color3.fromRGB(21, 151, 230),
	WaterDeep = Color3.fromRGB(13, 100, 186),
	Wood = Color3.fromRGB(126, 82, 43),
	WoodDark = Color3.fromRGB(87, 55, 33),
	White = Color3.fromRGB(255, 255, 245),
}

local PLOT_THEMES = {
	{
		name = "Berry",
		color = Color3.fromRGB(238, 76, 88),
		accent = Color3.fromRGB(255, 150, 120),
		roof = Color3.fromRGB(211, 61, 52),
	},
	{
		name = "Citrus",
		color = Color3.fromRGB(245, 146, 36),
		accent = Color3.fromRGB(255, 205, 88),
		roof = Color3.fromRGB(239, 118, 28),
	},
	{
		name = "Sun",
		color = Color3.fromRGB(244, 197, 48),
		accent = Color3.fromRGB(255, 232, 103),
		roof = Color3.fromRGB(219, 163, 34),
	},
	{
		name = "Melon",
		color = Color3.fromRGB(75, 192, 81),
		accent = Color3.fromRGB(132, 229, 116),
		roof = Color3.fromRGB(57, 156, 73),
	},
	{
		name = "Splash",
		color = Color3.fromRGB(58, 148, 228),
		accent = Color3.fromRGB(119, 203, 255),
		roof = Color3.fromRGB(36, 116, 199),
	},
	{
		name = "Grape",
		color = Color3.fromRGB(143, 81, 216),
		accent = Color3.fromRGB(200, 135, 255),
		roof = Color3.fromRGB(119, 55, 194),
	},
}

local DECORATION_POINTS = {
	Vector3.new(-146, 0, -48),
	Vector3.new(-122, 0, 58),
	Vector3.new(-78, 0, -106),
	Vector3.new(-30, 0, 104),
	Vector3.new(54, 0, -110),
	Vector3.new(108, 0, 54),
	Vector3.new(138, 0, -44),
	Vector3.new(172, 0, 32),
	Vector3.new(-168, 0, 18),
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

local function addBillboard(part, name, text, size, offset, color)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = name
	billboard.Size = size or UDim2.fromOffset(180, 46)
	billboard.StudsOffset = offset or Vector3.new(0, 3.4, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 150
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.2
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard

	return label
end

local function localToWorld(frame, x, y, z)
	return frame * CFrame.new(x, y, z)
end

local function createSign(parent, name, text, cframe, color, size)
	local sign = createPart(parent, name, size or Vector3.new(13, 5, 0.8), cframe, color, Enum.Material.SmoothPlastic)
	createPart(parent, `{name}Trim`, (size or Vector3.new(13, 5, 0.8)) + Vector3.new(1, 0.65, 0.12), cframe * CFrame.new(0, 0, 0.08), COLORS.WoodDark, Enum.Material.Wood)
	addBillboard(sign, `{name}Label`, text, UDim2.fromOffset(190, 54), Vector3.new(0, 2.2, 0), COLORS.White)
	return sign
end

local function createLamp(parent, name, position, scale)
	scale = scale or 1
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "Post", Vector3.new(0.35, 4.1, 0.35) * scale, CFrame.new(position + Vector3.new(0, 2.05 * scale, 0)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "Cap", Vector3.new(1.2, 0.25, 1.2) * scale, CFrame.new(position + Vector3.new(0, 4.25 * scale, 0)), COLORS.StoneDark, Enum.Material.SmoothPlastic)
	local lamp = createPart(model, "Lantern", Vector3.new(0.85, 0.85, 0.85) * scale, CFrame.new(position + Vector3.new(0, 3.75 * scale, 0)), Color3.fromRGB(255, 223, 91), Enum.Material.Neon)
	local light = Instance.new("PointLight")
	light.Name = "WarmLampLight"
	light.Color = Color3.fromRGB(255, 222, 136)
	light.Brightness = 0.75
	light.Range = 16 * scale
	light.Parent = lamp

	model.PrimaryPart = lamp
	return model
end

local function createVoxelTree(parent, name, position, scale, leafColor)
	scale = scale or 1
	leafColor = leafColor or Color3.fromRGB(58, 161, 66)

	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "Trunk", Vector3.new(1.25, 4, 1.25) * scale, CFrame.new(position + Vector3.new(0, 2 * scale, 0)), COLORS.Wood, Enum.Material.Wood)
	createPart(model, "LowerLeaves", Vector3.new(5.2, 2.1, 5.2) * scale, CFrame.new(position + Vector3.new(0, 4.45 * scale, 0)), leafColor, Enum.Material.Grass)
	createPart(model, "MiddleLeaves", Vector3.new(4.1, 2, 4.1) * scale, CFrame.new(position + Vector3.new(0, 5.75 * scale, 0)), leafColor:Lerp(Color3.fromRGB(255, 255, 255), 0.08), Enum.Material.Grass)
	createPart(model, "TopLeaves", Vector3.new(2.8, 1.8, 2.8) * scale, CFrame.new(position + Vector3.new(0, 7 * scale, 0)), leafColor:Lerp(Color3.fromRGB(255, 255, 255), 0.16), Enum.Material.Grass)

	model.PrimaryPart = model:FindFirstChild("Trunk")
	return model
end

local function createBush(parent, name, position, scale, color)
	scale = scale or 1
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "BushCore", Vector3.new(2.4, 1.1, 2.4) * scale, CFrame.new(position + Vector3.new(0, 0.65 * scale, 0)), color or COLORS.GrassLight, Enum.Material.Grass)
	createPart(model, "BushSideA", Vector3.new(1.5, 0.9, 1.7) * scale, CFrame.new(position + Vector3.new(-1.05 * scale, 0.55 * scale, 0.25 * scale)), COLORS.Grass, Enum.Material.Grass)
	createPart(model, "BushSideB", Vector3.new(1.5, 0.9, 1.7) * scale, CFrame.new(position + Vector3.new(1.05 * scale, 0.55 * scale, -0.25 * scale)), COLORS.Grass, Enum.Material.Grass)

	return model
end

local function createRock(parent, name, position, scale)
	scale = scale or 1
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	createPart(model, "RockBase", Vector3.new(2.7, 1.1, 2.2) * scale, CFrame.new(position + Vector3.new(0, 0.55 * scale, 0)), COLORS.Stone, Enum.Material.Slate)
	createPart(model, "RockTop", Vector3.new(1.8, 0.9, 1.6) * scale, CFrame.new(position + Vector3.new(0.28 * scale, 1.35 * scale, -0.12 * scale)), COLORS.StoneDark, Enum.Material.Slate)

	return model
end

local function createFlowerPatch(parent, name, position, color)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	for index, offset in ipairs({
		Vector3.new(-0.9, 0, -0.4),
		Vector3.new(0, 0, 0.4),
		Vector3.new(0.8, 0, -0.1),
	}) do
		createPart(model, `FlowerStem{index}`, Vector3.new(0.12, 0.65, 0.12), CFrame.new(position + offset + Vector3.new(0, 0.35, 0)), Color3.fromRGB(47, 146, 58), Enum.Material.Grass)
		createPart(model, `FlowerTop{index}`, Vector3.new(0.45, 0.28, 0.45), CFrame.new(position + offset + Vector3.new(0, 0.78, 0)), color, Enum.Material.SmoothPlastic)
	end

	return model
end

local function createPath(parent, name, size, cframe)
	local path = createPart(parent, name, size, cframe, COLORS.Path, Enum.Material.Sand)
	createPart(parent, `{name}LeftEdge`, Vector3.new(size.X, 0.18, 0.35), cframe * CFrame.new(0, 0.1, -size.Z / 2 - 0.2), COLORS.PathEdge, Enum.Material.SmoothPlastic)
	createPart(parent, `{name}RightEdge`, Vector3.new(size.X, 0.18, 0.35), cframe * CFrame.new(0, 0.1, size.Z / 2 + 0.2), COLORS.PathEdge, Enum.Material.SmoothPlastic)
	return path
end

local function createStand(parent, name, position, color, accent)
	local model = Instance.new("Model")
	model.Name = `{name}Stand`
	model.Parent = parent

	local base = createPart(model, "Base", Vector3.new(14, 1, 10), CFrame.new(position), color, Enum.Material.SmoothPlastic)
	createPart(model, "Counter", Vector3.new(12, 3, 2.3), CFrame.new(position + Vector3.new(0, 2, -3.3)), color:Lerp(Color3.fromRGB(0, 0, 0), 0.08), Enum.Material.SmoothPlastic)
	createPart(model, "BackWall", Vector3.new(12.4, 5.1, 1), CFrame.new(position + Vector3.new(0, 4.3, -5.1)), color, Enum.Material.SmoothPlastic)
	createPart(model, "AwningBack", Vector3.new(13.5, 0.55, 3.2), CFrame.new(position + Vector3.new(0, 6.95, -3.65)), accent or COLORS.White, Enum.Material.SmoothPlastic)
	for stripe = -2, 2 do
		createPart(model, `AwningStripe{stripe}`, Vector3.new(1.4, 0.62, 3.3), CFrame.new(position + Vector3.new(stripe * 2.6, 7.05, -3.65)), color, Enum.Material.SmoothPlastic)
	end
	createPart(model, "DisplayCrate", Vector3.new(2.4, 1.5, 2.4), CFrame.new(position + Vector3.new(-4.4, 1.75, 1.6)), COLORS.Wood, Enum.Material.WoodPlanks)
	createPart(model, "DisplayFruitBlock", Vector3.new(1.35, 1.35, 1.35), CFrame.new(position + Vector3.new(4.3, 2.05, 1.4)), accent or COLORS.White, Enum.Material.Neon, 0.05)
	addBillboard(base, "StandLabel", name, UDim2.fromOffset(150, 40), Vector3.new(0, 4, 0), COLORS.White)

	model.PrimaryPart = base
	return model
end

local function buildSharedCatapult(parent)
	local catapult = Instance.new("Model")
	catapult.Name = "Catapult"
	catapult:SetAttribute("SharedLaunch", true)
	catapult.Parent = parent

	createPart(catapult, "WoodenBase", Vector3.new(9.5, 0.75, 7), CFrame.new(22, 1.05, 0), COLORS.Wood, Enum.Material.Wood)
	createPart(catapult, "LeftWheel", Vector3.new(1.1, 2.2, 2.2), CFrame.new(18.2, 1.7, -3.75) * CFrame.Angles(0, 0, math.rad(90)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "RightWheel", Vector3.new(1.1, 2.2, 2.2), CFrame.new(18.2, 1.7, 3.75) * CFrame.Angles(0, 0, math.rad(90)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "LeftSupport", Vector3.new(0.6, 4.2, 0.6), CFrame.new(22.1, 3, -2.65) * CFrame.Angles(0, 0, math.rad(-12)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "RightSupport", Vector3.new(0.6, 4.2, 0.6), CFrame.new(22.1, 3, 2.65) * CFrame.Angles(0, 0, math.rad(12)), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "HingeBlock", Vector3.new(0.7, 0.7, 5.8), CFrame.new(23.4, 3.85, 0), COLORS.WoodDark, Enum.Material.Wood)
	createPart(catapult, "LaunchArm", Vector3.new(10.5, 0.5, 0.7), CFrame.new(27.8, 4.25, 0) * CFrame.Angles(0, 0, math.rad(-10)), Color3.fromRGB(147, 94, 52), Enum.Material.Wood)
	createPart(catapult, "BasketCup", Vector3.new(3.3, 0.7, 3.1), CFrame.new(33.4, 5.25, 0), Color3.fromRGB(151, 94, 52), Enum.Material.Wood)
	createPart(catapult, "BasketLip", Vector3.new(3.7, 0.34, 3.5), CFrame.new(33.65, 5.72, 0), COLORS.WoodDark, Enum.Material.Wood)

	for _, z in ipairs({ -2.2, 2.2 }) do
		createPart(catapult, "RopeDetail", Vector3.new(4.3, 0.16, 0.16), CFrame.new(25.7, 3.65, z) * CFrame.Angles(0, 0, math.rad(-18)), Color3.fromRGB(216, 184, 126), Enum.Material.Fabric)
	end

	local interactZone = createPart(catapult, "InteractZone", Vector3.new(13, 4.2, 11), CFrame.new(17, 2.8, 0), Color3.fromRGB(77, 180, 255), Enum.Material.ForceField, 0.74)
	interactZone.CanCollide = false
	interactZone:SetAttribute("SharedLaunch", true)
	interactZone:SetAttribute("LaunchOrigin", Vector3.new(35, 5.25, 0))
	interactZone:SetAttribute("LaunchDirection", Vector3.new(1, 0, 0))
	addBillboard(interactZone, "CatapultLabel", "Shared Launch", UDim2.fromOffset(160, 38), Vector3.new(0, 3.2, 0), COLORS.White)

	catapult.PrimaryPart = interactZone
	return catapult
end

local function buildSharedLaunchArea(map)
	local launchArea = getOrCreateFolder(map, "SharedLaunchArea")
	launchArea:ClearAllChildren()

	createPart(launchArea, "LaunchPlaza", Vector3.new(54, 0.34, 42), CFrame.new(20, 0.22, 0), Color3.fromRGB(74, 82, 92), Enum.Material.Slate)
	createPart(launchArea, "LaunchPlazaInset", Vector3.new(39, 0.14, 28), CFrame.new(22, 0.48, 0), Color3.fromRGB(98, 106, 116), Enum.Material.SmoothPlastic)
	createPath(launchArea, "HubToLaunchPath", Vector3.new(42, 0.16, 14), CFrame.new(-10, 0.56, 0))
	createSign(launchArea, "SharedLaunchSign", "SHARED LAUNCH", CFrame.new(6, 5, -18), Color3.fromRGB(42, 50, 59), Vector3.new(16, 4.2, 0.8))

	buildSharedCatapult(launchArea)

	for _, position in ipairs({
		Vector3.new(3, 0, -18),
		Vector3.new(3, 0, 18),
		Vector3.new(42, 0, -15),
		Vector3.new(42, 0, 15),
	}) do
		createLamp(launchArea, "LaunchLamp", position, 0.9)
	end

	local lane = Instance.new("Folder")
	lane.Name = "LaunchLane"
	lane.Parent = launchArea

	createPart(lane, "LaneFloor", Vector3.new(MapBuilder.SharedLaneLength, 0.28, 23), CFrame.new(101, 0.46, 0), Color3.fromRGB(76, 166, 76), Enum.Material.Grass)
	createPart(lane, "LaneInnerStripe", Vector3.new(MapBuilder.SharedLaneLength - 10, 0.08, 1), CFrame.new(102, 0.66, 0), Color3.fromRGB(242, 255, 210), Enum.Material.SmoothPlastic)
	for _, z in ipairs({ -12.2, 12.2 }) do
		createPart(lane, "LaneStoneCurb", Vector3.new(MapBuilder.SharedLaneLength, 0.65, 0.8), CFrame.new(101, 0.9, z), COLORS.StoneDark, Enum.Material.Slate)
		createPart(lane, "LaneFenceRail", Vector3.new(MapBuilder.SharedLaneLength - 8, 0.45, 0.35), CFrame.new(103, 2.05, z), COLORS.Wood, Enum.Material.Wood)
		for index = 0, 9 do
			createPart(lane, "LaneFencePost", Vector3.new(0.45, 2, 0.45), CFrame.new(45 + index * 13, 1.65, z), COLORS.WoodDark, Enum.Material.Wood)
		end
	end

	for _, distance in ipairs({ 20, 40, 60, 80, 100, 120 }) do
		local x = 35 + distance
		local marker = createPart(lane, `DistanceMarker_{distance}`, Vector3.new(0.5, 0.13, 20.5), CFrame.new(x, 0.78, 0), Color3.fromRGB(255, 239, 113), Enum.Material.Neon)
		marker:SetAttribute("DistanceStuds", distance)
		addBillboard(marker, "DistanceLabel", `{distance}`, UDim2.fromOffset(64, 24), Vector3.new(0, 1.65, 0), Color3.fromRGB(255, 255, 235))
	end

	local revealPlatform = createPart(lane, "LandingZone", Vector3.new(34, 0.38, 32), CFrame.new(177, 0.86, 0), Color3.fromRGB(149, 83, 225), Enum.Material.Neon, 0.18)
	revealPlatform:SetAttribute("Role", "LandingZone")
	createPart(lane, "RevealZoneBase", Vector3.new(38, 1.3, 36), CFrame.new(177, 0.05, 0), Color3.fromRGB(93, 72, 126), Enum.Material.Slate)
	createSign(lane, "RevealZoneSign", "REVEAL ZONE", CFrame.new(177, 4.8, 14.8), Color3.fromRGB(119, 65, 205), Vector3.new(18, 4, 0.8))
	addBillboard(revealPlatform, "LandingLabel", "Reveal Zone", UDim2.fromOffset(140, 32), Vector3.new(0, 2.55, 0), COLORS.White)

	for _, position in ipairs({
		Vector3.new(158, 0, -16),
		Vector3.new(158, 0, 16),
		Vector3.new(194, 0, -16),
		Vector3.new(194, 0, 16),
	}) do
		createLamp(lane, "RevealLamp", position, 0.85)
	end

	return launchArea
end

local function makeDisplaySlots(plot, plotFrame, plotId, theme)
	local slotsFolder = Instance.new("Folder")
	slotsFolder.Name = "FruitSlots"
	slotsFolder.Parent = plot

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
		local slot = createPart(
			slotsFolder,
			`Slot{slotIndex}`,
			Vector3.new(6.1, 0.38, 6.1),
			plotFrame * CFrame.new(localPosition),
			theme.accent,
			Enum.Material.SmoothPlastic
		)
		createPart(
			slotsFolder,
			`Slot{slotIndex}Inset`,
			Vector3.new(4.2, 0.18, 4.2),
			plotFrame * CFrame.new(localPosition + Vector3.new(0, 0.32, 0)),
			theme.color,
			Enum.Material.Neon,
			0.14
		)
		slot:SetAttribute("PlotId", plotId)
		slot:SetAttribute("SlotIndex", slotIndex)
		slot:SetAttribute("Occupied", false)

		if MapBuilder.DebugMode then
			addBillboard(slot, "SlotLabel", `Slot {slotIndex}`, UDim2.fromOffset(96, 24), Vector3.new(0, 2.2, 0), COLORS.White)
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
	local railColor = theme.color:Lerp(COLORS.Wood, 0.4)

	for _, localPosition in ipairs({
		Vector3.new(-halfX, 0, -halfZ),
		Vector3.new(halfX, 0, -halfZ),
		Vector3.new(-halfX, 0, halfZ),
		Vector3.new(halfX, 0, halfZ),
		Vector3.new(-halfX, 0, 0),
		Vector3.new(halfX, 0, 0),
		Vector3.new(-16, 0, -halfZ),
		Vector3.new(16, 0, -halfZ),
		Vector3.new(-halfX, 0, 16),
		Vector3.new(halfX, 0, 16),
	}) do
		createPart(fence, "FencePost", Vector3.new(0.9, 3, 0.9), localToWorld(plotFrame, localPosition.X, 2, localPosition.Z), COLORS.WoodDark, Enum.Material.Wood)
	end

	createPart(fence, "OuterRail", Vector3.new(MapBuilder.PlotSize.X, 0.55, 0.55), localToWorld(plotFrame, 0, 2.35, halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "OuterLowRail", Vector3.new(MapBuilder.PlotSize.X, 0.45, 0.45), localToWorld(plotFrame, 0, 1.25, halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "LeftRail", Vector3.new(0.55, 0.55, MapBuilder.PlotSize.Z), localToWorld(plotFrame, -halfX, 2.35, 0), railColor, Enum.Material.Wood)
	createPart(fence, "RightRail", Vector3.new(0.55, 0.55, MapBuilder.PlotSize.Z), localToWorld(plotFrame, halfX, 2.35, 0), railColor, Enum.Material.Wood)
	createPart(fence, "HubRailLeft", Vector3.new(19, 0.55, 0.55), localToWorld(plotFrame, -19.5, 2.35, -halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "HubRailRight", Vector3.new(19, 0.55, 0.55), localToWorld(plotFrame, 19.5, 2.35, -halfZ), railColor, Enum.Material.Wood)
end

local function makePlotHouse(plot, plotFrame, theme)
	local model = Instance.new("Model")
	model.Name = "DecorHouse"
	model.Parent = plot

	local baseFrame = plotFrame * CFrame.new(-20, 1.2, 16)
	createPart(model, "HouseBase", Vector3.new(10, 5, 8), baseFrame * CFrame.new(0, 2.1, 0), Color3.fromRGB(232, 190, 119), Enum.Material.WoodPlanks)
	createPart(model, "Door", Vector3.new(2.3, 3.4, 0.35), baseFrame * CFrame.new(0, 1.35, -4.2), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "WindowLeft", Vector3.new(1.55, 1.55, 0.35), baseFrame * CFrame.new(-3.1, 2.7, -4.25), Color3.fromRGB(128, 214, 255), Enum.Material.Glass, 0.1)
	createPart(model, "WindowRight", Vector3.new(1.55, 1.55, 0.35), baseFrame * CFrame.new(3.1, 2.7, -4.25), Color3.fromRGB(128, 214, 255), Enum.Material.Glass, 0.1)
	createPart(model, "RoofBlock", Vector3.new(11.4, 1.7, 9.3), baseFrame * CFrame.new(0, 5.25, 0), theme.roof, Enum.Material.SmoothPlastic)
	createWedge(model, "RoofFrontSlope", Vector3.new(11.5, 2.4, 4.8), baseFrame * CFrame.new(0, 5.6, -2.45) * CFrame.Angles(0, math.rad(180), 0), theme.roof, Enum.Material.SmoothPlastic)
	createWedge(model, "RoofBackSlope", Vector3.new(11.5, 2.4, 4.8), baseFrame * CFrame.new(0, 5.6, 2.45), theme.roof, Enum.Material.SmoothPlastic)

	return model
end

local function decoratePlot(plot, plotFrame, theme)
	createBush(plot, "PlotBushA", (plotFrame * CFrame.new(20, 0.6, 18)).Position, 0.75, theme.accent:Lerp(COLORS.Grass, 0.55))
	createBush(plot, "PlotBushB", (plotFrame * CFrame.new(-23, 0.6, -21)).Position, 0.7, COLORS.GrassLight)
	createRock(plot, "PlotRock", (plotFrame * CFrame.new(24, 0.55, -22)).Position, 0.7)
	createFlowerPatch(plot, "PlotFlowers", (plotFrame * CFrame.new(15, 0.55, 18)).Position, theme.accent)
end

local function makePlot(plotsFolder, plotId)
	local angle = MapBuilder.PlotAngleOffset + ((plotId - 1) / MapBuilder.PlotCount) * math.pi * 2
	local center = Vector3.new(math.cos(angle) * MapBuilder.PlotRadius, 0, math.sin(angle) * MapBuilder.PlotRadius)
	local outward = Vector3.new(math.cos(angle), 0, math.sin(angle)).Unit
	local plotFrame = CFrame.lookAt(center, center - outward)
	local theme = PLOT_THEMES[plotId]

	local plot = Instance.new("Model")
	plot.Name = `Plot{plotId}`
	plot:SetAttribute("PlotId", plotId)
	plot:SetAttribute("OwnerUserId", 0)
	plot:SetAttribute("OwnerName", "")
	plot:SetAttribute("Status", "Unclaimed")
	plot:SetAttribute("Theme", theme.name)
	plot.Parent = plotsFolder

	local base = createPart(plot, "PlotBase", MapBuilder.PlotSize, localToWorld(plotFrame, 0, 0.18, 0), COLORS.GrassLight:Lerp(theme.color, 0.18), Enum.Material.Grass)
	base:SetAttribute("PlotId", plotId)
	plot.PrimaryPart = base

	createPart(plot, "PlotDirtInset", Vector3.new(50, 0.16, 46), localToWorld(plotFrame, 0, 0.78, -3), Color3.fromRGB(194, 161, 104), Enum.Material.Ground)
	createPart(plot, "PlotPathToHub", Vector3.new(12, 0.14, 18), localToWorld(plotFrame, 0, 0.96, -27), COLORS.Path, Enum.Material.Sand)
	createPart(plot, "PlotPathLeftEdge", Vector3.new(0.35, 0.16, 18), localToWorld(plotFrame, -6.25, 1.05, -27), COLORS.PathEdge, Enum.Material.SmoothPlastic)
	createPart(plot, "PlotPathRightEdge", Vector3.new(0.35, 0.16, 18), localToWorld(plotFrame, 6.25, 1.05, -27), COLORS.PathEdge, Enum.Material.SmoothPlastic)

	makeFence(plot, plotFrame, theme)

	local sign = createPart(plot, "OwnerSignPost", Vector3.new(11.5, 4.2, 0.65), localToWorld(plotFrame, 0, 3.15, -29), theme.color, Enum.Material.SmoothPlastic)
	sign.CanCollide = false
	sign:SetAttribute("Role", "OwnerSign")
	addBillboard(sign, "OwnerBillboard", `Plot {plotId}\nUnclaimed Plot`, UDim2.fromOffset(200, 58), Vector3.new(0, 2.75, 0), COLORS.White)

	local spawnPad = createPart(plot, "SpawnPad", Vector3.new(12, 0.38, 8), localToWorld(plotFrame, 0, 0.92, 20), theme.color, Enum.Material.Neon, 0.12)
	spawnPad:SetAttribute("PlotId", plotId)
	spawnPad:SetAttribute("Role", "SpawnPad")
	addBillboard(spawnPad, "SpawnLabel", "SPAWN", UDim2.fromOffset(116, 30), Vector3.new(0, 1.55, 0), COLORS.White)

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

	createPart(hub, "HubPad", Vector3.new(94, 0.38, 86), CFrame.new(-8, 0.28, 0), Color3.fromRGB(93, 104, 113), Enum.Material.Slate)
	createPart(hub, "SafeZoneGrass", Vector3.new(68, 0.2, 61), CFrame.new(-12, 0.56, 0), COLORS.Grass, Enum.Material.Grass)
	createPart(hub, "SafeZoneRingNorth", Vector3.new(68, 0.18, 4), CFrame.new(-12, 0.72, -31), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingSouth", Vector3.new(68, 0.18, 4), CFrame.new(-12, 0.72, 31), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingWest", Vector3.new(4, 0.18, 61), CFrame.new(-46, 0.72, 0), COLORS.Path, Enum.Material.Sand)
	createPart(hub, "SafeZoneRingEast", Vector3.new(4, 0.18, 61), CFrame.new(22, 0.72, 0), COLORS.Path, Enum.Material.Sand)

	local title = createSign(hub, "BrainrotFruitsSign", "BRAINROT FRUITS", CFrame.new(-12, 7.2, -38), Color3.fromRGB(237, 78, 113), Vector3.new(23, 5.4, 0.9))
	title:SetAttribute("Role", "HubTitle")

	createStand(hub, "SHOP", Vector3.new(-38, 0.95, 17), Color3.fromRGB(217, 58, 45), Color3.fromRGB(255, 245, 228))
	createStand(hub, "SELL", Vector3.new(-38, 0.95, -17), Color3.fromRGB(218, 151, 43), Color3.fromRGB(255, 242, 152))
	createStand(hub, "UPGRADES", Vector3.new(13, 0.95, -25), Color3.fromRGB(128, 72, 218), Color3.fromRGB(245, 225, 255))
	createStand(hub, "INDEX", Vector3.new(14, 0.95, 25), Color3.fromRGB(42, 129, 215), Color3.fromRGB(215, 241, 255))

	local safeZoneSign = createPart(hub, "SafeZoneTextPad", Vector3.new(21, 0.18, 5), CFrame.new(-12, 0.86, 24), Color3.fromRGB(54, 164, 72), Enum.Material.Neon, 0.05)
	addBillboard(safeZoneSign, "SafeZoneLabel", "SAFE ZONE", UDim2.fromOffset(170, 42), Vector3.new(0, 1.2, 0), COLORS.White)

	local pedestal = createPart(hub, "ShowcasePedestal", Vector3.new(18, 3.1, 18), CFrame.new(0, 1.8, -8), Color3.fromRGB(52, 54, 72), Enum.Material.SmoothPlastic)
	pedestal:SetAttribute("Role", "RarestFruitShowcase")
	createPart(hub, "ShowcaseGlow", Vector3.new(14, 0.25, 14), CFrame.new(0, 3.55, -8), Color3.fromRGB(151, 82, 255), Enum.Material.Neon, 0.25)
	addBillboard(pedestal, "ShowcaseLabel", "Rarest Fruit\nShowcase", UDim2.fromOffset(210, 56), Vector3.new(0, 4.6, 0), COLORS.White)

	for _, position in ipairs({
		Vector3.new(-49, 0, -31),
		Vector3.new(-49, 0, 31),
		Vector3.new(25, 0, -31),
		Vector3.new(25, 0, 31),
		Vector3.new(-7, 0, -37),
		Vector3.new(-7, 0, 37),
	}) do
		createLamp(hub, "HubLamp", position, 0.82)
	end

	for plotId = 1, MapBuilder.PlotCount do
		local angle = MapBuilder.PlotAngleOffset + ((plotId - 1) / MapBuilder.PlotCount) * math.pi * 2
		local outward = Vector3.new(math.cos(angle), 0, math.sin(angle)).Unit
		local midpoint = outward * 84
		createPath(
			hub,
			`PathToPlot{plotId}`,
			Vector3.new(11, 0.16, 106),
			CFrame.lookAt(midpoint, midpoint - outward) * CFrame.new(0, 0.62, 0)
		)
	end
end

local function buildIslandBase(map)
	createPart(map, "Ocean", Vector3.new(620, 0.25, 560), CFrame.new(0, -3.2, 0), COLORS.Water, Enum.Material.SmoothPlastic, 0.05)
	createPart(map, "DeepOcean", Vector3.new(700, 0.22, 640), CFrame.new(0, -3.55, 0), COLORS.WaterDeep, Enum.Material.SmoothPlastic, 0.12)
	createPart(map, "MainGround", Vector3.new(440, 0.62, 390), CFrame.new(0, -0.12, 0), COLORS.Grass, Enum.Material.Grass)
	createPart(map, "IslandStoneUnderlay", Vector3.new(456, 4, 402), CFrame.new(0, -2.25, 0), COLORS.StoneDark, Enum.Material.Slate)

	local edge = getOrCreateFolder(map, "IslandEdges")
	edge:ClearAllChildren()

	createPart(edge, "NorthCliff", Vector3.new(430, 6, 13), CFrame.new(0, -1.65, -197), COLORS.StoneDark, Enum.Material.Slate)
	createPart(edge, "SouthCliff", Vector3.new(430, 6, 13), CFrame.new(0, -1.65, 197), COLORS.StoneDark, Enum.Material.Slate)
	createPart(edge, "WestCliff", Vector3.new(13, 6, 376), CFrame.new(-223, -1.65, 0), COLORS.StoneDark, Enum.Material.Slate)
	createPart(edge, "EastCliff", Vector3.new(13, 6, 376), CFrame.new(223, -1.65, 0), COLORS.StoneDark, Enum.Material.Slate)

	for index, position in ipairs({
		Vector3.new(-204, -0.2, -181),
		Vector3.new(204, -0.2, -181),
		Vector3.new(-204, -0.2, 181),
		Vector3.new(204, -0.2, 181),
		Vector3.new(-236, -2.4, -76),
		Vector3.new(236, -2.4, 72),
		Vector3.new(96, -2.4, 210),
		Vector3.new(-92, -2.4, -210),
	}) do
		createRock(edge, `CliffRock{index}`, position, 1.5)
	end

	for index, position in ipairs({
		Vector3.new(-219, -1.15, -106),
		Vector3.new(219, -1.15, 124),
		Vector3.new(146, -1.15, 199),
	}) do
		createPart(edge, `Waterfall{index}`, Vector3.new(7, 5.2, 1.1), CFrame.new(position), Color3.fromRGB(88, 207, 255), Enum.Material.Neon, 0.35)
		createPart(edge, `WaterfallFoam{index}`, Vector3.new(10, 0.2, 4.5), CFrame.new(position + Vector3.new(0, -2.8, 2.2)), COLORS.White, Enum.Material.SmoothPlastic, 0.18)
	end
end

local function buildWorldDecorations(map)
	local decor = getOrCreateFolder(map, "Decorations")
	decor:ClearAllChildren()

	for index, position in ipairs(DECORATION_POINTS) do
		local treeColor = index % 2 == 0 and Color3.fromRGB(69, 172, 70) or Color3.fromRGB(51, 145, 68)
		createVoxelTree(decor, `IslandTree{index}`, position, index % 3 == 0 and 0.92 or 0.78, treeColor)
	end

	for index, position in ipairs({
		Vector3.new(-92, 0.55, 37),
		Vector3.new(-68, 0.55, -52),
		Vector3.new(66, 0.55, 43),
		Vector3.new(86, 0.55, -52),
		Vector3.new(136, 0.55, 15),
		Vector3.new(-136, 0.55, -18),
	}) do
		createBush(decor, `IslandBush{index}`, position, 0.85, COLORS.GrassLight)
	end

	for index, position in ipairs({
		Vector3.new(-106, 0.55, 6),
		Vector3.new(-58, 0.55, 78),
		Vector3.new(53, 0.55, 83),
		Vector3.new(88, 0.55, -82),
		Vector3.new(140, 0.55, -28),
		Vector3.new(-150, 0.55, 42),
	}) do
		createFlowerPatch(decor, `IslandFlowers{index}`, position, PLOT_THEMES[((index - 1) % #PLOT_THEMES) + 1].accent)
	end

	for index, position in ipairs({
		Vector3.new(-114, 0.5, -84),
		Vector3.new(116, 0.5, 96),
		Vector3.new(166, 0.5, -68),
		Vector3.new(-176, 0.5, 82),
	}) do
		createRock(decor, `IslandRock{index}`, position, 0.95)
	end
end

function MapBuilder.build()
	local map = getOrCreateFolder(Workspace, MapBuilder.MapName)
	map:ClearAllChildren()
	map:SetAttribute("MapPolishVersion", "ReferenceIslandPolish_V1")

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

	print("[BrainrotFruits] Generated polished BrainrotMap island with 6 plots, central safe zone, shared launch lane, reveal zone, shops, showcase, and decorations.")

	return map
end

function MapBuilder.getMap()
	return Workspace:FindFirstChild(MapBuilder.MapName)
end

return MapBuilder
