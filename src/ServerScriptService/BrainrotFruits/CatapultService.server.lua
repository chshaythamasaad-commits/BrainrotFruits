local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CatapultConfig = require(brainrotFruits.Shared.CatapultConfig)
local FXService = require(script.Parent.FXService)
local PlotService = require(script.Parent.Map.PlotService)
local ReturnRunService = require(script.Parent.ReturnRunService)
local RewardService = require(script.Parent.RewardService)
local StrawberitaTransformService = require(script.Parent.StrawberitaTransformService)

local rng = Random.new()
local lastLaunchByUserId = {}
local sharedCatapultBusyUserId = nil
local sharedCatapultBusyUntil = 0

PlotService.init()
ReturnRunService.init()
print("[BrainrotFruits] PlayerCrateLaunch_V1 active")

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
local requestLaunchRemote = getOrCreateRemote(remoteFolder, CatapultConfig.Remotes.RequestLaunch)
local launchResultRemote = getOrCreateRemote(remoteFolder, CatapultConfig.Remotes.LaunchResult)
getOrCreateRemote(remoteFolder, CatapultConfig.Remotes.RequestReveal)
local revealResultRemote = getOrCreateRemote(remoteFolder, CatapultConfig.Remotes.RevealResult)

local function getPlayerRoot(player)
	local character = player.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function clampPower(power)
	local numericPower = tonumber(power) or CatapultConfig.MinPower
	return math.clamp(numericPower, CatapultConfig.MinPower, CatapultConfig.MaxPower)
end

local function lerp(minValue, maxValue, alpha)
	return minValue + (maxValue - minValue) * alpha
end

local function flatDistance(fromPosition, toPosition)
	local delta = Vector3.new(toPosition.X - fromPosition.X, 0, toPosition.Z - fromPosition.Z)
	return math.clamp(delta.Magnitude, 0, CatapultConfig.MaxValidDistance)
end

local function fireFailure(player, reason, extra)
	local payload = extra or {}
	payload.ok = false
	payload.reason = reason
	launchResultRemote:FireClient(player, payload)
end

local function addCrateSurfaceText(part, text, face)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "CrateSurfaceText"
	surface.Face = face
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 34
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 232, 95)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.25
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface
end

local function addCrateVisual(crate, name, size, offset, color, material)
	local visual = Instance.new("Part")
	visual.Name = name
	visual.Size = size
	visual.CFrame = crate.CFrame * offset
	visual.Color = color
	visual.Material = material or Enum.Material.SmoothPlastic
	visual.CanCollide = false
	visual.Massless = true
	visual.Parent = crate

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = crate
	weld.Part1 = visual
	weld.Parent = visual

	return visual
end

local function makeCrate(origin, player, powerAlpha, plot)
	local crate = Instance.new("Part")
	crate.Name = `LaunchedPlayerCrate_{player.UserId}`
	crate.Size = Vector3.new(3.1, 3.1, 3.1)
	crate.CFrame = CFrame.new(origin)
	crate.Color = Color3.fromRGB(148, 94, 49)
	crate.Material = Enum.Material.WoodPlanks
	crate.CustomPhysicalProperties = PhysicalProperties.new(0.8, 0.45, 0.35)
	crate:SetAttribute("OwnerUserId", player.UserId)
	crate:SetAttribute("OwnerName", player.Name)
	crate:SetAttribute("PlotId", plot:GetAttribute("PlotId"))
	crate:SetAttribute("LaunchPower", powerAlpha)
	crate:SetAttribute("HasLanded", false)
	crate:SetAttribute("RepresentsPlayer", true)
	crate.Parent = PlotService.getPlayerCratesFolder(player)

	addCrateVisual(crate, "TopStrap", Vector3.new(3.35, 0.22, 0.55), CFrame.new(0, 1.68, 0), Color3.fromRGB(91, 58, 34), Enum.Material.Wood)
	addCrateVisual(crate, "FrontStrap", Vector3.new(0.55, 3.35, 0.22), CFrame.new(0, 0, -1.68), Color3.fromRGB(91, 58, 34), Enum.Material.Wood)
	addCrateVisual(crate, "LeftMetalCorner", Vector3.new(0.62, 0.62, 0.18), CFrame.new(-1.05, 0.95, -1.7), Color3.fromRGB(135, 138, 137), Enum.Material.Metal)
	addCrateVisual(crate, "RightMetalCorner", Vector3.new(0.62, 0.62, 0.18), CFrame.new(1.05, 0.95, -1.7), Color3.fromRGB(135, 138, 137), Enum.Material.Metal)
	addCrateVisual(crate, "LuckySticker", Vector3.new(1.1, 1.1, 0.12), CFrame.new(0, -0.2, -1.72), Color3.fromRGB(255, 91, 129), Enum.Material.SmoothPlastic)
	addCrateSurfaceText(crate, "?", Enum.NormalId.Front)

	pcall(function()
		crate:SetNetworkOwner(nil)
	end)

	task.delay(CatapultConfig.CrateLifetimeSeconds, function()
		if crate.Parent and crate:GetAttribute("HasLanded") ~= true then
			crate:Destroy()
		end
	end)

	return crate
