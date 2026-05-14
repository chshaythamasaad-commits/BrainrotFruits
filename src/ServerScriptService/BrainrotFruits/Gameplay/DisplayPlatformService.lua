local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CharacterRegistry = require(brainrotFruits.Modules.CharacterRegistry)
local CharacterVariantService = require(brainrotFruits.Modules.CharacterVariantService)

local DisplayPlatformService = {}

DisplayPlatformService.Version = "AnimatedCollectibleDisplay_V1"

local printedVersion = false
local activeByModel = {}

local PRESENTATION_OBJECT_NAMES = {
	DisplayPlatformPresentation = true,
	DisplayIncomeRarityBillboard = true,
	DisplayBillboardFrame = true,
	DisplayIncomeLine = true,
	DisplayRarityLine = true,
	DisplayNameLine = true,
	DisplayPlatformGlowCenter = true,
	DisplayPlatformTrimFront = true,
	DisplayPlatformTrimBack = true,
	DisplayPlatformTrimLeft = true,
	DisplayPlatformTrimRight = true,
	DisplayPlatformPulseLight = true,
	DisplayPlatformValuePlate = true,
	DisplayPlatformPlateText = true,
}

local RARITY_COLORS = {
	Common = Color3.fromRGB(255, 244, 248),
	Uncommon = Color3.fromRGB(188, 255, 197),
	Rare = Color3.fromRGB(255, 218, 71),
	Epic = Color3.fromRGB(168, 112, 255),
	Legendary = Color3.fromRGB(188, 246, 255),
	Mythic = Color3.fromRGB(121, 246, 255),
}

local function markPresentationObject(instance)
	instance:SetAttribute("DisplayPresentationObject", true)
	return instance
end

local function markMap()
	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		map:SetAttribute("DisplayPresentationVersion", DisplayPlatformService.Version)
		map:SetAttribute("CharacterVariantVFXVersion", CharacterVariantService.Version)
		map:SetAttribute("StrawberitaVariantVFXVersion", "VariantAuraSparkle_V1")
	end
end

local function printVersion()
	if not printedVersion then
		print("[BrainrotFruits] DisplayPlatformPresentation_V1 active")
		print("[BrainrotFruits] Animated collectible display active")
		printedVersion = true
	end
	markMap()
end

local function clearPresentationObjects(parent)
	if not parent then
		return
	end

	for _, descendant in ipairs(parent:GetDescendants()) do
		if PRESENTATION_OBJECT_NAMES[descendant.Name] or descendant:GetAttribute("DisplayPresentationObject") == true then
			descendant:Destroy()
		end
	end
end

local function getModelRoot(model)
	if not model then
		return nil
	end

	if model:IsA("Model") then
		return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	elseif model:IsA("BasePart") then
		return model
	end

	return nil
end

local function getCompactNumber(value)
	local number = tonumber(value) or 0
	local abs = math.abs(number)

	if abs >= 1000000000 then
		return string.format("%.1fB", number / 1000000000)
	elseif abs >= 1000000 then
		return string.format("%.1fM", number / 1000000)
	elseif abs >= 1000 then
		return string.format("%.1fK", number / 1000)
	elseif abs >= 100 then
		return tostring(math.floor(number + 0.5))
	elseif abs >= 10 then
		return string.format("%.1f", number)
	end

	return string.format("%.0f", number)
end

local function resolveCharacterData(model, characterData)
	local data = characterData or {}
	local characterId = CharacterRegistry.normalizeCharacterId(
		data.characterId
			or data.CharacterId
			or (model and model:GetAttribute("CharacterId"))
			or "Strawberita"
	)
	local character = CharacterRegistry.getCharacter(characterId)
	local rawVariant = data.variantName
		or data.variant
		or data.variantId
		or (model and (model:GetAttribute("RewardVariant") or model:GetAttribute("VariantName") or model:GetAttribute("VariantId")))
		or CharacterRegistry.VariantOrder[1]
	local variantConfig, normalizedVariant = CharacterRegistry.getVariant(character.Id, rawVariant)
	local vfxConfig = CharacterVariantService.getConfig(character.Id, normalizedVariant)
	local rarity = data.rarity
		or variantConfig.rarity
		or variantConfig.Rarity
		or character.Rarity
		or "Common"
	local displayName = data.displayName
		or variantConfig.displayName
		or variantConfig.DisplayName
		or (model and model:GetAttribute("DisplayName"))
		or character.DisplayName
	local income = data.incomePerSecond
		or data.income
		or (model and model:GetAttribute("IncomePerSecond"))
		or math.max(1, math.floor(4 * (character.IncomeMultiplier or 1) * (variantConfig.IncomeMultiplierModifier or 1) + 0.5))
	local value = data.value
		or (model and model:GetAttribute("RewardValue"))
		or math.max(income * 275, 25)
	local level = data.level or 1
	local displayColor = (vfxConfig and (vfxConfig.displayColor or vfxConfig.auraColor))
		or RARITY_COLORS[rarity]
		or Color3.fromRGB(255, 244, 248)

	return {
		rawVariant = rawVariant,
		variantName = normalizedVariant,
		characterId = character.Id,
		displayName = displayName,
		rarity = rarity,
		income = income,
		value = value,
		level = level,
		color = displayColor,
		vfxConfig = vfxConfig,
	}
