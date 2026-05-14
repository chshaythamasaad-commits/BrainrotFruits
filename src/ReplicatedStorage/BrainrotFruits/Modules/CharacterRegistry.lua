local CharacterRegistry = {}

CharacterRegistry.Version = "BrainrotCharacterRegistry_V2"
CharacterRegistry.ReferenceRoot = "references/modelreferences/CharactersRefs"

CharacterRegistry.VariantOrder = {
	"Base",
	"Golden",
	"Diamond",
	"Galaxy",
	"Rainbow",
	"Toxic",
	"Cosmic",
}

local SHARED_VARIANTS = {
	Base = {
		Id = "Base",
		DisplayNamePrefix = "",
		Rarity = "Common",
		VisualTier = 1,
		IncomeMultiplierModifier = 1,
		AuraStyle = "None",
		ParticleStyle = "None",
		HasColorCycling = false,
		HasParticles = false,
		Material = Enum.Material.SmoothPlastic,
		Palette = {},
	},
	Golden = {
		Id = "Golden",
		DisplayNamePrefix = "Golden",
		Rarity = "Rare",
		VisualTier = 2,
		IncomeMultiplierModifier = 1.9,
		AuraStyle = "CoinSparkle",
		ParticleStyle = "GoldCoins",
		HasColorCycling = false,
		HasParticles = true,
		Material = Enum.Material.Metal,
		Palette = {
			Fruit = Color3.fromRGB(255, 205, 54),
			FruitDark = Color3.fromRGB(216, 151, 32),
			Accent = Color3.fromRGB(255, 238, 128),
			Outfit = Color3.fromRGB(255, 190, 59),
			Seed = Color3.fromRGB(255, 255, 220),
			Leaf = Color3.fromRGB(65, 178, 79),
			Shoe = Color3.fromRGB(224, 151, 37),
		},
	},
	Diamond = {
		Id = "Diamond",
		DisplayNamePrefix = "Diamond",
		Rarity = "Legendary",
		VisualTier = 4,
		IncomeMultiplierModifier = 3.6,
		AuraStyle = "CrystalShine",
		ParticleStyle = "DiamondGlints",
		HasColorCycling = false,
		HasParticles = true,
		Material = Enum.Material.Glass,
		Palette = {
			Fruit = Color3.fromRGB(126, 232, 255),
			FruitDark = Color3.fromRGB(72, 174, 222),
			Accent = Color3.fromRGB(235, 255, 255),
			Outfit = Color3.fromRGB(165, 238, 255),
			Seed = Color3.fromRGB(255, 255, 255),
			Leaf = Color3.fromRGB(72, 226, 205),
			Shoe = Color3.fromRGB(87, 201, 238),
		},
	},
	Galaxy = {
		Id = "Galaxy",
		DisplayNamePrefix = "Galaxy",
		Rarity = "Mythic",
		VisualTier = 5,
		IncomeMultiplierModifier = 4.2,
		AuraStyle = "StarAura",
		ParticleStyle = "GalaxyStars",
		HasColorCycling = false,
		HasParticles = true,
		Material = Enum.Material.SmoothPlastic,
		Palette = {
			Fruit = Color3.fromRGB(83, 52, 166),
			FruitDark = Color3.fromRGB(30, 25, 78),
			Accent = Color3.fromRGB(104, 247, 255),
			Outfit = Color3.fromRGB(41, 30, 96),
			Seed = Color3.fromRGB(190, 249, 255),
			Leaf = Color3.fromRGB(83, 226, 179),
			Shoe = Color3.fromRGB(31, 28, 82),
		},
	},
	Rainbow = {
		Id = "Rainbow",
		DisplayNamePrefix = "Rainbow",
		Rarity = "Epic",
		VisualTier = 3,
		IncomeMultiplierModifier = 2.7,
		AuraStyle = "RainbowSparkle",
		ParticleStyle = "RainbowStars",
		HasColorCycling = true,
		HasParticles = true,
		Material = Enum.Material.SmoothPlastic,
		Palette = {
			Fruit = Color3.fromRGB(255, 103, 151),
			FruitDark = Color3.fromRGB(120, 104, 255),
			Accent = Color3.fromRGB(104, 238, 255),
			Outfit = Color3.fromRGB(255, 216, 91),
			Seed = Color3.fromRGB(255, 255, 255),
			Leaf = Color3.fromRGB(87, 220, 116),
			Shoe = Color3.fromRGB(155, 109, 255),
		},
	},
	Toxic = {
		Id = "Toxic",
		DisplayNamePrefix = "Toxic",
		Rarity = "Epic",
		VisualTier = 3,
		IncomeMultiplierModifier = 3.1,
		AuraStyle = "Bubbles",
		ParticleStyle = "ToxicBubbles",
		HasColorCycling = false,
		HasParticles = true,
		Material = Enum.Material.SmoothPlastic,
		Palette = {
			Fruit = Color3.fromRGB(139, 255, 50),
			FruitDark = Color3.fromRGB(82, 165, 40),
			Accent = Color3.fromRGB(170, 74, 255),
			Outfit = Color3.fromRGB(82, 31, 112),
			Seed = Color3.fromRGB(196, 255, 90),
			Leaf = Color3.fromRGB(74, 255, 110),
			Shoe = Color3.fromRGB(95, 46, 130),
		},
	},
	Cosmic = {
		Id = "Cosmic",
		DisplayNamePrefix = "Cosmic",
		Rarity = "Mythic",
		VisualTier = 5,
		IncomeMultiplierModifier = 4.4,
		AuraStyle = "CosmicOrbit",
		ParticleStyle = "CosmicStars",
		HasColorCycling = false,
		HasParticles = true,
		Material = Enum.Material.SmoothPlastic,
		Palette = {
			Fruit = Color3.fromRGB(55, 45, 145),
			FruitDark = Color3.fromRGB(18, 19, 64),
			Accent = Color3.fromRGB(116, 245, 255),
			Outfit = Color3.fromRGB(33, 26, 84),
			Seed = Color3.fromRGB(212, 255, 255),
			Leaf = Color3.fromRGB(74, 255, 194),
			Shoe = Color3.fromRGB(22, 24, 72),
		},
	},
}

