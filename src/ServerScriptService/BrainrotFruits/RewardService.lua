local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local RarityConfig = require(brainrotFruits.Shared.RarityConfig)
local FruitConfig = require(brainrotFruits.Configs.BrainrotFruitConfig)
local StrawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)
local StrawberitaVFX = require(brainrotFruits.Shared.StrawberitaVFX)
local FXService = require(script.Parent.FXService)
local PlotService = require(script.Parent.Map.PlotService)

local RewardService = {}

local rng = Random.new()
local printedToolRewardVersion = false

local function printToolRewardVersion()
	if not printedToolRewardVersion then
		print("[BrainrotFruits] StrawberitaToolReward_V1 active")
		printedToolRewardVersion = true
	end
end

local function getOrCreateFolder(parent, name)
	local folder = parent:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end
	return folder
end

local function getBand(distance)
	local selected = RarityConfig.DistanceBands[1]
	for _, band in ipairs(RarityConfig.DistanceBands) do
		if distance >= band.minDistance then
			selected = band
		else
			break
		end
	end
	return selected
end

local function rollWeighted(weights)
	local totalWeight = 0
	for _, weight in pairs(weights) do
		totalWeight += weight
	end

	local roll = rng:NextNumber(0, totalWeight)
	local running = 0

	for variantName, weight in pairs(weights) do
		running += weight
		if roll <= running then
			return variantName
		end
	end

	return FruitConfig.DefaultVariant
end

local function createCratePiece(parent, name, size, cframe, color)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = Enum.Material.WoodPlanks
	part.Anchored = true
	part.CanCollide = false
	part.Parent = parent
	return part
end

local function addToolSurfaceText(part, text, face)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "ToolSurfaceText"
	surface.Face = face or Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 28
	surface.LightInfluence = 0.18
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 245)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.2
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface
end

local function createToolPart(tool, handle, name, size, offset, color, material, transparency)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = handle.CFrame * offset
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Transparency = transparency or 0
	part.Anchored = false
	part.CanCollide = false
	part.Massless = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = tool

	local weld = Instance.new("WeldConstraint")
	weld.Name = "ToolVisualWeld"
	weld.Part0 = handle
	weld.Part1 = part
	weld.Parent = part

	return part
end

