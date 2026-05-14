local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CatapultConfig = require(brainrotFruits.Shared.CatapultConfig)

local remotes = brainrotFruits:WaitForChild(CatapultConfig.RemoteFolderName)
local requestLaunchRemote = remotes:WaitForChild(CatapultConfig.Remotes.RequestLaunch)
local launchResultRemote = remotes:WaitForChild(CatapultConfig.Remotes.LaunchResult)
local revealResultRemote = remotes:WaitForChild(CatapultConfig.Remotes.RevealResult)
local returnRunStatusRemote = remotes:WaitForChild(CatapultConfig.Remotes.ReturnRunStatus)

local actionName = "BrainrotFruitsChargeCatapult"
local charging = false
local chargeStartedAt = 0
local cooldownUntil = 0
local latestDistance = nil
local revealMessageUntil = 0
local revealHiding = false
local returnRunActive = false
local returnRunEndsAt = 0
local returnRunDuration = 1
local returnMarker = nil

local rarityColors = {
	Common = Color3.fromRGB(255, 255, 255),
	Uncommon = Color3.fromRGB(128, 255, 163),
	Rare = Color3.fromRGB(255, 223, 92),
	Epic = Color3.fromRGB(182, 118, 255),
	Legendary = Color3.fromRGB(130, 239, 255),
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotFruitsCatapultHud"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "ChargePanel"
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.Position = UDim2.fromScale(0.5, 0.955)
frame.Size = UDim2.new(0.72, 0, 0, 62)
frame.BackgroundColor3 = Color3.fromRGB(25, 30, 38)
frame.BackgroundTransparency = 0.18
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameSize = Instance.new("UISizeConstraint")
frameSize.MinSize = Vector2.new(230, 62)
frameSize.MaxSize = Vector2.new(340, 62)
frameSize.Parent = frame

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Status"
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Step near the catapult"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Size = UDim2.new(1, -24, 0, 24)
title.Position = UDim2.fromOffset(12, 7)
title.Parent = frame

local meterBack = Instance.new("Frame")
meterBack.Name = "MeterBack"
meterBack.BackgroundColor3 = Color3.fromRGB(55, 64, 74)
meterBack.BorderSizePixel = 0
meterBack.Position = UDim2.fromOffset(16, 39)
meterBack.Size = UDim2.new(1, -32, 0, 12)
meterBack.Parent = frame

local meterFill = Instance.new("Frame")
meterFill.Name = "MeterFill"
meterFill.BackgroundColor3 = Color3.fromRGB(255, 91, 129)
meterFill.BorderSizePixel = 0
meterFill.Size = UDim2.fromScale(0, 1)
meterFill.Parent = meterBack

local meterCorner = Instance.new("UICorner")
meterCorner.CornerRadius = UDim.new(1, 0)
meterCorner.Parent = meterBack

local meterFillCorner = Instance.new("UICorner")
meterFillCorner.CornerRadius = UDim.new(1, 0)
meterFillCorner.Parent = meterFill

local revealFrame = Instance.new("Frame")
revealFrame.Name = "RevealPanel"
revealFrame.AnchorPoint = Vector2.new(0.5, 0)
revealFrame.Position = UDim2.fromScale(0.5, 0.055)
revealFrame.Size = UDim2.new(0.52, 0, 0, 76)
revealFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 38)
revealFrame.BackgroundTransparency = 1
revealFrame.BorderSizePixel = 0
revealFrame.Visible = false
revealFrame.Parent = screenGui

local revealSize = Instance.new("UISizeConstraint")
revealSize.MinSize = Vector2.new(250, 76)
revealSize.MaxSize = Vector2.new(420, 76)
revealSize.Parent = revealFrame

local revealCorner = Instance.new("UICorner")
revealCorner.CornerRadius = UDim.new(0, 16)
revealCorner.Parent = revealFrame

local revealStroke = Instance.new("UIStroke")
revealStroke.Color = Color3.fromRGB(255, 220, 92)
revealStroke.Thickness = 2
revealStroke.Transparency = 1
revealStroke.Parent = revealFrame

