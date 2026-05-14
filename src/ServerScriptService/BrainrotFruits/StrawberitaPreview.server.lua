local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotService = require(script.Parent.Map.PlotService)

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local strawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)

local map = PlotService.getMap()
local hub = map:WaitForChild("CentralHub")
local DEBUG_VISUAL_MARKERS = map:GetAttribute("DebugMode") == true

for _, descendant in ipairs(Workspace:GetDescendants()) do
	if descendant.Name == "GeneratedBrainrotPreview" then
		descendant:Destroy()
	end
end

local function addActiveSign(parent, position)
	local sign = Instance.new("Part")
	sign.Name = "VoxelStrawberitaActiveSign"
	sign.Size = Vector3.new(12, 0.65, 0.25)
	sign.CFrame = CFrame.new(position)
	sign.Color = Color3.fromRGB(255, 70, 96)
	sign.Material = Enum.Material.Neon
	sign.Anchored = true
	sign.CanCollide = false
	sign.CanTouch = false
	sign.CanQuery = false
	sign.Parent = parent

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ActiveSignBillboard"
	billboard.Size = UDim2.fromOffset(480, 76)
	billboard.StudsOffset = Vector3.new(0, 1.4, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 160
	billboard.Parent = sign

	local label = Instance.new("TextLabel")
	label.BackgroundColor3 = Color3.fromRGB(45, 14, 20)
	label.BackgroundTransparency = 0.12
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = "VOXEL STRAWBERITA ACTIVE"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(111, 18, 35)
	label.TextStrokeTransparency = 0.1
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard

	return sign
end

local showcaseFolder = hub:FindFirstChild("ShowcaseModels")
if not showcaseFolder then
	showcaseFolder = Instance.new("Folder")
	showcaseFolder.Name = "ShowcaseModels"
	showcaseFolder.Parent = hub
else
	showcaseFolder:ClearAllChildren()
end

local statue = strawberitaFactory.create("Galaxy", {
	anchored = true,
	label = false,
	scale = 2.35,
	pivot = CFrame.new(0, 7.25, -8) * CFrame.Angles(0, math.rad(180), 0),
})
statue.Name = "MythicStrawberitaShowcase"
statue:SetAttribute("Showcase", true)
statue.Parent = showcaseFolder

for _, oldName in ipairs({ "GeneratedBrainrotPreview", "PreviewModels" }) do
	local oldFolder = hub:FindFirstChild(oldName)
	if oldFolder then
		oldFolder:Destroy()
	end
end

local previewFolder = Instance.new("Folder")
previewFolder.Name = "GeneratedBrainrotPreview"
previewFolder:SetAttribute("StrawberitaVersion", "VoxelReferenceRebuild_V3")
previewFolder.Parent = hub

if DEBUG_VISUAL_MARKERS then
	addActiveSign(previewFolder, Vector3.new(0, 8.75, 21))
end

strawberitaFactory.createPreviewLineup(
	previewFolder,
	{ "Normal", "Golden", "Diamond", "Galaxy" },
	CFrame.new(-15, 2.25, 21) * CFrame.Angles(0, math.rad(180), 0)
)

print("[BrainrotFruits] Strawberita preview refreshed from rebuilt factory")
print("[BrainrotFruits] Debug visual markers hidden in normal mode")
