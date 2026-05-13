local Config = require(script.Parent.Parent.Configs.BrainrotFruitConfig)

local StrawberitaFactory = {}

local SEED_POINTS = {
	Vector3.new(-0.45, 0.72, -0.58),
	Vector3.new(0.02, 0.9, -0.64),
	Vector3.new(0.48, 0.66, -0.56),
	Vector3.new(-0.7, 0.22, -0.52),
	Vector3.new(-0.18, 0.18, -0.66),
	Vector3.new(0.35, 0.28, -0.62),
	Vector3.new(0.72, 0.04, -0.47),
	Vector3.new(-0.48, -0.28, -0.46),
	Vector3.new(0.04, -0.22, -0.58),
	Vector3.new(0.5, -0.38, -0.41),
}

local LEAF_ANGLES = { 0, 72, 144, 216, 288 }

local function getVariant(variantName)
	return Config.StrawberitaVariants[variantName or Config.DefaultVariant]
		or Config.StrawberitaVariants[Config.DefaultVariant]
end

local function scaledVector(vector, scale)
	return Vector3.new(vector.X * scale, vector.Y * scale, vector.Z * scale)
end

local function createPart(model, root, properties)
	local part = Instance.new(properties.className or "Part")
	part.Name = properties.name
	part.Size = scaledVector(properties.size or Vector3.one, properties.scale)
	part.CFrame = root.CFrame * properties.cframe
	part.Color = properties.color
	part.Material = properties.material or Enum.Material.SmoothPlastic
	part.Transparency = properties.transparency or 0
	part.CanCollide = properties.canCollide == true
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part.Anchored = false

	if properties.shape then
		part.Shape = properties.shape
	end

	part.Parent = model

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = part
	weld.Parent = part

	return part
end

local function addSparkles(root, color)
	local attachment = Instance.new("Attachment")
	attachment.Name = "SparkleAttachment"
	attachment.Parent = root

	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "SoftSparkles"
	emitter.Color = ColorSequence.new(color)
	emitter.LightEmission = 0.45
	emitter.Rate = 8
	emitter.Lifetime = NumberRange.new(0.8, 1.4)
	emitter.Speed = NumberRange.new(0.8, 1.6)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.12),
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
		highlight.FillTransparency = 0.82
		highlight.OutlineTransparency = 0.25
		highlight.Parent = model
	end

	if effects.light then
		local light = Instance.new("PointLight")
		light.Name = "VariantGlow"
		light.Color = effects.light
		light.Brightness = 1.1
		light.Range = 9
		light.Parent = root
	end

	if effects.sparkles then
		addSparkles(root, effects.sparkles)
	end

	if effects.aura then
		createPart(model, root, {
			name = "SoftGalaxyAura",
			shape = Enum.PartType.Ball,
			size = Vector3.new(3.6, 3.6, 3.6),
			cframe = CFrame.new(0, 1.25, 0),
			color = effects.aura,
			material = Enum.Material.Neon,
			transparency = 0.82,
			scale = 1,
		})
	end
end

