local Workspace = game:GetService("Workspace")

local TEST_WORLD_NAME = "BrainrotFruitsTest"

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

local function createCylinder(parent, name, size, cframe, color, material)
	local part = createPart(parent, name, size, cframe, color, material)
	part.Shape = Enum.PartType.Cylinder
	return part
end

local function addBillboard(part, text, offset)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Label"
	billboard.Size = UDim2.fromOffset(180, 42)
	billboard.StudsOffset = offset or Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.3
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard
end

local function buildLane(testArea)
	createPart(
		testArea,
		"LaunchLane",
		Vector3.new(14, 0.25, 112),
		CFrame.new(0, 0, 48),
		Color3.fromRGB(74, 142, 93),
		Enum.Material.Grass
	)

	createPart(
		testArea,
		"LaneCenterStripe",
		Vector3.new(0.4, 0.05, 106),
		CFrame.new(0, 0.18, 50),
		Color3.fromRGB(255, 245, 183),
		Enum.Material.SmoothPlastic
	)

	for _, x in ipairs({ -7.4, 7.4 }) do
		createPart(
			testArea,
			"LaneRail",
			Vector3.new(0.35, 0.55, 112),
			CFrame.new(x, 0.45, 48),
			Color3.fromRGB(108, 68, 40),
			Enum.Material.Wood
		)
	end

	for _, distance in ipairs({ 20, 40, 60, 80, 100 }) do
		local marker = createPart(
			testArea,
			`DistanceMarker_{distance}`,
			Vector3.new(13.5, 0.12, 0.35),
			CFrame.new(0, 0.32, distance),
			Color3.fromRGB(248, 232, 136),
			Enum.Material.Neon
		)
		addBillboard(marker, `{distance} studs`, Vector3.new(0, 2.2, 0))
	end

	local landing = createPart(
		testArea,
		"LandingZone",
		Vector3.new(16, 0.18, 18),
		CFrame.new(0, 0.38, 92),
		Color3.fromRGB(102, 191, 211),
		Enum.Material.SmoothPlastic,
		0.12
	)
	addBillboard(landing, "Landing Zone", Vector3.new(0, 3, 0))
end

local function buildDirectionArrow(testArea)
	createPart(
		testArea,
		"DirectionArrowShaft",
		Vector3.new(1.1, 0.15, 8),
		CFrame.new(0, 0.7, 6),
		Color3.fromRGB(255, 244, 122),
		Enum.Material.Neon
	)

	local head = Instance.new("WedgePart")
	head.Name = "DirectionArrowHead"
	head.Size = Vector3.new(4, 0.18, 4)
	head.CFrame = CFrame.new(0, 0.72, 12) * CFrame.Angles(0, math.rad(180), 0)
	head.Color = Color3.fromRGB(255, 244, 122)
	head.Material = Enum.Material.Neon
	head.Anchored = true
	head.Parent = testArea
end

local function buildCatapult(testArea)
	local catapult = Instance.new("Model")
	catapult.Name = "Catapult"
	catapult.Parent = testArea

	createPart(
		catapult,
		"WoodenBase",
		Vector3.new(6.5, 0.6, 5.5),
		CFrame.new(0, 0.65, -7),
		Color3.fromRGB(117, 76, 45),
		Enum.Material.Wood
	)
	createPart(
		catapult,
		"LeftSupport",
		Vector3.new(0.55, 4, 0.55),
		CFrame.new(-2.1, 2.4, -6.4) * CFrame.Angles(0, 0, math.rad(-10)),
		Color3.fromRGB(99, 62, 35),
		Enum.Material.Wood
	)
	createPart(
		catapult,
		"RightSupport",
		Vector3.new(0.55, 4, 0.55),
		CFrame.new(2.1, 2.4, -6.4) * CFrame.Angles(0, 0, math.rad(10)),
		Color3.fromRGB(99, 62, 35),
		Enum.Material.Wood
	)

	createCylinder(
		catapult,
		"HingeLog",
		Vector3.new(0.55, 4.7, 0.55),
		CFrame.new(0, 3.25, -6.15) * CFrame.Angles(0, 0, math.rad(90)),
		Color3.fromRGB(88, 54, 33),
		Enum.Material.Wood
	)

	createPart(
		catapult,
		"LaunchArm",
		Vector3.new(0.55, 0.38, 7.7),
		CFrame.new(0, 3.15, -3.25) * CFrame.Angles(math.rad(-18), 0, 0),
		Color3.fromRGB(137, 88, 50),
		Enum.Material.Wood
	)
	createPart(
		catapult,
		"BasketCup",
		Vector3.new(2.4, 0.55, 2.1),
		CFrame.new(0, 4, 0.35) * CFrame.Angles(math.rad(-18), 0, 0),
		Color3.fromRGB(150, 95, 54),
		Enum.Material.Wood
	)
	createPart(
		catapult,
		"BasketLip",
		Vector3.new(2.75, 0.25, 2.45),
		CFrame.new(0, 4.35, 0.23) * CFrame.Angles(math.rad(-18), 0, 0),
		Color3.fromRGB(95, 58, 34),
		Enum.Material.Wood
	)

	for _, x in ipairs({ -2.35, 2.35 }) do
		createCylinder(
			catapult,
			"RopeDetail",
			Vector3.new(0.16, 3.8, 0.16),
			CFrame.new(x, 2.25, -5.2) * CFrame.Angles(math.rad(28), 0, 0),
			Color3.fromRGB(216, 184, 126),
			Enum.Material.Fabric
		)
	end

	local interactZone = createPart(
		catapult,
		"InteractZone",
		Vector3.new(7.5, 4, 7.5),
		CFrame.new(0, 2.2, -7),
		Color3.fromRGB(78, 179, 255),
		Enum.Material.ForceField,
		0.78
	)
	interactZone.CanCollide = false
	interactZone:SetAttribute("LaunchOrigin", Vector3.new(0, 4.5, -0.25))
	interactZone:SetAttribute("LaunchDirection", Vector3.new(0, 0, 1))
	addBillboard(interactZone, "Catapult", Vector3.new(0, 3.4, 0))

	catapult.PrimaryPart = interactZone
end

local testWorld = getOrCreateFolder(Workspace, TEST_WORLD_NAME)
local testArea = getOrCreateFolder(testWorld, "TestArea")
testArea:ClearAllChildren()

buildLane(testArea)
buildDirectionArrow(testArea)
buildCatapult(testArea)
