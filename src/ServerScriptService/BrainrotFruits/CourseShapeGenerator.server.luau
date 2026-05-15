local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local DEBUG_PRINT = true
local LOCAL_TEST_CLEAR_WORKSPACE = true
local GENERATED_FOLDER_NAME = "GeneratedCourseShape"
local GENERATED_FOLDER_NAMES_TO_CLEAR = {
	"GeneratedCourseShape",
	"GeneratedValleyMap",
	"GeneratedMapWalls",
	"GeneratedCourse",
	"GeneratedMap",
	"CoursePreview",
	"BuilderPreview",
}
local VERSION = "CourseShapeGenerator_CheckerboardCanyon_V1"

local BLOCK_SIZE = 4
local INWARD_Z_SIGN = -1

local INNER_WIDTH_BLOCKS = 61
local INNER_WIDTH_STUDS = 244

local SECTION_COUNT = 11
local SECTION_LENGTH_BLOCKS = 80
local SECTION_LENGTH_STUDS = 320

local RIVER_COUNT = SECTION_COUNT - 1
local RIVER_LENGTH_BLOCKS = 16
local RIVER_LENGTH_STUDS = 64
local RIVER_DEPRESSION_STUDS = 1
local RIVER_EDGE_SUPPORT_THICKNESS_STUDS = 1

local TOTAL_INNER_LENGTH_BLOCKS = (SECTION_COUNT * SECTION_LENGTH_BLOCKS) + (RIVER_COUNT * RIVER_LENGTH_BLOCKS)
local TOTAL_INNER_LENGTH_STUDS = TOTAL_INNER_LENGTH_BLOCKS * BLOCK_SIZE

local WALL_THICKNESS_BLOCKS = 4
local WALL_THICKNESS_STUDS = 16

local WALL_HEIGHT_BLOCKS = 20
local WALL_HEIGHT_STUDS = 80

local FRONT_RAMP_DROP_STUDS = 10
local FRONT_RAMP_RUN_STUDS = 14
local FRONT_ENTRY_DEPTH_STUDS = 32

local SAFE_ZONE_DEPTH_BLOCKS = 5
local SAFE_ZONE_DEPTH_STUDS = 20
local SAFE_ZONE_BOUNDARY_LINE_WIDTH_STUDS = 1

local COURSE_WALL_LENGTH_BLOCKS = SAFE_ZONE_DEPTH_BLOCKS + TOTAL_INNER_LENGTH_BLOCKS
local COURSE_WALL_LENGTH_STUDS = COURSE_WALL_LENGTH_BLOCKS * BLOCK_SIZE

local GRASS_DRIP_MIN_BLOCKS = 1
local GRASS_DRIP_MAX_BLOCKS = 6
local GRASS_DRIP_NOISE_SCALE = 0.13
local GRASS_DRIP_SEED = 1337

local YIELD_EVERY_PLACEMENTS = 650

local REQUIRED_ASSET_NAMES = {
	"DirtBlock_4x4",
	"DirtBlock_4x4_Dark",
	"GrassBlock_4x4_Light",
	"GrassBlock_4x4_Dark",
	"GrassSideBlock_4x2",
	"GrassSideBlock_4x2_Dark",
}

local COLOR_SECTION_PLACEHOLDER = Color3.fromRGB(98, 211, 79)
local COLOR_SAFE_ZONE = Color3.fromRGB(236, 214, 160)
local COLOR_SAFE_ZONE_LINE = Color3.fromRGB(255, 255, 255)
local COLOR_ENTRY = Color3.fromRGB(180, 220, 104)
local COLOR_RIVER_BOTTOM = Color3.fromRGB(31, 108, 181)
local COLOR_RIVER_WATER = Color3.fromRGB(48, 171, 255)

local stats = {
	wallDirtCount = 0,
	wallTopGrassCount = 0,
	wallSideGrassCount = 0,
	generatedSectionCount = 0,
	generatedRiverCount = 0,
	sectionFloorCount = 0,
	riverCount = 0,
	riverPartCount = 0,
	riverSupportPartCount = 0,
	safeZonePartCount = 0,
	rampPartCount = 0,
	spawnPartCount = 0,
	entryPartCount = 0,
	folderCount = 0,
	placements = 0,
}

local resolvedAssetPaths = {}

local function debugPrint(...)
	if DEBUG_PRINT then
		print("[BrainrotFruits][CourseShape]", ...)
	end
end

local function getInstancePath(instance)
	local names = {}
	local current = instance

	while current and current ~= game do
		table.insert(names, 1, current.Name)
		current = current.Parent
	end

	return table.concat(names, ".")
end

local function createFolder(parent, name)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	stats.folderCount += 1
	return folder
end

local function findAssetRecursive(container, name)
	for _, descendant in ipairs(container:GetDescendants()) do
		if descendant.Name == name then
			return descendant
		end
	end

	return nil
end