end

local function releaseSharedCatapult(player)
	if sharedCatapultBusyUserId == player.UserId then
		sharedCatapultBusyUserId = nil
		sharedCatapultBusyUntil = 0
	end
end

local function trackLanding(player, crate, launchOrigin)
	local startedAt = os.clock()
	local landedPosition = crate.Position

	while crate.Parent and os.clock() - startedAt < CatapultConfig.LandingTimeoutSeconds do
		landedPosition = crate.Position
		StrawberitaTransformService.syncToCrate(player, crate)
		if os.clock() - startedAt > 0.7 and crate.AssemblyLinearVelocity.Magnitude <= CatapultConfig.RestingSpeed then
			break
		end
		task.wait(0.08)
	end

	if not crate.Parent then
		StrawberitaTransformService.finish(player, true, landedPosition)
		releaseSharedCatapult(player)
		return
	end

	local distance = flatDistance(launchOrigin, landedPosition)
	crate:SetAttribute("HasLanded", true)
	crate:SetAttribute("LandingDistance", distance)
	FXService.emitBurst(crate.Parent, landedPosition + Vector3.new(0, 1.2, 0), Color3.fromRGB(255, 238, 145), "LandingBurst", 22)

	print(`[BrainrotFruits] {player.Name} launched as Strawberita and landed {math.floor(distance)} studs from the shared catapult.`)

	launchResultRemote:FireClient(player, {
		ok = true,
		status = "Landed",
		distance = distance,
		crateName = crate.Name,
		plotId = crate:GetAttribute("PlotId"),
		position = landedPosition,
	})

	task.wait(0.35)

	if crate.Parent then
		local reveal = RewardService.revealCrate(player, crate, landedPosition, distance)
		StrawberitaTransformService.releaseForReturnRun(player, landedPosition)
		releaseSharedCatapult(player)

		revealResultRemote:FireClient(player, {
			ok = true,
			status = "Revealed",
			variantName = reveal.variantName,
			displayName = reveal.displayName,
			rarity = reveal.rarity,
			bandName = reveal.bandName,
			distance = reveal.distance,
			plotId = reveal.plotId,
			position = reveal.position,
			modelName = reveal.modelName,
		})

		local startedReturnRun, reason = ReturnRunService.start(player, reveal)
		if not startedReturnRun then
			StrawberitaTransformService.finish(player, true, landedPosition)
			warn(`[BrainrotFruits] Could not start return run for {player.Name}: {reason or "Unknown"}.`)
		end
	else
		StrawberitaTransformService.finish(player, true, landedPosition)
		releaseSharedCatapult(player)
	end
end

