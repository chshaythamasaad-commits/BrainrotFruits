local PlotModelBuilder = {}

local CatapultModelBuilder = require(script.Parent.CatapultModelBuilder)

PlotModelBuilder.PlotSize = Vector3.new(70, 1, 55)
PlotModelBuilder.ModelVersion = "BaseReferencePlot_V3"
PlotModelBuilder.PolishVersion = "InvitingPlots_V2"

local COLORS = {
	Grass = Color3.fromRGB(71, 171, 75),
	GrassLight = Color3.fromRGB(116, 207, 86),
	GrassDark = Color3.fromRGB(43, 128, 68),
	Path = Color3.fromRGB(211, 188, 127),
	PathDark = Color3.fromRGB(149, 124, 79),
	Stone = Color3.fromRGB(111, 118, 125),
	StoneLight = Color3.fromRGB(148, 153, 158),
	StoneDark = Color3.fromRGB(62, 70, 79),
	Wood = Color3.fromRGB(126, 82, 42),
	WoodDark = Color3.fromRGB(76, 49, 30),
	White = Color3.fromRGB(255, 255, 245),
	Black = Color3.fromRGB(24, 25, 29),
	HouseWall = Color3.fromRGB(226, 183, 112),
	GlowYellow = Color3.fromRGB(255, 216, 74),
	CashGreen = Color3.fromRGB(65, 232, 93),
}

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

local function createFolder(parent, name)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function localToWorld(plotFrame, x, y, z)
	return plotFrame * CFrame.new(x, y, z)
end

local function addSurfaceText(part, text, face, textColor, backgroundColor, pixelsPerStud)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "SurfaceText"
	surface.Face = face or Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = pixelsPerStud or 42
	surface.LightInfluence = 0.12
	surface.AlwaysOnTop = false
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundColor3 = backgroundColor or COLORS.Black
	label.BackgroundTransparency = backgroundColor and 0.1 or 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = textColor or COLORS.White
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0.22
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface

	return label
end

