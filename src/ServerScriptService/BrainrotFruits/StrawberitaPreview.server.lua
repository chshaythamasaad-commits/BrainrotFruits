local Workspace = game:GetService("Workspace")

local CharacterSpawnService = require(script.Parent.CharacterSpawnService)
local PlotService = require(script.Parent.Map.PlotService)

local map = PlotService.getMap()
local hub = map:WaitForChild("CentralHub")
local DEBUG_VISUAL_MARKERS = map:GetAttribute("DebugMode") == true

for _, descendant in ipairs(Workspace:GetDescendants()) do
	if descendant.Name == "GeneratedBrainrotPreview" or descendant.Name == "CharacterRosterPreview" then
		descendant:Destroy()
	end
end

local showcaseFolder = hub:FindFirstChild("ShowcaseModels")
if not showcaseFolder then
	showcaseFolder = Instance.new("Folder")
	showcaseFolder.Name = "ShowcaseModels"
	showcaseFolder.Parent = hub
else
	showcaseFolder:ClearAllChildren()
end

local statue = CharacterSpawnService.spawnPreview("DragonfruttoDrippo", "Cosmic", {
	parent = showcaseFolder,
	label = false,
	scale = 2.25,
	pivot = CFrame.new(0, 7.25, -8) * CFrame.Angles(0, math.rad(180), 0),
})
statue.Name = "CosmicDragonfruttoShowcase"
statue:SetAttribute("Showcase", true)

local previewFolder = Instance.new("Folder")
previewFolder.Name = "GeneratedBrainrotPreview"
previewFolder:SetAttribute("DebugPreview", true)
previewFolder:SetAttribute("CharacterRosterVersion", "SixCharacterRoster_V1")
previewFolder:SetAttribute("CharacterReferenceRoot", "references/modelreferences/CharactersRefs")
previewFolder.Parent = hub

if DEBUG_VISUAL_MARKERS then
	CharacterSpawnService.spawnAllVariants(nil, {
		parent = previewFolder,
		origin = CFrame.new(-17, 2.25, 20) * CFrame.Angles(0, math.rad(180), 0),
		scale = 0.72,
		spacingX = 6.4,
		spacingZ = 6.2,
		playIntro = false,
	})
else
	CharacterSpawnService.spawnAllCharacters("Base", {
		parent = previewFolder,
		origin = CFrame.new(-21, 2.25, 21) * CFrame.Angles(0, math.rad(180), 0),
		scale = 0.78,
		spacingX = 8.4,
		playIntro = false,
	})
end

print("[BrainrotFruits] Six-character roster preview refreshed")
print("[BrainrotFruits] Studio preview: require(ServerScriptService.BrainrotFruits.CharacterSpawnService).spawnAllVariants(nil, { clearFirst = true, playIntro = true })")
