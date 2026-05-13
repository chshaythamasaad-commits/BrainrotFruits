local Config = require(script.Parent.Parent.Configs.BrainrotFruitConfig)

local StrawberitaFactory = {}

local ZERO = Vector3.new(0, 0, 0)
local ONE = Vector3.new(1, 1, 1)

local SEED_PLACEMENTS = {
	{ offset = Vector3.new(-0.72, 2.18, -0.68), rotation = CFrame.Angles(0, 0, math.rad(-8)) },
	{ offset = Vector3.new(0.02, 2.31, -0.69), rotation = CFrame.Angles(0, 0, math.rad(7)) },
	{ offset = Vector3.new(0.7, 2.13, -0.68), rotation = CFrame.Angles(0, 0, math.rad(10)) },
	{ offset = Vector3.new(-0.95, 1.56, -0.72), rotation = CFrame.Angles(0, 0, math.rad(7)) },
	{ offset = Vector3.new(-0.32, 1.74, -0.75), rotation = CFrame.Angles(0, 0, math.rad(-10)) },
	{ offset = Vector3.new(0.46, 1.72, -0.75), rotation = CFrame.Angles(0, 0, math.rad(8)) },
	{ offset = Vector3.new(0.98, 1.42, -0.7), rotation = CFrame.Angles(0, 0, math.rad(-7)) },
	{ offset = Vector3.new(-0.62, 0.98, -0.69), rotation = CFrame.Angles(0, 0, math.rad(9)) },
	{ offset = Vector3.new(0.08, 0.92, -0.72), rotation = CFrame.Angles(0, 0, math.rad(-8)) },
	{ offset = Vector3.new(0.63, 0.84, -0.67), rotation = CFrame.Angles(0, 0, math.rad(7)) },
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
	billboard.Size = UDim2.fromOffset(220, 48)
	billboard.StudsOffset = Vector3.new(0, 4.2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = root

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = displayName
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextStrokeTransparency = 0.35
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
		size = Vector3.new(1.55, 0.52, 1.15),
		offset = Vector3.new(0, 0.55, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)
	createBrick(model, root, {
		name = `VoxelBodyMiddle_{variant.id}`,
		size = Vector3.new(2.35, 0.82, 1.22),
		offset = Vector3.new(0, 1.2, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)
	createBrick(model, root, {
		name = `VoxelBodyUpper_{variant.id}`,
		size = Vector3.new(2.05, 0.72, 1.16),
		offset = Vector3.new(0, 1.98, 0),
		color = variant.bodyColor,
		material = bodyMaterial,
	}, scale)
	createBrick(model, root, {
		name = `VoxelBodyCap_{variant.id}`,
		size = Vector3.new(1.32, 0.45, 1.05),
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
		size = Vector3.new(1.55, 1.08, 0.08),
		offset = Vector3.new(0, 1.52, -0.66),
		color = variant.bellyColor,
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
	local faceZ = -0.73

	createBrick(model, root, {
		name = "LeftSquareEye",
		size = Vector3.new(0.44, 0.44, 0.055),
		offset = Vector3.new(-0.42, 1.7, faceZ),
		color = Color3.fromRGB(255, 255, 255),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightSquareEye",
		size = Vector3.new(0.44, 0.44, 0.055),
		offset = Vector3.new(0.42, 1.7, faceZ),
		color = Color3.fromRGB(255, 255, 255),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "LeftPixelPupil",
		size = Vector3.new(0.17, 0.22, 0.06),
		offset = Vector3.new(-0.35, 1.65, faceZ - 0.04),
		color = Color3.fromRGB(31, 27, 32),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightPixelPupil",
		size = Vector3.new(0.17, 0.22, 0.06),
		offset = Vector3.new(0.35, 1.75, faceZ - 0.04),
		color = Color3.fromRGB(31, 27, 32),
		material = Enum.Material.SmoothPlastic,
	}, scale)

	createBrick(model, root, {
		name = "LeftBlockCheek",
		size = Vector3.new(0.28, 0.16, 0.055),
		offset = Vector3.new(-0.73, 1.3, faceZ - 0.02),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockCheek",
		size = Vector3.new(0.28, 0.16, 0.055),
		offset = Vector3.new(0.73, 1.3, faceZ - 0.02),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)

	createBrick(model, root, {
		name = "SmilePixelLeft",
		size = Vector3.new(0.18, 0.06, 0.06),
		offset = Vector3.new(-0.13, 1.22, faceZ - 0.04),
		rotation = CFrame.Angles(0, 0, math.rad(-18)),
		color = Color3.fromRGB(45, 32, 40),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "SmilePixelRight",
		size = Vector3.new(0.18, 0.06, 0.06),
		offset = Vector3.new(0.13, 1.22, faceZ - 0.04),
		rotation = CFrame.Angles(0, 0, math.rad(18)),
		color = Color3.fromRGB(45, 32, 40),
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "TinyTonguePixel",
		size = Vector3.new(0.12, 0.08, 0.06),
		offset = Vector3.new(0, 1.14, faceZ - 0.05),
		color = Color3.fromRGB(255, 118, 147),
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
		size = Vector3.new(0.32, 0.72, 0.34),
		offset = Vector3.new(-1.48, 1.35, -0.02),
		rotation = CFrame.Angles(0, 0, math.rad(-18)),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockArm",
		size = Vector3.new(0.32, 0.72, 0.34),
		offset = Vector3.new(1.48, 1.35, -0.02),
		rotation = CFrame.Angles(0, 0, math.rad(18)),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "LeftBlockHand",
		size = Vector3.new(0.38, 0.28, 0.36),
		offset = Vector3.new(-1.62, 0.92, -0.04),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
	}, scale)
	createBrick(model, root, {
		name = "RightBlockHand",
		size = Vector3.new(0.38, 0.28, 0.36),
		offset = Vector3.new(1.62, 0.92, -0.04),
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
		name = "BlockySashTop",
		size = Vector3.new(0.68, 0.14, 0.075),
		offset = Vector3.new(-0.46, 2.02, -0.75),
		rotation = CFrame.Angles(0, 0, math.rad(-24)),
		color = accessoryColor,
		material = accessoryMaterial,
	}, scale)
	createBrick(model, root, {
		name = "BlockySashMid",
		size = Vector3.new(0.72, 0.14, 0.075),
		offset = Vector3.new(0.02, 1.73, -0.77),
		rotation = CFrame.Angles(0, 0, math.rad(-24)),
		color = accessoryColor,
		material = accessoryMaterial,
	}, scale)
	createBrick(model, root, {
		name = "BlockySashBottom",
		size = Vector3.new(0.64, 0.14, 0.075),
		offset = Vector3.new(0.48, 1.45, -0.75),
		rotation = CFrame.Angles(0, 0, math.rad(-24)),
		color = accessoryColor,
		material = accessoryMaterial,
	}, scale)
	createBrick(model, root, {
		name = "TinySquareBadge",
		size = Vector3.new(0.26, 0.26, 0.085),
		offset = Vector3.new(0.62, 1.35, -0.8),
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
		local offset = CFrame.new((index - 1) * 4.5, 0, 0)
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
