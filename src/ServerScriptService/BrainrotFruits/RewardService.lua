local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CharacterAnimationService = require(brainrotFruits.Modules.CharacterAnimationService)
local CharacterModelFactory = require(brainrotFruits.Modules.CharacterModelFactory)
local CharacterRegistry = require(brainrotFruits.Modules.CharacterRegistry)
local CharacterVariantService = require(brainrotFruits.Modules.CharacterVariantService)
local RarityConfig = require(brainrotFruits.Shared.RarityConfig)
local FXService = require(script.Parent.FXService)
local PlotService = require(script.Parent.Map.PlotService)

local RewardService = {}

local rng = Random.new()
local printedToolRewardVersion = false

local BASE_INCOME_PER_SECOND = 4
local BASE_VALUE = 1100
-- Economy tuning lives here for now; roster weights and variant multipliers live in CharacterRegistry.

local TOOL_BASE_COLORS = {
	Strawberita = Color3.fromRGB(239, 52, 61),
	BananitoBandito = Color3.fromRGB(255, 218, 72),
	CoconuttoBonkini = Color3.fromRGB(116, 73, 43),
	LemonaldoSprintini = Color3.fromRGB(255, 223, 63),
	WatermeloniWobblino = Color3.fromRGB(72, 178, 75),
	DragonfruttoDrippo = Color3.fromRGB(235, 64, 145),
}

local TOOL_ACCENT_COLORS = {
	Strawberita = Color3.fromRGB(93, 181, 28),
	BananitoBandito = Color3.fromRGB(112, 72, 39),
	CoconuttoBonkini = Color3.fromRGB(255, 236, 190),
	LemonaldoSprintini = Color3.fromRGB(56, 190, 92),
	WatermeloniWobblino = Color3.fromRGB(221, 64, 55),
	DragonfruttoDrippo = Color3.fromRGB(66, 216, 116),
}

local TOOL_INITIALS = {
	Strawberita = "SB",
	BananitoBandito = "BB",
	CoconuttoBonkini = "CB",
	LemonaldoSprintini = "LS",
	WatermeloniWobblino = "WW",
	DragonfruttoDrippo = "DD",
}

local function printToolRewardVersion()
	if not printedToolRewardVersion then
		print("[BrainrotFruits] BrainrotCharacterRewardTool_V1 active")
		printedToolRewardVersion = true
	end
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

local function rollWeighted(weights, fallback)
	local totalWeight = 0
	for _, weight in pairs(weights) do
		totalWeight += weight
	end

	local roll = rng:NextNumber(0, math.max(totalWeight, 1))
	local running = 0

	for name, weight in pairs(weights) do
		running += weight
		if roll <= running then
			return name
		end
	end

	return fallback or RarityConfig.DefaultVariant or "Base"
end

local function rollWeightedEntries(entries, fallback)
	local totalWeight = 0
	for _, entry in ipairs(entries) do
		totalWeight += entry.weight or 0
	end

	local roll = rng:NextNumber(0, math.max(totalWeight, 1))
	local running = 0

	for _, entry in ipairs(entries) do
		running += entry.weight or 0
		if roll <= running then
			return entry.id
		end
	end

	return fallback or "Strawberita"
end

local function getRewardEconomy(character, variant)
	local incomeMultiplier = (character.IncomeMultiplier or 1) * (variant.IncomeMultiplierModifier or 1)
	local visualTier = variant.VisualTier or 1
	local income = math.max(1, math.floor(BASE_INCOME_PER_SECOND * incomeMultiplier + 0.5))
	local value = math.max(25, math.floor(BASE_VALUE * incomeMultiplier * visualTier + 0.5))
	return income, value, incomeMultiplier
end

