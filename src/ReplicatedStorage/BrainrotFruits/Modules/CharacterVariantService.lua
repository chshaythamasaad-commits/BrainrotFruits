local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local CharacterRegistry = require(script.Parent.CharacterRegistry)

local CharacterVariantService = {}

CharacterVariantService.Version = "CharacterVariantService_V1"

local activeColorCycles = {}

local VARIANT_OBJECT_NAMES = {
	CharacterVariantAuraAttachment = true,
	CharacterVariantSparkles = true,
	CharacterVariantGlow = true,
	CharacterVariantBurstAnchor = true,
	CharacterVariantRevealBurst = true,
	CharacterVariantSecuredBurst = true,
	CharacterVariantToolAttachment = true,
	CharacterVariantToolSparkles = true,
}

local PRESENTATION_COLORS = {
	-- Tune variant aura color, particle rate, light strength, and burst counts here.
	-- New variants should also be registered in CharacterRegistry.VariantOrder.
	Base = {
		auraColor = Color3.fromRGB(255, 244, 248),
		sparkleColorA = Color3.fromRGB(255, 255, 245),
		sparkleColorB = Color3.fromRGB(255, 194, 218),
		burstColorA = Color3.fromRGB(255, 255, 245),
		burstColorB = Color3.fromRGB(255, 171, 207),
		platformRate = 0.55,
		platformBounce = 0.17,
		platformLightBrightness = 0,
		platformDisplayLightBrightness = 0,
		platformLightRange = 0,
		trailRate = 7,
		trailIdleRate = 1.5,
		toolRate = 1.2,
		revealCount = 20,
		securedCount = 18,
	},
	Golden = {
		auraColor = Color3.fromRGB(255, 211, 73),
		sparkleColorA = Color3.fromRGB(255, 248, 170),
		sparkleColorB = Color3.fromRGB(255, 184, 45),
		burstColorA = Color3.fromRGB(255, 250, 168),
		burstColorB = Color3.fromRGB(255, 178, 35),
		platformRate = 2.7,
		platformBounce = 0.22,
		platformLightBrightness = 0.32,
		platformDisplayLightBrightness = 0.3,
		platformLightRange = 7.5,
		trailRate = 14,
		trailIdleRate = 3,
		toolRate = 3,
		revealCount = 34,
		securedCount = 30,
	},
	Diamond = {
		auraColor = Color3.fromRGB(162, 239, 255),
		sparkleColorA = Color3.fromRGB(245, 255, 255),
		sparkleColorB = Color3.fromRGB(105, 214, 255),
		burstColorA = Color3.fromRGB(250, 255, 255),
		burstColorB = Color3.fromRGB(112, 224, 255),
		platformRate = 3.1,
		platformBounce = 0.2,
		platformLightBrightness = 0.38,
		platformDisplayLightBrightness = 0.34,
		platformLightRange = 8.5,
		trailRate = 15,
		trailIdleRate = 3.5,
		toolRate = 3.2,
		revealCount = 38,
		securedCount = 32,
	},
	Galaxy = {
		auraColor = Color3.fromRGB(129, 81, 255),
		sparkleColorA = Color3.fromRGB(116, 245, 255),
		sparkleColorB = Color3.fromRGB(211, 102, 255),
		burstColorA = Color3.fromRGB(121, 246, 255),
		burstColorB = Color3.fromRGB(155, 82, 255),
		platformRate = 4.2,
		platformBounce = 0.25,
		platformLightBrightness = 0.46,
		platformDisplayLightBrightness = 0.4,
		platformLightRange = 10,
		trailRate = 18,
		trailIdleRate = 4,
		toolRate = 4,
		revealCount = 46,
		securedCount = 38,
	},
	Rainbow = {
		auraColor = Color3.fromRGB(104, 238, 255),
		sparkleColorA = Color3.fromRGB(255, 104, 166),
		sparkleColorB = Color3.fromRGB(104, 238, 255),
		burstColorA = Color3.fromRGB(255, 216, 91),
		burstColorB = Color3.fromRGB(122, 105, 255),
		platformRate = 3.5,
		platformBounce = 0.24,
		platformLightBrightness = 0.36,
		platformDisplayLightBrightness = 0.32,
		platformLightRange = 8,
		trailRate = 15,
		trailIdleRate = 3.2,
		toolRate = 3.4,
		revealCount = 38,
		securedCount = 32,
	},
	Toxic = {
		auraColor = Color3.fromRGB(124, 255, 61),
		sparkleColorA = Color3.fromRGB(196, 255, 90),
		sparkleColorB = Color3.fromRGB(174, 87, 255),
		burstColorA = Color3.fromRGB(173, 255, 76),
		burstColorB = Color3.fromRGB(122, 39, 168),
		platformRate = 3.2,
		platformBounce = 0.21,
		platformLightBrightness = 0.34,
		platformDisplayLightBrightness = 0.3,
		platformLightRange = 8,
		trailRate = 14,
		trailIdleRate = 3,
		toolRate = 3.1,
		revealCount = 36,
		securedCount = 30,
	},
	Cosmic = {
		auraColor = Color3.fromRGB(129, 81, 255),
		sparkleColorA = Color3.fromRGB(116, 245, 255),
		sparkleColorB = Color3.fromRGB(211, 102, 255),
		burstColorA = Color3.fromRGB(121, 246, 255),
		burstColorB = Color3.fromRGB(155, 82, 255),
		platformRate = 4.2,
		platformBounce = 0.26,
		platformLightBrightness = 0.48,
		platformDisplayLightBrightness = 0.4,
		platformLightRange = 10,
		trailRate = 18,
		trailIdleRate = 4,
		toolRate = 4,
		revealCount = 46,
		securedCount = 38,
	},
}

