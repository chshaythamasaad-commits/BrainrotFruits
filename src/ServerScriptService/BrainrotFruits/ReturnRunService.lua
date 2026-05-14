local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CatapultConfig = require(brainrotFruits.Shared.CatapultConfig)
local ChaosHazardService = require(script.Parent.ChaosHazardService)
local FXService = require(script.Parent.FXService)
local PlotService = require(script.Parent.Map.PlotService)
local RewardService = require(script.Parent.RewardService)
local StrawberitaTransformService = require(script.Parent.StrawberitaTransformService)

local ReturnRunService = {}

local activeByUserId = {}
local claimConnections = {}
local initialized = false

local function getOrCreateFolder(parent, name)
	local folder = parent:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end
	return folder
end

local function getOrCreateRemote(folder, name)
	local remote = folder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
	end
	return remote
end

local remoteFolder = getOrCreateFolder(brainrotFruits, CatapultConfig.RemoteFolderName)
local returnRunRemote = getOrCreateRemote(remoteFolder, CatapultConfig.Remotes.ReturnRunStatus)

local function getHumanoid(player)
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getPlayerFromHit(hit)
	local character = hit and hit:FindFirstAncestorOfClass("Model")
	if not character then
		return nil
	end
	return Players:GetPlayerFromCharacter(character)
end

local function setPlayerReturnAttributes(player, state)
	player:SetAttribute("PendingRewardName", state and state.reward.displayName or "")
	player:SetAttribute("PendingRewardVariant", state and state.reward.variantName or "")
	player:SetAttribute("ReturnRunActive", state ~= nil)
	player:SetAttribute("ReturnRunSpeedBoostActive", state ~= nil)
end

local function applySpeedBoost(player, state)
	local humanoid = getHumanoid(player)
	if not humanoid then
		return
	end

	state.humanoid = humanoid
	state.originalWalkSpeed = humanoid.WalkSpeed
	state.originalJumpPower = humanoid.JumpPower
	state.originalJumpHeight = humanoid.JumpHeight
	humanoid.WalkSpeed = CatapultConfig.ReturnRunWalkSpeed
end

local function restoreSpeedBoost(state)
	local humanoid = state and state.humanoid
	if humanoid and humanoid.Parent then
		humanoid.WalkSpeed = state.originalWalkSpeed or 16
		humanoid.JumpPower = state.originalJumpPower or humanoid.JumpPower
		humanoid.JumpHeight = state.originalJumpHeight or humanoid.JumpHeight
	end
end

local function fireStatus(player, payload)
	payload.ok = payload.ok ~= false
	returnRunRemote:FireClient(player, payload)
end

local function clearState(player, state)
	activeByUserId[player.UserId] = nil
	setPlayerReturnAttributes(player, nil)
	restoreSpeedBoost(state)
	StrawberitaTransformService.finish(player, false)

	if state.diedConnection then
		state.diedConnection:Disconnect()
	end
	if state.hazard and state.hazard.Parent then
		state.hazard:Destroy()
	end
end

function ReturnRunService.fail(player, reason, shouldRespawn)
	local state = activeByUserId[player.UserId]
	if not state or state.ending then
		return false
	end
	state.ending = true

	local rewardModel = state.rewardModel
	if rewardModel and rewardModel.Parent then
		rewardModel:SetAttribute("ClaimState", "Lost")
		FXService.emitBurst(rewardModel.Parent, rewardModel:GetPivot().Position + Vector3.new(0, 2.2, 0), Color3.fromRGB(255, 91, 129), "RewardLostBurst", 28)
		rewardModel:Destroy()
	end

	clearState(player, state)
	fireStatus(player, {
		status = "Lost",
		reason = reason or "RewardLost",
		message = reason == "NoEmptySlots" and "No empty slots!" or "Reward Lost!",
	})

	if shouldRespawn then
		local humanoid = getHumanoid(player)
		if humanoid and humanoid.Health > 0 then
			humanoid.Health = 0
		end
	end

	print(`[BrainrotFruits] Return run failed for {player.Name}: {reason or "RewardLost"}.`)
	return true
end