local function buildRewardData(characterId, variantId, distance, bandName)
	local character = CharacterRegistry.getCharacter(characterId)
	local variant, normalizedVariantId = CharacterRegistry.getVariant(character.Id, variantId)
	local income, value, incomeMultiplier = getRewardEconomy(character, variant)

	return {
		characterId = character.Id,
		baseDisplayName = character.DisplayName,
		baseFruit = character.BaseFruit,
		modelName = character.PlaceholderModelName,
		variant = normalizedVariantId,
		variantName = normalizedVariantId,
		displayName = variant.DisplayName or character.DisplayName,
		rarity = variant.Rarity or character.Rarity or "Common",
		bandName = bandName,
		income = income,
		incomePerSecond = income,
		incomeMultiplier = incomeMultiplier,
		value = value,
		launchDistance = distance,
		distance = distance,
	}
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

local function getToolColors(character, variant)
	local palette = variant.Palette or {}
	local fruitColor = palette.Fruit or TOOL_BASE_COLORS[character.Id] or Color3.fromRGB(255, 112, 168)
	local accentColor = palette.Leaf or palette.Accent or TOOL_ACCENT_COLORS[character.Id] or Color3.fromRGB(255, 238, 128)
	local seedColor = palette.Seed or palette.Accent or Color3.fromRGB(255, 255, 245)
	return fruitColor, accentColor, seedColor
end

local function grantRewardTool(player, reward)
	printToolRewardVersion()

	local backpack = player:FindFirstChildOfClass("Backpack") or player:FindFirstChild("Backpack")
	if not backpack then
		return nil
	end

	local character = CharacterRegistry.getCharacter(reward and reward.characterId)
	local variant, normalizedVariantId = CharacterRegistry.getVariant(character.Id, reward and (reward.variantName or reward.variant))
	local displayName = reward and reward.displayName or variant.DisplayName or character.DisplayName
	local fruitColor, accentColor, seedColor = getToolColors(character, variant)

	local tool = Instance.new("Tool")
	tool.Name = displayName
	tool.ToolTip = `BrainrotFruits reward: {displayName}`
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool:SetAttribute("RewardType", "BrainrotFruit")
	tool:SetAttribute("CharacterId", character.Id)
	tool:SetAttribute("BaseFruit", character.BaseFruit)
	tool:SetAttribute("RewardVariant", normalizedVariantId)
	tool:SetAttribute("VariantName", normalizedVariantId)
	tool:SetAttribute("Rarity", reward and reward.rarity or variant.Rarity or "Common")
	tool:SetAttribute("OwnerUserId", player.UserId)

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1.2, 1.32, 0.82)
	handle.Color = fruitColor
	handle.Material = variant.Material or Enum.Material.SmoothPlastic
	handle.Anchored = false
	handle.CanCollide = false
	handle.Massless = true
	handle.TopSurface = Enum.SurfaceType.Smooth
	handle.BottomSurface = Enum.SurfaceType.Smooth
	handle.Parent = tool
	addToolSurfaceText(handle, TOOL_INITIALS[character.Id] or "BF", Enum.NormalId.Front)

	createToolPart(tool, handle, "FacePanel", Vector3.new(0.72, 0.42, 0.08), CFrame.new(0, 0.05, -0.45), fruitColor:Lerp(Color3.fromRGB(255, 255, 245), 0.35), Enum.Material.SmoothPlastic)
	createToolPart(tool, handle, "LeftEye", Vector3.new(0.13, 0.18, 0.08), CFrame.new(-0.22, 0.11, -0.52), Color3.fromRGB(18, 18, 18), Enum.Material.SmoothPlastic)
	createToolPart(tool, handle, "RightEye", Vector3.new(0.13, 0.18, 0.08), CFrame.new(0.22, 0.11, -0.52), Color3.fromRGB(18, 18, 18), Enum.Material.SmoothPlastic)
	createToolPart(tool, handle, "TopAccent", Vector3.new(0.82, 0.16, 0.7), CFrame.new(0, 0.74, 0), accentColor, Enum.Material.SmoothPlastic)
	createToolPart(tool, handle, "SparkleSeedA", Vector3.new(0.13, 0.13, 0.08), CFrame.new(-0.37, 0.36, -0.48), seedColor, Enum.Material.Neon)
	createToolPart(tool, handle, "SparkleSeedB", Vector3.new(0.13, 0.13, 0.08), CFrame.new(0.37, 0.34, -0.48), seedColor, Enum.Material.Neon)

	CharacterVariantService.applyToolVFX(tool, character.Id, normalizedVariantId)

	tool.Parent = backpack
	return tool
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