local RAINBOW_COLORS = {
	Color3.fromRGB(255, 96, 130),
	Color3.fromRGB(255, 195, 74),
	Color3.fromRGB(124, 242, 99),
	Color3.fromRGB(86, 216, 255),
	Color3.fromRGB(165, 105, 255),
}

local function getRoot(instance)
	if not instance then
		return nil
	end
	if instance:IsA("BasePart") then
		return instance
	end
	if instance:IsA("Model") then
		return instance.PrimaryPart or instance:FindFirstChild("Root") or instance:FindFirstChildWhichIsA("BasePart", true)
	end
	return instance:FindFirstChildWhichIsA("BasePart", true)
end

local function getPartBaseColor(part)
	local baseColor = part:GetAttribute("BaseColor")
	return typeof(baseColor) == "Color3" and baseColor or part.Color
end

local function getPartBaseMaterial(part)
	local materialName = part:GetAttribute("BaseMaterial")
	if type(materialName) == "string" then
		local ok, material = pcall(function()
			return Enum.Material[materialName]
		end)
		if ok and material then
			return material
		end
	end
	return part.Material
end

local function getPresentationConfig(characterId, variantId)
	local variantDefinition, normalizedVariantId = CharacterRegistry.getVariant(characterId, variantId)
	local source = PRESENTATION_COLORS[normalizedVariantId] or PRESENTATION_COLORS.Base
	local config = {}
	for key, value in pairs(source) do
		config[key] = value
	end
	config.variantDefinition = variantDefinition
	config.variantName = normalizedVariantId
	config.displayName = variantDefinition.DisplayName
	config.displayColor = source.auraColor
	return config, normalizedVariantId
end

function CharacterVariantService.normalizeVariantName(value)
	return CharacterRegistry.normalizeVariantId(value)
end

function CharacterVariantService.getConfig(characterIdOrVariant, maybeVariant)
	local characterId = maybeVariant and characterIdOrVariant or "Strawberita"
	local variantId = maybeVariant or characterIdOrVariant
	return getPresentationConfig(characterId, variantId)
end

function CharacterVariantService.cleanupVFX(instance)
	if not instance then
		return
	end

	activeColorCycles[instance] = nil
	for _, descendant in ipairs(instance:GetDescendants()) do
		if VARIANT_OBJECT_NAMES[descendant.Name] or descendant:GetAttribute("CharacterVariantVFXObject") == true then
			descendant:Destroy()
		end
	end
end

local function createSparkleEmitter(parent, name, config, rate)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = name
	emitter.Color = ColorSequence.new(config.sparkleColorA, config.sparkleColorB)
	emitter.LightEmission = 0.5
	emitter.Rate = rate or 0
	emitter.Lifetime = NumberRange.new(0.45, 1.1)
	emitter.Speed = NumberRange.new(0.18, 0.8)
	emitter.SpreadAngle = Vector2.new(82, 82)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.13),
		NumberSequenceKeypoint.new(0.55, 0.09),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter:SetAttribute("CharacterVariantVFXObject", true)
	emitter.Parent = parent
	return emitter
end

