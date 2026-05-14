local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CharacterAnimationService = require(brainrotFruits.Modules.BrainrotAnimationService)
local CharacterModelFactory = require(brainrotFruits.Modules.BrainrotModelFactory)
local CharacterRegistry = require(brainrotFruits.Modules.CharacterRegistry)
local CharacterVariantService = require(brainrotFruits.Modules.CharacterVariantService)

local CharacterSpawnService = {}

CharacterSpawnService.Version = "CharacterSpawnService_V1"
CharacterSpawnService.PreviewFolderName = "CharacterRosterPreview"

local printedVersion = false

local function printVersion()
	if not printedVersion then
		print("[BrainrotFruits] CharacterSpawnService_V1 active")
		print("[BrainrotFruits] Character roster preview commands active")
		printedVersion = true
	end

	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		map:SetAttribute("CharacterSpawnServiceVersion", CharacterSpawnService.Version)
	end
end

local function getDefaultParent()
	local map = Workspace:FindFirstChild("BrainrotMap")
	local hub = map and map:FindFirstChild("CentralHub")
	return hub or map or Workspace
end

local function getOrCreatePreviewFolder(parent, name)
	parent = parent or getDefaultParent()
	name = name or CharacterSpawnService.PreviewFolderName

	local folder = parent:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end

	folder:SetAttribute("DebugPreview", true)
	folder:SetAttribute("CharacterRosterVersion", "SixCharacterRoster_V1")
	folder:SetAttribute("CharacterSpawnServiceVersion", CharacterSpawnService.Version)
	return folder
end

local function getPreviewPivot(options, index, row)
	options = options or {}
	local origin = options.origin or CFrame.new(0, 2.65, 21) * CFrame.Angles(0, math.rad(180), 0)
	local spacingX = options.spacingX or 8.5
	local spacingZ = options.spacingZ or 7.5
	return origin * CFrame.new(((index or 1) - 1) * spacingX, 0, ((row or 1) - 1) * spacingZ)
end

local function addSurfaceText(part, text, color)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "PreviewStandText"
	surface.Face = Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 44
	surface.LightInfluence = 0.12
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(255, 255, 245)
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0.18
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface
end

local function createPreviewPad(parent, model, pivot, character, variantId)
	local padFolder = parent:FindFirstChild("PreviewStands")
	if not padFolder then
		padFolder = Instance.new("Folder")
		padFolder.Name = "PreviewStands"
		padFolder.Parent = parent
	end

	local variant, normalizedVariantId = CharacterRegistry.getVariant(character.Id, variantId)
	local variantConfig = CharacterVariantService.getConfig(character.Id, normalizedVariantId)
	local baseColor = (variantConfig and variantConfig.displayColor) or character.ColorTheme or Color3.fromRGB(255, 112, 168)
	local pad = Instance.new("Part")
	pad.Name = `{model.Name}_ShowcasePedestal`
	pad.Size = Vector3.new(6.2, 0.44, 5.0)
	pad.CFrame = pivot * CFrame.new(0, -1.55, 0)
	pad.Color = Color3.fromRGB(33, 36, 48)
	pad.Material = Enum.Material.SmoothPlastic
	pad.Anchored = true
	pad.CanCollide = false
	pad.CanTouch = false
	pad.CanQuery = false
	pad:SetAttribute("DebugPreview", true)
	pad:SetAttribute("CharacterId", character.Id)
	pad:SetAttribute("VariantId", normalizedVariantId)
	pad:SetAttribute("ShowcasePedestal", true)
	pad.Parent = padFolder

	local top = Instance.new("Part")
	top.Name = `{model.Name}_PedestalTop`
	top.Size = Vector3.new(5.25, 0.14, 4.1)
	top.CFrame = pad.CFrame * CFrame.new(0, 0.29, 0)
	top.Color = Color3.fromRGB(52, 56, 73)
	top.Material = Enum.Material.SmoothPlastic
	top.Anchored = true
	top.CanCollide = false
	top.CanTouch = false
	top.CanQuery = false
	top:SetAttribute("DebugPreview", true)
	top:SetAttribute("CharacterId", character.Id)
	top:SetAttribute("VariantId", normalizedVariantId)
	top.Parent = padFolder

	local glow = Instance.new("Part")
	glow.Name = `{model.Name}_PedestalGlow`
	glow.Size = Vector3.new(4.55, 0.08, 3.42)
	glow.CFrame = top.CFrame * CFrame.new(0, 0.12, 0)
	glow.Color = baseColor
	glow.Material = Enum.Material.Neon
	glow.Transparency = 0.34
	glow.Anchored = true
	glow.CanCollide = false
	glow.CanTouch = false
	glow.CanQuery = false
	glow:SetAttribute("DebugPreview", true)
	glow.Parent = padFolder

	local nameplate = Instance.new("Part")
	nameplate.Name = `{model.Name}_Nameplate`
	nameplate.Size = Vector3.new(4.4, 0.62, 0.16)
	nameplate.CFrame = pad.CFrame * CFrame.new(0, 0.14, -2.58)
	nameplate.Color = Color3.fromRGB(24, 25, 34)
	nameplate.Material = Enum.Material.SmoothPlastic
	nameplate.Anchored = true
	nameplate.CanCollide = false
	nameplate.CanTouch = false
	nameplate.CanQuery = false
	nameplate:SetAttribute("DebugPreview", true)
	nameplate.Parent = padFolder
	addSurfaceText(nameplate, `{variant.DisplayName or character.DisplayName}\n{variant.Rarity or character.Rarity}`, baseColor)

	local gem = Instance.new("Part")
	gem.Name = `{model.Name}_RarityGem`
	gem.Size = Vector3.new(0.34, 0.34, 0.16)
	gem.CFrame = nameplate.CFrame * CFrame.new(-2.0, 0, -0.12) * CFrame.Angles(0, 0, math.rad(45))
	gem.Color = baseColor
	gem.Material = Enum.Material.Neon
	gem.Anchored = true
	gem.CanCollide = false
	gem.CanTouch = false
	gem.CanQuery = false
	gem:SetAttribute("DebugPreview", true)
	gem.Parent = padFolder

	return pad