local function resolveAssets()
	local assets = {}
	local missing = {}

	for _, assetName in ipairs(REQUIRED_ASSET_NAMES) do
		local asset = findAssetRecursive(ServerStorage, assetName)
		if asset then
			assets[assetName] = asset
			resolvedAssetPaths[assetName] = getInstancePath(asset)
		else
			table.insert(missing, assetName)
		end
	end

	if #missing > 0 then
		warn("[BrainrotFruits][CourseShape] Missing required ServerStorage assets: " .. table.concat(missing, ", "))
		return nil, missing
	end

	for _, assetName in ipairs(REQUIRED_ASSET_NAMES) do
		debugPrint("found asset", assetName, "=>", resolvedAssetPaths[assetName])
	end

	return assets, nil
end

local function clearExistingGeneratedCourse()
	for _, folderName in ipairs(GENERATED_FOLDER_NAMES_TO_CLEAR) do
		local existing = Workspace:FindFirstChild(folderName)
		if existing then
			existing:Destroy()
			debugPrint("removed old generated workspace folder", folderName)
		end
	end
end

local function clearWorkspaceForLocalCourseTest()
	if not LOCAL_TEST_CLEAR_WORKSPACE then
		return
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		if child.Name ~= GENERATED_FOLDER_NAME and not child:IsA("Terrain") and not child:IsA("Camera") then
			child:Destroy()
		end
	end

	debugPrint("cleared Workspace for local course-shape-only test")
end

local function setBasePartDefaults(part, canCollide)
	part.Anchored = true
	part.CanCollide = canCollide
	part.CanTouch = false
	part.CanQuery = true
	part.TopSurface = Enum.SurfaceType.Studs
	part.BottomSurface = Enum.SurfaceType.Inlet
end

local function createPart(parent, name, size, cframe, color, material, canCollide, transparency)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.Plastic
	part.Transparency = transparency or 0
	setBasePartDefaults(part, canCollide)
	part.Parent = parent
	return part
end

local function moveCharacterToCourseSpawn(character)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return
	end

	local spawnPosition = Vector3.new(0, 6, INWARD_Z_SIGN * (SAFE_ZONE_DEPTH_STUDS / 2))
	local lookTarget = spawnPosition + Vector3.new(0, 0, INWARD_Z_SIGN * 20)

	rootPart.AssemblyLinearVelocity = Vector3.zero
	rootPart.AssemblyAngularVelocity = Vector3.zero
	rootPart.CFrame = CFrame.lookAt(spawnPosition, lookTarget)
end

local function hookCourseSpawn()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			moveCharacterToCourseSpawn(player.Character)
		end

		player.CharacterAdded:Connect(moveCharacterToCourseSpawn)
	end

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(moveCharacterToCourseSpawn)
	end)
end

local function createCourseSpawn(parent)
	local spawnLocation = Instance.new("SpawnLocation")
	spawnLocation.Name = "CourseTestSpawn"
	spawnLocation.Size = Vector3.new(16, 1, 16)
	spawnLocation.CFrame = CFrame.lookAt(
		Vector3.new(0, 0.5, INWARD_Z_SIGN * (SAFE_ZONE_DEPTH_STUDS / 2)),
		Vector3.new(0, 0.5, INWARD_Z_SIGN * ((SAFE_ZONE_DEPTH_STUDS / 2) + 20))
	)
	spawnLocation.Color = Color3.fromRGB(82, 255, 120)
	spawnLocation.Material = Enum.Material.Plastic
	spawnLocation.Anchored = true
	spawnLocation.CanCollide = true
	spawnLocation.CanTouch = false
	spawnLocation.CanQuery = true
	spawnLocation.Neutral = true
	spawnLocation.Enabled = true
	spawnLocation.TopSurface = Enum.SurfaceType.Studs
	spawnLocation.BottomSurface = Enum.SurfaceType.Inlet
	spawnLocation.Parent = parent
	spawnLocation:SetAttribute("LocalTestSpawnForGeneratedCourseShape", true)

	stats.spawnPartCount += 1
	return spawnLocation
end

local function maybeYield()
	stats.placements += 1
	if stats.placements % YIELD_EVERY_PLACEMENTS == 0 then
		task.wait()
	end
end

local function cloneAssetTo(asset, parent, cframe, name)
	local clone = asset:Clone()
	clone.Name = name or asset.Name

	if clone:IsA("Model") then
		if not clone.PrimaryPart then
			local firstPart = clone:FindFirstChildWhichIsA("BasePart", true)
			if firstPart then
				clone.PrimaryPart = firstPart
			end
		end

		clone:PivotTo(cframe)
	elseif clone:IsA("BasePart") then
		clone.CFrame = cframe
		clone.Anchored = true
	end

	clone.Parent = parent
	maybeYield()
	return clone
end

local function blockCenterX(blockX)
	return (-INNER_WIDTH_STUDS / 2) + (blockX * BLOCK_SIZE) + (BLOCK_SIZE / 2)
end

