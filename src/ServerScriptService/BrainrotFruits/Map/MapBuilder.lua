local Workspace = game:GetService("Workspace")

local MapBuilder = {}

MapBuilder.MapName = "BrainrotMap"
MapBuilder.PlotCount = 6
MapBuilder.PlotRadius = 185
MapBuilder.PlotAngleOffset = math.rad(30)
MapBuilder.PlotSize = Vector3.new(64, 1, 72)
MapBuilder.SharedLaneLength = 132
MapBuilder.SlotCount = 10
MapBuilder.DebugMode = false

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

local function localToWorld(frame, x, y, z)
	return frame * CFrame.new(x, y, z)
end

local function createStand(parent, name, position, color)
	local model = Instance.new("Model")
	model.Name = `{name}Stand`
	model.Parent = parent

	local base = createPart(model, "Base", Vector3.new(14, 1.2, 10), CFrame.new(position), color, Enum.Material.SmoothPlastic)
	createPart(model, "Counter", Vector3.new(12, 3.2, 2.2), CFrame.new(position + Vector3.new(0, 2.2, -3.5)), color, Enum.Material.SmoothPlastic)
	createPart(model, "BackSign", Vector3.new(12, 6, 1), CFrame.new(position + Vector3.new(0, 5.6, -5.1)), color, Enum.Material.SmoothPlastic)
	addBillboard(base, "StandLabel", name, UDim2.fromOffset(150, 40), Vector3.new(0, 4.2, 0), Color3.fromRGB(255, 255, 255))
	model.PrimaryPart = base

	return model
end

local function buildSharedCatapult(parent, launchFrame)
	local catapult = Instance.new("Model")
	catapult.Name = "Catapult"
	catapult:SetAttribute("SharedLaunch", true)
	catapult.Parent = parent

	createPart(catapult, "WoodenBase", Vector3.new(8, 0.7, 6), localToWorld(launchFrame, 0, 1.1, -4), Color3.fromRGB(121, 77, 43), Enum.Material.Wood)
	createPart(catapult, "LeftSupport", Vector3.new(0.6, 4.2, 0.6), localToWorld(launchFrame, -2.45, 3, -3.15) * CFrame.Angles(0, 0, math.rad(-10)), Color3.fromRGB(98, 62, 35), Enum.Material.Wood)
	createPart(catapult, "RightSupport", Vector3.new(0.6, 4.2, 0.6), localToWorld(launchFrame, 2.45, 3, -3.15) * CFrame.Angles(0, 0, math.rad(10)), Color3.fromRGB(98, 62, 35), Enum.Material.Wood)
	createPart(catapult, "HingeBlock", Vector3.new(5.5, 0.62, 0.62), localToWorld(launchFrame, 0, 3.85, -2.9), Color3.fromRGB(82, 52, 31), Enum.Material.Wood)
	createPart(catapult, "LaunchArm", Vector3.new(0.7, 0.44, 8.8), localToWorld(launchFrame, 0, 3.75, 0.5) * CFrame.Angles(math.rad(-17), 0, 0), Color3.fromRGB(139, 89, 51), Enum.Material.Wood)
	createPart(catapult, "BasketCup", Vector3.new(3, 0.65, 2.4), localToWorld(launchFrame, 0, 4.72, 4.65) * CFrame.Angles(math.rad(-17), 0, 0), Color3.fromRGB(153, 97, 55), Enum.Material.Wood)
	createPart(catapult, "BasketLip", Vector3.new(3.3, 0.28, 2.7), localToWorld(launchFrame, 0, 5.08, 4.45) * CFrame.Angles(math.rad(-17), 0, 0), Color3.fromRGB(95, 59, 35), Enum.Material.Wood)

	for _, x in ipairs({ -2.75, 2.75 }) do
		createPart(catapult, "RopeDetail", Vector3.new(0.18, 3.8, 0.18), localToWorld(launchFrame, x, 2.95, -1.8) * CFrame.Angles(math.rad(25), 0, 0), Color3.fromRGB(216, 184, 126), Enum.Material.Fabric)
	end

	local interactZone = createPart(catapult, "InteractZone", Vector3.new(11, 4, 10), localToWorld(launchFrame, 0, 2.8, -8), Color3.fromRGB(86, 186, 255), Enum.Material.ForceField, 0.74)
	interactZone.CanCollide = false
	interactZone:SetAttribute("SharedLaunch", true)
	interactZone:SetAttribute("LaunchOrigin", (launchFrame * CFrame.new(0, 5.2, 6.6)).Position)
	interactZone:SetAttribute("LaunchDirection", Vector3.new(1, 0, 0))
	addBillboard(interactZone, "CatapultLabel", "Launch", UDim2.fromOffset(150, 38), Vector3.new(0, 3.2, 0), Color3.fromRGB(255, 255, 255))

	catapult.PrimaryPart = interactZone
	return catapult
