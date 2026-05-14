local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local RarityConfig = require(brainrotFruits.Shared.RarityConfig)
local FruitConfig = require(brainrotFruits.Configs.BrainrotFruitConfig)
local StrawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)
local FXService = require(script.Parent.FXService)
local PlotService = require(script.Parent.Map.PlotService)

local RewardService = {}

local rng = Random.new()

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
	FXService.emitBurst(rewardFolder, landingPosition + Vector3.new(0, 2.2, 0), Color3.fromRGB(255, 231, 120), "RevealBurst", 46)

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
	print(`[BrainrotFruits] Secured {reward.displayName or rewardModel.Name} on Plot {placedSlot:GetAttribute("PlotId")} Slot {placedSlot:GetAttribute("SlotIndex")}.`)

	return placedSlot
end

return RewardService