local revealTitle = Instance.new("TextLabel")
revealTitle.Name = "RevealTitle"
revealTitle.BackgroundTransparency = 1
revealTitle.Font = Enum.Font.GothamBlack
revealTitle.Text = "Revealed!"
revealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
revealTitle.TextScaled = true
revealTitle.TextTransparency = 1
revealTitle.Size = UDim2.new(1, -24, 0, 28)
revealTitle.Position = UDim2.fromOffset(12, 7)
revealTitle.Parent = revealFrame

local revealSubtitle = Instance.new("TextLabel")
revealSubtitle.Name = "RevealSubtitle"
revealSubtitle.BackgroundTransparency = 1
revealSubtitle.Font = Enum.Font.GothamBold
revealSubtitle.Text = ""
revealSubtitle.TextColor3 = Color3.fromRGB(219, 232, 255)
revealSubtitle.TextScaled = true
revealSubtitle.TextTransparency = 1
revealSubtitle.Size = UDim2.new(1, -24, 0, 20)
revealSubtitle.Position = UDim2.fromOffset(12, 35)
revealSubtitle.Parent = revealFrame

local revealHint = Instance.new("TextLabel")
revealHint.Name = "RevealHint"
revealHint.BackgroundTransparency = 1
revealHint.Font = Enum.Font.GothamBold
revealHint.Text = ""
revealHint.TextColor3 = Color3.fromRGB(255, 244, 184)
revealHint.TextScaled = true
revealHint.TextTransparency = 1
revealHint.Size = UDim2.new(1, -24, 0, 17)
revealHint.Position = UDim2.fromOffset(12, 56)
revealHint.Parent = revealFrame

local function getCharacterRoot()
	local character = player.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getInteractZone()
	local map = Workspace:FindFirstChild(CatapultConfig.WorldFolderName)
	local launchArea = map and map:FindFirstChild(CatapultConfig.SharedLaunchAreaName)
	local catapult = launchArea and launchArea:FindFirstChild(CatapultConfig.CatapultName)
	if not catapult then
		return nil
	end
	return catapult:FindFirstChild(CatapultConfig.InteractZoneName)
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

local function tweenReveal(targetTransparency)
	TweenService:Create(revealFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = targetTransparency,
	}):Play()
	TweenService:Create(revealStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = math.clamp(targetTransparency + 0.05, 0, 1),
	}):Play()
	for _, label in ipairs({ revealTitle, revealSubtitle, revealHint }) do
		TweenService:Create(label, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = targetTransparency >= 1 and 1 or 0,
		}):Play()
	end
end

local function showRevealPanel(seconds)
	revealHiding = false
	revealFrame.Visible = true
	tweenReveal(0.12)
	revealMessageUntil = os.clock() + (seconds or 3)
end

local function hideRevealPanel()
	if revealHiding then
		return
	end
	revealHiding = true
	tweenReveal(1)
	task.delay(0.2, function()
		if os.clock() > revealMessageUntil then
			revealFrame.Visible = false
			revealHiding = false
		end
	end)
end

local function clearReturnMarker()
	if returnMarker then
		returnMarker:Destroy()
		returnMarker = nil
	end
end

local function showReturnMarker(plotId)
	clearReturnMarker()

	local map = Workspace:FindFirstChild(CatapultConfig.WorldFolderName)
	local plots = map and map:FindFirstChild(CatapultConfig.PlotsFolderName)
	local plot = plots and plots:FindFirstChild(`Plot{plotId}`)
	local claimZone = plot and plot:FindFirstChild("BaseClaimZone")
	if not claimZone then
		return
	end

	local marker = Instance.new("BillboardGui")
	marker.Name = "ReturnRunBaseMarker"
	marker.Size = UDim2.fromOffset(132, 38)
	marker.StudsOffset = Vector3.new(0, 5.4, 0)
	marker.AlwaysOnTop = true
	marker.MaxDistance = 140
	marker.Parent = claimZone

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBlack
	label.Text = "YOUR BASE"
	label.TextColor3 = Color3.fromRGB(103, 255, 139)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.2
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = marker

	returnMarker = marker
end