local function cloneVariantDefinition(variantId)
	local source = SHARED_VARIANTS[variantId]
	local clone = {}
	for key, value in pairs(source) do
		if key == "Palette" then
			local palette = {}
			for paletteKey, color in pairs(value) do
				palette[paletteKey] = color
			end
			clone.Palette = palette
		else
			clone[key] = value
		end
	end
	return clone
end

local function makeVariantDefinitions(characterDisplayName)
	local definitions = {}
	for _, variantId in ipairs(CharacterRegistry.VariantOrder) do
		local definition = cloneVariantDefinition(variantId)
		definition.DisplayName = definition.DisplayNamePrefix == "" and characterDisplayName or `{definition.DisplayNamePrefix} {characterDisplayName}`
		definitions[variantId] = definition
	end
	return definitions
end

local function makeCharacter(config)
	config.ReferencePath = config.ReferencePath or config.ReferenceFolderPath
	config.Variants = config.Variants or makeVariantDefinitions(config.DisplayName)
	config.VariantDefinitions = config.VariantDefinitions or config.Variants
	config.IncomeMultiplier = config.IncomeMultiplier or math.max(1, (config.BaseIncome or 4) / 4)
	config.Weight = config.Weight or 10
	config.PlaceholderModelName = config.PlaceholderModelName or `Placeholder_{config.Id}`
	return config
end

-- To add a new character: add one registry entry, one model builder profile in BrainrotModelFactory,
-- and one animation style in BrainrotAnimationService/CharacterAnimationService.
-- Tune BaseIncome, SellValue, Weight, and variant multipliers here.
CharacterRegistry.CharacterOrder = {
	"BananaBandito",
	"CoconuttoBonkini",
	"DragonfruttoDrippo",
	"LemonaldoSprintini",
	"Strawberita",
	"WatermeloniWobblino",
}

