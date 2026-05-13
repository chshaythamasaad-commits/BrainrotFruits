local RarityConfig = {}

RarityConfig.DistanceBands = {
	{
		minDistance = 0,
		name = "Short Hop",
		weights = {
			Normal = 100,
		},
	},
	{
		minDistance = 30,
		name = "Clean Toss",
		weights = {
			Normal = 68,
			Shiny = 32,
		},
	},
	{
		minDistance = 58,
		name = "Fruit Flight",
		weights = {
			Normal = 45,
			Shiny = 34,
			Golden = 21,
		},
	},
	{
		minDistance = 86,
		name = "Brainrot Blast",
		weights = {
			Normal = 25,
			Shiny = 33,
			Golden = 27,
			Galaxy = 13,
			Diamond = 2,
		},
	},
	{
		minDistance = 108,
		name = "Absolute Smoothie Orbit",
		weights = {
			Shiny = 20,
			Golden = 32,
			Galaxy = 34,
			Diamond = 14,
		},
	},
}

RarityConfig.VariantRarity = {
	Normal = "Common",
	Shiny = "Uncommon",
	Golden = "Rare",
	Galaxy = "Epic",
	Diamond = "Legendary",
}

return RarityConfig