function RewardService.rollReward(distance)
	local band = getBand(distance)
	local variantName = rollWeighted(band.weights, RarityConfig.DefaultVariant or "Base")
	local characterId = rollWeightedEntries(CharacterRegistry.getWeightedCharacters(), "Strawberita")
	return buildRewardData(characterId, variantName, distance, band.name)
end

function RewardService.rollVariant(distance)
	return RewardService.rollReward(distance)
end

function RewardService.revealCrate(player, crate, landingPosition, distance)
	local reward = RewardService.rollReward(distance)
	local rewardFolder = PlotService.getPlayerRewardsFolder(player)
	local variantConfig = CharacterVariantService.getConfig(reward.characterId, reward.variantName)

	local openedCrate = openCrate(crate, landingPosition)
	FXService.emitBurst(crate.Parent, landingPosition + Vector3.new(0, 1.8, 0), variantConfig.burstColorA or Color3.fromRGB(255, 112, 168), "CrateOpenBurst", 34)
	task.delay(10, function()
		if crate.Parent then
			crate:Destroy()
		end
		if openedCrate.Parent then
			openedCrate:Destroy()
		end
	end)

	local model = CharacterModelFactory.create(reward.characterId, reward.variantName, {
		anchored = true,
		context = "Reveal",
		label = true,
		pivot = CFrame.new(landingPosition + Vector3.new(0, 1.75, 0)) * CFrame.Angles(0, math.rad(180), 0),
	})
	model.Name = reward.displayName
	model:SetAttribute("OwnerUserId", player.UserId)
	model:SetAttribute("Distance", distance)
	model:SetAttribute("BandName", reward.bandName)
	model:SetAttribute("ClaimState", "PendingReturnRun")
	model:SetAttribute("IncomePerSecond", reward.incomePerSecond)
	model:SetAttribute("RewardValue", reward.value)
	model.Parent = rewardFolder

	FXService.emitBurst(rewardFolder, landingPosition + Vector3.new(0, 2.2, 0), variantConfig.burstColorB or Color3.fromRGB(255, 231, 120), "RevealBurst", 42)
	CharacterVariantService.playRevealBurst(rewardFolder, landingPosition + Vector3.new(0, 2.35, 0), reward.characterId, reward.variantName)
	task.spawn(function()
		CharacterAnimationService.playIntro(model, reward)
	end)

	print(
		`[BrainrotFruits] Pending reveal for {player.Name}: {reward.displayName} ({reward.rarity}) at {math.floor(distance)} studs in {reward.bandName}.`
	)

	local pendingReward = table.clone(reward)
	pendingReward.ownerUserId = player.UserId
	pendingReward.plotId = crate:GetAttribute("PlotId")

	return {
		characterId = reward.characterId,
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
	if rewardModel:GetAttribute("RewardToolGranted") ~= true then
		local rewardTool = grantRewardTool(player, reward)
		if rewardTool then
			rewardModel:SetAttribute("RewardToolName", rewardTool.Name)
			rewardModel:SetAttribute("RewardToolGranted", true)
		end
	end

	CharacterVariantService.playRewardSecuredBurst(
		rewardModel.Parent,
		rewardModel:GetPivot().Position + Vector3.new(0, 1.7, 0),
		reward.characterId,
		reward.variantName
	)
	print(`[BrainrotFruits] Secured {reward.displayName or rewardModel.Name} on Plot {placedSlot:GetAttribute("PlotId")} Slot {placedSlot:GetAttribute("SlotIndex")}.`)

	return placedSlot
end

printToolRewardVersion()

return RewardService
