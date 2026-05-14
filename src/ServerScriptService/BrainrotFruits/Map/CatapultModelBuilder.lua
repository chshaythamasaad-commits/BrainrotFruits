local CatapultModelBuilder = {}

CatapultModelBuilder.Version = "BlockyCatapult_V1"
CatapultModelBuilder.StatueVersion = "BlockyCatapult_Statue_V1"

local printedVersion = false
local printedStatueVersion = false

local COLORS = {
	Wood = Color3.fromRGB(143, 89, 43),
	WoodLight = Color3.fromRGB(184, 117, 55),
	WoodDark = Color3.fromRGB(88, 55, 31),
	Metal = Color3.fromRGB(122, 126, 126),
	MetalDark = Color3.fromRGB(77, 82, 84),
	Stone = Color3.fromRGB(92, 96, 95),
	Bolt = Color3.fromRGB(163, 166, 164),
	Rope = Color3.fromRGB(197, 160, 99),
	Interact = Color3.fromRGB(82, 185, 255),
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

local function createCylinder(parent, name, size, cframe, color, material, transparency)
	local cylinder = Instance.new("Part")
	cylinder.Name = name
	cylinder.Shape = Enum.PartType.Cylinder
	cylinder.Size = size
	cylinder.CFrame = cframe
	cylinder.Color = color
	cylinder.Material = material or Enum.Material.Metal
	cylinder.Transparency = transparency or 0
	cylinder.Anchored = true
	cylinder.TopSurface = Enum.SurfaceType.Smooth
	cylinder.BottomSurface = Enum.SurfaceType.Smooth
	cylinder.Parent = parent
	return cylinder
end

local function createWedge(parent, name, size, cframe, color, material, transparency)
	local wedge = Instance.new("WedgePart")
	wedge.Name = name
	wedge.Size = size
	wedge.CFrame = cframe
	wedge.Color = color
	wedge.Material = material or Enum.Material.Wood
	wedge.Transparency = transparency or 0
	wedge.Anchored = true
	wedge.TopSurface = Enum.SurfaceType.Smooth
	wedge.BottomSurface = Enum.SurfaceType.Smooth
	wedge.Parent = parent
	return wedge
end

local function addSurfaceText(part, text, face)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "SurfaceText"
	surface.Face = face or Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 30
	surface.LightInfluence = 0.18
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 246, 205)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.28
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface
end

local function localFrame(frame, scale, x, y, z)
	return frame * CFrame.new(x * scale, y * scale, z * scale)
end

local function addBoltGrid(parent, baseFrame, scale, positions)
	for index, data in ipairs(positions) do
		createPart(
			parent,
			`Bolt{index}`,
			Vector3.new(0.42, 0.42, 0.2) * scale,
			localFrame(baseFrame, scale, data[1], data[2], data[3]) * CFrame.Angles(0, math.rad(data[4] or 0), 0),
			COLORS.Bolt,
			Enum.Material.Metal
		)
	end
end