local function grantRewardTool(player, reward)
	printToolRewardVersion()

	local backpack = player:FindFirstChildOfClass("Backpack") or player:FindFirstChild("Backpack")
	if not backpack then
		return nil
	end

	local variantName = reward and (reward.variantName or reward.variant) or FruitConfig.DefaultVariant
	local variantConfig = FruitConfig.StrawberitaVariants[variantName] or FruitConfig.StrawberitaVariants[FruitConfig.DefaultVariant]
	local displayName = reward and reward.displayName or variantConfig.displayName or "Base Strawberita"

	local tool = Instance.new("Tool")
	tool.Name = displayName
	tool.ToolTip = `BrainrotFruits reward: {displayName}`
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool:SetAttribute("RewardType", "Strawberita")
	tool:SetAttribute("RewardVariant", variantName)
	tool:SetAttribute("Rarity", reward and reward.rarity or variantConfig.rarity or "Common")
	tool:SetAttribute("OwnerUserId", player.UserId)

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1.15, 1.32, 0.82)
	handle.Color = variantConfig.bodyColor
	handle.Material = variantConfig.material or Enum.Material.SmoothPlastic
	handle.Anchored = false
	handle.CanCollide = false
	handle.Massless = true
	handle.TopSurface = Enum.SurfaceType.Smooth
	handle.BottomSurface = Enum.SurfaceType.Smooth
	handle.Parent = tool
	addToolSurfaceText(handle, "BF", Enum.NormalId.Front)

	createToolPart(tool, handle, "FacePanel", Vector3.new(0.72, 0.42, 0.08), CFrame.new(0, 0.05, -0.45), variantConfig.facePanelColor or variantConfig.bellyColor, Enum.Material.SmoothPlastic)
	createToolPart(tool, handle, "LeftEye", Vector3.new(0.14, 0.18, 0.08), CFrame.new(-0.22, 0.11, -0.52), Color3.fromRGB(18, 18, 18), Enum.Material.SmoothPlastic)
	createToolPart(tool, handle, "RightEye", Vector3.new(0.14, 0.18, 0.08), CFrame.new(0.22, 0.11, -0.52), Color3.fromRGB(18, 18, 18), Enum.Material.SmoothPlastic)
	createToolPart(tool, handle, "LeafCap", Vector3.new(0.82, 0.16, 0.7), CFrame.new(0, 0.74, 0), variantConfig.leafColor or Color3.fromRGB(80, 180, 60), Enum.Material.Grass)
	createToolPart(tool, handle, "Stem", Vector3.new(0.24, 0.38, 0.24), CFrame.new(0, 1.0, 0), variantConfig.leafShadowColor or Color3.fromRGB(55, 130, 45), Enum.Material.Wood)
	createToolPart(tool, handle, "SeedA", Vector3.new(0.13, 0.13, 0.08), CFrame.new(-0.37, 0.36, -0.48), variantConfig.seedColor, variantConfig.seedMaterial)
	createToolPart(tool, handle, "SeedB", Vector3.new(0.13, 0.13, 0.08), CFrame.new(0.37, 0.34, -0.48), variantConfig.seedColor, variantConfig.seedMaterial)

	local effects = variantConfig.effects or {}
	if effects.light then
		local light = Instance.new("PointLight")
		light.Name = "RewardToolGlow"
		light.Color = effects.light
		light.Brightness = 0.55
		light.Range = 8
		light.Parent = handle
	end
	if effects.sparkles then
		local sparkles = Instance.new("Sparkles")
		sparkles.Name = "RewardToolSparkles"
		sparkles.SparkleColor = effects.sparkles
		sparkles.Parent = handle
	end
	StrawberitaVFX.applyToolVFX(tool, variantName)

	tool.Parent = backpack
	return tool
end

local function openCrate(crate, landingPosition)
	local opened = Instance.new("Model")
	opened.Name = "OpenedFruitCrate"
	opened.Parent = crate.Parent

	local baseCFrame = CFrame.new(landingPosition + Vector3.new(0, 0.45, 0))
	createCratePiece(opened, "LeftCrateHalf", Vector3.new(1.2, 0.35, 2.3), baseCFrame * CFrame.new(-0.85, 0, 0) * CFrame.Angles(0, 0, math.rad(18)), Color3.fromRGB(145, 92, 49))
	createCratePiece(opened, "RightCrateHalf", Vector3.new(1.2, 0.35, 2.3), baseCFrame * CFrame.new(0.85, 0, 0) * CFrame.Angles(0, 0, math.rad(-18)), Color3.fromRGB(145, 92, 49))
	createCratePiece(opened, "TopPopLid", Vector3.new(2.1, 0.28, 1.1), baseCFrame * CFrame.new(0, 1.1, -0.7) * CFrame.Angles(math.rad(-28), 0, 0), Color3.fromRGB(166, 109, 61))

	crate.Transparency = 1
	crate.CanCollide = false
	crate:SetAttribute("Opened", true)

	for _, child in ipairs(crate:GetChildren()) do
		if child:IsA("BasePart") then
			child.Transparency = 1
			child.CanCollide = false
		end
	end

	return opened
end

function RewardService.rollVariant(distance)
	local band = getBand(distance)
	local variantName = rollWeighted(band.weights)
	local variantConfig = FruitConfig.StrawberitaVariants[variantName] or FruitConfig.StrawberitaVariants[FruitConfig.DefaultVariant]

	return {
		variantName = variantName,
		displayName = variantConfig.displayName,
		rarity = variantConfig.rarity or RarityConfig.VariantRarity[variantName] or "Common",
		bandName = band.name,
	}
end