end

local function buildSharedLaunchArea(map)
	local launchArea = getOrCreateFolder(map, "SharedLaunchArea")
	launchArea:ClearAllChildren()

	local launchFrame = CFrame.lookAt(Vector3.new(0, 0, 0), Vector3.new(-1, 0, 0))

	createPart(launchArea, "LaunchPlaza", Vector3.new(60, 0.28, 44), CFrame.new(-10, 0.18, 0), Color3.fromRGB(64, 82, 101), Enum.Material.SmoothPlastic)
	createPart(launchArea, "QueuePad", Vector3.new(22, 0.22, 16), CFrame.new(-34, 0.44, 0), Color3.fromRGB(92, 123, 154), Enum.Material.SmoothPlastic)
	addBillboard(createPart(launchArea, "SharedLaunchSign", Vector3.new(20, 5, 1), CFrame.new(-24, 5.1, -17), Color3.fromRGB(86, 186, 255), Enum.Material.SmoothPlastic), "SharedLaunchLabel", "Shared Launch", UDim2.fromOffset(220, 54), Vector3.new(0, 3.4, 0))

	buildSharedCatapult(launchArea, launchFrame)

	local lane = Instance.new("Folder")
	lane.Name = "LaunchLane"
	lane.Parent = launchArea

	createPart(lane, "LaneFloor", Vector3.new(MapBuilder.SharedLaneLength, 0.25, 22), CFrame.new(82, 0.42, 0), Color3.fromRGB(72, 149, 98), Enum.Material.Grass)
	createPart(lane, "CenterStripe", Vector3.new(MapBuilder.SharedLaneLength - 8, 0.07, 0.55), CFrame.new(84, 0.6, 0), Color3.fromRGB(255, 247, 178), Enum.Material.SmoothPlastic)

	for _, z in ipairs({ -11.6, 11.6 }) do
		createPart(lane, "LaneRail", Vector3.new(MapBuilder.SharedLaneLength, 0.72, 0.5), CFrame.new(82, 0.85, z), Color3.fromRGB(103, 65, 38), Enum.Material.Wood)
	end

	for _, distance in ipairs({ 20, 40, 60, 80, 100 }) do
		local marker = createPart(lane, `DistanceMarker_{distance}`, Vector3.new(0.45, 0.13, 21), CFrame.new(12 + distance, 0.72, 0), Color3.fromRGB(255, 238, 120), Enum.Material.Neon)
		marker:SetAttribute("DistanceStuds", distance)
		addBillboard(marker, "DistanceLabel", `{distance}`, UDim2.fromOffset(70, 26), Vector3.new(0, 2, 0), Color3.fromRGB(255, 255, 235))
	end

	local landing = createPart(lane, "LandingZone", Vector3.new(24, 0.32, 28), CFrame.new(148, 0.8, 0), Color3.fromRGB(255, 105, 133), Enum.Material.Neon, 0.22)
	landing:SetAttribute("Role", "LandingZone")
	addBillboard(landing, "LandingLabel", "Reveal Zone", UDim2.fromOffset(150, 34), Vector3.new(0, 2.8, 0), Color3.fromRGB(255, 255, 255))

	return launchArea