requestLaunchRemote.OnServerEvent:Connect(function(player, payload)
	if typeof(payload) ~= "table" then
		fireFailure(player, "BadLaunchPayload")
		return
	end

	local plot = PlotService.getPlayerPlot(player) or PlotService.assignPlayer(player)
	local root = getPlayerRoot(player)
	local zone = PlotService.getSharedCatapultZone()
	if not plot or not root or not zone then
		fireFailure(player, "CatapultNotReady")
		return
	end

	if StrawberitaTransformService.isActive(player) or player:GetAttribute("IsLaunching") == true then
		fireFailure(player, "AlreadyLaunching")
		return
	end

	if ReturnRunService.hasActiveRun(player) or player:GetAttribute("ReturnRunActive") == true then
		fireFailure(player, "ReturnRunActive")
		return
	end

	if not PlotService.getNextOpenSlot(player) then
		fireFailure(player, "NoEmptySlots")
		return
	end

	local distanceToCatapult = (root.Position - zone.Position).Magnitude
	if distanceToCatapult > CatapultConfig.InteractRange then
		fireFailure(player, "TooFarFromCatapult")
		return
	end

	local now = os.clock()
	if sharedCatapultBusyUserId and sharedCatapultBusyUntil > now then
		fireFailure(player, "CatapultBusy")
		return
	end

	local lastLaunch = lastLaunchByUserId[player.UserId] or -math.huge
	local cooldownRemaining = CatapultConfig.CooldownSeconds - (now - lastLaunch)
	if cooldownRemaining > 0 then
		fireFailure(player, "Cooldown", {
			cooldownRemaining = cooldownRemaining,
		})
		return
	end

	local powerAlpha = clampPower(payload.requestedPower)
	lastLaunchByUserId[player.UserId] = now
	sharedCatapultBusyUserId = player.UserId
	sharedCatapultBusyUntil = now + CatapultConfig.SharedCatapultBusySeconds

	local launchOrigin = zone:GetAttribute("LaunchOrigin")
	if typeof(launchOrigin) ~= "Vector3" then
		launchOrigin = zone.Position + Vector3.new(0, 2.5, 6)
	end

	local launchDirection = zone:GetAttribute("LaunchDirection")
	if typeof(launchDirection) ~= "Vector3" or launchDirection.Magnitude < 0.1 then
		launchDirection = Vector3.new(0, 0, 1)
	end
	local flatLaunchDirection = Vector3.new(launchDirection.X, 0, launchDirection.Z)
	if flatLaunchDirection.Magnitude < 0.1 then
		flatLaunchDirection = Vector3.new(0, 0, 1)
	end
	launchDirection = flatLaunchDirection.Unit

	local crate = makeCrate(launchOrigin + Vector3.new(rng:NextNumber(-0.15, 0.15), 0, 0), player, powerAlpha, plot)
	if not StrawberitaTransformService.beginFlight(player, crate, PlotService.getPlayerCratesFolder(player)) then
		crate:Destroy()
		releaseSharedCatapult(player)
		fireFailure(player, "CharacterNotReady")
		return
	end

	local horizontalSpeed = lerp(CatapultConfig.MinHorizontalSpeed, CatapultConfig.MaxHorizontalSpeed, powerAlpha)
	local upwardSpeed = lerp(CatapultConfig.MinUpwardSpeed, CatapultConfig.MaxUpwardSpeed, powerAlpha)
	crate.AssemblyLinearVelocity = launchDirection * horizontalSpeed + Vector3.new(0, upwardSpeed, 0)
	crate.AssemblyAngularVelocity = Vector3.new(rng:NextNumber(-5, 5), rng:NextNumber(-2, 2), rng:NextNumber(-5, 5))

	launchResultRemote:FireClient(player, {
		ok = true,
		status = "Launched",
		power = powerAlpha,
		cooldownSeconds = CatapultConfig.CooldownSeconds,
		crateName = crate.Name,
		plotId = plot:GetAttribute("PlotId"),
	})

	task.spawn(trackLanding, player, crate, launchOrigin)
end)

Players.PlayerRemoving:Connect(function(player)
	lastLaunchByUserId[player.UserId] = nil
	if sharedCatapultBusyUserId == player.UserId then
		releaseSharedCatapult(player)
	end
end)