local function startRainbowCycle(model)
	activeColorCycles[model] = true
	task.spawn(function()
		local index = 1
		while activeColorCycles[model] and model.Parent do
			local color = RAINBOW_COLORS[index]
			local nextColor = RAINBOW_COLORS[(index % #RAINBOW_COLORS) + 1]
			for _, part in ipairs(model:GetDescendants()) do
				if part:IsA("BasePart") then
					local colorRole = part:GetAttribute("VariantColorRole")
					if colorRole == "Fruit" or colorRole == "FruitDark" or colorRole == "Accent" then
						local targetColor = colorRole == "FruitDark" and color:Lerp(Color3.fromRGB(30, 30, 55), 0.32) or color:Lerp(nextColor, colorRole == "Accent" and 0.45 or 0)
						TweenService:Create(part, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = targetColor }):Play()
					end
				end
			end
			index = (index % #RAINBOW_COLORS) + 1
			task.wait(0.82)
		end
	end)
end

function CharacterVariantService.applyVariantVFX(model, characterId, variantId, context)
	local root = getRoot(model)
	if not root then
		return nil
	end

	CharacterVariantService.cleanupVFX(model)
	local character = CharacterRegistry.getCharacter(characterId or model)
	local config, normalizedVariantId = getPresentationConfig(character.Id, variantId or model)
	local variantDefinition = config.variantDefinition

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local colorRole = descendant:GetAttribute("VariantColorRole")
			local keepReadableMaterial = colorRole == "Face" or colorRole == "Eye" or colorRole == "Skin"
			if colorRole ~= "Face" and colorRole ~= "Eye" and colorRole ~= "Skin" then
				local color = variantDefinition.Palette[colorRole]
				descendant.Color = normalizedVariantId == "Base" and getPartBaseColor(descendant) or (color or getPartBaseColor(descendant))
			else
				descendant.Color = getPartBaseColor(descendant)
			end

			descendant.Material = (normalizedVariantId == "Base" or keepReadableMaterial) and getPartBaseMaterial(descendant) or (variantDefinition.Material or getPartBaseMaterial(descendant))
		end
	end

	model:SetAttribute("CharacterId", character.Id)
	model:SetAttribute("VariantName", normalizedVariantId)
	model:SetAttribute("VariantId", normalizedVariantId)
	model:SetAttribute("VariantVFX", "Active")
	model:SetAttribute("CharacterVariantVFXVersion", CharacterVariantService.Version)

	if variantDefinition.HasColorCycling then
		startRainbowCycle(model)
	end

	if variantDefinition.HasParticles then
		local attachment = Instance.new("Attachment")
		attachment.Name = "CharacterVariantAuraAttachment"
		attachment.Position = Vector3.new(0, context == "Platform" and 1.35 or 0.8, 0)
		attachment:SetAttribute("CharacterVariantVFXObject", true)
		attachment.Parent = root

		local rate = config.platformRate
		if context == "Reveal" then
			rate += 1.2
		elseif context == "Tool" then
			rate = 0
		end

		local emitter = createSparkleEmitter(attachment, "CharacterVariantSparkles", config, rate)
		local light = nil
		if config.platformLightBrightness > 0 and context ~= "Tool" then
			light = Instance.new("PointLight")
			light.Name = "CharacterVariantGlow"
			light.Color = config.auraColor
			light.Brightness = config.platformLightBrightness
			light.Range = config.platformLightRange
			light:SetAttribute("CharacterVariantVFXObject", true)
			light.Parent = root
		end

		return {
			attachment = attachment,
			emitter = emitter,
			glowLight = light,
			config = config,
			variantName = normalizedVariantId,
		}
	end

	return {
		config = config,
		variantName = normalizedVariantId,
	}
end

function CharacterVariantService.startPlatformVFX(model, characterId, variantId)
	return CharacterVariantService.applyVariantVFX(model, characterId, variantId, "Platform")
end

local function playBurst(parent, position, characterId, variantId, name, countField)
	local config = getPresentationConfig(characterId or "Strawberita", variantId)
	local container = typeof(parent) == "Instance" and parent or Workspace
	local anchor = Instance.new("Part")
	anchor.Name = "CharacterVariantBurstAnchor"
	anchor.Size = Vector3.new(0.2, 0.2, 0.2)
	anchor.CFrame = CFrame.new(position)
	anchor.Transparency = 1
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanTouch = false
	anchor.CanQuery = false
	anchor:SetAttribute("CharacterVariantVFXObject", true)
	anchor.Parent = container

	local attachment = Instance.new("Attachment")
	attachment.Name = `{name}Attachment`
	attachment:SetAttribute("CharacterVariantVFXObject", true)
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
	emitter:SetAttribute("CharacterVariantVFXObject", true)
	emitter.Parent = attachment
	emitter:Emit(config[countField] or 24)

	Debris:AddItem(anchor, 1.6)
	return anchor
end

function CharacterVariantService.playRevealBurst(parent, position, characterId, variantId)
	return playBurst(parent, position, characterId, variantId, "CharacterVariantRevealBurst", "revealCount")
end

function CharacterVariantService.playRewardSecuredBurst(parent, position, characterId, variantId)
	return playBurst(parent, position, characterId, variantId, "CharacterVariantSecuredBurst", "securedCount")
end

function CharacterVariantService.applyToolVFX(tool, characterId, variantId)
	if not tool or not tool:IsA("Tool") then
		return nil
	end

	local handle = tool:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then
		return nil
	end

	local config, normalizedVariantId = getPresentationConfig(characterId or tool:GetAttribute("CharacterId"), variantId or tool:GetAttribute("RewardVariant"))
	tool:SetAttribute("VariantVFX", "Active")
	tool:SetAttribute("VariantName", normalizedVariantId)

	local attachment = Instance.new("Attachment")
	attachment.Name = "CharacterVariantToolAttachment"
	attachment.Position = Vector3.new(0, 0.45, 0)
	attachment:SetAttribute("CharacterVariantVFXObject", true)
	attachment.Parent = handle

	local emitter = createSparkleEmitter(attachment, "CharacterVariantToolSparkles", config, 0)
	emitter.Lifetime = NumberRange.new(0.35, 0.75)

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

return CharacterVariantService