CharacterRegistry.Characters = {
	BananaBandito = makeCharacter({
		Id = "BananaBandito",
		DisplayName = "Banana Bandito",
		Rarity = "Uncommon",
		BaseFruit = "Banana",
		BaseIncome = 5,
		SellValue = 1450,
		ColorTheme = Color3.fromRGB(255, 218, 72),
		ShortDescription = "A sneaky banana outlaw with a tiny hat, mask, boots, and playful bandit energy.",
		ReferencePath = "references/modelreferences/CharactersRefs/Characters/BananitoBandito",
		ReferenceFolderPath = "references/modelreferences/CharactersRefs/Characters/BananitoBandito",
		BaseReferenceImagePath = "references/modelreferences/CharactersRefs/Characters/BananitoBandito/Base/BananitoBandito_Base_Turnaround.png",
		NotesPath = "references/modelreferences/CharactersRefs/Characters/BananitoBandito/notes.md",
		IncomeMultiplier = 1.25,
		Weight = 25,
		StyleTags = { "voxel", "chibi", "banana", "cowboy", "bandit" },
		AnimationStyle = "BanditHatTip",
	}),
	CoconuttoBonkini = makeCharacter({
		Id = "CoconuttoBonkini",
		DisplayName = "Coconutto Bonkini",
		Rarity = "Rare",
		BaseFruit = "Coconut",
		BaseIncome = 6,
		SellValue = 2100,
		ColorTheme = Color3.fromRGB(116, 73, 43),
		ShortDescription = "A lovable coconut caveman with a chunky shell, cream cap, club, and silly grin.",
		ReferencePath = "references/modelreferences/CharactersRefs/Characters/CoconuttoBonkini",
		ReferenceFolderPath = "references/modelreferences/CharactersRefs/Characters/CoconuttoBonkini",
		BaseReferenceImagePath = "references/modelreferences/CharactersRefs/Characters/CoconuttoBonkini/Base/CoconuttoBonkini_Base_Turnaround.png",
		NotesPath = "references/modelreferences/CharactersRefs/Characters/CoconuttoBonkini/notes.md",
		IncomeMultiplier = 1.55,
		Weight = 18,
		StyleTags = { "voxel", "chibi", "coconut", "caveman", "club" },
		AnimationStyle = "CavemanBonk",
	}),
	DragonfruttoDrippo = makeCharacter({
		Id = "DragonfruttoDrippo",
		DisplayName = "Dragonfrutto Drippo",
		Rarity = "Mythic",
		BaseFruit = "Dragon Fruit",
		BaseIncome = 11,
		SellValue = 5600,
		ColorTheme = Color3.fromRGB(235, 64, 145),
		ShortDescription = "A confident dragon fruit mascot with leafy spikes, shades, chain, and stylish drip.",
		ReferencePath = "references/modelreferences/CharactersRefs/Characters/DragonfruttoDrippo",
		ReferenceFolderPath = "references/modelreferences/CharactersRefs/Characters/DragonfruttoDrippo",
		BaseReferenceImagePath = "references/modelreferences/CharactersRefs/Characters/DragonfruttoDrippo/Base/DragonfruttoDrippo_Base_Turnaround.png",
		NotesPath = "references/modelreferences/CharactersRefs/Characters/DragonfruttoDrippo/notes.md",
		IncomeMultiplier = 2.8,
		Weight = 6,
		StyleTags = { "voxel", "chibi", "dragonfruit", "drip", "high-rarity" },
		AnimationStyle = "CoolShades",
	}),
	LemonaldoSprintini = makeCharacter({
		Id = "LemonaldoSprintini",
		DisplayName = "Lemonaldo Sprintini",
		Rarity = "Rare",
		BaseFruit = "Lemon",
		BaseIncome = 7,
		SellValue = 2600,
		ColorTheme = Color3.fromRGB(255, 223, 63),
		ShortDescription = "A fast lemon sprinter with a headband, sport outfit, chunky shoes, and foot taps.",
		ReferencePath = "references/modelreferences/CharactersRefs/Characters/LemonaldoSprintini",
		ReferenceFolderPath = "references/modelreferences/CharactersRefs/Characters/LemonaldoSprintini",
		BaseReferenceImagePath = "references/modelreferences/CharactersRefs/Characters/LemonaldoSprintini/Base/LemonaldoSprintini_Base_Turnaround.png",
		NotesPath = "references/modelreferences/CharactersRefs/Characters/LemonaldoSprintini/notes.md",
		IncomeMultiplier = 1.75,
		Weight = 15,
		StyleTags = { "voxel", "chibi", "lemon", "athlete", "runner" },
		AnimationStyle = "RunnerFootTap",
	}),
	Strawberita = makeCharacter({
		Id = "Strawberita",
		DisplayName = "Strawberita",
		Rarity = "Common",
		BaseFruit = "Strawberry",
		BaseIncome = 4,
		SellValue = 1100,
		ColorTheme = Color3.fromRGB(239, 52, 61),
		ShortDescription = "The main strawberry mascot with leafy crown, bow, seeds, cute face, and idol energy.",
		ReferencePath = "references/modelreferences/CharactersRefs/Characters/Strawberita",
		ReferenceFolderPath = "references/modelreferences/CharactersRefs/Characters/Strawberita",
		BaseReferenceImagePath = "references/modelreferences/CharactersRefs/Characters/Strawberita/Base/Strawberita_Base_Turnaround.png",
		NotesPath = "references/modelreferences/CharactersRefs/Characters/Strawberita/notes.md",
		IncomeMultiplier = 1,
		Weight = 36,
		StyleTags = { "voxel", "chibi", "strawberry", "mascot", "idol" },
		AnimationStyle = "CuteWave",
	}),
	WatermeloniWobblino = makeCharacter({
		Id = "WatermeloniWobblino",
		DisplayName = "Watermeloni Wobblino",
		Rarity = "Epic",
		BaseFruit = "Watermelon",
		BaseIncome = 8,
		SellValue = 3600,
		ColorTheme = Color3.fromRGB(72, 178, 75),
		ShortDescription = "A chunky watermelon tank with rind stripes, sumo belt, tiny feet, and wobbly charm.",
		ReferencePath = "references/modelreferences/CharactersRefs/Characters/WatermeloniWobblino",
		ReferenceFolderPath = "references/modelreferences/CharactersRefs/Characters/WatermeloniWobblino",
		BaseReferenceImagePath = "references/modelreferences/CharactersRefs/Characters/WatermeloniWobblino/Base/WatermeloniWobblino_Base_Turnaround.png",
		NotesPath = "references/modelreferences/CharactersRefs/Characters/WatermeloniWobblino/notes.md",
		IncomeMultiplier = 2.1,
		Weight = 10,
		StyleTags = { "voxel", "chibi", "watermelon", "sumo", "tanky" },
		AnimationStyle = "HeavyWobble",
	}),
}

