local Config = require(script.Parent.Parent.Configs.BrainrotFruitConfig)
local BaseStrawberita = require(script.Parent.Strawberita.BaseStrawberita)

local StrawberitaFactory = {}

local templateCache = {}
local DEFAULT_COLLECTIBLE_SCALE = 0.92

local BODY_ROLES = {
	Body = true,
	BodyDark = true,
	BodyShade = true,
	Bow = true,
	BerryIcon = true,
	Shoe = true,
}

local function getVariant(variantName)
	return Config.StrawberitaVariants[variantName or Config.DefaultVariant]
		or Config.StrawberitaVariants[Config.DefaultVariant]
end

local function getTemplate(scale)
	local key = tostring(scale or 1)
	if not templateCache[key] then
		templateCache[key] = BaseStrawberita.create({
			anchored = true,
			name = "BaseStrawberitaTemplate",
			scale = scale or 1,
		})
	end

	return templateCache[key]
end

local function getDarker(color, amount)
	return color:Lerp(Color3.fromRGB(55, 24, 31), amount or 0.16)
end

local function getLighter(color, amount)
	return color:Lerp(Color3.fromRGB(255, 255, 255), amount or 0.22)
end

local function setPartMaterial(part, role, variant)
	if role == "Seed" then
		part.Material = variant.seedMaterial or Enum.Material.SmoothPlastic
	elseif role == "EyeHighlight" then
		part.Material = Enum.Material.Neon
	elseif BODY_ROLES[role] then
		part.Material = variant.material or Enum.Material.SmoothPlastic
	elseif role == "Leaf" or role == "LeafShadow" then
		part.Material = variant.leafMaterial or Enum.Material.SmoothPlastic
	else
		part.Material = Enum.Material.SmoothPlastic
	end
end

local function getRoleColor(role, variant)
	if role == "Body" then
		return variant.bodyColor
	elseif role == "BodyDark" then
		return variant.bodyDarkColor or getDarker(variant.bodyColor, 0.14)
	elseif role == "BodyShade" then
		return variant.bodyShadeColor or variant.bodyDarkColor or getDarker(variant.bodyColor, 0.22)
	elseif role == "FacePanel" then
		return variant.facePanelColor or variant.skinColor or BaseStrawberita.Palette.FacePanel
	elseif role == "Skin" then
		return variant.skinColor or variant.facePanelColor or BaseStrawberita.Palette.Skin
	elseif role == "Seed" then
		return variant.seedColor
	elseif role == "Leaf" then
		return variant.leafColor
	elseif role == "LeafShadow" then
		return variant.leafShadowColor or getDarker(variant.leafColor, 0.2)
	elseif role == "Stem" then
		return variant.stemColor or BaseStrawberita.Palette.Stem
	elseif role == "Cheek" then
		return variant.cheekColor
	elseif role == "EyeFrame" then
		return BaseStrawberita.Palette.EyeFrame
	elseif role == "EyeWhite" then
		return BaseStrawberita.Palette.EyeWhite
	elseif role == "EyePupil" then
		return variant.eyeColor or BaseStrawberita.Palette.EyePupil
	elseif role == "EyeHighlight" then
		return BaseStrawberita.Palette.EyeHighlight
	elseif role == "Smile" then
		return BaseStrawberita.Palette.Smile
	elseif role == "Sock" then
		return variant.sockColor or getLighter(variant.bodyColor, 0.42)
	elseif role == "SockCuff" then
		return variant.sockCuffColor or BaseStrawberita.Palette.SockCuff
	elseif role == "Shoe" then
		return variant.shoeColor or getDarker(variant.bodyColor, 0.1)
	elseif role == "ShoePanel" then
		return variant.shoePanelColor or BaseStrawberita.Palette.ShoePanel
	elseif role == "BeltStud" then
		return variant.beltColor or BaseStrawberita.Palette.BeltStud
	elseif role == "Bow" then
		return variant.bowColor or getLighter(variant.bodyColor, 0.12)
	elseif role == "BerryIcon" then
		return variant.bodyAccentColor or getDarker(variant.bodyColor, 0.08)
	end

	return nil
end

local function addLabel(root, displayName, rarity, scale)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PreviewLabel"
	billboard.Size = UDim2.fromOffset(170, 48)
	billboard.StudsOffset = Vector3.new(0, 5.15 * (scale or 1), 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 85
	billboard.Parent = root

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = `{displayName}\n{rarity or "Common"}`
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.35
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard
end

local function addSparkles(root, color)
	local attachment = Instance.new("Attachment")
	attachment.Name = "BlockySparkleAttachment"
	attachment.Parent = root

	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "BlockySparkles"
	emitter.Color = ColorSequence.new(color)
	emitter.LightEmission = 0.55
	emitter.Rate = 7
	emitter.Lifetime = NumberRange.new(0.65, 1.2)
	emitter.Speed = NumberRange.new(0.6, 1.5)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.18),
		NumberSequenceKeypoint.new(0.45, 0.12),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Parent = attachment
