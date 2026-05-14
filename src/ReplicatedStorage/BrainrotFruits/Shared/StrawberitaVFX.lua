local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local StrawberitaVFX = {}

StrawberitaVFX.Version = "VariantAuraSparkle_V1"

local printedVersion = false

local VARIANT_CONFIGS = {
	Base = {
		displayName = "Base Strawberita",
		auraColor = Color3.fromRGB(255, 182, 207),
		sparkleColorA = Color3.fromRGB(255, 255, 245),
		sparkleColorB = Color3.fromRGB(255, 176, 211),
		burstColorA = Color3.fromRGB(255, 244, 235),
		burstColorB = Color3.fromRGB(255, 139, 184),
		platformRate = 0.55,
		platformBounce = 0.16,
		platformLightBrightness = 0,
		platformLightRange = 0,
		trailRate = 7,
		trailIdleRate = 1.5,
		toolRate = 1.2,
		revealCount = 20,
		securedCount = 18,
	},
	Golden = {
		displayName = "Golden Strawberita",
		auraColor = Color3.fromRGB(255, 211, 73),
		sparkleColorA = Color3.fromRGB(255, 248, 170),
		sparkleColorB = Color3.fromRGB(255, 184, 45),
		burstColorA = Color3.fromRGB(255, 250, 168),
		burstColorB = Color3.fromRGB(255, 178, 35),
		platformRate = 2.7,
		platformBounce = 0.21,
		platformLightBrightness = 0.32,
		platformLightRange = 7.5,
		trailRate = 14,
		trailIdleRate = 3,
		toolRate = 3,
		revealCount = 34,
		securedCount = 30,
	},
	Diamond = {
		displayName = "Diamond Strawberita",
		auraColor = Color3.fromRGB(162, 239, 255),
		sparkleColorA = Color3.fromRGB(245, 255, 255),
		sparkleColorB = Color3.fromRGB(105, 214, 255),
		burstColorA = Color3.fromRGB(250, 255, 255),
		burstColorB = Color3.fromRGB(112, 224, 255),
		platformRate = 3.1,
		platformBounce = 0.2,
		platformLightBrightness = 0.38,
		platformLightRange = 8.5,
		trailRate = 15,
		trailIdleRate = 3.5,
		toolRate = 3.2,
		revealCount = 38,
		securedCount = 32,
	},
	Galaxy = {
		displayName = "Galaxy Strawberita",
		auraColor = Color3.fromRGB(129, 81, 255),
		sparkleColorA = Color3.fromRGB(116, 245, 255),
		sparkleColorB = Color3.fromRGB(211, 102, 255),
		burstColorA = Color3.fromRGB(121, 246, 255),
		burstColorB = Color3.fromRGB(155, 82, 255),
		platformRate = 4.4,
		platformBounce = 0.24,
		platformLightBrightness = 0.5,
		platformLightRange = 10,
		trailRate = 18,
		trailIdleRate = 4,
		toolRate = 4,
		revealCount = 46,
		securedCount = 38,
	},
}

local VARIANT_ALIASES = {
	Normal = "Base",
	Base = "Base",
	Common = "Base",
	Shiny = "Base",
	Golden = "Golden",
	Diamond = "Diamond",
	Galaxy = "Galaxy",
}

local VFX_OBJECT_NAMES = {
	StrawberitaVariantAuraAttachment = true,
	StrawberitaVariantPlatformSparkles = true,
	StrawberitaVariantGlow = true,
	StrawberitaVariantReturnTrailAttachment = true,
	StrawberitaVariantReturnTrail = true,
	StrawberitaVariantRevealBurst = true,
	StrawberitaVariantSecuredBurst = true,
	StrawberitaVariantBurstAnchor = true,
	StrawberitaToolVFXAttachment = true,
	StrawberitaToolVariantSparkles = true,
}

local function markMap()
	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		map:SetAttribute("StrawberitaVariantVFXVersion", StrawberitaVFX.Version)
	end
end

local function printVersion()
	if printedVersion then
		return
	end

	print("[BrainrotFruits] StrawberitaVariantVFX_V1 active")
	print("[BrainrotFruits] Platform variant auras active")
	print("[BrainrotFruits] Return-run variant trails active")
	print("[BrainrotFruits] Reward reveal bursts active")
	printedVersion = true
	markMap()
end

local function variantNameFromValue(value)
	if typeof(value) == "Instance" then
		return value:GetAttribute("VariantName")
			or value:GetAttribute("RewardVariant")
			or value:GetAttribute("Variant")
			or value:GetAttribute("VariantId")
			or value:GetAttribute("DisplayName")
			or value.Name
	end

	if type(value) == "table" then
		return value.variantName or value.variant or value.id or value.rarity
	end

	return value
