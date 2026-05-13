local Workspace = game:GetService("Workspace")

local MapBuilder = {}

MapBuilder.MapName = "BrainrotMap"
MapBuilder.PlotCount = 6
MapBuilder.PlotRadius = 118
MapBuilder.PlotSize = Vector3.new(58, 1, 76)
MapBuilder.LaneLength = 126
MapBuilder.SlotCount = 10

local PLOT_COLORS = {
	Color3.fromRGB(255, 105, 133),
	Color3.fromRGB(255, 192, 86),
	Color3.fromRGB(98, 213, 124),
	Color3.fromRGB(93, 188, 255),
	Color3.fromRGB(178, 132, 255),
	Color3.fromRGB(255, 136, 218),
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

local function createCylinder(parent, name, size, cframe, color, material, transparency)
	local part = createPart(parent, name, size, cframe, color, material, transparency)
	part.Shape = Enum.PartType.Cylinder
	return part
end

local function addBillboard(part, name, text, size, offset, color)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = name
	billboard.Size = size or UDim2.fromOffset(220, 54)
	billboard.StudsOffset = offset or Vector3.new(0, 4, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.35
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard

	return label
end

local function localToWorld(plotFrame, x, y, z)
	return plotFrame * CFrame.new(x, y, z)
end

local function makeCatapult(plot, plotFrame, plotId, plotColor, outward)
	local catapult = Instance.new("Model")
	catapult.Name = "Catapult"
	catapult:SetAttribute("PlotId", plotId)
	catapult.Parent = plot

	createPart(catapult, "WoodenBase", Vector3.new(7, 0.65, 5.8), localToWorld(plotFrame, 0, 1.1, 20), Color3.fromRGB(121, 77, 43), Enum.Material.Wood)
	createPart(catapult, "LeftSupport", Vector3.new(0.55, 4, 0.55), localToWorld(plotFrame, -2.2, 2.85, 20.8) * CFrame.Angles(0, 0, math.rad(-10)), Color3.fromRGB(98, 62, 35), Enum.Material.Wood)
	createPart(catapult, "RightSupport", Vector3.new(0.55, 4, 0.55), localToWorld(plotFrame, 2.2, 2.85, 20.8) * CFrame.Angles(0, 0, math.rad(10)), Color3.fromRGB(98, 62, 35), Enum.Material.Wood)
	createCylinder(catapult, "HingeLog", Vector3.new(0.55, 4.8, 0.55), localToWorld(plotFrame, 0, 3.7, 21.05) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(82, 52, 31), Enum.Material.Wood)
	createPart(catapult, "LaunchArm", Vector3.new(0.55, 0.38, 7.8), localToWorld(plotFrame, 0, 3.6, 24.2) * CFrame.Angles(math.rad(-18), 0, 0), Color3.fromRGB(139, 89, 51), Enum.Material.Wood)
	createPart(catapult, "BasketCup", Vector3.new(2.5, 0.55, 2.15), localToWorld(plotFrame, 0, 4.45, 27.7) * CFrame.Angles(math.rad(-18), 0, 0), Color3.fromRGB(153, 97, 55), Enum.Material.Wood)
	createPart(catapult, "BasketLip", Vector3.new(2.85, 0.25, 2.5), localToWorld(plotFrame, 0, 4.78, 27.55) * CFrame.Angles(math.rad(-18), 0, 0), Color3.fromRGB(95, 59, 35), Enum.Material.Wood)

	for _, x in ipairs({ -2.45, 2.45 }) do
		createCylinder(catapult, "RopeDetail", Vector3.new(0.16, 3.9, 0.16), localToWorld(plotFrame, x, 2.75, 22.1) * CFrame.Angles(math.rad(28), 0, 0), Color3.fromRGB(216, 184, 126), Enum.Material.Fabric)
	end

	local interactZone = createPart(catapult, "InteractZone", Vector3.new(8.5, 4, 8.5), localToWorld(plotFrame, 0, 2.75, 19.7), plotColor, Enum.Material.ForceField, 0.72)
	interactZone.CanCollide = false
	interactZone:SetAttribute("PlotId", plotId)
	interactZone:SetAttribute("LaunchOrigin", (plotFrame * CFrame.new(0, 5.2, 29.3)).Position)
	interactZone:SetAttribute("LaunchDirection", outward)
	addBillboard(interactZone, "CatapultLabel", "Launch", UDim2.fromOffset(160, 42), Vector3.new(0, 3.4, 0), Color3.fromRGB(255, 255, 255))

	catapult.PrimaryPart = interactZone
	return catapult
end

local function makeLane(plot, plotFrame, plotColor)
	local lane = Instance.new("Folder")
	lane.Name = "LaunchLane"
	lane.Parent = plot

	createPart(lane, "LaneFloor", Vector3.new(16, 0.25, MapBuilder.LaneLength), localToWorld(plotFrame, 0, 0.42, 88), Color3.fromRGB(72, 149, 98), Enum.Material.Grass)
	createPart(lane, "CenterStripe", Vector3.new(0.45, 0.07, MapBuilder.LaneLength - 8), localToWorld(plotFrame, 0, 0.6, 90), Color3.fromRGB(255, 247, 178), Enum.Material.SmoothPlastic)

	for _, x in ipairs({ -8.3, 8.3 }) do
		createPart(lane, "LaneRail", Vector3.new(0.45, 0.7, MapBuilder.LaneLength), localToWorld(plotFrame, x, 0.85, 88), Color3.fromRGB(103, 65, 38), Enum.Material.Wood)
	end

	for _, distance in ipairs({ 20, 40, 60, 80, 100 }) do
		local marker = createPart(lane, `DistanceMarker_{distance}`, Vector3.new(15.5, 0.13, 0.4), localToWorld(plotFrame, 0, 0.72, 30 + distance), Color3.fromRGB(255, 238, 120), Enum.Material.Neon)
		marker:SetAttribute("DistanceStuds", distance)
		addBillboard(marker, "DistanceLabel", `{distance} studs`, UDim2.fromOffset(140, 32), Vector3.new(0, 2.1, 0), Color3.fromRGB(255, 255, 235))
	end

	local landing = createCylinder(lane, "LandingZone", Vector3.new(20, 0.28, 20), localToWorld(plotFrame, 0, 0.78, 130), plotColor, Enum.Material.Neon, 0.28)
	landing:SetAttribute("Role", "LandingZone")
	addBillboard(landing, "LandingLabel", "Reward Zone", UDim2.fromOffset(170, 38), Vector3.new(0, 2.7, 0), Color3.fromRGB(255, 255, 255))

	local arrow = Instance.new("WedgePart")
	arrow.Name = "LaunchArrow"
	arrow.Size = Vector3.new(5.4, 0.18, 5)
	arrow.CFrame = localToWorld(plotFrame, 0, 0.9, 41) * CFrame.Angles(0, math.rad(180), 0)
	arrow.Color = Color3.fromRGB(255, 245, 116)
	arrow.Material = Enum.Material.Neon
	arrow.Anchored = true
	arrow.Parent = lane

	return lane
end

local function makeDisplaySlots(plot, plotFrame, plotId)
	local slotsFolder = Instance.new("Folder")
	slotsFolder.Name = "FruitSlots"
	slotsFolder.Parent = plot

	local slotPositions = {
		Vector3.new(-21, 1.05, -24),
		Vector3.new(-12, 1.05, -24),
		Vector3.new(12, 1.05, -24),
		Vector3.new(21, 1.05, -24),
		Vector3.new(-21, 1.05, -12),
		Vector3.new(-12, 1.05, -12),
		Vector3.new(12, 1.05, -12),
		Vector3.new(21, 1.05, -12),
		Vector3.new(-21, 1.05, 0),
		Vector3.new(21, 1.05, 0),
	}

	for slotIndex, localPosition in ipairs(slotPositions) do
		local slot = createCylinder(
			slotsFolder,
			`Slot{slotIndex}`,
			Vector3.new(5.6, 0.35, 5.6),
			plotFrame * CFrame.new(localPosition),
			Color3.fromRGB(255, 233, 157),
			Enum.Material.SmoothPlastic
		)
		slot:SetAttribute("PlotId", plotId)
		slot:SetAttribute("SlotIndex", slotIndex)
		slot:SetAttribute("Occupied", false)
		addBillboard(slot, "SlotLabel", `Slot {slotIndex}`, UDim2.fromOffset(110, 28), Vector3.new(0, 2.3, 0), Color3.fromRGB(255, 255, 255))
	end

	return slotsFolder
end

local function makeFence(plot, plotFrame, plotColor)
	local fence = Instance.new("Folder")
	fence.Name = "Borders"
	fence.Parent = plot

	local halfX = MapBuilder.PlotSize.X / 2
	local halfZ = MapBuilder.PlotSize.Z / 2
	createPart(fence, "BackBorder", Vector3.new(MapBuilder.PlotSize.X, 1.2, 0.65), localToWorld(plotFrame, 0, 1.15, -halfZ), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "LeftBorder", Vector3.new(0.65, 1.2, MapBuilder.PlotSize.Z), localToWorld(plotFrame, -halfX, 1.15, 0), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "RightBorder", Vector3.new(0.65, 1.2, MapBuilder.PlotSize.Z), localToWorld(plotFrame, halfX, 1.15, 0), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "FrontGuideLeft", Vector3.new(18, 1.2, 0.65), localToWorld(plotFrame, -20, 1.15, halfZ), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "FrontGuideRight", Vector3.new(18, 1.2, 0.65), localToWorld(plotFrame, 20, 1.15, halfZ), plotColor, Enum.Material.SmoothPlastic)
end

local function makeDecorations(plot, plotFrame)
	for index, localPosition in ipairs({ Vector3.new(-24, 2.1, 26), Vector3.new(24, 2.1, 26) }) do
		local trunk = createPart(plot, `FruitTreeTrunk{index}`, Vector3.new(1.1, 4.2, 1.1), plotFrame * CFrame.new(localPosition.X, 2.1, localPosition.Z), Color3.fromRGB(119, 77, 43), Enum.Material.Wood)
		local top = createPart(plot, `FruitTreeTop{index}`, Vector3.new(5.6, 5.6, 5.6), trunk.CFrame * CFrame.new(0, 4.1, 0), Color3.fromRGB(78, 190, 105), Enum.Material.Grass)
		top.Shape = Enum.PartType.Ball
	end
end

local function makePlot(plotsFolder, plotId)
	local angle = ((plotId - 1) / MapBuilder.PlotCount) * math.pi * 2
	local center = Vector3.new(math.cos(angle) * MapBuilder.PlotRadius, 0, math.sin(angle) * MapBuilder.PlotRadius)
	local outward = Vector3.new(math.cos(angle), 0, math.sin(angle)).Unit
	local plotFrame = CFrame.lookAt(center, center - outward)
	local plotColor = PLOT_COLORS[plotId]

	local plot = Instance.new("Model")
	plot.Name = `Plot{plotId}`
	plot:SetAttribute("PlotId", plotId)
	plot:SetAttribute("OwnerUserId", 0)
	plot:SetAttribute("OwnerName", "")
	plot:SetAttribute("Status", "Unclaimed")
	plot.Parent = plotsFolder

	local base = createPart(plot, "PlotBase", MapBuilder.PlotSize, localToWorld(plotFrame, 0, 0.18, 0), Color3.fromRGB(52, 65, 74), Enum.Material.SmoothPlastic)
	base:SetAttribute("PlotId", plotId)
	plot.PrimaryPart = base

	makeFence(plot, plotFrame, plotColor)

	local sign = createPart(plot, "OwnerSignPost", Vector3.new(8, 4.8, 0.65), localToWorld(plotFrame, 0, 3.2, -34), plotColor, Enum.Material.SmoothPlastic)
	sign:SetAttribute("Role", "OwnerSign")
	addBillboard(sign, "OwnerBillboard", `Plot {plotId}\nUnclaimed Plot`, UDim2.fromOffset(230, 70), Vector3.new(0, 3.7, 0), Color3.fromRGB(255, 255, 255))

	local spawnPad = createCylinder(plot, "SpawnPad", Vector3.new(8, 0.35, 8), localToWorld(plotFrame, 0, 0.86, -22), plotColor, Enum.Material.Neon, 0.18)
	spawnPad:SetAttribute("PlotId", plotId)
	spawnPad:SetAttribute("Role", "SpawnPad")
	addBillboard(spawnPad, "SpawnLabel", "Spawn", UDim2.fromOffset(110, 28), Vector3.new(0, 2.5, 0), Color3.fromRGB(255, 255, 255))

	makeDisplaySlots(plot, plotFrame, plotId)
	makeCatapult(plot, plotFrame, plotId, plotColor, outward)
	makeLane(plot, plotFrame, plotColor)
	makeDecorations(plot, plotFrame)
	getOrCreateFolder(plot, "ActiveCrates")
	getOrCreateFolder(plot, "RevealedRewards")
	getOrCreateFolder(plot, "ChaosHazards")

	return plot
end

local function buildHub(map)
	local hub = getOrCreateFolder(map, "CentralHub")
	hub:ClearAllChildren()

	createCylinder(hub, "HubPad", Vector3.new(58, 0.35, 58), CFrame.new(0, 0.25, 0), Color3.fromRGB(62, 78, 94), Enum.Material.SmoothPlastic)

	local sign = createPart(hub, "BrainrotFruitsSign", Vector3.new(22, 7, 1), CFrame.new(0, 7.4, -16), Color3.fromRGB(255, 104, 146), Enum.Material.SmoothPlastic)
	addBillboard(sign, "HubTitle", "Brainrot Fruits", UDim2.fromOffset(360, 82), Vector3.new(0, 4.5, 0), Color3.fromRGB(255, 255, 255))

	for plotId = 1, MapBuilder.PlotCount do
		local angle = ((plotId - 1) / MapBuilder.PlotCount) * math.pi * 2
		local outward = Vector3.new(math.cos(angle), 0, math.sin(angle)).Unit
		local midpoint = outward * 64
		createPart(
			hub,
			`PathToPlot{plotId}`,
			Vector3.new(12, 0.16, 92),
			CFrame.lookAt(midpoint, midpoint - outward) * CFrame.new(0, 0.18, 0),
			Color3.fromRGB(236, 219, 161),
			Enum.Material.Sand
		)
	end
end

function MapBuilder.build()
	local map = getOrCreateFolder(Workspace, MapBuilder.MapName)
	map:ClearAllChildren()

	createPart(map, "MainGround", Vector3.new(600, 0.35, 600), CFrame.new(0, -0.12, 0), Color3.fromRGB(46, 126, 81), Enum.Material.Grass)
	buildHub(map)

	local plotsFolder = getOrCreateFolder(map, "Plots")
	plotsFolder:ClearAllChildren()

	for plotId = 1, MapBuilder.PlotCount do
		makePlot(plotsFolder, plotId)
	end

	getOrCreateFolder(map, "ActiveCrates")
	getOrCreateFolder(map, "RevealedRewards")
	getOrCreateFolder(map, "ChaosHazards")

	print("[BrainrotFruits] Generated BrainrotMap with 6 player plots, catapults, lanes, reward zones, and fruit slots.")

	return map
end

function MapBuilder.getMap()
	return Workspace:FindFirstChild(MapBuilder.MapName)
end

return MapBuilder
