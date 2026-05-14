local RarityConfig = {}

RarityConfig.DefaultVariant = "Base"

RarityConfig.DistanceBands = {
	{
		minDistance = 0,
		name = "Short Hop",
		weights = {
			Base = 92,
			Golden = 8,
		},
	},
	{
		minDistance = 30,
		name = "Clean Toss",
		weights = {
			Base = 70,
			Golden = 21,
			Rainbow = 9,
		},
	},
	{
		minDistance = 58,
		name = "Fruit Flight",
		weights = {
			Base = 45,
			Golden = 25,
			Rainbow = 14,
			Toxic = 8,
			Diamond = 8,
		},
	},
	{
		minDistance = 86,
		name = "Brainrot Blast",
		weights = {
			Base = 25,
			Golden = 22,
			Rainbow = 17,
			Toxic = 13,
			Diamond = 10,
			Galaxy = 8,
			Cosmic = 5,
		},
	},
	{
		minDistance = 108,
		name = "Absolute Smoothie Orbit",
		weights = {
			Golden = 22,
			Rainbow = 20,
			Toxic = 18,
			Diamond = 16,
			Galaxy = 14,
			Cosmic = 10,
		},
	},
}

RarityConfig.VariantRarity = {
	Base = "Common",
	Golden = "Rare",
	Rainbow = "Epic",
	Toxic = "Epic",
	Diamond = "Legendary",
	Galaxy = "Mythic",
	Cosmic = "Mythic",

	-- Backward-compatible aliases for older saved reward names.
	Normal = "Common",
	Shiny = "Epic",
}

return RarityConfig
