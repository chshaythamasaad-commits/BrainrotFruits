local BrainrotFruitConfig = {}

BrainrotFruitConfig.DefaultVariant = "Normal"

BrainrotFruitConfig.VariantOrder = {
	"Normal",
	"Shiny",
	"Golden",
	"Galaxy",
	"Diamond",
}

BrainrotFruitConfig.StrawberitaVariants = {
	Normal = {
		id = "Normal",
		displayName = "Base Strawberita",
		rarity = "Common",
		bodyColor = Color3.fromRGB(235, 69, 92),
		bellyColor = Color3.fromRGB(255, 132, 154),
		seedColor = Color3.fromRGB(255, 229, 137),
		leafColor = Color3.fromRGB(63, 177, 83),
		cheekColor = Color3.fromRGB(255, 165, 180),
		material = Enum.Material.SmoothPlastic,
		seedMaterial = Enum.Material.SmoothPlastic,
		effects = {},
	},
	Shiny = {
		id = "Shiny",
		displayName = "Shiny Strawberita",
		rarity = "Uncommon",
		bodyColor = Color3.fromRGB(255, 98, 157),
		bellyColor = Color3.fromRGB(255, 183, 209),
		seedColor = Color3.fromRGB(255, 255, 214),
		leafColor = Color3.fromRGB(87, 220, 116),
		cheekColor = Color3.fromRGB(255, 217, 232),
		material = Enum.Material.SmoothPlastic,
		seedMaterial = Enum.Material.Neon,
		effects = {
			highlight = Color3.fromRGB(255, 208, 238),
			sparkles = Color3.fromRGB(255, 226, 247),
		},
	},
	Golden = {
		id = "Golden",
		displayName = "Golden Strawberita",
		rarity = "Rare",
		bodyColor = Color3.fromRGB(255, 198, 51),
		bellyColor = Color3.fromRGB(255, 228, 122),
		seedColor = Color3.fromRGB(255, 255, 229),
		leafColor = Color3.fromRGB(49, 170, 79),
		cheekColor = Color3.fromRGB(255, 238, 166),
		material = Enum.Material.Metal,
		seedMaterial = Enum.Material.Neon,
		effects = {
			highlight = Color3.fromRGB(255, 231, 94),
			light = Color3.fromRGB(255, 210, 82),
		},
	},
	Galaxy = {
		id = "Galaxy",
		displayName = "Galaxy Strawberita",
		rarity = "Epic",
		bodyColor = Color3.fromRGB(93, 54, 169),
		bellyColor = Color3.fromRGB(178, 85, 214),
		seedColor = Color3.fromRGB(104, 247, 255),
		leafColor = Color3.fromRGB(69, 228, 158),
		cheekColor = Color3.fromRGB(255, 113, 218),
		material = Enum.Material.SmoothPlastic,
		seedMaterial = Enum.Material.Neon,
		effects = {
			highlight = Color3.fromRGB(147, 95, 255),
			light = Color3.fromRGB(125, 77, 255),
			sparkles = Color3.fromRGB(117, 244, 255),
			aura = Color3.fromRGB(64, 30, 111),
		},
	},
	Diamond = {
		id = "Diamond",
		displayName = "Diamond Strawberita",
		rarity = "Legendary",
		bodyColor = Color3.fromRGB(124, 232, 255),
		bellyColor = Color3.fromRGB(215, 250, 255),
		seedColor = Color3.fromRGB(255, 255, 255),
		leafColor = Color3.fromRGB(41, 214, 189),
		cheekColor = Color3.fromRGB(219, 255, 255),
		material = Enum.Material.Glass,
		seedMaterial = Enum.Material.Neon,
		effects = {
			highlight = Color3.fromRGB(204, 255, 255),
			light = Color3.fromRGB(150, 238, 255),
			sparkles = Color3.fromRGB(220, 255, 255),
		},
	},
}

return BrainrotFruitConfig