local function blockCenterZ(blockZ)
	return INWARD_Z_SIGN * ((blockZ * BLOCK_SIZE) + (BLOCK_SIZE / 2))
end

local function depthToWorldZ(depthStuds)
	return INWARD_Z_SIGN * depthStuds
end

local function outsideDepthToWorldZ(depthStuds)
	return -INWARD_Z_SIGN * depthStuds
end

local function segmentCenterZ(startZBlock, lengthBlocks)
	return depthToWorldZ((startZBlock * BLOCK_SIZE) + ((lengthBlocks * BLOCK_SIZE) / 2))
end

local function floorBlockCFrame(blockX, blockZ)
	return CFrame.new(blockCenterX(blockX), -BLOCK_SIZE / 2, blockCenterZ(blockZ))
end

local function wallBlockCFrame(blockX, blockY, blockZ)
	return CFrame.new(blockCenterX(blockX), (blockY * BLOCK_SIZE) + (BLOCK_SIZE / 2), blockCenterZ(blockZ))
end

local function grassTopCFrame(blockX, blockZ)
	return CFrame.new(blockCenterX(blockX), WALL_HEIGHT_STUDS + (BLOCK_SIZE / 2), blockCenterZ(blockZ))
end

local function chooseFloorGrassAsset(assets, xIndex, zIndex)
	if (xIndex + zIndex) % 2 == 0 then
		return assets.GrassBlock_4x4_Light
	end

	return assets.GrassBlock_4x4_Dark
end

local function chooseDirtAsset(assets, xIndex, yIndex, zIndex)
	if (xIndex + yIndex + zIndex) % 2 == 0 then
		return assets.DirtBlock_4x4
	end

	return assets.DirtBlock_4x4_Dark
end

local function chooseTopGrassAsset(assets, xIndex, zIndex)
	if (xIndex + zIndex) % 2 == 0 then
		return assets.GrassBlock_4x4_Light
	end

	return assets.GrassBlock_4x4_Dark
end

local function chooseSideGrassAsset(assets, columnIndex, yIndex)
	if (columnIndex + yIndex) % 2 == 0 then
		return assets.GrassSideBlock_4x2
	end

	return assets.GrassSideBlock_4x2_Dark
end

local function getDripDepth(columnIndex, salt)
	local noiseValue = math.noise((columnIndex + salt) * GRASS_DRIP_NOISE_SCALE, salt, GRASS_DRIP_SEED)
	local normalized = math.clamp((noiseValue + 1) / 2, 0, 0.999)
	local span = GRASS_DRIP_MAX_BLOCKS - GRASS_DRIP_MIN_BLOCKS + 1

	return GRASS_DRIP_MIN_BLOCKS + math.floor(normalized * span)
end

local function buildRamp(frontEntryFolder)
	local rampFolder = createFolder(frontEntryFolder, "Ramp")

	createPart(
		rampFolder,
		"EntryApronHighPlatform",
		Vector3.new(INNER_WIDTH_STUDS, 1, FRONT_ENTRY_DEPTH_STUDS),
		CFrame.new(0, FRONT_RAMP_DROP_STUDS - 0.5, outsideDepthToWorldZ(FRONT_RAMP_RUN_STUDS + (FRONT_ENTRY_DEPTH_STUDS / 2))),
		COLOR_SAFE_ZONE,
		Enum.Material.Plastic,
		true,
		0
	)
	stats.entryPartCount += 1

	local rampThickness = 0.5
	local rampSlopeLength = math.sqrt((FRONT_RAMP_RUN_STUDS * FRONT_RAMP_RUN_STUDS) + (FRONT_RAMP_DROP_STUDS * FRONT_RAMP_DROP_STUDS))
	local rampAngle = -math.atan2(FRONT_RAMP_DROP_STUDS, FRONT_RAMP_RUN_STUDS)
	local topLineMidpoint = Vector3.new(0, FRONT_RAMP_DROP_STUDS / 2, outsideDepthToWorldZ(FRONT_RAMP_RUN_STUDS / 2))
	local localYInWorld = Vector3.new(0, math.cos(rampAngle), math.sin(rampAngle))
	local rampCenter = topLineMidpoint - (localYInWorld * (rampThickness / 2))
	local rampCFrame = CFrame.new(rampCenter) * CFrame.Angles(rampAngle, 0, 0)

	local ramp = createPart(
		rampFolder,
		"FullWidthRamp_Run14_Drop10",
		Vector3.new(INNER_WIDTH_STUDS, rampThickness, rampSlopeLength),
		rampCFrame,
		COLOR_SAFE_ZONE,
		Enum.Material.Plastic,
		true,
		0
	)
	ramp:SetAttribute("RampRunStuds", FRONT_RAMP_RUN_STUDS)
	ramp:SetAttribute("RampDropStuds", FRONT_RAMP_DROP_STUDS)
	ramp:SetAttribute("RampTopStartZ", outsideDepthToWorldZ(FRONT_RAMP_RUN_STUDS))
	ramp:SetAttribute("RampBottomEndZ", 0)
	ramp:SetAttribute("RampColorMatchesSafeZone", true)
	stats.rampPartCount += 1