local function addLabel(model, root, displayName)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PreviewLabel"
	billboard.Size = UDim2.fromOffset(220, 48)
	billboard.StudsOffset = Vector3.new(0, 3.8, 0)
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

	local body = createPart(model, root, {
		name = "RoundedStrawberryBody",
		shape = Enum.PartType.Ball,
		size = Vector3.new(2.05, 2.45, 1.7),
		cframe = CFrame.new(0, 1.35 * scale, 0),
		color = variant.bodyColor,
		material = variant.material,
		scale = scale,
	})

	createPart(model, root, {
		name = "SoftBellyBlush",
		shape = Enum.PartType.Ball,
		size = Vector3.new(1.2, 1.05, 0.18),
		cframe = CFrame.new(0, 1.2 * scale, -0.76 * scale),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})

	for index, point in ipairs(SEED_POINTS) do
		local seed = createPart(model, root, {
			name = `Seed_{index}`,
			shape = Enum.PartType.Ball,
			size = Vector3.new(0.13, 0.2, 0.08),
			cframe = CFrame.new(scaledVector(point, scale)),
			color = variant.seedColor,
			material = variant.seedMaterial,
			scale = scale,
		})
		seed.CFrame *= CFrame.Angles(math.rad(8), 0, math.rad((index % 3 - 1) * 12))
	end

	for _, angle in ipairs(LEAF_ANGLES) do
		local radians = math.rad(angle)
		local leaf = createPart(model, root, {
			name = `Leaf_{angle}`,
			className = "WedgePart",
			size = Vector3.new(0.55, 0.22, 0.95),
			cframe = CFrame.new(0, 2.56 * scale, 0)
				* CFrame.Angles(0, radians, 0)
				* CFrame.new(0, 0, -0.46 * scale)
				* CFrame.Angles(math.rad(-18), 0, 0),
			color = variant.leafColor,
			material = Enum.Material.SmoothPlastic,
			scale = scale,
		})
		leaf.Name = `LeafCrown_{angle}`
	end

	createPart(model, root, {
		name = "LeftEye",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.36, 0.42, 0.12),
		cframe = CFrame.new(-0.37 * scale, 1.58 * scale, -0.82 * scale),
		color = Color3.fromRGB(255, 255, 255),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "RightEye",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.33, 0.36, 0.12),
		cframe = CFrame.new(0.36 * scale, 1.7 * scale, -0.82 * scale),
		color = Color3.fromRGB(255, 255, 255),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "LeftPupil",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.13, 0.17, 0.06),
		cframe = CFrame.new(-0.32 * scale, 1.54 * scale, -0.89 * scale),
		color = Color3.fromRGB(30, 26, 30),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "RightPupil",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.12, 0.15, 0.06),
		cframe = CFrame.new(0.31 * scale, 1.75 * scale, -0.89 * scale),
		color = Color3.fromRGB(30, 26, 30),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})

	createPart(model, root, {
		name = "LeftCheek",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.24, 0.16, 0.06),
		cframe = CFrame.new(-0.62 * scale, 1.18 * scale, -0.86 * scale),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "RightCheek",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.24, 0.16, 0.06),
		cframe = CFrame.new(0.62 * scale, 1.18 * scale, -0.86 * scale),
		color = variant.cheekColor,
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})

	createPart(model, root, {
		name = "SmileLeft",
		size = Vector3.new(0.16, 0.04, 0.05),
		cframe = CFrame.new(-0.12 * scale, 1.06 * scale, -0.91 * scale) * CFrame.Angles(0, 0, math.rad(-18)),
		color = Color3.fromRGB(43, 30, 38),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "SmileRight",
		size = Vector3.new(0.16, 0.04, 0.05),
		cframe = CFrame.new(0.12 * scale, 1.06 * scale, -0.91 * scale) * CFrame.Angles(0, 0, math.rad(18)),
		color = Color3.fromRGB(43, 30, 38),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})

	createPart(model, root, {
		name = "LeftArm",
		shape = Enum.PartType.Cylinder,
		size = Vector3.new(0.18, 0.72, 0.18),
		cframe = CFrame.new(-1.1 * scale, 1.08 * scale, -0.1 * scale) * CFrame.Angles(0, 0, math.rad(36)),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "RightArm",
		shape = Enum.PartType.Cylinder,
		size = Vector3.new(0.18, 0.72, 0.18),
		cframe = CFrame.new(1.1 * scale, 1.18 * scale, -0.1 * scale) * CFrame.Angles(0, 0, math.rad(-48)),
		color = variant.bellyColor,
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "LeftLeg",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.38, 0.3, 0.42),
		cframe = CFrame.new(-0.42 * scale, 0.04 * scale, -0.08 * scale),
		color = Color3.fromRGB(69, 43, 54),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})
	createPart(model, root, {
		name = "RightLeg",
		shape = Enum.PartType.Ball,
		size = Vector3.new(0.38, 0.3, 0.42),
		cframe = CFrame.new(0.42 * scale, 0.04 * scale, -0.08 * scale),
		color = Color3.fromRGB(69, 43, 54),
		material = Enum.Material.SmoothPlastic,
		scale = scale,
	})

	addVariantEffects(model, root, variant)

	if options.label then
		addLabel(model, root, variant.displayName)
	end

	body.Name = `RoundedStrawberryBody_{variant.id}`

	return model
end

function StrawberitaFactory.createPreviewLineup(parent, variantOrder, origin)
	variantOrder = variantOrder or Config.VariantOrder
	origin = origin or CFrame.new()

	local created = {}
	for index, variantName in ipairs(variantOrder) do
		local offset = CFrame.new((index - 1) * 4.2, 0, 0)
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