end

local function addVariantEffects(model, root, variant)
	local effects = variant.effects or {}

	if effects.highlight then
		local highlight = Instance.new("Highlight")
		highlight.Name = "VariantHighlight"
		highlight.FillColor = effects.highlight
		highlight.OutlineColor = effects.highlight
		highlight.FillTransparency = 0.86
		highlight.OutlineTransparency = 0.22
		highlight.Parent = model
	end

	if effects.light then
		local light = Instance.new("PointLight")
		light.Name = "VariantGlow"
		light.Color = effects.light
		light.Brightness = 1.2
		light.Range = 9
		light.Parent = root
	end

	if effects.sparkles then
		addSparkles(root, effects.sparkles)
	end

	if effects.aura then
		local light = Instance.new("PointLight")
		light.Name = "GalaxyBlockAura"
		light.Color = effects.aura
		light.Brightness = 0.85
		light.Range = 12
		light.Parent = root
	end
end

local function applyVariant(model, variant)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local role = descendant:GetAttribute("StrawberitaRole")
			local color = getRoleColor(role, variant)
			if color then
				descendant.Color = color
				descendant:SetAttribute("VariantVisualRole", role)
			end

			setPartMaterial(descendant, role, variant)
		end
	end
end

function StrawberitaFactory.getBaseReferenceInfo()
	return {
		templateName = BaseStrawberita.TemplateName,
		templateVersion = BaseStrawberita.TemplateVersion,
		referencePath = BaseStrawberita.ReferencePath,
		referenceDescription = BaseStrawberita.ReferenceDescription,
	}
end

function StrawberitaFactory.createBaseTemplate(options)
	options = options or {}
	return BaseStrawberita.create({
		anchored = options.anchored,
		name = options.name or BaseStrawberita.TemplateName,
		pivot = options.pivot,
		scale = options.scale,
	})
end

function StrawberitaFactory.create(variantName, options)
	options = options or {}

	local variant = getVariant(variantName)
	local scale = options.scale or DEFAULT_COLLECTIBLE_SCALE
	local pivot = options.pivot or CFrame.new()

	local model = getTemplate(scale):Clone()
	model.Name = "Strawberita"
	model:SetAttribute("VariantId", variant.id)
	model:SetAttribute("DisplayName", variant.displayName)
	model:SetAttribute("Rarity", variant.rarity)
	model:SetAttribute("Style", "VoxelStrawberryMascot")
	model:SetAttribute("CanonicalBaseName", BaseStrawberita.TemplateName)
	model:SetAttribute("CanonicalBaseVersion", BaseStrawberita.TemplateVersion)
	model:SetAttribute("CanonicalReferencePath", BaseStrawberita.ReferencePath)
	model:SetAttribute("VariantDerivedFromBase", true)
	model:SetAttribute("EstimatedHeightStuds", (BaseStrawberita.EstimatedHeightStuds or 6.05) * scale)

	local root = BaseStrawberita.ensurePrimaryPart(model)
	if not root then
		error("BaseStrawberita template is missing a PrimaryPart")
	end

	BaseStrawberita.setAnchored(model, options.anchored ~= false)
	applyVariant(model, variant)
	addVariantEffects(model, root, variant)
	model:PivotTo(pivot)

	if options.label then
		addLabel(root, variant.displayName, variant.rarity, scale)
	end

	return model
end

function StrawberitaFactory.CreateStrawberita(variantName, options)
	return StrawberitaFactory.create(variantName, options)
end

function StrawberitaFactory.createPreviewLineup(parent, variantOrder, origin)
	variantOrder = variantOrder or Config.VariantOrder
	origin = origin or CFrame.new()

	local created = {}
	for index, variantName in ipairs(variantOrder) do
		local offset = CFrame.new((index - 1) * 8, 0, 0)
		local model = StrawberitaFactory.create(variantName, {
			anchored = true,
			label = true,
			pivot = origin * offset,
		})
		model.Parent = parent
		table.insert(created, model)
	end

	return created
end

function StrawberitaFactory.CreatePreviewLineup(parent, variantOrder, origin)
	return StrawberitaFactory.createPreviewLineup(parent, variantOrder, origin)
end

return StrawberitaFactory
