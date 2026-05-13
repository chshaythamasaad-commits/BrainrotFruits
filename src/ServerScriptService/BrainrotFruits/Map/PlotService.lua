local Players = game:GetService("Players")

local MapBuilder = require(script.Parent.MapBuilder)
local CatapultBinder = require(script.Parent.CatapultBinder)

local PlotService = {}

local map
local plotsFolder
local playerPlots = {}

local function getOwnerText(plot)
	local ownerName = plot:GetAttribute("OwnerName")
	if ownerName and ownerName ~= "" then
		return `{ownerName}'s Plot`
	end
	return "Unclaimed Plot"
end

local function updateOwnerSign(plot)
	local sign = plot:FindFirstChild("OwnerSignPost")
	local billboard = sign and sign:FindFirstChild("OwnerBillboard")
	local text = billboard and billboard:FindFirstChild("Text")
	if text and text:IsA("TextLabel") then
		text.Text = `Plot {plot:GetAttribute("PlotId")}\n{getOwnerText(plot)}`
	end
end

local function getSortedPlots()
	local plots = {}
	for _, plot in ipairs(plotsFolder:GetChildren()) do
		if plot:IsA("Model") then
			table.insert(plots, plot)
		end
	end

	table.sort(plots, function(left, right)
		return (left:GetAttribute("PlotId") or 0) < (right:GetAttribute("PlotId") or 0)
	end)

	return plots
end

local function getPlotSpawnCFrame(plot)
	local spawnPad = plot:FindFirstChild("SpawnPad")
	if spawnPad and spawnPad:IsA("BasePart") then
		return spawnPad.CFrame + Vector3.new(0, 4, 0)
	end
	return plot:GetPivot() + Vector3.new(0, 7, 0)
end

local function teleportCharacterToPlot(player, plot)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root and plot then
		root.CFrame = getPlotSpawnCFrame(plot)
	end
end

local function resetPlotSlots(plot)
	local slots = plot:FindFirstChild("FruitSlots")
	if not slots then
		return
	end

	for _, slot in ipairs(slots:GetChildren()) do
		if slot:IsA("BasePart") then
			slot:SetAttribute("Occupied", false)
			slot:SetAttribute("OwnerUserId", 0)
			slot:SetAttribute("FruitVariant", "")
			slot:SetAttribute("FruitDisplayName", "")
		end
	end
end

local function clearPlotRuntimeFolders(plot)
	for _, folderName in ipairs({ "ActiveCrates", "RevealedRewards", "ChaosHazards" }) do
		local folder = plot:FindFirstChild(folderName)
		if folder then
			folder:ClearAllChildren()
		end
	end
end

function PlotService.init()
	if map and map.Parent then
		return
	end

	map = MapBuilder.build()
	plotsFolder = map:WaitForChild("Plots")
	CatapultBinder.bindAll(plotsFolder)

	for _, player in ipairs(Players:GetPlayers()) do
		task.defer(function()
			PlotService.assignPlayer(player)
		end)
	end

	print("[BrainrotFruits] PlotService ready for 6-player plot assignment.")
end

function PlotService.getMap()
	PlotService.init()
	return map
end

function PlotService.getPlotsFolder()
	PlotService.init()
	return plotsFolder
end

function PlotService.getMapFolder(name)
	PlotService.init()
	local folder = map:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = map
	end
	return folder
end

function PlotService.getPlotById(plotId)
	PlotService.init()
	return plotsFolder:FindFirstChild(`Plot{plotId}`)
end

function PlotService.getPlayerPlot(player)
	PlotService.init()
	return playerPlots[player.UserId]
end

function PlotService.assignPlayer(player)
	PlotService.init()

	if playerPlots[player.UserId] then
		return playerPlots[player.UserId]
	end

	for _, plot in ipairs(getSortedPlots()) do
		local ownerUserId = plot:GetAttribute("OwnerUserId") or 0
		if ownerUserId == 0 then
			plot:SetAttribute("OwnerUserId", player.UserId)
			plot:SetAttribute("OwnerName", player.Name)
			plot:SetAttribute("Status", "Claimed")
			playerPlots[player.UserId] = plot

			local zone = PlotService.getPlayerCatapultZone(player)
			if zone then
				zone:SetAttribute("OwnerUserId", player.UserId)
				zone:SetAttribute("OwnerName", player.Name)
			end

			updateOwnerSign(plot)
			teleportCharacterToPlot(player, plot)
			print(`[BrainrotFruits] Assigned {player.Name} to Plot {plot:GetAttribute("PlotId")}.`)
			return plot
		end
	end

	warn(`[BrainrotFruits] No open plots for {player.Name}.`)
	return nil
