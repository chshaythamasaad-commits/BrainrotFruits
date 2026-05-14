local CharacterRegistry = require(script.Parent.Parent.Modules.CharacterRegistry)
local CharacterModelFactory = require(script.Parent.Parent.Modules.CharacterModelFactory)

local StrawberitaFactory = {}

local DEFAULT_COLLECTIBLE_SCALE = 0.92

local function normalizeVariant(variantName)
	return CharacterRegistry.normalizeVariantId(variantName)
end

function StrawberitaFactory.getBaseReferenceInfo()
	local character = CharacterRegistry.getCharacter("Strawberita")
	return {
		templateName = character.PlaceholderModelName,
		templateVersion = CharacterModelFactory.Version,
		referencePath = character.BaseReferenceImagePath,
		referenceDescription = "Voxel/chibi Strawberita turnaround reference from references/modelreferences/CharactersRefs.",
		notesPath = character.NotesPath,
	}
end

function StrawberitaFactory.createBaseTemplate(options)
	options = options or {}
	return CharacterModelFactory.create("Strawberita", "Base", {
		anchored = options.anchored,
		name = options.name,
		pivot = options.pivot,
		scale = options.scale or DEFAULT_COLLECTIBLE_SCALE,
	})
end

function StrawberitaFactory.create(variantName, options)
	options = options or {}
	local normalizedVariant = normalizeVariant(variantName)
	local model = CharacterModelFactory.create("Strawberita", normalizedVariant, {
		anchored = options.anchored,
		context = options.context,
		label = options.label,
		pivot = options.pivot,
		scale = options.scale or DEFAULT_COLLECTIBLE_SCALE,
	})

	model:SetAttribute("CanonicalBaseName", "Placeholder_Strawberita")
	model:SetAttribute("CanonicalBaseVersion", CharacterModelFactory.Version)
	model:SetAttribute("CanonicalReferencePath", CharacterRegistry.getCharacter("Strawberita").BaseReferenceImagePath)
	model:SetAttribute("VariantDerivedFromBase", true)
	model:SetAttribute("EstimatedHeightStuds", 6.05 * (options.scale or DEFAULT_COLLECTIBLE_SCALE))

	return model
end

function StrawberitaFactory.CreateStrawberita(variantName, options)
	return StrawberitaFactory.create(variantName, options)
end

function StrawberitaFactory.createPreviewLineup(parent, variantOrder, origin)
	variantOrder = variantOrder or CharacterRegistry.VariantOrder
	origin = origin or CFrame.new()

	local created = {}
	for index, variantName in ipairs(variantOrder) do
		local model = StrawberitaFactory.create(variantName, {
			anchored = true,
			label = true,
			pivot = origin * CFrame.new((index - 1) * 10, 0, 0),
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
