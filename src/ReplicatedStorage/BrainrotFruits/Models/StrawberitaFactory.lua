local Config = require(script.Parent.Parent.Configs.BrainrotFruitConfig)

local StrawberitaFactory = {}

local ZERO = Vector3.new(0, 0, 0)
local ONE = Vector3.new(1, 1, 1)

local SEED_PLACEMENTS = {
	{ offset = Vector3.new(-0.94, 2.34, -0.68), rotation = CFrame.Angles(0, 0, math.rad(-8)) },
	{ offset = Vector3.new(-0.24, 2.48, -0.7), rotation = CFrame.Angles(0, 0, math.rad(7)) },
	{ offset = Vector3.new(0.48, 2.42, -0.7), rotation = CFrame.Angles(0, 0, math.rad(10)) },
	{ offset = Vector3.new(1.02, 2.13, -0.66), rotation = CFrame.Angles(0, 0, math.rad(-7)) },
	{ offset = Vector3.new(-1.22, 1.55, -0.68), rotation = CFrame.Angles(0, 0, math.rad(8)) },
	{ offset = Vector3.new(1.22, 1.5, -0.68), rotation = CFrame.Angles(0, 0, math.rad(-8)) },
	{ offset = Vector3.new(-0.86, 0.72, -0.66), rotation = CFrame.Angles(0, 0, math.rad(9)) },
	{ offset = Vector3.new(0, 0.58, -0.7), rotation = CFrame.Angles(0, 0, math.rad(-8)) },
	{ offset = Vector3.new(0.86, 0.72, -0.66), rotation = CFrame.Angles(0, 0, math.rad(7)) },
}

local function getVariant(variantName)
	return Config.StrawberitaVariants[variantName or Config.DefaultVariant]
		or Config.StrawberitaVariants[Config.DefaultVariant]
end

local function scaledVector(vector, scale)
	return Vector3.new(vector.X * scale, vector.Y * scale, vector.Z * scale)
end

local function createBrick(model, root, properties, scale)
	local part = Instance.new(properties.className or "Part")
	part.Name = properties.name
	part.Size = scaledVector(properties.size or ONE, scale)
	part.CFrame = root.CFrame
		* CFrame.new(scaledVector(properties.offset or ZERO, scale))
		* (properties.rotation or CFrame.new())
	part.Color = properties.color
	part.Material = properties.material or Enum.Material.SmoothPlastic
	part.Transparency = properties.transparency or 0
	part.Reflectance = properties.reflectance or 0
	part.CanCollide = properties.canCollide == true
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part.Anchored = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = model

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = part
	weld.Parent = part

	return part
end

