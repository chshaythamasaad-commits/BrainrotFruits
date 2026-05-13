local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CatapultConfig = require(brainrotFruits.Shared.CatapultConfig)

local remotes = brainrotFruits:WaitForChild(CatapultConfig.RemoteFolderName)
local requestLaunchRemote = remotes:WaitForChild(CatapultConfig.Remotes.RequestLaunch)
local launchResultRemote = remotes:WaitForChild(CatapultConfig.Remotes.LaunchResult)

local actionName = "BrainrotFruitsChargeCatapult"
local charging = false
local chargeStartedAt = 0
local cooldownUntil = 0
local latestDistance = nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotFruitsCatapultHud"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "ChargePanel"
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.Position = UDim2.fromScale(0.5, 0.92)
frame.Size = UDim2.fromOffset(320, 84)
frame.BackgroundColor3 = Color3.fromRGB(25, 30, 38)
frame.BackgroundTransparency = 0.12
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Name = "Status"
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Step near the catapult"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Size = UDim2.new(1, -24, 0, 32)
title.Position = UDim2.fromOffset(12, 8)
title.Parent = frame

local meterBack = Instance.new("Frame")
meterBack.Name = "MeterBack"
meterBack.BackgroundColor3 = Color3.fromRGB(55, 64, 74)
meterBack.BorderSizePixel = 0
meterBack.Position = UDim2.fromOffset(16, 50)
meterBack.Size = UDim2.new(1, -32, 0, 18)
meterBack.Parent = frame

local meterFill = Instance.new("Frame")
meterFill.Name = "MeterFill"
meterFill.BackgroundColor3 = Color3.fromRGB(255, 91, 129)
meterFill.BorderSizePixel = 0
meterFill.Size = UDim2.fromScale(0, 1)
meterFill.Parent = meterBack

local function getCharacterRoot()
	local character = player.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getInteractZone()
	local testWorld = Workspace:FindFirstChild(CatapultConfig.WorldFolderName)
	local testArea = testWorld and testWorld:FindFirstChild(CatapultConfig.TestAreaFolderName)
	local catapult = testArea and testArea:FindFirstChild(CatapultConfig.CatapultName)
	return catapult and catapult:FindFirstChild(CatapultConfig.InteractZoneName)
end

local function isNearCatapult()
	local root = getCharacterRoot()
	local zone = getInteractZone()
	if not root or not zone then
		return false
	end
	return (root.Position - zone.Position).Magnitude <= CatapultConfig.InteractRange
end

local function getChargeAlpha()
	if not charging then
		return 0
	end
	return math.clamp((os.clock() - chargeStartedAt) / CatapultConfig.ChargeSeconds, 0, 1)
end

local function setStatus(message)
	title.Text = message
end

local function beginCharge()
	if charging then
		return
	end

	if os.clock() < cooldownUntil then
		setStatus(`Cooling down {math.ceil(cooldownUntil - os.clock())}s`)
		return
	end

	if not isNearCatapult() then
		setStatus("Move closer to the catapult")
		return
	end

	charging = true
	chargeStartedAt = os.clock()
	latestDistance = nil
	setStatus("Charging launch...")
end

local function releaseCharge()
	if not charging then
		return
	end

	local chargeAlpha = getChargeAlpha()
	charging = false
	meterFill.Size = UDim2.fromScale(chargeAlpha, 1)
	setStatus("Launching...")

	requestLaunchRemote:FireServer({
		requestedPower = math.clamp(chargeAlpha, CatapultConfig.MinPower, CatapultConfig.MaxPower),
		chargeDuration = os.clock() - chargeStartedAt,
	})
end

local function handleAction(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		beginCharge()
	elseif inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
		releaseCharge()
	end
	return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction(
	actionName,
	handleAction,
	true,
	Enum.KeyCode.E,
	Enum.KeyCode.Space,
	Enum.UserInputType.MouseButton1
)
ContextActionService:SetTitle(actionName, "Launch")
ContextActionService:SetPosition(actionName, UDim2.fromScale(0.82, 0.72))

launchResultRemote.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	if not payload.ok then
		if payload.reason == "Cooldown" then
			cooldownUntil = os.clock() + (payload.cooldownRemaining or CatapultConfig.CooldownSeconds)
			setStatus(`Cooldown {math.ceil(payload.cooldownRemaining or CatapultConfig.CooldownSeconds)}s`)
		elseif payload.reason == "TooFarFromCatapult" then
			setStatus("Step into the catapult zone")
		else
			setStatus(`Launch failed: {payload.reason or "Unknown"}`)
		end
		return
	end

	if payload.status == "Launched" then
		cooldownUntil = os.clock() + (payload.cooldownSeconds or CatapultConfig.CooldownSeconds)
		setStatus("Crate is flying...")
	elseif payload.status == "Landed" then
		latestDistance = payload.distance
		setStatus(`Landed: {math.floor(payload.distance or 0)} studs`)
	end
end)

RunService.RenderStepped:Connect(function()
	local nearCatapult = isNearCatapult()
	local now = os.clock()

	if charging then
		local alpha = getChargeAlpha()
		meterFill.Size = UDim2.fromScale(alpha, 1)
		if alpha >= 1 then
			setStatus("Max power! Release!")
		end
		return
	end

	if now < cooldownUntil then
		meterFill.Size = UDim2.fromScale(math.max(0, (cooldownUntil - now) / CatapultConfig.CooldownSeconds), 1)
		setStatus(`Cooldown {math.ceil(cooldownUntil - now)}s`)
	elseif nearCatapult then
		meterFill.Size = UDim2.fromScale(0, 1)
		if latestDistance then
			setStatus(`Ready - last launch {math.floor(latestDistance)} studs`)
		else
			setStatus("Hold E, Space, click, or Launch")
		end
	else
		meterFill.Size = UDim2.fromScale(0, 1)
		setStatus("Step near the catapult")
	end
end)
