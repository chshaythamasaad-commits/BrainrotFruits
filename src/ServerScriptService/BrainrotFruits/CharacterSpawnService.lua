local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CharacterAnimationService = require(brainrotFruits.Modules.BrainrotAnimationService)
local CharacterModelFactory = require(brainrotFruits.Modules.BrainrotModelFactory)
local CharacterRegistry = require(brainrotFruits.Modules.CharacterRegistry)

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
	local origin = options.origin or CFrame.new(0, 2.25, 21) * CFrame.Angles(0, math.rad(180), 0)
	local spacingX = options.spacingX or 8.5
	local spacingZ = options.spacingZ or 7.5
	return origin * CFrame.new(((index or 1) - 1) * spacingX, 0, ((row or 1) - 1) * spacingZ)
end

local function createPreviewPad(parent, model, pivot, character, variantId)
	local padFolder = parent:FindFirstChild("PreviewPads")
	if not padFolder then
		padFolder = Instance.new("Folder")
		padFolder.Name = "PreviewPads"
		padFolder.Parent = parent
	end

	local baseColor = character.ColorTheme or Color3.fromRGB(255, 112, 168)
	local pad = Instance.new("Part")
	pad.Name = `{model.Name}_Pad`
	pad.Size = Vector3.new(5.8, 0.34, 4.6)
	pad.CFrame = pivot * CFrame.new(0, -2.15, 0)
	pad.Color = Color3.fromRGB(39, 42, 54)
	pad.Material = Enum.Material.SmoothPlastic
	pad.Anchored = true
	pad.CanCollide = false
	pad.CanTouch = false
	pad.CanQuery = false
	pad:SetAttribute("DebugPreview", true)
	pad:SetAttribute("CharacterId", character.Id)
	pad:SetAttribute("VariantId", variantId)
	pad.Parent = padFolder

	local glow = Instance.new("Part")
	glow.Name = `{model.Name}_PadGlow`
	glow.Size = Vector3.new(4.6, 0.08, 3.55)
	glow.CFrame = pad.CFrame * CFrame.new(0, 0.22, 0)
	glow.Color = baseColor
	glow.Material = Enum.Material.Neon
	glow.Transparency = 0.28
	glow.Anchored = true
	glow.CanCollide = false
	glow.CanTouch = false
	glow.CanQuery = false
	glow:SetAttribute("DebugPreview", true)
	glow.Parent = padFolder

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