end

local function makeDisplaySlots(plot, plotFrame, plotId)
	local slotsFolder = Instance.new("Folder")
	slotsFolder.Name = "FruitSlots"
	slotsFolder.Parent = plot

	local slotPositions = {
		Vector3.new(-22, 1.05, -16),
		Vector3.new(-13, 1.05, -16),
		Vector3.new(-4, 1.05, -16),
		Vector3.new(5, 1.05, -16),
		Vector3.new(14, 1.05, -16),
		Vector3.new(23, 1.05, -16),
		Vector3.new(-17, 1.05, -2),
		Vector3.new(-6, 1.05, -2),
		Vector3.new(6, 1.05, -2),
		Vector3.new(17, 1.05, -2),
	}

	for slotIndex, localPosition in ipairs(slotPositions) do
		local slot = createPart(
			slotsFolder,
			`Slot{slotIndex}`,
			Vector3.new(6.4, 0.35, 6.4),
			plotFrame * CFrame.new(localPosition),
			Color3.fromRGB(255, 233, 157),
			Enum.Material.SmoothPlastic
		)
		slot:SetAttribute("PlotId", plotId)
		slot:SetAttribute("SlotIndex", slotIndex)
		slot:SetAttribute("Occupied", false)

		if MapBuilder.DebugMode then
			addBillboard(slot, "SlotLabel", `Slot {slotIndex}`, UDim2.fromOffset(100, 26), Vector3.new(0, 2.2, 0), Color3.fromRGB(255, 255, 255))
		end
	end

	return slotsFolder
end

local function makeFence(plot, plotFrame, plotColor)
	local fence = Instance.new("Folder")
	fence.Name = "Borders"
	fence.Parent = plot

	local halfX = MapBuilder.PlotSize.X / 2
	local halfZ = MapBuilder.PlotSize.Z / 2
	createPart(fence, "BackBorder", Vector3.new(MapBuilder.PlotSize.X, 1.1, 0.65), localToWorld(plotFrame, 0, 1.1, -halfZ), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "LeftBorder", Vector3.new(0.65, 1.1, MapBuilder.PlotSize.Z), localToWorld(plotFrame, -halfX, 1.1, 0), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "RightBorder", Vector3.new(0.65, 1.1, MapBuilder.PlotSize.Z), localToWorld(plotFrame, halfX, 1.1, 0), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "FrontBorderLeft", Vector3.new(20, 1.1, 0.65), localToWorld(plotFrame, -22, 1.1, halfZ), plotColor, Enum.Material.SmoothPlastic)
	createPart(fence, "FrontBorderRight", Vector3.new(20, 1.1, 0.65), localToWorld(plotFrame, 22, 1.1, halfZ), plotColor, Enum.Material.SmoothPlastic)
end

local function makePlot(plotsFolder, plotId)
	local angle = MapBuilder.PlotAngleOffset + ((plotId - 1) / MapBuilder.PlotCount) * math.pi * 2
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

	local sign = createPart(plot, "OwnerSignPost", Vector3.new(11, 4.8, 0.65), localToWorld(plotFrame, 0, 3.2, -32), plotColor, Enum.Material.SmoothPlastic)
	sign:SetAttribute("Role", "OwnerSign")
	addBillboard(sign, "OwnerBillboard", `Plot {plotId}\nUnclaimed Plot`, UDim2.fromOffset(230, 70), Vector3.new(0, 3.7, 0), Color3.fromRGB(255, 255, 255))

	local spawnPad = createPart(plot, "SpawnPad", Vector3.new(9, 0.35, 9), localToWorld(plotFrame, 0, 0.86, 22), plotColor, Enum.Material.Neon, 0.18)
	spawnPad:SetAttribute("PlotId", plotId)
	spawnPad:SetAttribute("Role", "SpawnPad")

	makeDisplaySlots(plot, plotFrame, plotId)

	getOrCreateFolder(plot, "ActiveCrates")
	getOrCreateFolder(plot, "RevealedRewards")
	getOrCreateFolder(plot, "ChaosHazards")

	return plot
