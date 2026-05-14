local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local brainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local StrawberitaFactory = require(brainrotFruits.Models.StrawberitaFactory)
local StrawberitaVFX = require(brainrotFruits.Shared.StrawberitaVFX)

local StrawberitaTransformService = {}

local activeByUserId = {}
local printedVersion = false
local printedAnimationVersion = false

local ANIMATION_VERSION = "FunBouncyMotion_V1"
local MOVING_THRESHOLD = 0.08
local FACE_POP_SECONDS = 0.48
local CELEBRATION_SECONDS = 0.72
local LOST_WOBBLE_SECONDS = 0.58
local LAUNCH_STRETCH_SECONDS = 0.52

local LEAF_ROLES = {
	Leaf = true,
	LeafShadow = true,
	Stem = true,
}

local FACE_ROLES = {
	Cheek = true,
	Eye = true,
	EyeFrame = true,
	EyeWhite = true,
	EyePupil = true,
	Face = true,
	FacePanel = true,
	Mouth = true,
	Smile = true,
}

local BODY_STRETCH_ROLES = {
	Body = true,
	BodyDark = true,
	BodyShade = true,
	Bow = true,
}

local function markAnimationVersion()
	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		map:SetAttribute("StrawberitaTransformAnimationVersion", ANIMATION_VERSION)
		if not map:GetAttribute("StrawberitaAnimationVersion") then
			map:SetAttribute("StrawberitaAnimationVersion", ANIMATION_VERSION)
		end
		map:SetAttribute("StrawberitaVariantVFXVersion", StrawberitaVFX.Version)
	end
end

local function printVersion()
	if not printedVersion then
		print("[BrainrotFruits] StrawberitaTransform_Fixed_V1 active")
		printedVersion = true
	end
	if not printedAnimationVersion then
		print("[BrainrotFruits] StrawberitaFunAnimation_V1 active")
		print("[BrainrotFruits] Strawberita idle/walk animation active")
		print("[BrainrotFruits] Strawberita return-run trail active")
		printedAnimationVersion = true
	end
	markAnimationVersion()
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
	if not root then
		state.returnTrailActive = true
		return
	end

	local variantVFXState = StrawberitaVFX.startTransformedPlayerVFX(state.player, visualModel, state.variantName or "Normal")
	state.returnTrailActive = true
	state.variantVFXState = variantVFXState
	state.returnTrailEmitter = variantVFXState and variantVFXState.trailEmitter
	state.returnTrailAttachment = variantVFXState and variantVFXState.trailAttachment
	state.returnTrailMovingRate = variantVFXState and variantVFXState.trailMovingRate or 20
	state.returnTrailIdleRate = variantVFXState and variantVFXState.trailIdleRate or 6
end

local function createEmitter(parent, name, colorSequence, rate)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = name
	emitter.Color = colorSequence
	emitter.LightEmission = 0.42
	emitter.Rate = rate or 0
	emitter.Lifetime = NumberRange.new(0.24, 0.52)
	emitter.Speed = NumberRange.new(0.25, 0.9)
	emitter.SpreadAngle = Vector2.new(65, 65)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.16),
		NumberSequenceKeypoint.new(0.55, 0.11),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Parent = parent
	return emitter
end

local function emitOneShot(root, name, colorSequence, count, speed)
	if not root then
		return
	end

	local attachment = Instance.new("Attachment")
	attachment.Name = `{name}Attachment`
	attachment.Parent = root

	local emitter = createEmitter(attachment, name, colorSequence, 0)
	emitter.Lifetime = NumberRange.new(0.28, 0.72)
	emitter.Speed = speed or NumberRange.new(0.9, 2.2)
	emitter:Emit(count or 18)

	task.delay(1.15, function()
		if attachment.Parent then
			attachment:Destroy()
		end
	end)
end

