local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CatapultConfig = require(brainrotFruits.Shared.CatapultConfig)

local rng = Random.new()
local lastLaunchByUserId = {}

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

local function getTestWorld()
	return getOrCreateFolder(Workspace, CatapultConfig.WorldFolderName)
end

local function getActiveCratesFolder()
	return getOrCreateFolder(getTestWorld(), CatapultConfig.ActiveCratesFolderName)
end

local function getInteractZone()
	local testWorld = Workspace:FindFirstChild(CatapultConfig.WorldFolderName)
	local testArea = testWorld and testWorld:FindFirstChild(CatapultConfig.TestAreaFolderName)
	local catapult = testArea and testArea:FindFirstChild(CatapultConfig.CatapultName)
	return catapult and catapult:FindFirstChild(CatapultConfig.InteractZoneName)
end

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

local function makeCrate(origin, player, powerAlpha)
	local crate = Instance.new("Part")
	crate.Name = `FruitCrate_{player.UserId}`
	crate.Size = Vector3.new(2.4, 2.1, 2.4)
	crate.CFrame = CFrame.new(origin)
	crate.Color = Color3.fromRGB(148, 94, 49)
	crate.Material = Enum.Material.WoodPlanks
	crate.CustomPhysicalProperties = PhysicalProperties.new(0.8, 0.45, 0.35)
	crate:SetAttribute("OwnerUserId", player.UserId)
	crate:SetAttribute("LaunchPower", powerAlpha)
	crate:SetAttribute("HasLanded", false)
	crate.Parent = getActiveCratesFolder()

	local corner = Instance.new("Part")
	corner.Name = "BrightSticker"
	corner.Size = Vector3.new(0.75, 0.08, 0.75)
	corner.CFrame = crate.CFrame * CFrame.new(0, 1.08, -0.5)
	corner.Color = Color3.fromRGB(255, 91, 129)
	corner.Material = Enum.Material.SmoothPlastic
	corner.CanCollide = false
	corner.Massless = true
	corner.Parent = crate

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = crate
	weld.Part1 = corner
	weld.Parent = corner

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

local function addPromptWhenReady()
	task.spawn(function()
		local zone
		for _ = 1, 120 do
			zone = getInteractZone()
			if zone then
				break
			end
			task.wait(0.25)
		end

		if not zone or zone:FindFirstChild("CatapultPrompt") then
			return
		end

		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "CatapultPrompt"
		prompt.ActionText = "Charge Launch"
		prompt.ObjectText = "Strawberita Catapult"
		prompt.HoldDuration = 0
		prompt.MaxActivationDistance = CatapultConfig.InteractRange
		prompt.KeyboardKeyCode = Enum.KeyCode.E
		prompt.Parent = zone
	end)
end

local function fireFailure(player, reason, extra)
	local payload = extra or {}
	payload.ok = false
	payload.reason = reason
	launchResultRemote:FireClient(player, payload)
end

local function trackLanding(player, crate, launchOrigin)
	local startedAt = os.clock()
	local landedPosition = crate.Position

	while crate.Parent and os.clock() - startedAt < CatapultConfig.LandingTimeoutSeconds do
		landedPosition = crate.Position
		if os.clock() - startedAt > 0.7 and crate.AssemblyLinearVelocity.Magnitude <= CatapultConfig.RestingSpeed then
			break
		end
		task.wait(0.15)
	end

	if not crate.Parent then
		return
	end

	local distance = flatDistance(launchOrigin, landedPosition)
	crate:SetAttribute("HasLanded", true)
	crate:SetAttribute("LandingDistance", distance)

	print(`[BrainrotFruits] {player.Name} launched a crate {math.floor(distance)} studs.`)

	launchResultRemote:FireClient(player, {
		ok = true,
		status = "Landed",
		distance = distance,
		crateName = crate.Name,
		position = landedPosition,
	})
end

requestLaunchRemote.OnServerEvent:Connect(function(player, payload)
	if typeof(payload) ~= "table" then
		fireFailure(player, "BadLaunchPayload")
		return
	end

	local root = getPlayerRoot(player)
	local zone = getInteractZone()
	if not root or not zone then
		fireFailure(player, "CatapultNotReady")
		return
	end

	local distanceToCatapult = (root.Position - zone.Position).Magnitude
	if distanceToCatapult > CatapultConfig.InteractRange then
		fireFailure(player, "TooFarFromCatapult")
		return
	end

	local now = os.clock()
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

	local launchOrigin = zone:GetAttribute("LaunchOrigin")
	if typeof(launchOrigin) ~= "Vector3" then
		launchOrigin = zone.Position + Vector3.new(0, 2.5, 6)
	end

	local launchDirection = zone:GetAttribute("LaunchDirection")
	if typeof(launchDirection) ~= "Vector3" or launchDirection.Magnitude < 0.1 then
		launchDirection = Vector3.new(0, 0, 1)
	end
	launchDirection = Vector3.new(launchDirection.X, 0, launchDirection.Z).Unit

	local crate = makeCrate(launchOrigin + Vector3.new(rng:NextNumber(-0.15, 0.15), 0, 0), player, powerAlpha)
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
	})

	task.spawn(trackLanding, player, crate, launchOrigin)
end)

Players.PlayerRemoving:Connect(function(player)
	lastLaunchByUserId[player.UserId] = nil
end)

addPromptWhenReady()