end

function PlotService.releasePlayer(player)
	local plot = playerPlots[player.UserId]
	if not plot then
		return
	end

	plot:SetAttribute("OwnerUserId", 0)
	plot:SetAttribute("OwnerName", "")
	plot:SetAttribute("Status", "Unclaimed")
	resetPlotSlots(plot)
	clearPlotRuntimeFolders(plot)

	local zone = PlotService.getPlayerCatapultZone(player)
	if zone then
		zone:SetAttribute("OwnerUserId", 0)
		zone:SetAttribute("OwnerName", "")
	end

	playerPlots[player.UserId] = nil
	updateOwnerSign(plot)
	print(`[BrainrotFruits] Freed Plot {plot:GetAttribute("PlotId")} from {player.Name}.`)
end

function PlotService.getPlayerCatapultZone(player)
	local plot = PlotService.getPlayerPlot(player)
	local catapult = plot and plot:FindFirstChild("Catapult")
	return catapult and catapult:FindFirstChild("InteractZone")
end

function PlotService.getPlayerCratesFolder(player)
	local plot = PlotService.getPlayerPlot(player)
	local folder = plot and plot:FindFirstChild("ActiveCrates")
	if not folder and plot then
		folder = Instance.new("Folder")
		folder.Name = "ActiveCrates"
		folder.Parent = plot
	end
	return folder or PlotService.getMapFolder("ActiveCrates")
end

function PlotService.getPlayerRewardsFolder(player)
	local plot = PlotService.getPlayerPlot(player)
	local folder = plot and plot:FindFirstChild("RevealedRewards")
	if not folder and plot then
		folder = Instance.new("Folder")
		folder.Name = "RevealedRewards"
		folder.Parent = plot
	end
	return folder or PlotService.getMapFolder("RevealedRewards")
end

function PlotService.getPlayerHazardsFolder(player)
	local plot = PlotService.getPlayerPlot(player)
	local folder = plot and plot:FindFirstChild("ChaosHazards")
	if not folder and plot then
		folder = Instance.new("Folder")
		folder.Name = "ChaosHazards"
		folder.Parent = plot
	end
	return folder or PlotService.getMapFolder("ChaosHazards")
end

function PlotService.getNextOpenSlot(player)
	local plot = PlotService.getPlayerPlot(player)
	local slots = plot and plot:FindFirstChild("FruitSlots")
	if not slots then
		return nil
	end

	local slotList = {}
	for _, slot in ipairs(slots:GetChildren()) do
		if slot:IsA("BasePart") then
			table.insert(slotList, slot)
		end
	end

	table.sort(slotList, function(left, right)
		return (left:GetAttribute("SlotIndex") or 0) < (right:GetAttribute("SlotIndex") or 0)
	end)

	for _, slot in ipairs(slotList) do
		if slot:GetAttribute("Occupied") ~= true then
			return slot
		end
	end

	return nil
end

function PlotService.placeRewardOnSlot(player, rewardModel, reward)
	local slot = PlotService.getNextOpenSlot(player)
	if not slot or not rewardModel or not rewardModel.PrimaryPart then
		return nil
	end

	slot:SetAttribute("Occupied", true)
	slot:SetAttribute("OwnerUserId", player.UserId)
	slot:SetAttribute("FruitVariant", reward.variantName or "")
	slot:SetAttribute("FruitDisplayName", reward.displayName or rewardModel.Name)

	local yOffset = (slot.Size.Y / 2) + 1.65
	rewardModel:PivotTo(slot.CFrame * CFrame.new(0, yOffset, 0) * CFrame.Angles(0, math.rad(180), 0))
	rewardModel:SetAttribute("DisplaySlotIndex", slot:GetAttribute("SlotIndex"))
	rewardModel:SetAttribute("PlotId", slot:GetAttribute("PlotId"))

	return slot
end

Players.PlayerAdded:Connect(function(player)
	PlotService.assignPlayer(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.15)
		teleportCharacterToPlot(player, PlotService.getPlayerPlot(player))
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	PlotService.releasePlayer(player)
end)

return PlotService