function ReturnRunService.claim(player)
	local state = activeByUserId[player.UserId]
	if not state or state.ending then
		return false
	end
	state.ending = true

	local placedSlot, reason = RewardService.claimPendingReward(player, state.rewardModel, state.reward)
	if not placedSlot then
		state.ending = false
		return ReturnRunService.fail(player, reason or "NoEmptySlots", false)
	end

	FXService.emitBurst(placedSlot.Parent, placedSlot.Position + Vector3.new(0, 3, 0), Color3.fromRGB(103, 255, 139), "RewardSecuredBurst", 34)
	clearState(player, state)
	fireStatus(player, {
		status = "Secured",
		message = "Reward Secured!",
		displayName = state.reward.displayName,
		rarity = state.reward.rarity,
		slotIndex = placedSlot:GetAttribute("SlotIndex"),
		plotId = placedSlot:GetAttribute("PlotId"),
	})

	print(`[BrainrotFruits] Return run secured for {player.Name}: {state.reward.displayName}.`)
	return true
end

local function onClaimZoneTouched(zone, hit)
	local player = getPlayerFromHit(hit)
	if not player then
		return
	end

	local state = activeByUserId[player.UserId]
	if not state then
		return
	end

	local zonePlotId = zone:GetAttribute("PlotId")
	if zonePlotId ~= state.plotId then
		return
	end

	local playerPlot = PlotService.getPlayerPlot(player)
	if not playerPlot or playerPlot:GetAttribute("PlotId") ~= zonePlotId then
		return
	end

	ReturnRunService.claim(player)
end

local function bindClaimZones()
	for _, connection in ipairs(claimConnections) do
		connection:Disconnect()
	end
	table.clear(claimConnections)

	local plotsFolder = PlotService.getPlotsFolder()
	for _, plot in ipairs(plotsFolder:GetChildren()) do
		local claimZone = plot:IsA("Model") and plot:FindFirstChild("BaseClaimZone")
		if claimZone and claimZone:IsA("BasePart") then
			table.insert(claimConnections, claimZone.Touched:Connect(function(hit)
				onClaimZoneTouched(claimZone, hit)
			end))
		end
	end
end

function ReturnRunService.hasActiveRun(player)
	return activeByUserId[player.UserId] ~= nil
end

function ReturnRunService.start(player, reveal)
	if activeByUserId[player.UserId] then
		ReturnRunService.fail(player, "Interrupted", false)
	end

	local plot = PlotService.getPlayerPlot(player) or PlotService.assignPlayer(player)
	local rewardModel = reveal and reveal.rewardModel
	local reward = reveal and reveal.pendingReward
	if not plot or not rewardModel or not reward then
		return false, "ReturnRunMissingReward"
	end

	local humanoid = getHumanoid(player)
	if not humanoid then
		return false, "CharacterNotReady"
	end

	local state = {
		player = player,
		plot = plot,
		plotId = plot:GetAttribute("PlotId"),
		rewardModel = rewardModel,
		reward = reward,
		startedAt = os.clock(),
	}
	activeByUserId[player.UserId] = state

	setPlayerReturnAttributes(player, state)
	applySpeedBoost(player, state)
	state.diedConnection = humanoid.Died:Connect(function()
		ReturnRunService.fail(player, "Bonked", false)
	end)

	fireStatus(player, {
		status = "Started",
		message = "Run back to your base to keep it!",
		displayName = reward.displayName,
		rarity = reward.rarity,
		plotId = state.plotId,
		timeoutSeconds = CatapultConfig.ReturnRunTimeoutSeconds,
	})

	task.delay(0.75, function()
		if activeByUserId[player.UserId] == state and rewardModel.Parent then
			state.hazard = ChaosHazardService.spawnReturnBonker(player, rewardModel, function()
				ReturnRunService.fail(player, "Bonked", true)
			end)
		end
	end)

	task.delay(CatapultConfig.ReturnRunTimeoutSeconds, function()
		if activeByUserId[player.UserId] == state then
			ReturnRunService.fail(player, "TimedOut", false)
		end
	end)

	print(`[BrainrotFruits] Return run started for {player.Name}; reward must be secured at Plot {state.plotId}.`)
	return true
end

function ReturnRunService.init()
	if initialized then
		return
	end
	initialized = true
	bindClaimZones()
	print("[BrainrotFruits] ReturnRun_V1 active")
end

Players.PlayerRemoving:Connect(function(player)
	local state = activeByUserId[player.UserId]
	if state then
		if state.rewardModel and state.rewardModel.Parent then
			state.rewardModel:Destroy()
		end
		clearState(player, state)
	end
end)

return ReturnRunService