end

local function buildSafeZone(frontEntryFolder)
	local safeZoneFolder = createFolder(frontEntryFolder, "SafeZone")

	local safeZone = createPart(
		safeZoneFolder,
		"SafeZoneFloor_61x5Blocks",
		Vector3.new(INNER_WIDTH_STUDS, 0.5, SAFE_ZONE_DEPTH_STUDS),
		CFrame.new(0, -0.25, depthToWorldZ(SAFE_ZONE_DEPTH_STUDS / 2)),
		COLOR_SAFE_ZONE,
		Enum.Material.Plastic,
		true,
		0
	)
	safeZone:SetAttribute("DepthBlocks", SAFE_ZONE_DEPTH_BLOCKS)
	safeZone:SetAttribute("DepthStuds", SAFE_ZONE_DEPTH_STUDS)
	stats.safeZonePartCount += 1
	createCourseSpawn(safeZoneFolder)

	local boundaryFolder = createFolder(frontEntryFolder, "SafeZoneBoundary")
	local boundary = createPart(
		boundaryFolder,
		"RampStartBoundary_White1Stud",
		Vector3.new(INNER_WIDTH_STUDS, 0.2, SAFE_ZONE_BOUNDARY_LINE_WIDTH_STUDS),
		CFrame.new(0, FRONT_RAMP_DROP_STUDS + 0.1, outsideDepthToWorldZ(FRONT_RAMP_RUN_STUDS)),
		COLOR_SAFE_ZONE_LINE,
		Enum.Material.Plastic,
		true,
		0
	)
	boundary.BottomSurface = Enum.SurfaceType.Smooth
	boundary:SetAttribute("LineWidthStuds", SAFE_ZONE_BOUNDARY_LINE_WIDTH_STUDS)
	boundary:SetAttribute("SpansWallToWallStuds", INNER_WIDTH_STUDS)
	boundary:SetAttribute("AtRampStart", true)
	boundary:SetAttribute("RampStartZ", outsideDepthToWorldZ(FRONT_RAMP_RUN_STUDS))
	stats.safeZonePartCount += 1
end

local function buildFrontEntry(root)
	local frontEntryFolder = createFolder(root, "FrontEntry")
	buildRamp(frontEntryFolder)
	buildSafeZone(frontEntryFolder)
	return frontEntryFolder
end

local function buildSection(assets, sectionsFolder, sectionIndex, startZBlock)
	local sectionFolder = createFolder(sectionsFolder, string.format("Section%02d", sectionIndex))
	sectionFolder:SetAttribute("SectionIndex", sectionIndex)
	sectionFolder:SetAttribute("ThemePlaceholder", "DefaultGrassCheckerboard")
	sectionFolder:SetAttribute("StartZBlock", startZBlock)
	sectionFolder:SetAttribute("LengthBlocks", SECTION_LENGTH_BLOCKS)
	sectionFolder:SetAttribute("LengthStuds", SECTION_LENGTH_STUDS)
	sectionFolder:SetAttribute("WidthBlocks", INNER_WIDTH_BLOCKS)
	sectionFolder:SetAttribute("WidthStuds", INNER_WIDTH_STUDS)

	for localZ = 0, SECTION_LENGTH_BLOCKS - 1 do
		local zIndex = startZBlock + localZ
		for xIndex = 0, INNER_WIDTH_BLOCKS - 1 do
			local asset = chooseFloorGrassAsset(assets, xIndex, zIndex)
			cloneAssetTo(
				asset,
				sectionFolder,
				floorBlockCFrame(xIndex, zIndex),
				string.format("Grass_S%02d_X%02d_Z%04d", sectionIndex, xIndex, zIndex)
			)
			stats.sectionFloorCount += 1
		end
	end

	stats.generatedSectionCount += 1
	debugPrint(
		string.format(
			"section %02d generated: zBlock %d through %d",
			sectionIndex,
			startZBlock,
			startZBlock + SECTION_LENGTH_BLOCKS - 1
		)
	)

	return sectionFolder
end