end

local function addTextLine(parent, name, text, color, position, size, maxTextSize)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(18, 18, 24)
	label.TextStrokeTransparency = 0.12
	label.TextWrapped = true
	label.Position = position
	label.Size = size
	markPresentationObject(label)
	label.Parent = parent

	local constraint = Instance.new("UITextSizeConstraint")
	constraint.MaxTextSize = maxTextSize or 20
	constraint.MinTextSize = 8
	constraint.Parent = label

	return label
end

function DisplayPlatformService.createIncomeRarityBillboard(model, characterData)
	local root = getModelRoot(model)
	if not root then
		return nil
	end

	local data = resolveCharacterData(model, characterData)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "DisplayIncomeRarityBillboard"
	billboard.Size = UDim2.fromOffset(154, 70)
	billboard.StudsOffset = Vector3.new(0, 4.95, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 48
	billboard.LightInfluence = 0.15
	markPresentationObject(billboard)
	billboard.Parent = root

	local frame = Instance.new("Frame")
	frame.Name = "DisplayBillboardFrame"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = UDim2.fromScale(1, 1)
	markPresentationObject(frame)
	frame.Parent = billboard

	addTextLine(
		frame,
		"DisplayIncomeLine",
		"$" .. getCompactNumber(data.income) .. "/s",
		Color3.fromRGB(118, 255, 137),
		UDim2.fromScale(0, 0),
		UDim2.fromScale(1, 0.34),
		22
	)
	addTextLine(
		frame,
		"DisplayRarityLine",
		data.rarity,
		data.color,
		UDim2.fromScale(0, 0.33),
		UDim2.fromScale(1, 0.29),
		18
	)
	addTextLine(
		frame,
		"DisplayNameLine",
		data.displayName,
		Color3.fromRGB(255, 255, 255),
		UDim2.fromScale(0, 0.62),
		UDim2.fromScale(1, 0.38),
		17
	)

	return billboard
end

local function createPresentationPart(parent, name, size, cframe, color, material, transparency)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Transparency = transparency or 0
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	markPresentationObject(part)
	part.Parent = parent
	return part
end

local function createPulseTween(instance, properties, seconds)
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(seconds or 1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		properties
	)
	tween:Play()
	return tween
end

local function createPlatformGlow(slot, data)
	local folder = Instance.new("Folder")
	folder.Name = "DisplayPlatformPresentation"
	markPresentationObject(folder)
	folder.Parent = slot

	local color = data.color
	local topOffset = (slot.Size.Y / 2) + 0.08
	local glowCenter = createPresentationPart(
		folder,
		"DisplayPlatformGlowCenter",
		Vector3.new(slot.Size.X * 0.68, 0.08, slot.Size.Z * 0.68),
		slot.CFrame * CFrame.new(0, topOffset, 0),
		color,
		Enum.Material.Neon,
		0.46
	)

	local trimY = topOffset + 0.05
	local trimTransparency = data.variantName == "Base" and 0.24 or 0.12
	local trimThickness = 0.16
	local trimHeight = 0.12
	local frontBackSize = Vector3.new(slot.Size.X + 0.22, trimHeight, trimThickness)
	local sideSize = Vector3.new(trimThickness, trimHeight, slot.Size.Z + 0.22)

	local trimFront = createPresentationPart(
		folder,
		"DisplayPlatformTrimFront",
		frontBackSize,
		slot.CFrame * CFrame.new(0, trimY, -slot.Size.Z / 2 - trimThickness / 2),
		color,
		Enum.Material.Neon,
		trimTransparency
	)
	local trimBack = createPresentationPart(
		folder,
		"DisplayPlatformTrimBack",
		frontBackSize,
		slot.CFrame * CFrame.new(0, trimY, slot.Size.Z / 2 + trimThickness / 2),
		color,
		Enum.Material.Neon,
		trimTransparency
	)
	local trimLeft = createPresentationPart(
		folder,
		"DisplayPlatformTrimLeft",
		sideSize,
		slot.CFrame * CFrame.new(-slot.Size.X / 2 - trimThickness / 2, trimY, 0),
		color,
		Enum.Material.Neon,
		trimTransparency
	)
	local trimRight = createPresentationPart(
		folder,
		"DisplayPlatformTrimRight",
		sideSize,
		slot.CFrame * CFrame.new(slot.Size.X / 2 + trimThickness / 2, trimY, 0),
		color,
		Enum.Material.Neon,
		trimTransparency
	)

	local tweens = {
		createPulseTween(glowCenter, { Transparency = data.variantName == "Base" and 0.34 or 0.26 }, 1.25),
		createPulseTween(trimFront, { Transparency = math.max(trimTransparency - 0.08, 0.04) }, 1.4),
		createPulseTween(trimBack, { Transparency = math.max(trimTransparency - 0.08, 0.04) }, 1.4),
		createPulseTween(trimLeft, { Transparency = math.max(trimTransparency - 0.08, 0.04) }, 1.4),
		createPulseTween(trimRight, { Transparency = math.max(trimTransparency - 0.08, 0.04) }, 1.4),
	}

	local platformLight = nil
	local lightBrightness = data.vfxConfig and data.vfxConfig.platformDisplayLightBrightness
	if not lightBrightness then
		lightBrightness = data.variantName == "Base" and 0 or 0.32
	end

	if lightBrightness > 0 then
		platformLight = Instance.new("PointLight")
		platformLight.Name = "DisplayPlatformPulseLight"
		platformLight.Color = color
		platformLight.Brightness = lightBrightness
		platformLight.Range = data.variantName == "Cosmic" and 9 or 7
		markPresentationObject(platformLight)
		platformLight.Parent = glowCenter
		table.insert(tweens, createPulseTween(platformLight, { Brightness = lightBrightness * 1.28 }, 1.25))
	end

	return {
		folder = folder,
		glowCenter = glowCenter,
		platformLight = platformLight,
		tweens = tweens,
	}
end

local function getPlotModel(slot)
	local ancestor = slot and slot.Parent
	while ancestor do
		if ancestor:IsA("Model") and ancestor:GetAttribute("PlotId") then
			return ancestor
		end
		ancestor = ancestor.Parent
	end
	return nil
end

function DisplayPlatformService.createPlatformValuePlate(slot, characterData)
	if not slot or not slot:IsA("BasePart") then
		return nil
	end

	local data = resolveCharacterData(nil, characterData)
	local plot = getPlotModel(slot)
	local targetPosition = plot and plot:GetPivot().Position or (slot.Position - slot.CFrame.LookVector)
	local direction = Vector3.new(targetPosition.X - slot.Position.X, 0, targetPosition.Z - slot.Position.Z)
	if direction.Magnitude < 0.1 then
		direction = -slot.CFrame.LookVector
	else
		direction = direction.Unit
	end

	local platePosition = slot.Position
		+ direction * (math.max(slot.Size.X, slot.Size.Z) * 0.5 + 0.85)
		+ Vector3.new(0, 1.05, 0)
	local plate = createPresentationPart(
		slot,
		"DisplayPlatformValuePlate",
		Vector3.new(4.15, 1.32, 0.22),
		CFrame.lookAt(platePosition, platePosition + direction),
		Color3.fromRGB(32, 34, 42),
		Enum.Material.SmoothPlastic,
		0.02
	)

	local surface = Instance.new("SurfaceGui")
	surface.Name = "DisplayPlatformPlateText"
	surface.Face = Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 38
	surface.LightInfluence = 0.12
	markPresentationObject(surface)
	surface.Parent = plate

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = "$" .. getCompactNumber(data.value) .. "\nLvl " .. tostring(data.level)
	label.TextColor3 = data.color
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0.15
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface

	local constraint = Instance.new("UITextSizeConstraint")
	constraint.MaxTextSize = 18
	constraint.MinTextSize = 8
	constraint.Parent = label

	return plate
end

function DisplayPlatformService.cleanupSlotPresentation(slot)
	clearPresentationObjects(slot)
end

function DisplayPlatformService.cleanupDisplayPresentation(model)
	local state = activeByModel[model]
	if state then
		activeByModel[model] = nil
		if state.ancestryConnection then
			state.ancestryConnection:Disconnect()
		end
		for _, tween in ipairs(state.tweens or {}) do
			tween:Cancel()
		end
		if state.slot then
			DisplayPlatformService.cleanupSlotPresentation(state.slot)
		end
	end

	clearPresentationObjects(model)
end

function DisplayPlatformService.applyDisplayPresentation(model, slot, characterData)
	printVersion()

	if not model or not slot then
		return nil
	end

	local root = getModelRoot(model)
	if not root then
		return nil
	end

	DisplayPlatformService.cleanupDisplayPresentation(model)
	DisplayPlatformService.cleanupSlotPresentation(slot)

	local data = resolveCharacterData(model, characterData)
	local billboard = DisplayPlatformService.createIncomeRarityBillboard(model, data)
	local platformGlow = createPlatformGlow(slot, data)
	local valuePlate = DisplayPlatformService.createPlatformValuePlate(slot, data)

	model:SetAttribute("DisplayPresentation", "Active")
	model:SetAttribute("VariantVFX", "Active")
	model:SetAttribute("PlatformIdleAnimation", "Active")
	model:SetAttribute("VariantName", data.variantName)
	model:SetAttribute("DisplayIncomePerSecond", data.income)
	model:SetAttribute("DisplayRarity", data.rarity)
	model:SetAttribute("DisplayPresentationVersion", DisplayPlatformService.Version)

	local state = {
		model = model,
		slot = slot,
		billboard = billboard,
		valuePlate = valuePlate,
		tweens = platformGlow.tweens or {},
	}
	activeByModel[model] = state

	state.ancestryConnection = model.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			DisplayPlatformService.cleanupDisplayPresentation(model)
		end
	end)

	return state
end

printVersion()

return DisplayPlatformService
