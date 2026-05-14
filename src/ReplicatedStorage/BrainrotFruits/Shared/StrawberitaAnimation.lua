local RunService = game:GetService("RunService")

local StrawberitaVFX = require(script.Parent.StrawberitaVFX)

local StrawberitaAnimation = {}

StrawberitaAnimation.PlatformVersion = "PlatformBounce_V1"

local activeByModel = {}
local printedPlatformVersion = false

local RARITY_EFFECTS = {
	Common = {
		colorA = Color3.fromRGB(255, 255, 245),
		colorB = Color3.fromRGB(255, 217, 232),
		rate = 0.6,
		bounce = 0.16,
		light = nil,
	},
	Uncommon = {
		colorA = Color3.fromRGB(180, 255, 197),
		colorB = Color3.fromRGB(255, 217, 232),
		rate = 1.2,
		bounce = 0.18,
		light = Color3.fromRGB(128, 255, 163),
	},
	Rare = {
		colorA = Color3.fromRGB(255, 232, 95),
		colorB = Color3.fromRGB(255, 198, 51),
		rate = 3.2,
		bounce = 0.2,
		light = Color3.fromRGB(255, 210, 82),
	},
	Epic = {
		colorA = Color3.fromRGB(125, 77, 255),
		colorB = Color3.fromRGB(117, 244, 255),
		rate = 4.2,
		bounce = 0.24,
		light = Color3.fromRGB(125, 77, 255),
	},
	Legendary = {
		colorA = Color3.fromRGB(220, 255, 255),
		colorB = Color3.fromRGB(150, 238, 255),
		rate = 3.8,
		bounce = 0.22,
		light = Color3.fromRGB(150, 238, 255),
	},
}

local function printPlatformVersion()
	if not printedPlatformVersion then
		print("[BrainrotFruits] PlatformIdleBounce_V1 active")
		printedPlatformVersion = true
	end
end

local function getVariantName(model, reward)
	return (reward and (reward.variantName or reward.variant))
		or model:GetAttribute("VariantName")
		or model:GetAttribute("RewardVariant")
		or model:GetAttribute("Variant")
		or "Normal"
end

local function getEffectConfig(variantName)
	local config = StrawberitaVFX.getConfig(variantName)
	return config or RARITY_EFFECTS.Common
end

local function setPartsDisplaySafe(model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end
end

local function addPlatformEffects(state, config)
	local vfxState = StrawberitaVFX.startPlatformVFX(state.model, state.variantName)
	state.variantVFXState = vfxState
	state.glowLight = vfxState and vfxState.glowLight
	state.glowBaseBrightness = config.platformLightBrightness or 0
end

local function stopState(model)
	local state = activeByModel[model]
	if not state then
		return
	end

	activeByModel[model] = nil
	if state.connection then
		state.connection:Disconnect()
	end
	if state.ancestryConnection then
		state.ancestryConnection:Disconnect()
	end
	if model and model.Parent and state.basePivot then
		model:PivotTo(state.basePivot)
	end
	for _, instance in ipairs({ state.sparkleAttachment, state.glowLight }) do
		if instance and instance.Parent then
			instance:Destroy()
		end
	end
	StrawberitaVFX.cleanupVFX(model)
end

function StrawberitaAnimation.stopPlatformIdle(model)
	stopState(model)
end

function StrawberitaAnimation.startPlatformIdle(model, reward)
	if not model or not model:IsA("Model") then
		return false
	end
	if activeByModel[model] then
		return true
	end

	local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	if not root then
		return false
	end
	model.PrimaryPart = root
	printPlatformVersion()
	setPartsDisplaySafe(model)

	local variantName = getVariantName(model, reward)
	local config = getEffectConfig(variantName)
	local basePivot = model:GetPivot()
	local seed = (model:GetAttribute("OwnerUserId") or 0) + (model:GetAttribute("DisplaySlotIndex") or 0) * 0.37

	local state = {
		model = model,
		root = root,
		basePivot = basePivot,
		config = config,
		variantName = variantName,
	}
	activeByModel[model] = state

	addPlatformEffects(state, config)
	model:SetAttribute("PlatformIdleAnimation", "Active")
	model:SetAttribute("StrawberitaAnimationVersion", StrawberitaAnimation.PlatformVersion)

	state.ancestryConnection = model.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			stopState(model)
		end
	end)

	state.connection = RunService.Heartbeat:Connect(function()
		if activeByModel[model] ~= state or not model.Parent then
			stopState(model)
			return
		end

		local now = os.clock()
		local period = 1.35 + ((seed % 4) * 0.09)
		local phase = (now / period + seed) * math.pi * 2
		local y = (math.sin(phase) * 0.5 + 0.5) * (config.platformBounce or config.bounce or 0.16)
		local sway = math.sin(phase * 0.5) * 0.035
		local tilt = math.sin(phase * 0.5) * math.rad(1.6)
		local glowAlpha = math.sin(phase) * 0.5 + 0.5

		model:PivotTo(basePivot * CFrame.new(sway, y, 0) * CFrame.Angles(0, 0, tilt))
		if state.glowLight then
			state.glowLight.Brightness = state.glowBaseBrightness * (0.68 + glowAlpha * 0.42)
		end
	end)

	return true
end

return StrawberitaAnimation