local function buildRiver(riversFolder, riverIndex, startZBlock)
	local riverFolder = createFolder(riversFolder, string.format("River%02d", riverIndex))
	local supportFolder = createFolder(riverFolder, "Support")
	local startDepthStuds = startZBlock * BLOCK_SIZE
	local endDepthStuds = startDepthStuds + RIVER_LENGTH_STUDS
	local centerZ = segmentCenterZ(startZBlock, RIVER_LENGTH_BLOCKS)

	riverFolder:SetAttribute("RiverIndex", riverIndex)
	riverFolder:SetAttribute("StartZBlock", startZBlock)
	riverFolder:SetAttribute("LengthBlocks", RIVER_LENGTH_BLOCKS)
	riverFolder:SetAttribute("LengthStuds", RIVER_LENGTH_STUDS)
	riverFolder:SetAttribute("WidthBlocks", INNER_WIDTH_BLOCKS)
	riverFolder:SetAttribute("WidthStuds", INNER_WIDTH_STUDS)
	riverFolder:SetAttribute("RiverBedDepressionStuds", RIVER_DEPRESSION_STUDS)
	riverFolder:SetAttribute("SupportCoversFullFootprint", true)
	riverFolder:SetAttribute("SideEdgeSupportThicknessStuds", RIVER_EDGE_SUPPORT_THICKNESS_STUDS)

	local bottom = createPart(
		riverFolder,
		"RiverBottom_Depressed1Stud",
		Vector3.new(INNER_WIDTH_STUDS, RIVER_DEPRESSION_STUDS, RIVER_LENGTH_STUDS),
		CFrame.new(0, -RIVER_DEPRESSION_STUDS - (RIVER_DEPRESSION_STUDS / 2), centerZ),
		COLOR_RIVER_BOTTOM,
		Enum.Material.Plastic,
		true,
		0
	)
	bottom:SetAttribute("TopSurfaceY", -RIVER_DEPRESSION_STUDS)

	local underfill = createPart(
		supportFolder,
		"RiverUnderfill_NoVoidSlab",
		Vector3.new(INNER_WIDTH_STUDS, BLOCK_SIZE - (RIVER_DEPRESSION_STUDS * 2), RIVER_LENGTH_STUDS),
		CFrame.new(0, -3, centerZ),
		COLOR_RIVER_BOTTOM,
		Enum.Material.Plastic,
		true,
		0
	)
	underfill:SetAttribute("Purpose", "Hidden support under lowered river bottom so no void is visible")

	local leftEdgeSupport = createPart(
		supportFolder,
		"RiverLeftEdgeSupportLip",
		Vector3.new(RIVER_EDGE_SUPPORT_THICKNESS_STUDS, RIVER_DEPRESSION_STUDS, RIVER_LENGTH_STUDS),
		CFrame.new((-INNER_WIDTH_STUDS / 2) + (RIVER_EDGE_SUPPORT_THICKNESS_STUDS / 2), -RIVER_DEPRESSION_STUDS / 2, centerZ),
		COLOR_RIVER_BOTTOM,
		Enum.Material.Plastic,
		true,
		0
	)
	leftEdgeSupport:SetAttribute("Purpose", "Covers the 1-stud river depression edge against the left wall")

	local rightEdgeSupport = createPart(
		supportFolder,
		"RiverRightEdgeSupportLip",
		Vector3.new(RIVER_EDGE_SUPPORT_THICKNESS_STUDS, RIVER_DEPRESSION_STUDS, RIVER_LENGTH_STUDS),
		CFrame.new((INNER_WIDTH_STUDS / 2) - (RIVER_EDGE_SUPPORT_THICKNESS_STUDS / 2), -RIVER_DEPRESSION_STUDS / 2, centerZ),
		COLOR_RIVER_BOTTOM,
		Enum.Material.Plastic,
		true,
		0
	)
	rightEdgeSupport:SetAttribute("Purpose", "Covers the 1-stud river depression edge against the right wall")

	local frontEdgeSupport = createPart(
		supportFolder,
		"RiverFrontEdgeSupportLip",
		Vector3.new(INNER_WIDTH_STUDS, RIVER_DEPRESSION_STUDS, RIVER_EDGE_SUPPORT_THICKNESS_STUDS),
		CFrame.new(0, -RIVER_DEPRESSION_STUDS / 2, depthToWorldZ(startDepthStuds + (RIVER_EDGE_SUPPORT_THICKNESS_STUDS / 2))),
		COLOR_RIVER_BOTTOM,
		Enum.Material.Plastic,
		true,
		0
	)
	frontEdgeSupport:SetAttribute("Purpose", "Covers the 1-stud river depression edge against the previous section")

	local backEdgeSupport = createPart(
		supportFolder,
		"RiverBackEdgeSupportLip",
		Vector3.new(INNER_WIDTH_STUDS, RIVER_DEPRESSION_STUDS, RIVER_EDGE_SUPPORT_THICKNESS_STUDS),
		CFrame.new(0, -RIVER_DEPRESSION_STUDS / 2, depthToWorldZ(endDepthStuds - (RIVER_EDGE_SUPPORT_THICKNESS_STUDS / 2))),
		COLOR_RIVER_BOTTOM,
		Enum.Material.Plastic,
		true,
		0
	)
	backEdgeSupport:SetAttribute("Purpose", "Covers the 1-stud river depression edge against the next section")

	local water = createPart(
		riverFolder,
		"WaterSurface",
		Vector3.new(INNER_WIDTH_STUDS, 0.2, RIVER_LENGTH_STUDS),
		CFrame.new(0, -0.85, centerZ),
		COLOR_RIVER_WATER,
		Enum.Material.Water,
		false,
		0.35
	)
	water.BottomSurface = Enum.SurfaceType.Smooth
	water:SetAttribute("UsesWaterMaterial", true)

	stats.riverCount += 1
	stats.generatedRiverCount += 1
	stats.riverPartCount += 7
	stats.riverSupportPartCount += 5
	debugPrint(
		string.format(
			"river %02d generated: zBlock %d through %d with depression support",
			riverIndex,
			startZBlock,
			startZBlock + RIVER_LENGTH_BLOCKS - 1
		)
	)

	return riverFolder