end

function CharacterSpawnService.clearPreviewModels(parent)
	printVersion()

	local searchParent = parent or getDefaultParent()
	for _, child in ipairs(searchParent:GetChildren()) do
		if child.Name == CharacterSpawnService.PreviewFolderName or child:GetAttribute("DebugPreview") == true then
			child:Destroy()
		end
	end
end

function CharacterSpawnService.spawnPreview(characterId, variantId, options)
	printVersion()
	options = options or {}

	local character = CharacterRegistry.getCharacter(characterId)
	local normalizedVariantId = CharacterRegistry.normalizeVariantId(variantId)
	local parent = options.parent or getOrCreatePreviewFolder(options.container, options.folderName)
	local model = CharacterModelFactory.create(character.Id, normalizedVariantId, {
		anchored = options.anchored ~= false,
		context = "Platform",
		label = options.label ~= false,
		pivot = options.pivot or CFrame.new(),
		scale = options.scale or 0.92,
	})

	model.Name = `{normalizedVariantId}_{character.Id}_Preview`
	model:SetAttribute("DebugPreview", true)
	model.Parent = parent
	if options.pad ~= false then
		createPreviewPad(parent, model, options.pivot or CFrame.new(), character, normalizedVariantId)
	end
	CharacterAnimationService.startIdle(model, {
		characterId = character.Id,
		variantName = normalizedVariantId,
	})

	if options.playIntro then
		task.spawn(function()
			CharacterAnimationService.playIntro(model, {
				characterId = character.Id,
				variantName = normalizedVariantId,
			})
		end)
	end

	return model
end

function CharacterSpawnService.spawnAllCharacters(variantId, options)
	printVersion()
	options = options or {}
	local parent = options.parent or getOrCreatePreviewFolder(options.container, options.folderName)
	if options.clearFirst then
		parent:ClearAllChildren()
	end

	local created = {}
	for index, characterId in ipairs(CharacterRegistry.CharacterOrder) do
		local model = CharacterSpawnService.spawnPreview(characterId, variantId or "Base", {
			parent = parent,
			pivot = getPreviewPivot(options, index, 1),
			scale = options.scale,
			playIntro = options.playIntro,
		})
		table.insert(created, model)
	end
	return created
end

function CharacterSpawnService.spawnAllVariants(characterId, options)
	printVersion()
	options = options or {}
	local parent = options.parent or getOrCreatePreviewFolder(options.container, options.folderName)
	if options.clearFirst then
		parent:ClearAllChildren()
	end

	local characters = characterId and { CharacterRegistry.normalizeCharacterId(characterId) } or CharacterRegistry.CharacterOrder
	local created = {}
	for row, rosterCharacterId in ipairs(characters) do
		for index, variantId in ipairs(CharacterRegistry.VariantOrder) do
			local model = CharacterSpawnService.spawnPreview(rosterCharacterId, variantId, {
				parent = parent,
				pivot = getPreviewPivot(options, index, row),
				scale = options.scale,
				playIntro = options.playIntro,
			})
			table.insert(created, model)
		end
	end
	return created
end

function CharacterSpawnService.playIntro(model)
	if model and model:IsA("Model") then
		return CharacterAnimationService.playIntro(model, {
			characterId = model:GetAttribute("CharacterId"),
			variantName = model:GetAttribute("VariantName"),
		})
	end
	return false
end

printVersion()

return CharacterSpawnService
