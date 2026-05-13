local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotService = require(script.Parent.Map.PlotService)

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local strawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)

local map = PlotService.getMap()
local hub = map:WaitForChild("CentralHub")

local showcaseFolder = hub:FindFirstChild("ShowcaseModels")
if not showcaseFolder then
	showcaseFolder = Instance.new("Folder")
	showcaseFolder.Name = "ShowcaseModels"
	showcaseFolder.Parent = hub
else
	showcaseFolder:ClearAllChildren()
end

local statue = strawberitaFactory.create("Diamond", {
	anchored = true,
	label = false,
	scale = 2.15,
	pivot = CFrame.new(0, 5.05, -8) * CFrame.Angles(0, math.rad(180), 0),
})
statue.Name = "MythicStrawberitaShowcase"
statue:SetAttribute("Showcase", true)
statue.Parent = showcaseFolder

local previewFolder = hub:FindFirstChild("PreviewModels")
if not previewFolder then
	previewFolder = Instance.new("Folder")
	previewFolder.Name = "PreviewModels"
	previewFolder.Parent = hub
else
	previewFolder:ClearAllChildren()
end

strawberitaFactory.createPreviewLineup(
	previewFolder,
	{ "Normal", "Shiny", "Golden", "Galaxy", "Diamond" },
	CFrame.new(-10.2, 2.25, 21) * CFrame.Angles(0, math.rad(180), 0)
)
