local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotService = require(script.Parent.Map.PlotService)

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local fruitConfig = require(brainrotFruits.Configs.BrainrotFruitConfig)
local strawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)

local map = PlotService.getMap()
local hub = map:WaitForChild("CentralHub")

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
	fruitConfig.VariantOrder,
	CFrame.new(-8, 2.25, 20) * CFrame.Angles(0, math.rad(180), 0)
)