function CatapultModelBuilder.createCatapult(config)
	config = config or {}
	local scale = config.scale or 1
	local frame = config.cframe or CFrame.new()
	local name = config.name or "Catapult"
	local plotId = config.plotId or 0
	local isShared = config.isSharedLauncher == true
	local decorative = config.decorative == true
	local catapultVersion = decorative and not isShared and CatapultModelBuilder.StatueVersion or CatapultModelBuilder.Version

	if not printedVersion then
		print("[BrainrotFruits] BlockyCatapult_V1 active")
		printedVersion = true
	end
	if decorative and not isShared and not printedStatueVersion then
		print("[BrainrotFruits] BlockyCatapult_Statue_V1 active")
		printedStatueVersion = true
	end

	local model = Instance.new("Model")
	model.Name = name
	model:SetAttribute("Type", "Catapult")
	model:SetAttribute("PlotId", plotId)
	model:SetAttribute("IsSharedLauncher", isShared)
	model:SetAttribute("Decorative", decorative)
	model:SetAttribute("CatapultVersion", catapultVersion)
	model.Parent = config.parent

	if decorative and not isShared then
		createPart(model, "DisplayPedestal", Vector3.new(15.4, 0.55, 17.2) * scale, localFrame(frame, scale, 0, 0.28, 0), COLORS.Stone, Enum.Material.Slate)
		createPart(model, "PedestalGlowInset", Vector3.new(12.6, 0.18, 14.2) * scale, localFrame(frame, scale, 0, 0.64, 0), Color3.fromRGB(255, 216, 103), Enum.Material.Neon, 0.45)
	end

	local base = createPart(model, "BaseFrame", Vector3.new(13.5, 1.1, 15.5) * scale, localFrame(frame, scale, 0, 0.55, 0), COLORS.Wood, Enum.Material.WoodPlanks)
	createPart(model, "FrontBeam", Vector3.new(15.5, 1.3, 1.4) * scale, localFrame(frame, scale, 0, 1.15, -6.9), COLORS.WoodDark, Enum.Material.WoodPlanks)
	createPart(model, "BackBeam", Vector3.new(15.5, 1.3, 1.4) * scale, localFrame(frame, scale, 0, 1.15, 6.9), COLORS.WoodDark, Enum.Material.WoodPlanks)
	createPart(model, "LeftSkid", Vector3.new(1.55, 1.2, 15.8) * scale, localFrame(frame, scale, -6.9, 1.2, 0), COLORS.WoodDark, Enum.Material.WoodPlanks)
	createPart(model, "RightSkid", Vector3.new(1.55, 1.2, 15.8) * scale, localFrame(frame, scale, 6.9, 1.2, 0), COLORS.WoodDark, Enum.Material.WoodPlanks)

	for _, x in ipairs({ -6.4, 6.4 }) do
		for _, z in ipairs({ -6.6, 6.6 }) do
			createPart(model, "CornerFoot", Vector3.new(2.4, 1.7, 2.4) * scale, localFrame(frame, scale, x, 0.85, z), COLORS.WoodDark, Enum.Material.WoodPlanks)
			createPart(model, "CornerMetalPlate", Vector3.new(1.15, 0.16, 1.15) * scale, localFrame(frame, scale, x, 1.76, z), COLORS.Metal, Enum.Material.Metal)
		end
	end

	for _, x in ipairs({ -4.8, 4.8 }) do
		createPart(model, "TowerPost", Vector3.new(1.35, 7.8, 1.35) * scale, localFrame(frame, scale, x, 5.05, -1.2), COLORS.Wood, Enum.Material.WoodPlanks)
		createPart(model, "TowerTopCap", Vector3.new(2.1, 0.85, 2.1) * scale, localFrame(frame, scale, x, 9.35, -1.2), COLORS.WoodLight, Enum.Material.WoodPlanks)
		createPart(model, "MetalBracket", Vector3.new(2.1, 2.1, 0.36) * scale, localFrame(frame, scale, x, 7.55, -2.0), COLORS.Metal, Enum.Material.Metal)
		createPart(model, "OuterBrace", Vector3.new(1, 7.2, 1) * scale, localFrame(frame, scale, x, 4.35, 2.75) * CFrame.Angles(math.rad(-24), 0, 0), COLORS.WoodLight, Enum.Material.WoodPlanks)
		createPart(model, "InnerBrace", Vector3.new(0.9, 6.5, 0.9) * scale, localFrame(frame, scale, x * 0.65, 4.15, -4.05) * CFrame.Angles(math.rad(27), 0, 0), COLORS.WoodLight, Enum.Material.WoodPlanks)
	end

	createCylinder(model, "MetalAxle", Vector3.new(1.25, 11.2, 1.25) * scale, localFrame(frame, scale, 0, 7.55, -1.75) * CFrame.Angles(0, 0, math.rad(90)), COLORS.Metal, Enum.Material.Metal)
	for _, x in ipairs({ -5.9, 5.9 }) do
		createCylinder(model, "AxleRing", Vector3.new(1.7, 0.72, 1.7) * scale, localFrame(frame, scale, x, 7.55, -1.75) * CFrame.Angles(0, 0, math.rad(90)), COLORS.MetalDark, Enum.Material.Metal)
	end

	createPart(model, "ThrowingArm", Vector3.new(1.55, 1.05, 17.2) * scale, localFrame(frame, scale, 0, 8.0, 4.25) * CFrame.Angles(math.rad(-29), 0, 0), COLORS.WoodLight, Enum.Material.WoodPlanks)
	createPart(model, "ArmMetalBand", Vector3.new(2.05, 1.22, 1.2) * scale, localFrame(frame, scale, 0, 7.28, -0.65) * CFrame.Angles(math.rad(-29), 0, 0), COLORS.Metal, Enum.Material.Metal)
	createPart(model, "FrontStopBracket", Vector3.new(4.4, 3.1, 0.72) * scale, localFrame(frame, scale, 0, 2.75, -4.3) * CFrame.Angles(math.rad(-10), 0, 0), COLORS.Metal, Enum.Material.Metal)
	createPart(model, "CounterWeight", Vector3.new(3.2, 2.6, 2.5) * scale, localFrame(frame, scale, 0, 2.85, -5.65), COLORS.Stone, Enum.Material.Metal)

	local cupFrame = localFrame(frame, scale, 0, 11.25, 10.85) * CFrame.Angles(math.rad(-18), 0, 0)
	createPart(model, "BasketFloor", Vector3.new(5.1, 0.55, 4.6) * scale, cupFrame, COLORS.Wood, Enum.Material.WoodPlanks)
	createPart(model, "BasketBackWall", Vector3.new(5.1, 2.1, 0.65) * scale, cupFrame * CFrame.new(0, 1.15 * scale, 2.0 * scale), COLORS.WoodDark, Enum.Material.WoodPlanks)
	createPart(model, "BasketFrontLip", Vector3.new(5.1, 1.35, 0.65) * scale, cupFrame * CFrame.new(0, 0.82 * scale, -2.0 * scale), COLORS.WoodDark, Enum.Material.WoodPlanks)
	createPart(model, "BasketLeftWall", Vector3.new(0.65, 1.7, 4.6) * scale, cupFrame * CFrame.new(-2.55 * scale, 0.96 * scale, 0), COLORS.WoodDark, Enum.Material.WoodPlanks)
	createPart(model, "BasketRightWall", Vector3.new(0.65, 1.7, 4.6) * scale, cupFrame * CFrame.new(2.55 * scale, 0.96 * scale, 0), COLORS.WoodDark, Enum.Material.WoodPlanks)
	createPart(model, "BasketFrontRim", Vector3.new(5.65, 0.35, 0.45) * scale, cupFrame * CFrame.new(0, 2.0 * scale, -2.35 * scale), COLORS.WoodLight, Enum.Material.WoodPlanks)
	createPart(model, "BasketBackRim", Vector3.new(5.65, 0.35, 0.45) * scale, cupFrame * CFrame.new(0, 2.0 * scale, 2.35 * scale), COLORS.WoodLight, Enum.Material.WoodPlanks)
	createPart(model, "BasketLeftRim", Vector3.new(0.45, 0.35, 5.15) * scale, cupFrame * CFrame.new(-2.8 * scale, 2.0 * scale, 0), COLORS.WoodLight, Enum.Material.WoodPlanks)
	createPart(model, "BasketRightRim", Vector3.new(0.45, 0.35, 5.15) * scale, cupFrame * CFrame.new(2.8 * scale, 2.0 * scale, 0), COLORS.WoodLight, Enum.Material.WoodPlanks)

	for _, x in ipairs({ -2.25, 2.25 }) do
		createPart(model, "RopeStrip", Vector3.new(0.18, 3.6, 0.18) * scale, localFrame(frame, scale, x, 5.55, 1.5) * CFrame.Angles(math.rad(31), 0, 0), COLORS.Rope, Enum.Material.Fabric)
	end

	addBoltGrid(model, frame, scale, {
		{ -4.8, 7.9, -2.21 },
		{ -4.8, 7.15, -2.21 },
		{ 4.8, 7.9, -2.21 },
		{ 4.8, 7.15, -2.21 },
		{ -6.4, 1.95, -6.6 },
		{ 6.4, 1.95, -6.6 },
		{ -6.4, 1.95, 6.6 },
		{ 6.4, 1.95, 6.6 },
	})

	if isShared then
		local interactZone = createPart(model, "InteractZone", Vector3.new(14, 5.5, 13) * scale, localFrame(frame, scale, 0, 3.15, -8.8), COLORS.Interact, Enum.Material.ForceField, 0.78)
		interactZone.CanCollide = false
		interactZone:SetAttribute("SharedLaunch", true)
		interactZone:SetAttribute("LaunchOrigin", (frame * CFrame.new(0, 7.5 * scale, 12.3 * scale)).Position)
		interactZone:SetAttribute("LaunchDirection", frame:VectorToWorldSpace(Vector3.new(0, 0, 1)))
		addSurfaceText(interactZone, "LOAD CRATE", Enum.NormalId.Top)
		model.PrimaryPart = interactZone
	else
		model.PrimaryPart = base
	end

	return model
end

return CatapultModelBuilder