end

local function buildInterior(assets, root)
	local sectionsFolder = createFolder(root, "Sections")
	local riversFolder = createFolder(root, "Rivers")

	local courseStartZBlock = SAFE_ZONE_DEPTH_BLOCKS
	local expectedCourseEndZBlock = courseStartZBlock + TOTAL_INNER_LENGTH_BLOCKS
	local currentZBlock = courseStartZBlock

	for sectionIndex = 1, SECTION_COUNT do
		buildSection(assets, sectionsFolder, sectionIndex, currentZBlock)
		currentZBlock += SECTION_LENGTH_BLOCKS

		if sectionIndex <= RIVER_COUNT then
			buildRiver(riversFolder, sectionIndex, currentZBlock)
			currentZBlock += RIVER_LENGTH_BLOCKS
		end
	end

	if currentZBlock ~= expectedCourseEndZBlock then
		warn(
			string.format(
				"[BrainrotFruits][CourseShape] Interior length mismatch: expected end zBlock %d, got %d",
				expectedCourseEndZBlock,
				currentZBlock
			)
		)
	end

	root:SetAttribute("InteriorStartZBlock", courseStartZBlock)
	root:SetAttribute("InteriorEndZBlock", currentZBlock)
	root:SetAttribute("InteriorEndZStuds", currentZBlock * BLOCK_SIZE)
	root:SetAttribute("ExpectedInteriorEndZBlock", expectedCourseEndZBlock)
	root:SetAttribute("ExpectedInteriorEndZStuds", expectedCourseEndZBlock * BLOCK_SIZE)
	root:SetAttribute("InteriorLengthValidated", currentZBlock == expectedCourseEndZBlock)
end

local function buildDirtBlock(assets, parent, xIndex, yIndex, zIndex, namePrefix)
	local asset = chooseDirtAsset(assets, xIndex, yIndex, zIndex)
	cloneAssetTo(
		asset,
		parent,
		wallBlockCFrame(xIndex, yIndex, zIndex),
		string.format("%s_X%03d_Y%02d_Z%04d", namePrefix, xIndex, yIndex, zIndex)
	)
	stats.wallDirtCount += 1
end

local function buildTopGrassBlock(assets, parent, xIndex, zIndex, namePrefix)
	local asset = chooseTopGrassAsset(assets, xIndex, zIndex)
	cloneAssetTo(
		asset,
		parent,
		grassTopCFrame(xIndex, zIndex),
		string.format("%s_X%03d_Z%04d", namePrefix, xIndex, zIndex)
	)
	stats.wallTopGrassCount += 1
end

local function buildSideGrassBlock(assets, parent, columnIndex, yIndex, cframe, namePrefix)
	local asset = chooseSideGrassAsset(assets, columnIndex, yIndex)
	cloneAssetTo(
		asset,
		parent,
		cframe,
		string.format("%s_C%04d_Y%02d", namePrefix, columnIndex, yIndex)
	)
	stats.wallSideGrassCount += 1
end

local function buildSideWall(assets, wallsFolder, wallName, xStart, xEnd, isLeftWall)
	local wallFolder = createFolder(wallsFolder, wallName)
	local dirtFolder = createFolder(wallFolder, "Dirt")
	local topGrassFolder = createFolder(wallFolder, "TopGrass")
	local sideGrassFolder = createFolder(wallFolder, "SideGrass")
	local sideGrassX = if isLeftWall then -INNER_WIDTH_STUDS / 2 else INNER_WIDTH_STUDS / 2
	local sideGrassRotation = CFrame.Angles(0, math.rad(90), 0)
	local wallSalt = if isLeftWall then 11 else 29

	for zIndex = 0, COURSE_WALL_LENGTH_BLOCKS - 1 do
		for xIndex = xStart, xEnd do
			for yIndex = 0, WALL_HEIGHT_BLOCKS - 1 do
				buildDirtBlock(assets, dirtFolder, xIndex, yIndex, zIndex, wallName .. "_Dirt")
			end

			buildTopGrassBlock(assets, topGrassFolder, xIndex, zIndex, wallName .. "_TopGrass")
		end

		local dripDepth = getDripDepth(zIndex, wallSalt)
		local worldZ = blockCenterZ(zIndex)

		for depthOffset = 0, dripDepth - 1 do
			local yIndex = WALL_HEIGHT_BLOCKS - 1 - depthOffset
			local worldY = (yIndex * BLOCK_SIZE) + (BLOCK_SIZE / 2)
			buildSideGrassBlock(
				assets,
				sideGrassFolder,
				zIndex,
				yIndex,
				CFrame.new(sideGrassX, worldY, worldZ) * sideGrassRotation,
				wallName .. "_SideGrass"
			)
		end
	end

	wallFolder:SetAttribute("SideGrassVisibleLipStuds", 1)
	wallFolder:SetAttribute("SideGrassEmbeddedLipStuds", 1)
	return wallFolder