local CHARACTER_ALIASES = {
	BananitoBandito = "BananaBandito",
	Bananito = "BananaBandito",
	Banana = "BananaBandito",
	BananaBandit = "BananaBandito",
	Strawberry = "Strawberita",
	Coconut = "CoconuttoBonkini",
	Lemon = "LemonaldoSprintini",
	Watermelon = "WatermeloniWobblino",
	DragonFruit = "DragonfruttoDrippo",
	Dragonfruit = "DragonfruttoDrippo",
}

local VARIANT_ALIASES = {
	Normal = "Base",
	Shiny = "Rainbow",
	Crystal = "Diamond",
	Icy = "Diamond",
	Mythic = "Galaxy",
	Space = "Galaxy",
}

local function normalizeLooseText(value)
	return string.lower(tostring(value or "")):gsub("%s+", ""):gsub("_", ""):gsub("%p+", "")
end

function CharacterRegistry.normalizeCharacterId(value)
	if type(value) == "table" then
		value = value.Id or value.id or value.CharacterId or value.characterId
	elseif typeof(value) == "Instance" then
		value = value:GetAttribute("CharacterId") or value.Name
	end

	local text = tostring(value or "Strawberita")
	if CharacterRegistry.Characters[text] then
		return text
	end
	if CHARACTER_ALIASES[text] then
		return CHARACTER_ALIASES[text]
	end

	local loose = normalizeLooseText(text)
	for alias, characterId in pairs(CHARACTER_ALIASES) do
		if normalizeLooseText(alias) == loose then
			return characterId
		end
	end
	for characterId, character in pairs(CharacterRegistry.Characters) do
		if normalizeLooseText(characterId) == loose or normalizeLooseText(character.DisplayName) == loose then
			return characterId
		end
	end

	return "Strawberita"
end

function CharacterRegistry.normalizeVariantId(value)
	if type(value) == "table" then
		value = value.Id or value.id or value.VariantId or value.variantId or value.variantName or value.variant
	elseif typeof(value) == "Instance" then
		value = value:GetAttribute("VariantId") or value:GetAttribute("VariantName")
	end

	local text = tostring(value or "Base")
	if SHARED_VARIANTS[text] then
		return text
	end
	if VARIANT_ALIASES[text] then
		return VARIANT_ALIASES[text]
	end

	local loose = normalizeLooseText(text)
	for variantId in pairs(SHARED_VARIANTS) do
		if normalizeLooseText(variantId) == loose then
			return variantId
		end
	end
	for alias, variantId in pairs(VARIANT_ALIASES) do
		if normalizeLooseText(alias) == loose then
			return variantId
		end
	end

	return "Base"
end

function CharacterRegistry.getCharacter(characterId)
	return CharacterRegistry.Characters[CharacterRegistry.normalizeCharacterId(characterId)]
end

function CharacterRegistry.getVariant(characterId, variantId)
	local character = CharacterRegistry.getCharacter(characterId)
	local normalizedVariantId = CharacterRegistry.normalizeVariantId(variantId)
	return character.Variants[normalizedVariantId] or character.Variants.Base, normalizedVariantId
end

function CharacterRegistry.getDisplayName(characterId, variantId)
	local character = CharacterRegistry.getCharacter(characterId)
	local variant = CharacterRegistry.getVariant(characterId, variantId)
	return variant.DisplayName or character.DisplayName
end

function CharacterRegistry.getWeightedCharacters()
	local entries = {}
	for _, characterId in ipairs(CharacterRegistry.CharacterOrder) do
		local character = CharacterRegistry.Characters[characterId]
		table.insert(entries, {
			id = character.Id,
			weight = character.Weight or 1,
		})
	end
	return entries
end

function CharacterRegistry.getAllCharacters()
	local list = {}
	for _, characterId in ipairs(CharacterRegistry.CharacterOrder) do
		table.insert(list, CharacterRegistry.Characters[characterId])
	end
	return list
end

return CharacterRegistry
