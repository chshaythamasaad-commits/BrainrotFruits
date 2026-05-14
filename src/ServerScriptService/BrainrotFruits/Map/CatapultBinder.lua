local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local CatapultConfig = require(brainrotFruits.Shared.CatapultConfig)

local CatapultBinder = {}

function CatapultBinder.bindPlotCatapult(plot)
	local catapult = plot:FindFirstChild(CatapultConfig.CatapultName)
	local zone = catapult and catapult:FindFirstChild(CatapultConfig.InteractZoneName)
	if not zone then
		return nil
	end

	if not zone:FindFirstChild("CatapultPrompt") then
		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "CatapultPrompt"
		prompt.ActionText = "Charge Launch"
		prompt.ObjectText = `Plot {plot:GetAttribute("PlotId")} Catapult`
		prompt.HoldDuration = 0
		prompt.MaxActivationDistance = CatapultConfig.InteractRange
		prompt.KeyboardKeyCode = Enum.KeyCode.E
		prompt.Parent = zone
	end

	return zone
end

function CatapultBinder.bindAll(plotsFolder)
	for _, plot in ipairs(plotsFolder:GetChildren()) do
		if plot:IsA("Model") then
			CatapultBinder.bindPlotCatapult(plot)
		end
	end
end

function CatapultBinder.bindSharedLaunchArea(map)
	local launchArea = map:FindFirstChild(CatapultConfig.SharedLaunchAreaName)
	local catapult = launchArea and launchArea:FindFirstChild(CatapultConfig.CatapultName)
	local zone = catapult and catapult:FindFirstChild(CatapultConfig.InteractZoneName)
	if not zone then
		return nil
	end

	if not zone:FindFirstChild("CatapultPrompt") then
		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "CatapultPrompt"
		prompt.ActionText = "Charge Launch"
		prompt.ObjectText = "Shared Catapult"
		prompt.HoldDuration = 0
		prompt.MaxActivationDistance = CatapultConfig.InteractRange
		prompt.KeyboardKeyCode = Enum.KeyCode.E
		prompt.Parent = zone
	end

	return zone
end

return CatapultBinder