end

function StrawberitaVFX.normalizeVariantName(value)
	local raw = variantNameFromValue(value)
	if raw == nil then
		return "Base"
	end

	local text = tostring(raw)
	local direct = VARIANT_ALIASES[text]
	if direct then
		return direct
	end

	local lower = string.lower(text)
	if string.find(lower, "gold") then
		return "Golden"
	elseif string.find(lower, "diamond") or string.find(lower, "crystal") then
		return "Diamond"
	elseif string.find(lower, "galaxy") or string.find(lower, "cosmic") or string.find(lower, "mythic") then
		return "Galaxy"
	end

	return "Base"
end

function StrawberitaVFX.getConfig(value)
	local variantName = StrawberitaVFX.normalizeVariantName(value)
	return VARIANT_CONFIGS[variantName], variantName
end

local function getRoot(instance)
	if not instance then
		return nil
	end
	if instance:IsA("BasePart") then
		return instance
	end
	if instance:IsA("Model") then
		return instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart", true)
	end
	return instance:FindFirstChildWhichIsA("BasePart", true)
end

local function createSparkleEmitter(parent, name, config, rate)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = name
	emitter.Color = ColorSequence.new(config.sparkleColorA, config.sparkleColorB)
	emitter.LightEmission = 0.48
	emitter.Rate = rate or 0
	emitter.Lifetime = NumberRange.new(0.45, 1.1)
	emitter.Speed = NumberRange.new(0.18, 0.8)
	emitter.SpreadAngle = Vector2.new(80, 80)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.13),
		NumberSequenceKeypoint.new(0.55, 0.09),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Parent = parent
	return emitter
end

local function setVFXAttributes(model, variantName)
	if model and model.SetAttribute then
		model:SetAttribute("VariantVFX", "Active")
		model:SetAttribute("VariantName", variantName)
		model:SetAttribute("StrawberitaVariantVFXVersion", StrawberitaVFX.Version)
	end
end

function StrawberitaVFX.cleanupVFX(instance)
	if not instance then
		return
	end

	for _, descendant in ipairs(instance:GetDescendants()) do
		if VFX_OBJECT_NAMES[descendant.Name] or descendant:GetAttribute("StrawberitaVariantVFXObject") == true then
			descendant:Destroy()
		end
	end
end

function StrawberitaVFX.applyVariantVFX(model, variantValue, context)
	printVersion()

	local config, variantName = StrawberitaVFX.getConfig(variantValue or model)
	local root = getRoot(model)
	if not root then
		return nil
	end

	StrawberitaVFX.cleanupVFX(model)
	setVFXAttributes(model, variantName)

	local attachment = Instance.new("Attachment")
	attachment.Name = "StrawberitaVariantAuraAttachment"
	attachment.Position = Vector3.new(0, context == "Platform" and 1.25 or 0.7, 0)
	attachment:SetAttribute("StrawberitaVariantVFXObject", true)
	attachment.Parent = root

	local rate = config.platformRate
	if context == "Transform" then
		rate = math.max(config.platformRate * 0.5, 0.45)
	elseif context == "Reveal" then
		rate = config.platformRate + 1.4
	end

	local emitter = createSparkleEmitter(attachment, "StrawberitaVariantPlatformSparkles", config, rate)
	emitter:SetAttribute("StrawberitaVariantVFXObject", true)

	local glowLight = nil
	if config.platformLightBrightness and config.platformLightBrightness > 0 then
		glowLight = Instance.new("PointLight")
		glowLight.Name = "StrawberitaVariantGlow"
		glowLight.Color = config.auraColor
		glowLight.Brightness = context == "Transform" and config.platformLightBrightness * 0.7 or config.platformLightBrightness
		glowLight.Range = context == "Transform" and math.max(config.platformLightRange - 1.5, 5) or config.platformLightRange
		glowLight:SetAttribute("StrawberitaVariantVFXObject", true)
		glowLight.Parent = root
	end

	return {
		attachment = attachment,
		emitter = emitter,
		glowLight = glowLight,
		config = config,
		variantName = variantName,
	}
end

function StrawberitaVFX.startPlatformVFX(model, variantValue)
	local state = StrawberitaVFX.applyVariantVFX(model, variantValue, "Platform")
	if model then
		model:SetAttribute("PlatformIdleAnimation", "Active")
	end
	return state
end

