local Workspace = game:GetService("Workspace")

local FXService = require(script.Parent.FXService)
local PlotService = require(script.Parent.Map.PlotService)

local ChaosHazardService = {}

local PLACEHOLDER_SPEED = 7
local BONK_DISTANCE = 2.6
local MAX_CHASE_SECONDS = 10

local function getOrCreateFolder(parent, name)
	local folder = parent:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end
	return folder
end

local function getHazardFolder()
	local map = PlotService.getMap()
	return getOrCreateFolder(map or Workspace, "ChaosHazards")
end

local function makeBlobPart(model, root, name, size, cframe, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Shape = Enum.PartType.Ball
	part.Size = size
	part.CFrame = root.CFrame * cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part.Parent = model

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = part
	weld.Parent = part

	return part
end

local function addBlobLabel(root)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PlaceholderLabel"
	billboard.Size = UDim2.fromOffset(130, 30)
	billboard.StudsOffset = Vector3.new(0, 2.2, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 48
	billboard.Parent = root

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = "Wobble Blob"
	label.TextColor3 = Color3.fromRGB(198, 255, 231)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.35
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard
end

local function addBonkLabel(rewardModel)
	local root = rewardModel.PrimaryPart
	if not root then
		return
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PlaceholderBonkLabel"
	billboard.Size = UDim2.fromOffset(150, 36)
	billboard.StudsOffset = Vector3.new(0, 3.6, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 55
	billboard.Parent = root

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBlack
	label.Text = "BONKED"
	label.TextColor3 = Color3.fromRGB(255, 249, 148)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.25
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard
end

local function createWobbleBlob(position, parent)
	local model = Instance.new("Model")
	model.Name = "WobbleBlobPlaceholder"
	model:SetAttribute("PlaceholderSystem", "Future survive/claim hazard")

	local root = Instance.new("Part")
	root.Name = "Root"
	root.Shape = Enum.PartType.Ball
	root.Size = Vector3.new(2.3, 1.7, 2.3)
	root.CFrame = CFrame.new(position)
	root.Color = Color3.fromRGB(77, 208, 176)
	root.Material = Enum.Material.SmoothPlastic
	root.Anchored = true
	root.CanCollide = false
	root.Parent = model
	model.PrimaryPart = root

	makeBlobPart(model, root, "LeftEye", Vector3.new(0.34, 0.34, 0.12), CFrame.new(-0.42, 0.36, -1.04), Color3.fromRGB(255, 255, 255))
	makeBlobPart(model, root, "RightEye", Vector3.new(0.34, 0.34, 0.12), CFrame.new(0.42, 0.36, -1.04), Color3.fromRGB(255, 255, 255))
	makeBlobPart(model, root, "LeftPupil", Vector3.new(0.14, 0.14, 0.08), CFrame.new(-0.38, 0.33, -1.12), Color3.fromRGB(35, 42, 46))
	makeBlobPart(model, root, "RightPupil", Vector3.new(0.14, 0.14, 0.08), CFrame.new(0.38, 0.33, -1.12), Color3.fromRGB(35, 42, 46))
	makeBlobPart(model, root, "TopWobble", Vector3.new(0.85, 0.5, 0.85), CFrame.new(0.18, 0.88, 0), Color3.fromRGB(114, 237, 203))

	addBlobLabel(root)
	model.Parent = parent or getHazardFolder()

	return model
end

local function bonkReward(player, hazard, rewardModel)
	rewardModel:SetAttribute("BonkedByPlaceholder", true)
	rewardModel:SetAttribute("BonkedByUserId", player.UserId)
	hazard:SetAttribute("SequenceEnded", true)

	addBonkLabel(rewardModel)
	FXService.emitBurst(hazard.Parent, rewardModel:GetPivot().Position + Vector3.new(0, 2.2, 0), Color3.fromRGB(255, 249, 148), "BonkCloudBurst", 36)
	print(`[BrainrotFruits] Wobble Blob placeholder bonked {rewardModel.Name}; future claim/survive rules go here.`)
end

local function getPlayerRoot(player)
	local character = player.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

function ChaosHazardService.spawnWobbleBlob(player, rewardModel)
	if not rewardModel or not rewardModel.PrimaryPart then
		return nil
	end

	local rewardPosition = rewardModel:GetPivot().Position
	local spawnPosition = rewardPosition + Vector3.new(10, 1.1, -8)
	local hazard = createWobbleBlob(spawnPosition, PlotService.getPlayerHazardsFolder(player))
	local startedAt = os.clock()

	task.spawn(function()
		while hazard.Parent and rewardModel.Parent and os.clock() - startedAt < MAX_CHASE_SECONDS do
			local currentPosition = hazard:GetPivot().Position
			local targetPosition = rewardModel:GetPivot().Position + Vector3.new(0, 0.8, 0)
			local offset = targetPosition - currentPosition
			local distance = offset.Magnitude

			if distance <= BONK_DISTANCE then
				bonkReward(player, hazard, rewardModel)
				break
			end

			local step = math.min(distance, PLACEHOLDER_SPEED * 0.08)
			local wobble = math.sin(os.clock() * 8) * 0.12
			local nextPosition = currentPosition + offset.Unit * step
			hazard:PivotTo(CFrame.new(nextPosition + Vector3.new(0, wobble, 0), targetPosition))
			task.wait(0.08)
		end
	end)

	return hazard
end

function ChaosHazardService.spawnReturnBonker(player, rewardModel, onBonked)
	if not rewardModel or not rewardModel.PrimaryPart then
		return nil
	end

	local rewardPosition = rewardModel:GetPivot().Position
	local spawnPosition = rewardPosition + Vector3.new(13, 1.1, -10)
	local hazard = createWobbleBlob(spawnPosition, PlotService.getPlayerHazardsFolder(player))
	hazard.Name = "ReturnRunBonker"
	hazard:SetAttribute("Type", "ReturnRunBonker")
	hazard:SetAttribute("TargetUserId", player.UserId)
	hazard:SetAttribute("SafeCartoonHazard", true)

	local startedAt = os.clock()
	task.spawn(function()
		while hazard.Parent and player.Parent and player:GetAttribute("ReturnRunActive") == true and os.clock() - startedAt < MAX_CHASE_SECONDS do
			local root = getPlayerRoot(player)
			if not root then
				break
			end

			local currentPosition = hazard:GetPivot().Position
			local targetPosition = root.Position + Vector3.new(0, 1.1, 0)
			local offset = targetPosition - currentPosition
			local distance = offset.Magnitude

			if distance <= BONK_DISTANCE + 0.9 then
				hazard:SetAttribute("SequenceEnded", true)
				FXService.emitBurst(hazard.Parent, currentPosition + Vector3.new(0, 1.6, 0), Color3.fromRGB(255, 249, 148), "PlayerBonkBurst", 32)
				print(`[BrainrotFruits] ReturnRun bonker caught {player.Name}.`)
				if onBonked then
					onBonked()
				end
				break
			end

			if distance > 0.05 then
				local step = math.min(distance, (PLACEHOLDER_SPEED + 2.5) * 0.08)
				local wobble = math.sin(os.clock() * 9) * 0.14
				local nextPosition = currentPosition + offset.Unit * step
				hazard:PivotTo(CFrame.new(nextPosition + Vector3.new(0, wobble, 0), targetPosition))
			end
			task.wait(0.08)
		end

		if hazard.Parent then
			task.delay(1.5, function()
				if hazard.Parent and hazard:GetAttribute("SequenceEnded") == true then
					hazard:Destroy()
				end
			end)
		end
	end)

	return hazard
end

return ChaosHazardService