function RewardService.revealCrate(player, crate, landingPosition, distance)
	local reward = RewardService.rollVariant(distance)
	local rewardFolder = PlotService.getPlayerRewardsFolder(player)
	local variantConfig = FruitConfig.StrawberitaVariants[reward.variantName] or FruitConfig.StrawberitaVariants[FruitConfig.DefaultVariant]

	local openedCrate = openCrate(crate, landingPosition)
	FXService.emitBurst(crate.Parent, landingPosition + Vector3.new(0, 1.8, 0), Color3.fromRGB(255, 112, 168), "CrateOpenBurst", 34)
	task.delay(10, function()
		if crate.Parent then
			crate:Destroy()
		end
		if openedCrate.Parent then
			openedCrate:Destroy()
		end
	end)

	local model = StrawberitaFactory.create(reward.variantName, {
		anchored = true,
		label = true,
		pivot = CFrame.new(landingPosition + Vector3.new(0, 1.75, 0)) * CFrame.Angles(0, math.rad(180), 0),
	})
	model.Name = reward.displayName
	model:SetAttribute("OwnerUserId", player.UserId)
	model:SetAttribute("Distance", distance)
	model:SetAttribute("BandName", reward.bandName)
	model:SetAttribute("ClaimState", "PendingReturnRun")
	model.Parent = rewardFolder
	StrawberitaVFX.applyVariantVFX(model, reward.variantName, "Reveal")
	FXService.emitBurst(rewardFolder, landingPosition + Vector3.new(0, 2.2, 0), Color3.fromRGB(255, 231, 120), "RevealBurst", 46)
	StrawberitaVFX.playRevealBurst(rewardFolder, landingPosition + Vector3.new(0, 2.35, 0), reward.variantName)

	print(
		`[BrainrotFruits] Pending reveal for {player.Name}: {reward.displayName} ({reward.rarity}) at {math.floor(distance)} studs in {reward.bandName}.`
	)

	local pendingReward = {
		characterId = "Strawberita",
		modelName = model.Name,
		variant = reward.variantName,
		variantName = reward.variantName,
		displayName = reward.displayName,
		rarity = reward.rarity,
		bandName = reward.bandName,
		income = variantConfig and variantConfig.income or 0,
		launchDistance = distance,
		distance = distance,
		ownerUserId = player.UserId,
		plotId = crate:GetAttribute("PlotId"),
	}

	return {
		variantName = reward.variantName,
		displayName = reward.displayName,
		rarity = reward.rarity,
		bandName = reward.bandName,
		distance = distance,
		launchDistance = distance,
		position = landingPosition,
		plotId = crate:GetAttribute("PlotId"),
		modelName = model.Name,
		rewardModel = model,
		pendingReward = pendingReward,
	}
end

function RewardService.claimPendingReward(player, rewardModel, reward)
	if not rewardModel or not rewardModel.Parent then
		return nil, "MissingRewardModel"
	end

	local placedSlot = PlotService.placeRewardOnSlot(player, rewardModel, reward)
	if not placedSlot then
		return nil, "NoEmptySlots"
	end

	rewardModel:SetAttribute("ClaimState", "Secured")
	rewardModel:SetAttribute("ClaimedByUserId", player.UserId)
	rewardModel:SetAttribute("DisplaySlotIndex", placedSlot:GetAttribute("SlotIndex"))
	local rewardTool = grantRewardTool(player, reward)
	if rewardTool then
		rewardModel:SetAttribute("RewardToolName", rewardTool.Name)
		rewardModel:SetAttribute("RewardToolGranted", true)
	end
	StrawberitaVFX.playRewardSecuredBurst(rewardModel.Parent, rewardModel:GetPivot().Position + Vector3.new(0, 1.7, 0), reward.variantName)
	print(`[BrainrotFruits] Secured {reward.displayName or rewardModel.Name} on Plot {placedSlot:GetAttribute("PlotId")} Slot {placedSlot:GetAttribute("SlotIndex")}.`)

	return placedSlot
end

printToolRewardVersion()

return RewardService