local function addMovementEmitters(state)
	local root = state.visualModel and state.visualModel.PrimaryPart
	if not root or state.footstepEmitter then
		return
	end

	local footAttachment = Instance.new("Attachment")
	footAttachment.Name = "StrawberitaFootstepAttachment"
	footAttachment.Position = Vector3.new(0, -1.92, 0.25)
	footAttachment.Parent = root

	state.footstepAttachment = footAttachment
	state.footstepEmitter = createEmitter(
		footAttachment,
		"CuteFootstepPuffs",
		ColorSequence.new(Color3.fromRGB(255, 238, 211), Color3.fromRGB(255, 159, 190)),
		0
	)

	local sparkleAttachment = Instance.new("Attachment")
	sparkleAttachment.Name = "StrawberitaIdleSparkleAttachment"
	sparkleAttachment.Position = Vector3.new(0, 0.7, 0.2)
	sparkleAttachment.Parent = root

	state.idleSparkleAttachment = sparkleAttachment
	state.idleSparkleEmitter = createEmitter(
		sparkleAttachment,
		"CuteIdleSparkles",
		ColorSequence.new(Color3.fromRGB(255, 246, 156), Color3.fromRGB(255, 120, 191)),
		1
	)
end

local function prepareAnimatedVisual(state)
	local visualModel = state.visualModel
	local visualRoot = visualModel and visualModel.PrimaryPart
	if not visualRoot then
		return
	end

	state.partWelds = {}
	state.originalPartC0 = {}
	state.originalPartSize = {}
	state.leafParts = {}
	state.faceParts = {}
	state.bodyStretchParts = {}

	for _, descendant in ipairs(visualModel:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant ~= visualRoot then
			for _, child in ipairs(descendant:GetChildren()) do
				if child:IsA("WeldConstraint") and child.Name == "BaseTemplateWeld" then
					child:Destroy()
				end
			end

			local weld = Instance.new("Weld")
			weld.Name = "StrawberitaFunAnimationWeld"
			weld.Part0 = visualRoot
			weld.Part1 = descendant
			weld.C0 = visualRoot.CFrame:ToObjectSpace(descendant.CFrame)
			weld.C1 = CFrame.new()
			weld.Parent = descendant

			local role = descendant:GetAttribute("StrawberitaRole")
				or descendant:GetAttribute("CharacterPartRole")
				or descendant:GetAttribute("AnimationRole")
			state.partWelds[descendant] = weld
			state.originalPartC0[descendant] = weld.C0
			state.originalPartSize[descendant] = descendant.Size

			if LEAF_ROLES[role] then
				table.insert(state.leafParts, descendant)
			end
			if FACE_ROLES[role] then
				table.insert(state.faceParts, descendant)
			end
			if BODY_STRETCH_ROLES[role] then
				table.insert(state.bodyStretchParts, descendant)
			end
		end
	end

	addMovementEmitters(state)
end

local function getMovementMagnitude(state)
	local humanoid = state.humanoid
	if humanoid and humanoid.Parent then
		return humanoid.MoveDirection.Magnitude
	end
	return 0
end

local function updatePartOffsets(state, now, moving, dt)
	local leafSpeed = moving and 12.5 or 4.2
	local leafAmount = moving and math.rad(7.5) or math.rad(2.5)
	local facePop = 0
	if state.facePopUntil and now < state.facePopUntil then
		local alpha = math.clamp((state.facePopUntil - now) / FACE_POP_SECONDS, 0, 1)
		facePop = math.sin(alpha * math.pi)
	end

	for _, part in ipairs(state.leafParts or {}) do
		local weld = state.partWelds and state.partWelds[part]
		local original = state.originalPartC0 and state.originalPartC0[part]
		if weld and original then
			local phase = now * leafSpeed + (part.Position.X * 0.7)
			weld.C0 = original
				* CFrame.Angles(math.sin(phase) * leafAmount, math.sin(phase * 0.6) * leafAmount * 0.35, math.cos(phase) * leafAmount * 0.55)
		end
	end

	for _, part in ipairs(state.faceParts or {}) do
		local weld = state.partWelds and state.partWelds[part]
		local original = state.originalPartC0 and state.originalPartC0[part]
		if weld and original then
			local role = part:GetAttribute("StrawberitaRole")
			local popZ = (role == "Cheek" or role == "EyeFrame" or role == "EyePupil" or role == "EyeWhite") and -0.045 * facePop or -0.025 * facePop
			weld.C0 = original * CFrame.new(0, 0.025 * facePop, popZ)
		end
	end

	local stretch = 0
	if state.launchStretchUntil and now < state.launchStretchUntil then
		local alpha = math.clamp((state.launchStretchUntil - now) / LAUNCH_STRETCH_SECONDS, 0, 1)
		stretch = math.sin(alpha * math.pi)
	end
	for _, part in ipairs(state.bodyStretchParts or {}) do
		local originalSize = state.originalPartSize and state.originalPartSize[part]
		if part and part.Parent and originalSize then
			part.Size = originalSize + Vector3.new(0, 0.08 * stretch, 0)
		end
	end

	if state.footstepEmitter then
		state.footstepEmitter.Rate = moving and 18 or 0
	end
	if state.idleSparkleEmitter then
		state.idleSparkleEmitter.Rate = moving and 3 or 1
	end
	if state.returnTrailEmitter then
		local movingRate = state.returnTrailMovingRate or 20
		local idleRate = state.returnTrailIdleRate or 6
		state.returnTrailEmitter.Rate = state.returnTrailActive and (moving and movingRate or idleRate) or 0
	end
end

local function updateVisualRootOffset(state, now, moving)
	local weld = state.visualWeld
	if not weld or not weld.Parent then
		return
	end

	local speed = moving and 10.5 or 3.1
	local bounce = moving and 0.16 or 0.07
	local sway = moving and 0.065 or 0.025
	local tilt = moving and math.rad(3.8) or math.rad(1.2)
	local phase = now * speed

	local yOffset = math.abs(math.sin(phase)) * bounce
	local xOffset = math.sin(phase * 0.55) * sway
	local zTilt = math.sin(phase * 0.55) * tilt
	local yTilt = math.sin(phase * 0.38) * (moving and math.rad(2.2) or math.rad(0.8))
	local spin = 0

	if state.launchStretchUntil and now < state.launchStretchUntil then
		local alpha = math.clamp((state.launchStretchUntil - now) / LAUNCH_STRETCH_SECONDS, 0, 1)
		yOffset += math.sin(alpha * math.pi) * 0.2
		zTilt += math.sin(alpha * math.pi * 2) * math.rad(7)
	end

	if state.celebrationUntil and now < state.celebrationUntil then
		local alpha = math.clamp((state.celebrationUntil - now) / CELEBRATION_SECONDS, 0, 1)
		local pop = math.sin(alpha * math.pi)
		yOffset += pop * 0.42
		spin = pop * math.rad(18)
	end

	if state.lostWobbleUntil and now < state.lostWobbleUntil then
		local alpha = math.clamp((state.lostWobbleUntil - now) / LOST_WOBBLE_SECONDS, 0, 1)
		zTilt += math.sin(alpha * math.pi * 5) * math.rad(13)
		xOffset += math.sin(alpha * math.pi * 4) * 0.12
	end

	weld.C0 = CFrame.new(xOffset, yOffset, 0) * CFrame.Angles(0, yTilt + spin, zTilt)
end

local function startAnimationLoop(state)
	if state.animationConnection then
		return
	end

	state.animationConnection = RunService.Heartbeat:Connect(function(dt)
		if activeByUserId[state.player.UserId] ~= state or not state.visualModel or not state.visualModel.Parent then
			return
		end

		local now = os.clock()
		local moving = getMovementMagnitude(state) > MOVING_THRESHOLD and state.crate == nil
		updateVisualRootOffset(state, now, moving)
		updatePartOffsets(state, now, moving, dt)
	end)
end

local function triggerHappyPop(state)
	if not state then
		return
	end
	state.facePopUntil = os.clock() + FACE_POP_SECONDS
	local config = StrawberitaVFX.getConfig(state.variantName or "Normal")
	emitOneShot(
		state.visualModel and state.visualModel.PrimaryPart,
		"StrawberitaHappyPop",
		ColorSequence.new(config.sparkleColorA, config.sparkleColorB),
		18
	)
end

local function triggerLaunchStretch(state)
	if not state then
		return
	end
	state.launchStretchUntil = os.clock() + LAUNCH_STRETCH_SECONDS
	triggerHappyPop(state)
	emitOneShot(
		state.visualModel and state.visualModel.PrimaryPart,
		"StrawberitaLaunchPuff",
		ColorSequence.new(Color3.fromRGB(255, 244, 220), Color3.fromRGB(190, 190, 190)),
		24,
		NumberRange.new(1.2, 2.8)
	)
end

local function cleanupAnimation(state)
	if state.visualModel then
		StrawberitaVFX.cleanupVFX(state.visualModel)
	end
	if state.animationConnection then
		state.animationConnection:Disconnect()
		state.animationConnection = nil
	end
	if state.characterRemovingConnection then
		state.characterRemovingConnection:Disconnect()
		state.characterRemovingConnection = nil
	end
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
	local weld = Instance.new("Weld")
	weld.Name = "StrawberitaTransformWeld"
	weld.Part0 = root
	weld.Part1 = visualRoot
	weld.C0 = CFrame.new()
	weld.C1 = CFrame.new()
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
		player = player,
		variantName = "Base",
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
	prepareAnimatedVisual(state)
	startAnimationLoop(state)
	triggerLaunchStretch(state)
	state.characterRemovingConnection = player.CharacterRemoving:Connect(function(removingCharacter)
		if removingCharacter == state.character then
			StrawberitaTransformService.finish(player, true)
		end
	end)

	player:SetAttribute("IsLaunching", true)
	player:SetAttribute("IsCrate", true)
	player:SetAttribute("IsTransformedStrawberita", true)
	player:SetAttribute("PendingRewardName", "")
	player:SetAttribute("ReturnRunActive", false)

	return true
end

function StrawberitaTransformService.setVariant(player, variantName, reward)
	local state = activeByUserId[player.UserId]
	if not state then
		return false
	end

	state.reward = reward
	state.variantName = StrawberitaVFX.normalizeVariantName(variantName or reward)
	player:SetAttribute("TransformedStrawberitaVariant", state.variantName)

	if state.visualModel then
		state.visualModel:SetAttribute("VariantName", state.variantName)
		state.visualModel:SetAttribute("RewardVariant", variantName or state.variantName)
		StrawberitaVFX.applyVariantVFX(state.visualModel, state.variantName, "Transform")
	end

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
	if not state.variantName or state.variantName == "" then
		state.variantName = StrawberitaVFX.normalizeVariantName(player:GetAttribute("PendingRewardVariant"))
	end
	addReturnRunSparkles(state)
	triggerHappyPop(state)
	return true
end

function StrawberitaTransformService.playRewardSecured(player)
	local state = activeByUserId[player.UserId]
	if not state then
		return false
	end

	state.celebrationUntil = os.clock() + CELEBRATION_SECONDS
	state.facePopUntil = os.clock() + FACE_POP_SECONDS
	local config = StrawberitaVFX.getConfig(state.variantName or "Normal")
	emitOneShot(
		state.visualModel and state.visualModel.PrimaryPart,
		"StrawberitaRewardSecured",
		ColorSequence.new(config.burstColorA, config.burstColorB),
		34,
		NumberRange.new(1.1, 2.6)
	)
	if state.visualModel and state.visualModel.PrimaryPart then
		StrawberitaVFX.playRewardSecuredBurst(state.visualModel, state.visualModel.PrimaryPart.Position, state.variantName)
	end
	return true
end

function StrawberitaTransformService.playRewardLost(player)
	local state = activeByUserId[player.UserId]
	if not state then
		return false
	end

	state.lostWobbleUntil = os.clock() + LOST_WOBBLE_SECONDS
	local config = StrawberitaVFX.getConfig(state.variantName or "Normal")
	emitOneShot(
		state.visualModel and state.visualModel.PrimaryPart,
		"StrawberitaBonkedPuff",
		ColorSequence.new(config.sparkleColorA, Color3.fromRGB(218, 218, 218)),
		24,
		NumberRange.new(0.9, 2.1)
	)
	return true
end

function StrawberitaTransformService.finish(player, restoreMovement, position)
	local state = activeByUserId[player.UserId]
	if not state then
		return
	end

	cleanupAnimation(state)
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
	player:SetAttribute("TransformedStrawberitaVariant", "")
end

Players.PlayerRemoving:Connect(function(player)
	StrawberitaTransformService.finish(player, true)
end)

printVersion()

return StrawberitaTransformService