end

local function buildBackWall(assets, wallsFolder)
	local wallFolder = createFolder(wallsFolder, "BackWall")
	local dirtFolder = createFolder(wallFolder, "Dirt")
	local topGrassFolder = createFolder(wallFolder, "TopGrass")
	local sideGrassFolder = createFolder(wallFolder, "SideGrass")

	local backStartZ = COURSE_WALL_LENGTH_BLOCKS
	local backInnerFaceZ = depthToWorldZ(COURSE_WALL_LENGTH_STUDS)

	for zIndex = backStartZ, backStartZ + WALL_THICKNESS_BLOCKS - 1 do
		for xIndex = -WALL_THICKNESS_BLOCKS, INNER_WIDTH_BLOCKS + WALL_THICKNESS_BLOCKS - 1 do
			for yIndex = 0, WALL_HEIGHT_BLOCKS - 1 do
				buildDirtBlock(assets, dirtFolder, xIndex, yIndex, zIndex, "BackWall_Dirt")
			end

			buildTopGrassBlock(assets, topGrassFolder, xIndex, zIndex, "BackWall_TopGrass")
		end
	end

	for xIndex = 0, INNER_WIDTH_BLOCKS - 1 do
		local dripDepth = getDripDepth(xIndex, 47)
		local worldX = blockCenterX(xIndex)

		for depthOffset = 0, dripDepth - 1 do
			local yIndex = WALL_HEIGHT_BLOCKS - 1 - depthOffset
			local worldY = (yIndex * BLOCK_SIZE) + (BLOCK_SIZE / 2)
			buildSideGrassBlock(
				assets,
				sideGrassFolder,
				xIndex,
				yIndex,
				CFrame.new(worldX, worldY, backInnerFaceZ),
				"BackWall_SideGrass"
			)
		end
	end

	wallFolder:SetAttribute("SideGrassVisibleLipStuds", 1)
	wallFolder:SetAttribute("SideGrassEmbeddedLipStuds", 1)
	return wallFolder
end

local function buildWalls(assets, root)
	local wallsFolder = createFolder(root, "Walls")

	buildSideWall(assets, wallsFolder, "LeftWall", -WALL_THICKNESS_BLOCKS, -1, true)
	buildSideWall(assets, wallsFolder, "RightWall", INNER_WIDTH_BLOCKS, INNER_WIDTH_BLOCKS + WALL_THICKNESS_BLOCKS - 1, false)
	buildBackWall(assets, wallsFolder)
end

local function writeDebugAttributes(root)
	root:SetAttribute("GeneratorVersion", VERSION)
	root:SetAttribute("InwardZSign", INWARD_Z_SIGN)
	root:SetAttribute("CourseExtendsToward", "-Z")
	root:SetAttribute("OpenFrontZ", 0)
	root:SetAttribute("OutsideFrontApproachZ", outsideDepthToWorldZ(FRONT_RAMP_RUN_STUDS + FRONT_ENTRY_DEPTH_STUDS))
	root:SetAttribute("RampStartZ", outsideDepthToWorldZ(FRONT_RAMP_RUN_STUDS))
	root:SetAttribute("RampEndZ", 0)
	root:SetAttribute("InnerWidthBlocks", INNER_WIDTH_BLOCKS)
	root:SetAttribute("InnerWidthStuds", INNER_WIDTH_STUDS)
	root:SetAttribute("SectionCount", SECTION_COUNT)
	root:SetAttribute("SectionLengthBlocks", SECTION_LENGTH_BLOCKS)
	root:SetAttribute("SectionLengthStuds", SECTION_LENGTH_STUDS)
	root:SetAttribute("RiverCount", RIVER_COUNT)
	root:SetAttribute("RiverLengthBlocks", RIVER_LENGTH_BLOCKS)
	root:SetAttribute("RiverLengthStuds", RIVER_LENGTH_STUDS)
	root:SetAttribute("RiverDepressionStuds", RIVER_DEPRESSION_STUDS)
	root:SetAttribute("RiverEdgeSupportThicknessStuds", RIVER_EDGE_SUPPORT_THICKNESS_STUDS)
	root:SetAttribute("TotalInnerLengthBlocks", TOTAL_INNER_LENGTH_BLOCKS)
	root:SetAttribute("TotalInnerLengthStuds", TOTAL_INNER_LENGTH_STUDS)
	root:SetAttribute("WallThicknessBlocks", WALL_THICKNESS_BLOCKS)
	root:SetAttribute("WallThicknessStuds", WALL_THICKNESS_STUDS)
	root:SetAttribute("WallHeightBlocks", WALL_HEIGHT_BLOCKS)
	root:SetAttribute("WallHeightStuds", WALL_HEIGHT_STUDS)
	root:SetAttribute("CourseWallLengthBlocksIncludingSafeZone", COURSE_WALL_LENGTH_BLOCKS)
	root:SetAttribute("CourseWallLengthStudsIncludingSafeZone", COURSE_WALL_LENGTH_STUDS)
	root:SetAttribute("FrontIsOpen", true)
	root:SetAttribute("FrontWallGenerated", false)
	root:SetAttribute("RampRunStuds", FRONT_RAMP_RUN_STUDS)
	root:SetAttribute("RampDropStuds", FRONT_RAMP_DROP_STUDS)
	root:SetAttribute("SafeZoneDepthBlocks", SAFE_ZONE_DEPTH_BLOCKS)
	root:SetAttribute("SafeZoneDepthStuds", SAFE_ZONE_DEPTH_STUDS)
	root:SetAttribute("SafeZoneBoundaryLineWidthStuds", SAFE_ZONE_BOUNDARY_LINE_WIDTH_STUDS)
	root:SetAttribute("WhiteBoundaryAtRampStart", true)
	root:SetAttribute("RampColorMatchesSafeZone", true)
	root:SetAttribute("OldGeneratedGeometryClearedBeforeBuild", true)
	root:SetAttribute("WaterMaterialUsedForRivers", true)
	root:SetAttribute("CheckerboardVariationMandatory", true)
	root:SetAttribute("SideGrassVisibleLipStuds", 1)
	root:SetAttribute("SideGrassEmbeddedLipStuds", 1)

	for key, value in pairs(stats) do
		root:SetAttribute(key, value)
	end
