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
			Base = 47,
			Golden = 27,
			Rainbow = 16,
			Toxic = 10,
		},
	},
	{
		minDistance = 86,
		name = "Brainrot Blast",
		weights = {
			Base = 28,
			Golden = 25,
			Rainbow = 19,
			Toxic = 16,
			Cosmic = 12,
		},
	},
	{
		minDistance = 108,
		name = "Absolute Smoothie Orbit",
		weights = {
			Golden = 28,
			Rainbow = 25,
			Toxic = 22,
			Cosmic = 25,
		},
	},
}

RarityConfig.VariantRarity = {
	Base = "Common",
	Golden = "Rare",
	Rainbow = "Epic",
	Toxic = "Epic",
	Cosmic = "Mythic",

	-- Backward-compatible aliases for older saved reward names.
	Normal = "Common",
	Shiny = "Epic",
	Galaxy = "Mythic",
	Diamond = "Mythic",
}

return RarityConfig