local function showReveal(payload)
	local rarity = payload.rarity or "Common"
	revealTitle.Text = payload.displayName or "Strawberita"
	revealTitle.TextColor3 = rarityColors[rarity] or Color3.fromRGB(255, 255, 255)
	revealSubtitle.Text = rarity
	revealHint.Text = "Run back to your base!"
	showRevealPanel(3.25)
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
		setStatus("Move closer to the shared catapult")
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
	setStatus("Loading crate...")

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
		elseif payload.reason == "CatapultBusy" then
			setStatus("Catapult is busy!")
		elseif payload.reason == "NoEmptySlots" then
			setStatus("No empty slots!")
		elseif payload.reason == "ReturnRunActive" then
			setStatus("Secure your reward first!")
		else
			setStatus(`Launch failed: {payload.reason or "Unknown"}`)
		end
		return
	end

	if payload.status == "Launched" then
		cooldownUntil = os.clock() + (payload.cooldownSeconds or CatapultConfig.CooldownSeconds)
		setStatus("Launch! Strawberita sprint!")
	elseif payload.status == "Landed" then
		latestDistance = payload.distance
		setStatus("Opening crate...")
	end
end)

revealResultRemote.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" or not payload.ok then
		return
	end

	setStatus(`You found: {payload.displayName or "Strawberita"}!`)
	showReveal(payload)
end)

returnRunStatusRemote.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	if payload.status == "Started" then
		returnRunActive = true
		returnRunDuration = payload.timeoutSeconds or CatapultConfig.ReturnRunTimeoutSeconds or 45
		returnRunEndsAt = os.clock() + returnRunDuration
		showReturnMarker(payload.plotId)
		setStatus("Run Home!")
		revealHint.Text = "Run back to your base!"
		showRevealPanel(math.min(returnRunDuration, 5))
	elseif payload.status == "Secured" then
		returnRunActive = false
		returnRunEndsAt = 0
		clearReturnMarker()
		setStatus(payload.message or "Reward Secured!")
		revealTitle.Text = "Reward Secured!"
		revealTitle.TextColor3 = Color3.fromRGB(103, 255, 139)
		revealSubtitle.Text = payload.displayName or ""
		revealHint.Text = "Tool added to Backpack!"
		showRevealPanel(3)
	elseif payload.status == "Lost" then
		returnRunActive = false
		returnRunEndsAt = 0
		clearReturnMarker()
		setStatus(payload.message or "Reward Lost!")
		revealTitle.Text = payload.message or "Reward Lost!"
		revealTitle.TextColor3 = Color3.fromRGB(255, 91, 129)
		revealSubtitle.Text = payload.reason or "Bonked"
		revealHint.Text = "Try another launch!"
		showRevealPanel(3)
	end
end)

RunService.RenderStepped:Connect(function()
	local nearCatapult = isNearCatapult()
	local now = os.clock()

	if charging then
		local alpha = getChargeAlpha()
		meterFill.Size = UDim2.fromScale(alpha, 1)
		meterFill.BackgroundColor3 = Color3.fromRGB(255, math.floor(91 + 120 * alpha), 129)
		if alpha >= 1 then
			setStatus("Max power! Release!")
		end
		return
	end

	if revealFrame.Visible and os.clock() > revealMessageUntil then
		hideRevealPanel()
	end

	if now < cooldownUntil then
		meterFill.Size = UDim2.fromScale(math.max(0, (cooldownUntil - now) / CatapultConfig.CooldownSeconds), 1)
		meterFill.BackgroundColor3 = Color3.fromRGB(120, 175, 255)
		setStatus(`Cooldown {math.ceil(cooldownUntil - now)}s`)
	elseif returnRunActive then
		local remaining = math.max(0, returnRunEndsAt - now)
		local alpha = returnRunDuration > 0 and remaining / returnRunDuration or 0
		meterFill.Size = UDim2.fromScale(alpha, 1)
		meterFill.BackgroundColor3 = Color3.fromRGB(103, 255, 139)
		setStatus("Run Home!")
	elseif nearCatapult then
		meterFill.Size = UDim2.fromScale(0, 1)
		meterFill.BackgroundColor3 = Color3.fromRGB(255, 91, 129)
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
