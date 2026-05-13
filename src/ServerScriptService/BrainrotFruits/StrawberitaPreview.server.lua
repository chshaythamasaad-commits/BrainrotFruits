local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local fruitConfig = require(brainrotFruits.Configs.BrainrotFruitConfig)
local strawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)

local testWorld = Workspace:FindFirstChild("BrainrotFruitsTest")
if not testWorld then
	testWorld = Instance.new("Folder")
	testWorld.Name = "BrainrotFruitsTest"
	testWorld.Parent = Workspace
end

local previewFolder = testWorld:FindFirstChild("PreviewModels")
if not previewFolder then
	previewFolder = Instance.new("Folder")
	previewFolder.Name = "PreviewModels"
	previewFolder.Parent = testWorld
else
	previewFolder:ClearAllChildren()
end

strawberitaFactory.createPreviewLineup(
	previewFolder,
	fruitConfig.VariantOrder,
	CFrame.new(-8, 2.25, -22) * CFrame.Angles(0, math.rad(180), 0)
)