end

local function buildHub(map)
	local hub = getOrCreateFolder(map, "CentralHub")
	hub:ClearAllChildren()

	createPart(hub, "HubPad", Vector3.new(78, 0.35, 78), CFrame.new(0, 0.25, 0), Color3.fromRGB(62, 78, 94), Enum.Material.SmoothPlastic)
	createPart(hub, "SafeZoneAccent", Vector3.new(64, 0.12, 64), CFrame.new(0, 0.5, 0), Color3.fromRGB(87, 117, 139), Enum.Material.SmoothPlastic, 0.22)

	local sign = createPart(hub, "BrainrotFruitsSign", Vector3.new(24, 7, 1), CFrame.new(-8, 7.4, -30), Color3.fromRGB(255, 104, 146), Enum.Material.SmoothPlastic)
	addBillboard(sign, "HubTitle", "Brainrot Fruits", UDim2.fromOffset(360, 82), Vector3.new(0, 4.5, 0), Color3.fromRGB(255, 255, 255))

	createStand(hub, "Shop", Vector3.new(-26, 0.8, 24), Color3.fromRGB(255, 192, 86))
	createStand(hub, "Upgrades", Vector3.new(0, 0.8, 31), Color3.fromRGB(93, 188, 255))
	createStand(hub, "Sell", Vector3.new(26, 0.8, 24), Color3.fromRGB(98, 213, 124))
	createStand(hub, "Index", Vector3.new(-31, 0.8, -2), Color3.fromRGB(178, 132, 255))

	local pedestal = createPart(hub, "ShowcasePedestal", Vector3.new(18, 3.2, 18), CFrame.new(0, 1.8, -8), Color3.fromRGB(47, 54, 70), Enum.Material.SmoothPlastic)
	pedestal:SetAttribute("Role", "RarestFruitShowcase")
	addBillboard(pedestal, "ShowcaseLabel", "Rarest Fruit Showcase", UDim2.fromOffset(270, 52), Vector3.new(0, 5.1, 0), Color3.fromRGB(255, 255, 255))

	for plotId = 1, MapBuilder.PlotCount do
		local angle = MapBuilder.PlotAngleOffset + ((plotId - 1) / MapBuilder.PlotCount) * math.pi * 2
		local outward = Vector3.new(math.cos(angle), 0, math.sin(angle)).Unit
		local midpoint = outward * 94
		createPart(
			hub,
			`PathToPlot{plotId}`,
			Vector3.new(12, 0.16, 112),
			CFrame.lookAt(midpoint, midpoint - outward) * CFrame.new(0, 0.18, 0),
			Color3.fromRGB(236, 219, 161),
			Enum.Material.Sand
		)
	end
end

function MapBuilder.build()
	local map = getOrCreateFolder(Workspace, MapBuilder.MapName)
	map:ClearAllChildren()

	createPart(map, "MainGround", Vector3.new(660, 0.35, 660), CFrame.new(0, -0.12, 0), Color3.fromRGB(46, 126, 81), Enum.Material.Grass)
	buildHub(map)
	buildSharedLaunchArea(map)

	local plotsFolder = getOrCreateFolder(map, "Plots")
	plotsFolder:ClearAllChildren()

	for plotId = 1, MapBuilder.PlotCount do
		makePlot(plotsFolder, plotId)
	end

	getOrCreateFolder(map, "ActiveCrates")
	getOrCreateFolder(map, "RevealedRewards")
	getOrCreateFolder(map, "ChaosHazards")

	print("[BrainrotFruits] Generated BrainrotMap with central hub, shared launch area, 6 plots, showcase, stands, and fruit slots.")

	return map
end

function MapBuilder.getMap()
	return Workspace:FindFirstChild(MapBuilder.MapName)
end

return MapBuilder