local function addSmallBillboard(part, name, text, size, offset, maxDistance)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = name
	billboard.Size = size or UDim2.fromOffset(140, 42)
	billboard.StudsOffset = offset or Vector3.new(0, 2.7, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = maxDistance or 58
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.TextColor3 = COLORS.White
	label.TextScaled = true
	label.TextStrokeTransparency = 0.22
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard

	return label
end

local function createTopTextPad(parent, name, text, size, cframe, color, textColor)
	local pad = createPart(parent, name, size, cframe, color, Enum.Material.SmoothPlastic)
	addSurfaceText(pad, text, Enum.NormalId.Top, textColor or COLORS.White, nil, 34)
	return pad
end

local function createVoxelTree(parent, name, plotFrame, localPosition, scale, leafColor)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local baseFrame = plotFrame * CFrame.new(localPosition)
	createPart(model, "Trunk", Vector3.new(1.1, 3.4, 1.1) * scale, baseFrame * CFrame.new(0, 1.7 * scale, 0), COLORS.Wood, Enum.Material.Wood)
	createPart(model, "LeafLow", Vector3.new(4.5, 1.6, 4.5) * scale, baseFrame * CFrame.new(0, 3.7 * scale, 0), leafColor, Enum.Material.Grass)
	createPart(model, "LeafMid", Vector3.new(3.4, 1.5, 3.4) * scale, baseFrame * CFrame.new(0, 4.8 * scale, 0), leafColor:Lerp(COLORS.White, 0.08), Enum.Material.Grass)
	createPart(model, "LeafTop", Vector3.new(2.2, 1.3, 2.2) * scale, baseFrame * CFrame.new(0, 5.75 * scale, 0), leafColor:Lerp(COLORS.White, 0.16), Enum.Material.Grass)

	return model
end

local function createBush(parent, name, plotFrame, localPosition, scale, color)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local baseFrame = plotFrame * CFrame.new(localPosition)
	createPart(model, "BushCore", Vector3.new(2.4, 1, 2.2) * scale, baseFrame * CFrame.new(0, 0.5 * scale, 0), color or COLORS.GrassLight, Enum.Material.Grass)
	createPart(model, "BushLeft", Vector3.new(1.4, 0.8, 1.4) * scale, baseFrame * CFrame.new(-0.9 * scale, 0.4 * scale, 0.15 * scale), COLORS.Grass, Enum.Material.Grass)
	createPart(model, "BushRight", Vector3.new(1.4, 0.8, 1.4) * scale, baseFrame * CFrame.new(0.9 * scale, 0.4 * scale, -0.15 * scale), COLORS.Grass, Enum.Material.Grass)

	return model
end

local function createRock(parent, name, plotFrame, localPosition, scale)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local baseFrame = plotFrame * CFrame.new(localPosition)
	createPart(model, "RockBase", Vector3.new(2.7, 1.1, 2.1) * scale, baseFrame * CFrame.new(0, 0.55 * scale, 0), COLORS.Stone, Enum.Material.Slate)
	createPart(model, "RockTop", Vector3.new(1.7, 0.8, 1.4) * scale, baseFrame * CFrame.new(0.25 * scale, 1.35 * scale, -0.1 * scale), COLORS.StoneDark, Enum.Material.Slate)

	return model
end

local function createFlowerPatch(parent, name, plotFrame, localPosition, color)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	for index, offset in ipairs({
		Vector3.new(-0.85, 0, -0.25),
		Vector3.new(0, 0, 0.35),
		Vector3.new(0.8, 0, -0.1),
	}) do
		local flowerFrame = plotFrame * CFrame.new(localPosition + offset)
		createPart(model, `Stem{index}`, Vector3.new(0.12, 0.58, 0.12), flowerFrame * CFrame.new(0, 0.29, 0), Color3.fromRGB(45, 146, 57), Enum.Material.Grass)
		createPart(model, `Flower{index}`, Vector3.new(0.46, 0.28, 0.46), flowerFrame * CFrame.new(0, 0.72, 0), color, Enum.Material.SmoothPlastic)
	end

	return model
end

local function createLamp(parent, name, plotFrame, localPosition, scale)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local baseFrame = plotFrame * CFrame.new(localPosition)
	createPart(model, "Post", Vector3.new(0.32, 3.5, 0.32) * scale, baseFrame * CFrame.new(0, 1.75 * scale, 0), COLORS.WoodDark, Enum.Material.Wood)
	createPart(model, "Cap", Vector3.new(1, 0.24, 1) * scale, baseFrame * CFrame.new(0, 3.75 * scale, 0), COLORS.StoneDark, Enum.Material.SmoothPlastic)
	local lantern = createPart(model, "Lantern", Vector3.new(0.72, 0.72, 0.72) * scale, baseFrame * CFrame.new(0, 3.25 * scale, 0), COLORS.GlowYellow, Enum.Material.Neon)

	local light = Instance.new("PointLight")
	light.Name = "WarmLight"
	light.Color = Color3.fromRGB(255, 219, 132)
	light.Brightness = 0.58
	light.Range = 11 * scale
	light.Parent = lantern

	return model
end

local function createCrates(parent, name, plotFrame, localPosition)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local baseFrame = plotFrame * CFrame.new(localPosition)
	createPart(model, "CrateA", Vector3.new(2.1, 1.8, 2.1), baseFrame * CFrame.new(0, 0.9, 0), COLORS.Wood, Enum.Material.WoodPlanks)
	createPart(model, "CrateB", Vector3.new(1.7, 1.5, 1.7), baseFrame * CFrame.new(1.55, 0.75, -0.65), COLORS.Wood, Enum.Material.WoodPlanks)
	createPart(model, "Barrel", Vector3.new(1.3, 1.8, 1.3), baseFrame * CFrame.new(-1.55, 0.9, 0.45), Color3.fromRGB(111, 70, 39), Enum.Material.Wood)

	return model
end

local function createFoundation(plot, plotFrame, plotId, theme)
	local foundation = Instance.new("Folder")
	foundation.Name = "Foundation"
	foundation.Parent = plot

	local halfX = PlotModelBuilder.PlotSize.X / 2
	local halfZ = PlotModelBuilder.PlotSize.Z / 2

	createPart(foundation, "StoneUnderlay", Vector3.new(74, 4.2, 59), localToWorld(plotFrame, 0, -1.85, 0), COLORS.StoneDark, Enum.Material.Slate)
	local base = createPart(plot, "PlotBase", PlotModelBuilder.PlotSize, localToWorld(plotFrame, 0, 0.18, 0), COLORS.GrassLight:Lerp(theme.color, 0.12), Enum.Material.Grass)
	base:SetAttribute("PlotId", plotId)

	createPart(foundation, "GrassInterior", Vector3.new(62, 0.16, 47), localToWorld(plotFrame, 0, 0.8, 1.2), COLORS.Grass, Enum.Material.Grass)
	createPart(foundation, "CenterPath", Vector3.new(8, 0.18, 42), localToWorld(plotFrame, 0, 0.95, -2.5), COLORS.Path, Enum.Material.Sand)
	createPart(foundation, "PathGateBridge", Vector3.new(12, 0.18, 12), localToWorld(plotFrame, 0, 0.98, -31.5), COLORS.Path, Enum.Material.Sand)
	for index, z in ipairs({ -20, -12, -4, 4, 12 }) do
		createPart(foundation, `CenterPathStone{index}`, Vector3.new(5.6, 0.08, 2.4), localToWorld(plotFrame, 0, 1.08, z), COLORS.PathDark, Enum.Material.SmoothPlastic, 0.12)
	end

	for _, data in ipairs({
		{ "FrontStoneEdge", Vector3.new(74, 1.4, 2.6), Vector3.new(0, 0.55, -halfZ - 1.3) },
		{ "BackStoneEdge", Vector3.new(74, 1.4, 2.6), Vector3.new(0, 0.55, halfZ + 1.3) },
		{ "LeftStoneEdge", Vector3.new(2.6, 1.4, 55), Vector3.new(-halfX - 1.3, 0.55, 0) },
		{ "RightStoneEdge", Vector3.new(2.6, 1.4, 55), Vector3.new(halfX + 1.3, 0.55, 0) },
	}) do
		createPart(foundation, data[1], data[2], localToWorld(plotFrame, data[3].X, data[3].Y, data[3].Z), COLORS.Stone, Enum.Material.Slate)
	end

	for _, data in ipairs({
		{ -halfX - 2, -halfZ - 2 },
		{ halfX + 2, -halfZ - 2 },
		{ -halfX - 2, halfZ + 2 },
		{ halfX + 2, halfZ + 2 },
	}) do
		createPart(foundation, "CornerCliffBlock", Vector3.new(4.2, 2.4, 4.2), localToWorld(plotFrame, data[1], -0.1, data[2]), COLORS.StoneDark, Enum.Material.Slate)
	end

	return base
end

local function createFence(plot, plotFrame, theme)
	local fence = Instance.new("Folder")
	fence.Name = "Fence"
	fence.Parent = plot

	local halfX = PlotModelBuilder.PlotSize.X / 2
	local halfZ = PlotModelBuilder.PlotSize.Z / 2
	local railColor = theme.color:Lerp(COLORS.Wood, 0.45)

	for _, localPosition in ipairs({
		Vector3.new(-halfX, 0, -halfZ),
		Vector3.new(halfX, 0, -halfZ),
		Vector3.new(-halfX, 0, halfZ),
		Vector3.new(halfX, 0, halfZ),
		Vector3.new(-halfX, 0, -9),
		Vector3.new(halfX, 0, -9),
		Vector3.new(-halfX, 0, 9),
		Vector3.new(halfX, 0, 9),
		Vector3.new(-17, 0, -halfZ),
		Vector3.new(17, 0, -halfZ),
		Vector3.new(-17, 0, halfZ),
		Vector3.new(17, 0, halfZ),
	}) do
		createPart(fence, "FencePost", Vector3.new(0.82, 3.1, 0.82), localToWorld(plotFrame, localPosition.X, 2.15, localPosition.Z), COLORS.WoodDark, Enum.Material.Wood)
		createPart(fence, "PostCap", Vector3.new(1.15, 0.42, 1.15), localToWorld(plotFrame, localPosition.X, 3.9, localPosition.Z), theme.color, Enum.Material.SmoothPlastic)
	end

	createPart(fence, "BackHighRail", Vector3.new(70, 0.42, 0.42), localToWorld(plotFrame, 0, 2.7, halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "BackLowRail", Vector3.new(70, 0.35, 0.35), localToWorld(plotFrame, 0, 1.65, halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "LeftHighRail", Vector3.new(0.42, 0.42, 55), localToWorld(plotFrame, -halfX, 2.7, 0), railColor, Enum.Material.Wood)
	createPart(fence, "RightHighRail", Vector3.new(0.42, 0.42, 55), localToWorld(plotFrame, halfX, 2.7, 0), railColor, Enum.Material.Wood)
	createPart(fence, "FrontLeftRail", Vector3.new(23, 0.42, 0.42), localToWorld(plotFrame, -23.5, 2.7, -halfZ), railColor, Enum.Material.Wood)
	createPart(fence, "FrontRightRail", Vector3.new(23, 0.42, 0.42), localToWorld(plotFrame, 23.5, 2.7, -halfZ), railColor, Enum.Material.Wood)

	local gate = Instance.new("Folder")
	gate.Name = "Gate"
	gate.Parent = plot
	createPart(gate, "GateLeftPillar", Vector3.new(1.35, 4.2, 1.35), localToWorld(plotFrame, -7.2, 2.45, -halfZ - 0.35), COLORS.WoodDark, Enum.Material.Wood)
	createPart(gate, "GateRightPillar", Vector3.new(1.35, 4.2, 1.35), localToWorld(plotFrame, 7.2, 2.45, -halfZ - 0.35), COLORS.WoodDark, Enum.Material.Wood)
	createPart(gate, "GateCapLeft", Vector3.new(1.7, 0.5, 1.7), localToWorld(plotFrame, -7.2, 4.85, -halfZ - 0.35), theme.color, Enum.Material.SmoothPlastic)
	createPart(gate, "GateCapRight", Vector3.new(1.7, 0.5, 1.7), localToWorld(plotFrame, 7.2, 4.85, -halfZ - 0.35), theme.color, Enum.Material.SmoothPlastic)
	createPart(gate, "GateTopBeam", Vector3.new(17, 0.75, 0.75), localToWorld(plotFrame, 0, 5.35, -halfZ - 0.35), COLORS.Wood, Enum.Material.Wood)
	createPart(gate, "GateGlowTrim", Vector3.new(12, 0.18, 0.28), localToWorld(plotFrame, 0, 5.88, -halfZ - 0.72), theme.accent, Enum.Material.Neon, 0.15)
end

local function createOwnerSign(plot, plotFrame, plotId, theme, ownerName)
	local halfZ = PlotModelBuilder.PlotSize.Z / 2
	local sign = createPart(plot, "OwnerSignPost", Vector3.new(12, 3.4, 0.6), localToWorld(plotFrame, 0, 3.2, -halfZ - 1.2), theme.color, Enum.Material.SmoothPlastic)
	sign.CanCollide = false
	sign:SetAttribute("Role", "OwnerSign")
	addSurfaceText(sign, `PLOT {plotId}\n{ownerName or "Unclaimed Plot"}`, Enum.NormalId.Front, COLORS.White, COLORS.Black, 34)
end

local function createSpawnPad(plot, plotFrame, plotId, theme)
	local spawnPad = createPart(plot, "SpawnPad", Vector3.new(8, 1, 8), localToWorld(plotFrame, 0, 1.25, -9), theme.color, Enum.Material.SmoothPlastic, 1)
	spawnPad.CanCollide = false
	spawnPad:SetAttribute("Type", "SpawnPad")
	spawnPad:SetAttribute("PlotId", plotId)
	spawnPad:SetAttribute("Role", "SpawnPad")
	spawnPad:SetAttribute("Invisible", true)

	return spawnPad
end

local function createBaseClaimZone(plot, plotFrame, plotId)
	local claimZone = createPart(plot, "BaseClaimZone", Vector3.new(54, 8, 42), localToWorld(plotFrame, 0, 4.7, -1), Color3.fromRGB(103, 255, 139), Enum.Material.ForceField, 1)
	claimZone.CanCollide = false
	claimZone.CanQuery = false
	claimZone.CanTouch = true
	claimZone:SetAttribute("Type", "BaseClaimZone")
	claimZone:SetAttribute("PlotId", plotId)
	return claimZone
end

local function createCollector(plot, plotFrame, plotId, theme)
	local collector = Instance.new("Model")
	collector.Name = "Collector"
	collector:SetAttribute("Type", "Collector")
	collector:SetAttribute("PlotId", plotId)
	collector.Parent = plot

	local baseFrame = localToWorld(plotFrame, 20, 1.08, -21)
	local base = createPart(collector, "CollectorBase", Vector3.new(12, 0.8, 8.5), baseFrame, COLORS.Wood, Enum.Material.Wood)
	createPart(collector, "CollectorMachine", Vector3.new(6.2, 3.7, 4.5), baseFrame * CFrame.new(0, 2.2, 0.2), theme.color:Lerp(COLORS.Wood, 0.25), Enum.Material.SmoothPlastic)
	local display = createPart(collector, "CashDisplay", Vector3.new(5.4, 1.35, 0.35), baseFrame * CFrame.new(0, 2.5, -2.35), COLORS.Black, Enum.Material.SmoothPlastic)
	addSurfaceText(display, "$ 1,234,567", Enum.NormalId.Front, COLORS.CashGreen, COLORS.Black, 32)
	local coin = createPart(collector, "CoinBlock", Vector3.new(2.8, 2.8, 0.5), baseFrame * CFrame.new(0, 4.65, -0.2), COLORS.GlowYellow, Enum.Material.Neon)
	addSurfaceText(coin, "$", Enum.NormalId.Front, Color3.fromRGB(128, 92, 26), nil, 30)
	local label = createPart(collector, "CollectorLabel", Vector3.new(6.8, 1.2, 0.32), baseFrame * CFrame.new(0, 4.4, -2.62), theme.color, Enum.Material.SmoothPlastic)
	addSurfaceText(label, "COLLECTOR", Enum.NormalId.Front, COLORS.White, COLORS.Black, 30)

	collector.PrimaryPart = base
end

local function createFruitSlots(plot, plotFrame, plotId, theme, debugMode)
	local slotsFolder = Instance.new("Folder")
	slotsFolder.Name = "FruitSlots"
	slotsFolder.Parent = plot

	local visualsFolder = Instance.new("Folder")
	visualsFolder.Name = "FruitSlotVisuals"
	visualsFolder.Parent = plot

	local zPositions = { -15, -9, -3, 3, 9, 15 }
	local slotIndex = 0

	for _, x in ipairs({ -18, 18 }) do
		for _, z in ipairs(zPositions) do
			slotIndex += 1
			local slotFrame = localToWorld(plotFrame, x, 1.25, z)
			local slot = createPart(slotsFolder, `Slot{slotIndex}`, Vector3.new(7, 0.5, 5.3), slotFrame, theme.accent, Enum.Material.SmoothPlastic)
			slot:SetAttribute("PlotId", plotId)
			slot:SetAttribute("SlotIndex", slotIndex)
			slot:SetAttribute("Occupied", false)

			createPart(visualsFolder, `Slot{slotIndex}StoneBase`, Vector3.new(8.2, 0.5, 6.4), slotFrame * CFrame.new(0, -0.28, 0), COLORS.Stone, Enum.Material.Slate)
			createPart(visualsFolder, `Slot{slotIndex}GlowInset`, Vector3.new(5.15, 0.2, 3.55), slotFrame * CFrame.new(0, 0.36, 0), COLORS.GlowYellow:Lerp(theme.color, 0.22), Enum.Material.Neon, 0.05)

			if debugMode then
				addSmallBillboard(slot, "SlotLabel", `Slot {slotIndex}`, UDim2.fromOffset(92, 24), Vector3.new(0, 2, 0), 45)
			end
		end
	end
end

local function createPlotCatapult(plot, plotFrame, plotId)
	return CatapultModelBuilder.createCatapult({
		parent = plot,
		name = "PlotCatapult",
		cframe = localToWorld(plotFrame, 0, 1.08, -1) * CFrame.Angles(0, math.rad(180), 0),
		scale = 0.48,
		plotId = plotId,
		isSharedLauncher = false,
		decorative = true,
	})
end

local function createHut(plot, plotFrame, theme)
	local hut = Instance.new("Model")
	hut.Name = "Hut"
	hut.Parent = plot

	local frame = localToWorld(plotFrame, 0, 1.05, 22)
	createPart(hut, "Porch", Vector3.new(16, 0.7, 5.2), frame * CFrame.new(0, 0.32, -5.4), COLORS.Stone, Enum.Material.Slate)
	createPart(hut, "HouseBase", Vector3.new(15, 5.5, 9.5), frame * CFrame.new(0, 2.8, 0), COLORS.HouseWall, Enum.Material.WoodPlanks)
	createPart(hut, "Door", Vector3.new(2.4, 3.4, 0.35), frame * CFrame.new(0, 1.75, -4.9), COLORS.WoodDark, Enum.Material.Wood)
	createPart(hut, "WindowLeft", Vector3.new(1.75, 1.75, 0.35), frame * CFrame.new(-4.2, 3.1, -4.95), COLORS.GlowYellow, Enum.Material.Neon)
	createPart(hut, "WindowRight", Vector3.new(1.75, 1.75, 0.35), frame * CFrame.new(4.2, 3.1, -4.95), COLORS.GlowYellow, Enum.Material.Neon)
	createPart(hut, "RoofBlock", Vector3.new(16.8, 1.55, 11.2), frame * CFrame.new(0, 6.05, 0), theme.roof, Enum.Material.SmoothPlastic)
	createWedge(hut, "RoofFrontSlope", Vector3.new(16.9, 2.6, 5.7), frame * CFrame.new(0, 6.4, -2.9) * CFrame.Angles(0, math.rad(180), 0), theme.roof, Enum.Material.SmoothPlastic)
	createWedge(hut, "RoofBackSlope", Vector3.new(16.9, 2.6, 5.7), frame * CFrame.new(0, 6.4, 2.9), theme.roof, Enum.Material.SmoothPlastic)
	createPart(hut, "Chimney", Vector3.new(1.9, 3.3, 1.9), frame * CFrame.new(4.8, 7.2, 1.2), COLORS.StoneDark, Enum.Material.Slate)
	createPart(hut, "RoofGlowTrim", Vector3.new(14.8, 0.22, 0.38), frame * CFrame.new(0, 5.4, -5.72), theme.accent, Enum.Material.Neon, 0.18)
	createPart(hut, "WelcomeMat", Vector3.new(5.4, 0.14, 2.2), frame * CFrame.new(0, 0.78, -8.15), theme.accent, Enum.Material.SmoothPlastic)
	createPart(hut, "FlowerBoxLeft", Vector3.new(2.7, 0.42, 0.55), frame * CFrame.new(-4.2, 2.12, -5.2), theme.accent, Enum.Material.SmoothPlastic)
	createPart(hut, "FlowerBoxRight", Vector3.new(2.7, 0.42, 0.55), frame * CFrame.new(4.2, 2.12, -5.2), theme.accent, Enum.Material.SmoothPlastic)

	return hut
end

local function createDecorations(plot, plotFrame, theme)
	createVoxelTree(plot, "BackLeftTree", plotFrame, Vector3.new(-27, 0.78, 22), 0.82, Color3.fromRGB(57, 151, 65))
	createVoxelTree(plot, "BackRightTree", plotFrame, Vector3.new(28, 0.78, 21), 0.78, Color3.fromRGB(78, 174, 69))
	createBush(plot, "FrontLeftBush", plotFrame, Vector3.new(-29, 0.95, -17), 0.7, COLORS.GrassLight)
	createBush(plot, "FrontRightBush", plotFrame, Vector3.new(29, 0.95, -17), 0.7, COLORS.GrassLight)
	createBush(plot, "GateLeftAccentBush", plotFrame, Vector3.new(-12, 0.95, -24), 0.58, theme.accent:Lerp(COLORS.Grass, 0.45))
	createBush(plot, "GateRightAccentBush", plotFrame, Vector3.new(12, 0.95, -24), 0.58, theme.accent:Lerp(COLORS.Grass, 0.45))
	createBush(plot, "BackFlowerBush", plotFrame, Vector3.new(22, 0.95, 22), 0.75, theme.accent:Lerp(COLORS.Grass, 0.52))
	createRock(plot, "LeftRock", plotFrame, Vector3.new(-29, 0.9, 7), 0.78)
	createRock(plot, "RightRock", plotFrame, Vector3.new(29, 0.9, 8), 0.78)
	createFlowerPatch(plot, "FlowersLeft", plotFrame, Vector3.new(-29, 0.95, -4), theme.accent)
	createFlowerPatch(plot, "FlowersRight", plotFrame, Vector3.new(29, 0.95, -4), theme.accent)
	createFlowerPatch(plot, "GateFlowersLeft", plotFrame, Vector3.new(-16, 0.95, -22), theme.accent)
	createFlowerPatch(plot, "GateFlowersRight", plotFrame, Vector3.new(16, 0.95, -22), theme.accent)
	createCrates(plot, "BackCrates", plotFrame, Vector3.new(-22, 0.95, 18))
	createCrates(plot, "CollectorCrates", plotFrame, Vector3.new(23, 0.95, -18))

	for _, localPosition in ipairs({
		Vector3.new(-30, 0.95, -25),
		Vector3.new(30, 0.95, -25),
		Vector3.new(-31, 0.95, 24),
		Vector3.new(31, 0.95, 24),
	}) do
		createLamp(plot, "PlotLamp", plotFrame, localPosition, 0.82)
	end
end

function PlotModelBuilder.createPlot(config)
	local plotId = config.plotId
	local theme = config.theme
	local plotFrame = config.plotFrame or CFrame.new(config.position or Vector3.zero)
	local ownerName = config.ownerName

	local plot = Instance.new("Model")
	plot.Name = `Plot{plotId}`
	plot:SetAttribute("PlotId", plotId)
	plot:SetAttribute("OwnerUserId", config.ownerUserId or 0)
	plot:SetAttribute("OwnerName", ownerName or "")
	plot:SetAttribute("Status", ownerName and "Claimed" or "Unclaimed")
	plot:SetAttribute("Theme", theme.name)
	plot:SetAttribute("PlotModelVersion", PlotModelBuilder.ModelVersion)
	plot:SetAttribute("PlotPolishVersion", PlotModelBuilder.PolishVersion)
	plot.Parent = config.parent

	local base = createFoundation(plot, plotFrame, plotId, theme)
	plot.PrimaryPart = base

	createFence(plot, plotFrame, theme)
	createOwnerSign(plot, plotFrame, plotId, theme, ownerName)
	createSpawnPad(plot, plotFrame, plotId, theme)
	createBaseClaimZone(plot, plotFrame, plotId)
	createCollector(plot, plotFrame, plotId, theme)
	createFruitSlots(plot, plotFrame, plotId, theme, config.debugMode)
	createPlotCatapult(plot, plotFrame, plotId)
	createHut(plot, plotFrame, theme)
	createDecorations(plot, plotFrame, theme)

	createFolder(plot, "ActiveCrates")
	createFolder(plot, "RevealedRewards")
	createFolder(plot, "ChaosHazards")

	return plot
end

return PlotModelBuilder