function StrawberitaVFX.startTransformedPlayerVFX(player, model, variantValue)
	local state = StrawberitaVFX.applyVariantVFX(model, variantValue, "Transform")
	if not state then
		return nil
	end

	local root = getRoot(model)
	local config = state.config

	local trailAttachment = Instance.new("Attachment")
	trailAttachment.Name = "StrawberitaVariantReturnTrailAttachment"
	trailAttachment.Position = Vector3.new(0, -1.35, 0.35)
	trailAttachment:SetAttribute("StrawberitaVariantVFXObject", true)
	trailAttachment.Parent = root

	local trailEmitter = createSparkleEmitter(trailAttachment, "StrawberitaVariantReturnTrail", config, config.trailIdleRate)
	trailEmitter.Lifetime = NumberRange.new(0.32, 0.75)
	trailEmitter.Speed = NumberRange.new(0.35, 1.05)
	trailEmitter:SetAttribute("StrawberitaVariantVFXObject", true)

	if player then
		player:SetAttribute("TransformedStrawberitaVariant", state.variantName)
	end

	state.trailAttachment = trailAttachment
	state.trailEmitter = trailEmitter
	state.trailMovingRate = config.trailRate
	state.trailIdleRate = config.trailIdleRate
	return state
end

local function playBurst(parent, position, variantValue, name, countField)
	printVersion()

	local config = StrawberitaVFX.getConfig(variantValue)
	local container = typeof(parent) == "Instance" and parent or Workspace
	local anchor = Instance.new("Part")
	anchor.Name = "StrawberitaVariantBurstAnchor"
	anchor.Size = Vector3.new(0.2, 0.2, 0.2)
	anchor.CFrame = CFrame.new(position)
	anchor.Transparency = 1
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanTouch = false
	anchor.CanQuery = false
	anchor.TopSurface = Enum.SurfaceType.Smooth
	anchor.BottomSurface = Enum.SurfaceType.Smooth
	anchor:SetAttribute("StrawberitaVariantVFXObject", true)
	anchor.Parent = container

	local attachment = Instance.new("Attachment")
	attachment.Name = `{name}Attachment`
	attachment:SetAttribute("StrawberitaVariantVFXObject", true)
	attachment.Parent = anchor

	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = name
	emitter.Color = ColorSequence.new(config.burstColorA, config.burstColorB)
	emitter.LightEmission = 0.62
	emitter.Rate = 0
	emitter.Lifetime = NumberRange.new(0.45, 1.2)
	emitter.Speed = NumberRange.new(1.2, 3.2)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.22),
		NumberSequenceKeypoint.new(0.55, 0.14),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter:SetAttribute("StrawberitaVariantVFXObject", true)
	emitter.Parent = attachment
	emitter:Emit(config[countField] or 24)

	Debris:AddItem(anchor, 1.6)
	return anchor
end

function StrawberitaVFX.playRevealBurst(parent, position, variantValue)
	return playBurst(parent, position, variantValue, "StrawberitaVariantRevealBurst", "revealCount")
end

function StrawberitaVFX.playRewardSecuredBurst(parent, position, variantValue)
	return playBurst(parent, position, variantValue, "StrawberitaVariantSecuredBurst", "securedCount")
end

function StrawberitaVFX.applyToolVFX(tool, variantValue)
	printVersion()

	if not tool or not tool:IsA("Tool") then
		return nil
	end

	local handle = tool:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then
		return nil
	end

	local config, variantName = StrawberitaVFX.getConfig(variantValue or tool)
	tool:SetAttribute("VariantVFX", "Active")
	tool:SetAttribute("VariantName", variantName)

	local attachment = Instance.new("Attachment")
	attachment.Name = "StrawberitaToolVFXAttachment"
	attachment.Position = Vector3.new(0, 0.45, 0)
	attachment:SetAttribute("StrawberitaVariantVFXObject", true)
	attachment.Parent = handle

	local emitter = createSparkleEmitter(attachment, "StrawberitaToolVariantSparkles", config, 0)
	emitter.Lifetime = NumberRange.new(0.35, 0.75)
	emitter:SetAttribute("StrawberitaVariantVFXObject", true)

	local equippedConnection
	local unequippedConnection
	equippedConnection = tool.Equipped:Connect(function()
		if emitter.Parent then
			emitter.Rate = config.toolRate
		end
	end)
	unequippedConnection = tool.Unequipped:Connect(function()
		if emitter.Parent then
			emitter.Rate = 0
		end
	end)

	tool.Destroying:Connect(function()
		if equippedConnection then
			equippedConnection:Disconnect()
		end
		if unequippedConnection then
			unequippedConnection:Disconnect()
		end
	end)

	return emitter
end

printVersion()

return StrawberitaVFX