local function addLabel(root, displayName)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PreviewLabel"
	billboard.Size = UDim2.fromOffset(180, 34)
	billboard.StudsOffset = Vector3.new(0, 3.85, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 85
	billboard.Parent = root

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = displayName
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

local function buildBlockyBody(model, root, variant, scale)
	local bodyMaterial = variant.material
	local accentMaterial = variant.seedMaterial or Enum.Material.SmoothPlastic

	createBrick(model, root, {
		name = `VoxelBodyBottom_{variant.id}`,
		size = Vector3.new(1.68, 0.5, 1.16),
		offset = Vector3.new(0, 0.55, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)
	createBrick(model, root, {
		name = `VoxelBodyMiddle_{variant.id}`,
		size = Vector3.new(2.48, 0.78, 1.24),
		offset = Vector3.new(0, 1.2, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)
	createBrick(model, root, {
		name = `VoxelBodyUpper_{variant.id}`,
		size = Vector3.new(2.14, 0.7, 1.18),
		offset = Vector3.new(0, 1.98, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)
	createBrick(model, root, {
		name = `VoxelBodyCap_{variant.id}`,
		size = Vector3.new(1.36, 0.43, 1.05),
		offset = Vector3.new(0, 2.56, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)

	createBrick(model, root, {
		name = "LeftBlockyTaper",
		className = "WedgePart",
		size = Vector3.new(0.62, 1.25, 1.18),
		offset = Vector3.new(-1.25, 1.47, 0),
		rotation = CFrame.Angles(0, 0, math.rad(180)),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockyTaper",
		className = "WedgePart",
		size = Vector3.new(0.62, 1.25, 1.18),
		offset = Vector3.new(1.25, 1.47, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)

	createBrick(model, root, {
		name = "FlatFacePanel",
		size = Vector3.new(1.92, 1.32, 0.1),
		offset = Vector3.new(0, 1.56, -0.69),
		color = variant.facePanelColor or variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)

	for index, placement in ipairs(SEED_PLACEMENTS) do
		createBrick(model, root, {
			name = `BlockSeed_{index}`,
			size = Vector3.new(0.16, 0.24, 0.07),
			offset = placement.offset,
			rotation = placement.rotation,
			color = variant.seedColor,
			material = accentMaterial,
		}, scale)
	end
end

local function buildFace(model, root, variant, scale)
	local faceZ = -0.805
	local eyeFrameColor = Color3.fromRGB(38, 32, 38)
	local eyeWhiteColor = Color3.fromRGB(255, 255, 255)
	local eyeShineColor = Color3.fromRGB(177, 244, 255)

	createBrick(model, root, {
		name = "LeftEyeFrame",
		size = Vector3.new(0.56, 0.58, 0.055),
		offset = Vector3.new(-0.43, 1.74, faceZ),
		color = eyeFrameColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightEyeFrame",
		size = Vector3.new(0.56, 0.58, 0.055),
		offset = Vector3.new(0.43, 1.74, faceZ),
		color = eyeFrameColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "LeftEyeWhite",
		size = Vector3.new(0.42, 0.44, 0.06),
		offset = Vector3.new(-0.43, 1.75, faceZ - 0.035),
		color = eyeWhiteColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightEyeWhite",
		size = Vector3.new(0.42, 0.44, 0.06),
		offset = Vector3.new(0.43, 1.75, faceZ - 0.035),
		color = eyeWhiteColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "LeftPixelPupil",
		size = Vector3.new(0.18, 0.22, 0.065),
		offset = Vector3.new(-0.43, 1.7, faceZ - 0.08),
		color = Color3.fromRGB(31, 27, 32),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightPixelPupil",
		size = Vector3.new(0.18, 0.22, 0.065),
		offset = Vector3.new(0.43, 1.7, faceZ - 0.08),
		color = Color3.fromRGB(31, 27, 32),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "LeftEyeHighlight",
		size = Vector3.new(0.08, 0.08, 0.07),
		offset = Vector3.new(-0.53, 1.88, faceZ - 0.12),
		color = eyeShineColor,
		material = Enum.Material.Neon,
	}, scale)
	createBrick(model, root, {
		name = "RightEyeHighlight",
		size = Vector3.new(0.08, 0.08, 0.07),
		offset = Vector3.new(0.33, 1.88, faceZ - 0.12),
		color = eyeShineColor,
		material = Enum.Material.Neon,
	}, scale)

	createBrick(model, root, {
		name = "LeftBlockCheek",
		size = Vector3.new(0.24, 0.16, 0.055),
		offset = Vector3.new(-0.72, 1.34, faceZ - 0.045),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockCheek",
		size = Vector3.new(0.24, 0.16, 0.055),
		offset = Vector3.new(0.72, 1.34, faceZ - 0.045),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)

	createBrick(model, root, {
		name = "SmileCenterPixel",
		size = Vector3.new(0.26, 0.08, 0.065),
		offset = Vector3.new(0, 1.19, faceZ - 0.09),
		color = Color3.fromRGB(45, 32, 40),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "SmileLeftPixel",
		size = Vector3.new(0.08, 0.16, 0.065),
		offset = Vector3.new(-0.18, 1.25, faceZ - 0.09),
		color = Color3.fromRGB(45, 32, 40),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "SmileRightPixel",
		size = Vector3.new(0.08, 0.16, 0.065),
		offset = Vector3.new(0.18, 1.25, faceZ - 0.09),
		color = Color3.fromRGB(45, 32, 40),
		material = Enum.Material.SmoothPlastic,
	}, scale)
end

local function buildLeafCrown(model, root, variant, scale)
	local leafMaterial = Enum.Material.SmoothPlastic

	createBrick(model, root, {
		name = "LeafCrownBase",
		size = Vector3.new(1.7, 0.25, 0.95),
		offset = Vector3.new(0, 2.89, 0),
		color = variant.leafColor,
		material = leafMaterial,
	}, scale)
	createBrick(model, root, {
		name = "LeafCrownFront",
		className = "WedgePart",
		size = Vector3.new(0.7, 0.34, 0.98),
		offset = Vector3.new(0, 3.05, -0.43),
		rotation = CFrame.Angles(math.rad(-8), 0, 0),
		color = variant.leafColor,
		material = leafMaterial,
	}, scale)
	createBrick(model, root, {
		name = "LeafCrownLeft",
		className = "WedgePart",
		size = Vector3.new(0.68, 0.32, 0.9),
		offset = Vector3.new(-0.72, 3.02, -0.08),
		rotation = CFrame.Angles(math.rad(-8), math.rad(-34), 0),
		color = variant.leafColor,
		material = leafMaterial,
	}, scale)
	createBrick(model, root, {
		name = "LeafCrownRight",
		className = "WedgePart",
		size = Vector3.new(0.68, 0.32, 0.9),
		offset = Vector3.new(0.72, 3.02, -0.08),
		rotation = CFrame.Angles(math.rad(-8), math.rad(34), 0),
		color = variant.leafColor,
		material = leafMaterial,
	}, scale)
	createBrick(model, root, {
		name = "BlockyStem",
		size = Vector3.new(0.32, 0.55, 0.32),
		offset = Vector3.new(0, 3.38, 0.02),
		color = Color3.fromRGB(77, 116, 55),
		material = Enum.Material.Wood,
	}, scale)
end

local function buildLimbs(model, root, variant, scale)
	createBrick(model, root, {
		name = "LeftBlockArm",
		size = Vector3.new(0.34, 0.56, 0.34),
		offset = Vector3.new(-1.44, 1.28, -0.02),
		rotation = CFrame.Angles(0, 0, math.rad(-12)),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockArm",
		size = Vector3.new(0.34, 0.56, 0.34),
		offset = Vector3.new(1.44, 1.28, -0.02),
		rotation = CFrame.Angles(0, 0, math.rad(12)),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "LeftBlockHand",
		size = Vector3.new(0.38, 0.3, 0.36),
		offset = Vector3.new(-1.52, 0.99, -0.04),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockHand",
		size = Vector3.new(0.38, 0.3, 0.36),
		offset = Vector3.new(1.52, 0.99, -0.04),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)

	createBrick(model, root, {
		name = "LeftBlockLeg",
		size = Vector3.new(0.34, 0.46, 0.38),
		offset = Vector3.new(-0.44, 0.08, 0),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockLeg",
		size = Vector3.new(0.34, 0.46, 0.38),
		offset = Vector3.new(0.44, 0.08, 0),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "LeftSquareShoe",
		size = Vector3.new(0.56, 0.28, 0.62),
		offset = Vector3.new(-0.48, -0.23, -0.1),
		color = Color3.fromRGB(61, 43, 51),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightSquareShoe",
		size = Vector3.new(0.56, 0.28, 0.62),
		offset = Vector3.new(0.48, -0.23, -0.1),
		color = Color3.fromRGB(61, 43, 51),
		material = Enum.Material.SmoothPlastic,
	}, scale)
end

local function buildAccessory(model, root, variant, scale)
	local accessoryColor = (variant.effects and variant.effects.highlight) or variant.seedColor
	local accessoryMaterial = variant.seedMaterial or Enum.Material.SmoothPlastic

	createBrick(model, root, {
		name = "BlockBowKnot",
		size = Vector3.new(0.22, 0.22, 0.085),
		offset = Vector3.new(-0.68, 2.69, -0.79),
		color = accessoryColor,
		material = accessoryMaterial,
	}, scale)
	createBrick(model, root, {
		name = "BlockBowLeftWing",
		size = Vector3.new(0.3, 0.24, 0.08),
		offset = Vector3.new(-0.93, 2.68, -0.78),
		rotation = CFrame.Angles(0, 0, math.rad(8)),
		color = accessoryColor,
		material = accessoryMaterial,
	}, scale)
	createBrick(model, root, {
		name = "BlockBowRightWing",
		size = Vector3.new(0.3, 0.24, 0.08),
		offset = Vector3.new(-0.43, 2.68, -0.78),
		rotation = CFrame.Angles(0, 0, math.rad(-8)),
		color = accessoryColor,
		material = accessoryMaterial,
	}, scale)
	createBrick(model, root, {
		name = "BowLeftTail",
		size = Vector3.new(0.16, 0.22, 0.075),
		offset = Vector3.new(-0.82, 2.48, -0.78),
		rotation = CFrame.Angles(0, 0, math.rad(-10)),
		color = accessoryColor,
		material = accessoryMaterial,
	}, scale)
	createBrick(model, root, {
		name = "TinyCollectorBadge",
		size = Vector3.new(0.24, 0.24, 0.08),
		offset = Vector3.new(0.84, 2.42, -0.79),
		color = variant.seedColor,
		material = accessoryMaterial,
	}, scale)
end

function StrawberitaFactory.create(variantName, options)
	options = options or {}

	local variant = getVariant(variantName)
	local scale = options.scale or 1
	local pivot = options.pivot or CFrame.new()

	local model = Instance.new("Model")
	model.Name = "Strawberita"
	model:SetAttribute("VariantId", variant.id)
	model:SetAttribute("DisplayName", variant.displayName)
	model:SetAttribute("Rarity", variant.rarity)
	model:SetAttribute("Style", "ChunkyBlockCollectible")

	local root = Instance.new("Part")
	root.Name = "Root"
	root.Size = Vector3.new(1, 1, 1) * scale
	root.CFrame = pivot
	root.Transparency = 1
	root.CanCollide = false
	root.CanTouch = false
	root.CanQuery = false
	root.Anchored = options.anchored ~= false
	root.Parent = model
	model.PrimaryPart = root

	buildBlockyBody(model, root, variant, scale)
	buildFace(model, root, variant, scale)
	buildLeafCrown(model, root, variant, scale)
	buildLimbs(model, root, variant, scale)
	buildAccessory(model, root, variant, scale)
	addVariantEffects(model, root, variant)

	if options.label then
		addLabel(root, variant.displayName)
	end

	return model
end

function StrawberitaFactory.createPreviewLineup(parent, variantOrder, origin)
	variantOrder = variantOrder or Config.VariantOrder
	origin = origin or CFrame.new()

	local created = {}
	for index, variantName in ipairs(variantOrder) do
		local offset = CFrame.new((index - 1) * 5.1, 0, 0)
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

return StrawberitaFactory