end

local function printSummary(root)
	debugPrint("section count", SECTION_COUNT)
	debugPrint("river count", RIVER_COUNT)
	debugPrint("wall height blocks/studs", WALL_HEIGHT_BLOCKS, WALL_HEIGHT_STUDS)
	debugPrint("wall thickness blocks/studs", WALL_THICKNESS_BLOCKS, WALL_THICKNESS_STUDS)
	debugPrint("inner width blocks/studs", INNER_WIDTH_BLOCKS, INNER_WIDTH_STUDS)
	debugPrint("total inner length blocks/studs", TOTAL_INNER_LENGTH_BLOCKS, TOTAL_INNER_LENGTH_STUDS)
	debugPrint("wall dirt blocks", stats.wallDirtCount)
	debugPrint("wall top grass blocks", stats.wallTopGrassCount)
	debugPrint("wall side grass blocks", stats.wallSideGrassCount)
	debugPrint("generated sections", stats.generatedSectionCount)
	debugPrint("generated rivers", stats.generatedRiverCount)
	debugPrint("section floor grass blocks", stats.sectionFloorCount)
	debugPrint("river folders", stats.riverCount)
	debugPrint("river parts", stats.riverPartCount)
	debugPrint("river support parts", stats.riverSupportPartCount)
	debugPrint("safe zone parts", stats.safeZonePartCount)
	debugPrint("ramp parts", stats.rampPartCount)
	debugPrint("entry parts", stats.entryPartCount)
	debugPrint("folders", stats.folderCount)
	debugPrint("final total generated descendants", #root:GetDescendants())
end

local function buildAllCourseGeometry()
	local assets, missing = resolveAssets()
	if not assets then
		debugPrint("course generation stopped; missing assets", table.concat(missing, ", "))
		return
	end

	clearExistingGeneratedCourse()
	clearWorkspaceForLocalCourseTest()

	local root = createFolder(Workspace, GENERATED_FOLDER_NAME)
	root:SetAttribute("BuildInProgress", true)

	debugPrint("BUILD SPEC", "open-front checkerboard canyon course, 61 blocks wide, 11 sections, 10 rivers")
	debugPrint("STYLE MATCH PLAN", "use existing studded modular assets with deterministic light/dark checkerboard variation")
	debugPrint("PART BREAKDOWN", "modular floor blocks, modular dirt walls, modular top grass, modular side grass, placeholder river/water/ramp/safe-zone parts")
	debugPrint("HIERARCHY PLAN", "GeneratedCourseShape/FrontEntry/Sections/Rivers/Walls")

	buildInterior(assets, root)
	buildFrontEntry(root)
	buildWalls(assets, root)

	local debugFolder = createFolder(root, "Debug")
	for assetName, assetPath in pairs(resolvedAssetPaths) do
		debugFolder:SetAttribute(assetName .. "Path", assetPath)
	end

	root:SetAttribute("BuildInProgress", false)
	writeDebugAttributes(root)
	hookCourseSpawn()
	printSummary(root)
end

task.defer(buildAllCourseGeometry)
