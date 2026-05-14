local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local StrawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)

local StrawberitaTransformService = {}

local activeByUserId = {}
local printedVersion = false

local function printVersion()
	if not printedVersion then
		print("[BrainrotFruits] StrawberitaTransform_V1 active")
		printedVersion = true
	end
end

local function getHumanoid(player)
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot(player)
	local character = player.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function flatDirectionFromVelocity(velocity, fallback)
	local direction = Vector3.new(velocity.X, 0, velocity.Z)
	if direction.Magnitude > 0.1 then
		return direction.Unit
	end

	local flatFallback = Vector3.new(fallback.X, 0, fallback.Z)
	if flatFallback.Magnitude > 0.1 then
		return flatFallback.Unit
	end

	return Vector3.new(0, 0, 1)
end

local function pivotVisual(state, position, direction)
	local visualModel = state.visualModel
	if not visualModel or not visualModel.Parent then
		return
	end

	local targetDirection = flatDirectionFromVelocity(direction or Vector3.zero, Vector3.new(0, 0, 1))
	visualModel:PivotTo(CFrame.lookAt(position, position + targetDirection))
end

local function createVisualModel(player, parent, root)
	local visualModel = StrawberitaFactory.create("Normal", {
		anchored = true,
		label = false,
		pivot = root.CFrame,
		scale = 0.92,
	})
	visualModel.Name = `TransformedStrawberita_{player.UserId}`
	visualModel:SetAttribute("OwnerUserId", player.UserId)
	visualModel:SetAttribute("Type", "TemporaryStrawberitaTransform")
	visualModel.Parent = parent

	for _, descendant in ipairs(visualModel:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end

	return visualModel
end

local function hideFlightCrateProxy(crate)
	crate.Transparency = 1
	for _, descendant in ipairs(crate:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Transparency = 1
		end
	end
end

local function hideCharacter(state)
	for _, descendant in ipairs(state.character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			state.parts[descendant] = {
				Transparency = descendant.Transparency,
				CanCollide = descendant.CanCollide,
				CanTouch = descendant.CanTouch,
			}
			descendant.Transparency = 1
			descendant.CanCollide = false
			descendant.CanTouch = true
		elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
			state.decals[descendant] = descendant.Transparency
			descendant.Transparency = 1
		end
	end
end

local function restoreCharacterVisuals(state)
	for part, original in pairs(state.parts) do
		if part and part.Parent then
			part.Transparency = original.Transparency
			part.CanCollide = original.CanCollide
			part.CanTouch = original.CanTouch
		end
	end

	for decal, transparency in pairs(state.decals) do
		if decal and decal.Parent then
			decal.Transparency = transparency
		end
	end
end

local function startReturnFollowLoop(player, state)
	state.followingReturnRun = true
	task.spawn(function()
		while activeByUserId[player.UserId] == state and state.followingReturnRun do
			local root = getRoot(player)
			if not root then
				break
			end

			local velocity = root.AssemblyLinearVelocity
			local facing = flatDirectionFromVelocity(velocity, root.CFrame.LookVector)
			pivotVisual(state, root.Position, facing)
			task.wait(0.05)
		end
	end)
end

function StrawberitaTransformService.isActive(player)
	return activeByUserId[player.UserId] ~= nil
end

function StrawberitaTransformService.beginFlight(player, crate, parent)
	printVersion()

	local character = player.Character
	local humanoid = getHumanoid(player)
	local root = getRoot(player)
	if not character or not humanoid or not root or not crate then
		return false
	end

	StrawberitaTransformService.finish(player, true)

	local state = {
		character = character,
		humanoid = humanoid,
		root = root,
		crate = crate,
		parts = {},
		decals = {},
		rootAnchored = root.Anchored,
		walkSpeed = humanoid.WalkSpeed,
		jumpPower = humanoid.JumpPower,
		jumpHeight = humanoid.JumpHeight,
		autoRotate = humanoid.AutoRotate,
		platformStand = humanoid.PlatformStand,
	}

	state.visualModel = createVisualModel(player, parent or crate.Parent, root)
	activeByUserId[player.UserId] = state
	hideCharacter(state)
	hideFlightCrateProxy(crate)

	root.Anchored = true
	root.CFrame = crate.CFrame + Vector3.new(0, 1.8, 0)
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0
	humanoid.AutoRotate = false
	humanoid.PlatformStand = true

	player:SetAttribute("IsLaunching", true)
	player:SetAttribute("IsCrate", true)
	player:SetAttribute("IsTransformedStrawberita", true)
	player:SetAttribute("PendingRewardName", "")
	player:SetAttribute("ReturnRunActive", false)

	pivotVisual(state, crate.Position + Vector3.new(0, 2.15, 0), crate.AssemblyLinearVelocity)
	return true
end

function StrawberitaTransformService.syncToCrate(player, crate)
	local state = activeByUserId[player.UserId]
	if not state or state.crate ~= crate then
		return
	end

	local root = getRoot(player)
	if root then
		root.CFrame = crate.CFrame + Vector3.new(0, 1.8, 0)
	end

	pivotVisual(state, crate.Position + Vector3.new(0, 2.15, 0), crate.AssemblyLinearVelocity)
end

function StrawberitaTransformService.releaseForReturnRun(player, position)
	local state = activeByUserId[player.UserId]
	if not state then
		return false
	end

	local humanoid = getHumanoid(player)
	local root = getRoot(player)
	if root then
		root.Anchored = false
		root.CFrame = CFrame.new(position + Vector3.new(0, 4, 0))
	end
	if humanoid then
		humanoid.WalkSpeed = state.walkSpeed or 16
		humanoid.JumpPower = state.jumpPower or humanoid.JumpPower
		humanoid.JumpHeight = state.jumpHeight or humanoid.JumpHeight
		humanoid.AutoRotate = state.autoRotate ~= false
		humanoid.PlatformStand = state.platformStand == true
	end

	state.crate = nil
	player:SetAttribute("IsLaunching", false)
	player:SetAttribute("IsCrate", false)
	player:SetAttribute("IsTransformedStrawberita", true)
	startReturnFollowLoop(player, state)
	return true
end

function StrawberitaTransformService.finish(player, restoreMovement, position)
	local state = activeByUserId[player.UserId]
	if not state then
		return
	end

	state.followingReturnRun = false
	restoreCharacterVisuals(state)

	if state.visualModel and state.visualModel.Parent then
		state.visualModel:Destroy()
	end

	if restoreMovement then
		local humanoid = getHumanoid(player)
		local root = getRoot(player)
		if root then
			root.Anchored = state.rootAnchored == true
			if position then
				root.CFrame = CFrame.new(position + Vector3.new(0, 4, 0))
			end
		end
		if humanoid then
			humanoid.WalkSpeed = state.walkSpeed or 16
			humanoid.JumpPower = state.jumpPower or humanoid.JumpPower
			humanoid.JumpHeight = state.jumpHeight or humanoid.JumpHeight
			humanoid.AutoRotate = state.autoRotate ~= false
			humanoid.PlatformStand = state.platformStand == true
		end
	end

	activeByUserId[player.UserId] = nil
	player:SetAttribute("IsLaunching", false)
	player:SetAttribute("IsCrate", false)
	player:SetAttribute("IsTransformedStrawberita", false)
end

Players.PlayerRemoving:Connect(function(player)
	StrawberitaTransformService.finish(player, true)
end)

printVersion()

return StrawberitaTransformService
