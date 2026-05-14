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
	pad = false,
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

local function createShowroomPart(name, size, cframe, color, material, transparency)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Transparency = transparency or 0
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part:SetAttribute("DebugPreview", true)
	part.Parent = previewFolder
	return part
end

local function addTopText(part, text)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "ShowroomTopText"
	surface.Face = Enum.NormalId.Top
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 32
	surface.LightInfluence = 0.16
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 244, 218)
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0.2
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = surface
end

local showroomDepth = DEBUG_VISUAL_MARKERS and 46 or 10
local showroomFloor = createShowroomPart(
	"PremiumCharacterShowroomFloor",
	Vector3.new(60, 0.18, showroomDepth),
	CFrame.new(0, 0.56, DEBUG_VISUAL_MARKERS and 38 or 21),
	Color3.fromRGB(44, 48, 64),
	Enum.Material.SmoothPlastic
)
addTopText(showroomFloor, "BRAINROT FRUITS SHOWCASE")
createShowroomPart(
	"PremiumShowroomFrontGlow",
	Vector3.new(54, 0.08, 0.42),
	showroomFloor.CFrame * CFrame.new(0, 0.16, -showroomDepth * 0.46),
	Color3.fromRGB(255, 211, 73),
	Enum.Material.Neon,
	0.18
)
createShowroomPart(
	"PremiumShowroomBackGlow",
	Vector3.new(54, 0.08, 0.42),
	showroomFloor.CFrame * CFrame.new(0, 0.16, showroomDepth * 0.46),
	Color3.fromRGB(124, 235, 255),
	Enum.Material.Neon,
	0.28
)

if DEBUG_VISUAL_MARKERS then
	CharacterSpawnService.spawnAllVariants(nil, {
		parent = previewFolder,
		origin = CFrame.new(-17, 2.65, 20) * CFrame.Angles(0, math.rad(180), 0),
		scale = 0.72,
		spacingX = 6.4,
		spacingZ = 6.2,
		playIntro = false,
	})
else
	CharacterSpawnService.spawnAllCharacters("Base", {
		parent = previewFolder,
		origin = CFrame.new(-21, 2.65, 21) * CFrame.Angles(0, math.rad(180), 0),
		scale = 0.78,
		spacingX = 8.4,
		playIntro = false,
	})
end

print("[BrainrotFruits] Six-character roster preview refreshed")
print("[BrainrotFruits] Studio preview: require(ServerScriptService.BrainrotFruits.CharacterSpawnService).spawnAllVariants(nil, { clearFirst = true, playIntro = true })")
