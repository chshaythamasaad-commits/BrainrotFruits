local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local StrawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)

local StrawberitaTransformService = {}

local activeByUserId = {}
local printedVersion = false

local function printVersion()
	if not printedVersion then
		print("[BrainrotFruits] StrawberitaTransform_Fixed_V1 active")
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

local function getFlightCFrame(crate)
	local position = crate.Position + Vector3.new(0, 1.8, 0)
	local targetDirection = flatDirectionFromVelocity(crate.AssemblyLinearVelocity, Vector3.new(0, 0, 1))
	return CFrame.lookAt(position, position + targetDirection)
end

local function addReturnRunSparkles(state)
	local visualModel = state.visualModel
	local root = visualModel and visualModel.PrimaryPart
	if not root or root:FindFirstChild("ReturnRunSparkleAttachment") then
		return
	end

	local attachment = Instance.new("Attachment")
	attachment.Name = "ReturnRunSparkleAttachment"
	attachment.Position = Vector3.new(0, -1.4, 0.35)
	attachment.Parent = root

	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "CuteReturnRunSparkles"
	emitter.Color = ColorSequence.new(Color3.fromRGB(255, 244, 184), Color3.fromRGB(255, 128, 170))
	emitter.LightEmission = 0.45
	emitter.Rate = 10
	emitter.Lifetime = NumberRange.new(0.35, 0.7)
	emitter.Speed = NumberRange.new(0.25, 0.85)
	emitter.SpreadAngle = Vector2.new(45, 45)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.14),
		NumberSequenceKeypoint.new(0.55, 0.1),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Parent = attachment
end

local function createVisualModel(player, parent, root)
	local visualModel = StrawberitaFactory.create("Normal", {
		anchored = false,
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
			descendant.Anchored = false
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = true
		end
	end

	return visualModel
end

local function attachVisualToRoot(state)
	local visualModel = state.visualModel
	local visualRoot = visualModel and visualModel.PrimaryPart
	local root = state.root
	if not visualRoot or not root then
		return false
	end

	visualRoot.CFrame = root.CFrame
	local weld = Instance.new("WeldConstraint")
	weld.Name = "StrawberitaTransformWeld"
	weld.Part0 = root
	weld.Part1 = visualRoot
	weld.Parent = visualRoot
	state.visualWeld = weld
	return true
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

	root.Anchored = true
	root.CFrame = getFlightCFrame(crate)
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0
	humanoid.AutoRotate = false
	humanoid.PlatformStand = true

	state.visualModel = createVisualModel(player, parent or crate.Parent, root)
	activeByUserId[player.UserId] = state
	hideCharacter(state)
	hideFlightCrateProxy(crate)
	attachVisualToRoot(state)

	player:SetAttribute("IsLaunching", true)
	player:SetAttribute("IsCrate", true)
	player:SetAttribute("IsTransformedStrawberita", true)
	player:SetAttribute("PendingRewardName", "")
	player:SetAttribute("ReturnRunActive", false)

	return true
end

function StrawberitaTransformService.syncToCrate(player, crate)
	local state = activeByUserId[player.UserId]
	if not state or state.crate ~= crate then
		return
	end

	local root = getRoot(player)
	if root then
		root.CFrame = getFlightCFrame(crate)
	end
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
	addReturnRunSparkles(state)
	return true
end

function StrawberitaTransformService.finish(player, restoreMovement, position)
	local state = activeByUserId[player.UserId]
	if not state then
		return
	end

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
