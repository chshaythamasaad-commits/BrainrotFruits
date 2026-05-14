local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local StrawberitaVFX = require(script.Parent.StrawberitaVFX)

local StrawberitaAnimation = {}

StrawberitaAnimation.PlatformVersion = "AliveIdle_V1"

local activeByModel = {}
local printedPlatformVersion = false

local ARM_SWAY_SECONDS = 1.75
local LEAF_WIGGLE_SECONDS = 1.25
local ROOT_IDLE_MIN_SECONDS = 1.4
local ROOT_IDLE_MAX_SECONDS = 1.8
local IDLE_BEHAVIOR_VERSION = "WaveHeadTurn_V1"

local RARITY_EFFECTS = {
	Common = {
		colorA = Color3.fromRGB(255, 255, 245),
		colorB = Color3.fromRGB(255, 217, 232),
		platformBounce = 0.18,
		platformLightBrightness = 0,
	},
	Uncommon = {
		colorA = Color3.fromRGB(180, 255, 197),
		colorB = Color3.fromRGB(255, 217, 232),
		platformBounce = 0.19,
		platformLightBrightness = 0.08,
	},
	Rare = {
		colorA = Color3.fromRGB(255, 232, 95),
		colorB = Color3.fromRGB(255, 198, 51),
		platformBounce = 0.22,
		platformLightBrightness = 0.22,
	},
	Epic = {
		colorA = Color3.fromRGB(125, 77, 255),
		colorB = Color3.fromRGB(117, 244, 255),
		platformBounce = 0.27,
		platformLightBrightness = 0.34,
	},
	Legendary = {
		colorA = Color3.fromRGB(220, 255, 255),
		colorB = Color3.fromRGB(150, 238, 255),
		platformBounce = 0.24,
		platformLightBrightness = 0.28,
	},
}

local function markMap()
	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		map:SetAttribute("StrawberitaAnimationVersion", StrawberitaAnimation.PlatformVersion)
		map:SetAttribute("StrawberitaPlatformAnimationVersion", StrawberitaAnimation.PlatformVersion)
		map:SetAttribute("StrawberitaIdleBehaviorVersion", IDLE_BEHAVIOR_VERSION)
	end
end

local function printPlatformVersion()
	if not printedPlatformVersion then
		print("[BrainrotFruits] StrawberitaAliveIdle_V1 active")
		print("[BrainrotFruits] StrawberitaHeadTurn_V1 active")
		print("[BrainrotFruits] StrawberitaWaveIdle_V1 active")
		print("[BrainrotFruits] Strawberita arm wave idle active")
		print("[BrainrotFruits] Strawberita leaf wiggle active")
		printedPlatformVersion = true
	end
	markMap()
end

local function getVariantName(model, reward)
	return (reward and (reward.variantName or reward.variant))
		or model:GetAttribute("VariantName")
		or model:GetAttribute("RewardVariant")
		or model:GetAttribute("Variant")
		or "Normal"
end

local function getEffectConfig(variantName)
	local config = StrawberitaVFX.getConfig(variantName)
	return config or RARITY_EFFECTS.Common
end

local function waitWhileActive(state, seconds)
	local startedAt = os.clock()
	while activeByModel[state.model] == state and os.clock() - startedAt < seconds do
		task.wait(math.min(0.08, seconds))
	end
	return activeByModel[state.model] == state
end

local function cancelTween(state, key)
	local tween = state.tweensByKey and state.tweensByKey[key]
	if tween then
		tween:Cancel()
		state.tweensByKey[key] = nil
	end
end

local function tweenProperty(state, key, instance, seconds, properties, easingStyle, easingDirection)
	if activeByModel[state.model] ~= state or not instance or not instance.Parent then
		return nil
	end

	cancelTween(state, key)
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(
			seconds,
			easingStyle or Enum.EasingStyle.Sine,
			easingDirection or Enum.EasingDirection.InOut
		),
		properties
	)

	state.tweensByKey[key] = tween
	local connection
	connection = tween.Completed:Connect(function()
		if connection then
			connection:Disconnect()
		end
		if state.tweensByKey and state.tweensByKey[key] == tween then
			state.tweensByKey[key] = nil
		end
	end)

	tween:Play()
	return tween
end

local function withHeadTurn(state, part, baseC0)
	if not state.headPartsLookup or not state.headPartsLookup[part] then
		return baseC0
	end

	local pivot = state.headTurnPivot or Vector3.new(0, 1.55, 0)
	local yaw = state.headYaw or 0
	local tilt = state.headTilt or 0
	if math.abs(yaw) < 0.0001 and math.abs(tilt) < 0.0001 then
		return baseC0
	end

	return CFrame.new(pivot) * CFrame.Angles(0, yaw, tilt) * CFrame.new(-pivot) * baseC0
end

local function composePartC0(state, part, original, localOffset)
	return withHeadTurn(state, part, original) * (localOffset or CFrame.new())
end

local function setPartsDisplaySafe(model, root)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = true
			descendant.Anchored = descendant == root
		end
	end
end

local function isHeadTurnPart(part)
	local name = part.Name
	local role = part:GetAttribute("StrawberitaRole")

	if string.find(name, "Arm") or string.find(name, "Hand") or string.find(name, "Leg") or string.find(name, "Boot") then
		return false
	end
	if string.find(name, "Dress") or string.find(name, "Skirt") or string.find(name, "Chest") or string.find(name, "Trim") then
		return false
	end
	if role == "Leaf" or role == "LeafShadow" or role == "Stem" then
		return false
	end

	return string.find(name, "Head") ~= nil
		or string.find(name, "Strawberry") ~= nil
		or string.find(name, "Seed") ~= nil
		or string.find(name, "FacePanel") ~= nil
		or string.find(name, "Eye") ~= nil
		or string.find(name, "Cheek") ~= nil
		or string.find(name, "Smile") ~= nil
		or string.find(name, "Bow") ~= nil
		or role == "FacePanel"
		or role == "EyeFrame"
		or role == "EyeWhite"
		or role == "EyePupil"
		or role == "Cheek"
		or role == "Smile"
		or role == "Seed"
		or role == "Bow"
end

local function getPartBucket(part)
	local name = part.Name
	local role = part:GetAttribute("StrawberitaRole")

	if string.find(name, "LeftArm") or string.find(name, "LeftHand") then
		return "leftArm"
	elseif string.find(name, "RightArm") or string.find(name, "RightHand") then
		return "rightArm"
	elseif string.sub(name, 1, 4) == "Leaf" or name == "StemBlock" then
		return "leaf"
	elseif role == "EyeFrame" or role == "EyeWhite" or role == "EyePupil" then
		return "eye"
	elseif role == "Cheek" then
		return "cheek"
	elseif role == "Shoe" or role == "ShoePanel" or role == "Sock" or role == "SockCuff" then
		return "foot"
	end

	return nil
end

local function createAnimationWelds(state)
	local root = state.root
	state.welds = {}
	state.originalC0 = {}
	state.originalSize = {}
	state.originalTransparency = {}
	state.leftArm = {}
	state.rightArm = {}
	state.leaves = {}
	state.eyes = {}
	state.cheeks = {}
	state.feet = {}
	state.headParts = {}
	state.headPartsLookup = {}

	for _, descendant in ipairs(state.model:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant ~= root then
			for _, child in ipairs(descendant:GetChildren()) do
				if child:IsA("WeldConstraint") and child.Name == "BaseTemplateWeld" then
					child:Destroy()
				elseif child:IsA("Weld") and child.Name == "AliveIdleAnimationWeld" then
					child:Destroy()
				end
			end

			local weld = Instance.new("Weld")
			weld.Name = "AliveIdleAnimationWeld"
			weld.Part0 = root
			weld.Part1 = descendant
			weld.C0 = root.CFrame:ToObjectSpace(descendant.CFrame)
			weld.C1 = CFrame.new()
			weld.Parent = descendant

			state.welds[descendant] = weld
			state.originalC0[descendant] = weld.C0
			state.originalSize[descendant] = descendant.Size
			state.originalTransparency[descendant] = descendant.Transparency

			if isHeadTurnPart(descendant) then
				table.insert(state.headParts, descendant)
				state.headPartsLookup[descendant] = true
			end

			local bucket = getPartBucket(descendant)
			if bucket == "leftArm" then
				table.insert(state.leftArm, descendant)
			elseif bucket == "rightArm" then
				table.insert(state.rightArm, descendant)
			elseif bucket == "leaf" then
				table.insert(state.leaves, descendant)
			elseif bucket == "eye" then
				table.insert(state.eyes, descendant)
			elseif bucket == "cheek" then
				table.insert(state.cheeks, descendant)
			elseif bucket == "foot" then
				table.insert(state.feet, descendant)
			end
		end
	end
end

local function tweenPartGroup(state, parts, poseName, seconds, getC0)
	for index, part in ipairs(parts or {}) do
		local weld = state.welds[part]
		local original = state.originalC0[part]
		if weld and original then
			tweenProperty(
				state,
				`{poseName}_{part.Name}`,
				weld,
				seconds,
				{ C0 = getC0(part, original, index) },
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			)
		end
	end
end

local function restorePartGroup(state, parts, poseName, seconds)
	tweenPartGroup(state, parts, poseName, seconds or 0.2, function(part, original)
		return composePartC0(state, part, original)
	end)
end

local function applyHeadPose(state, poseName, yawDegrees, tiltDegrees, seconds)
	state.headYaw = math.rad(math.clamp(yawDegrees or 0, -18, 18))
	state.headTilt = math.rad(math.clamp(tiltDegrees or 0, -5, 5))

	for _, part in ipairs(state.headParts or {}) do
		local weld = state.welds[part]
		local original = state.originalC0[part]
		if weld and original then
			tweenProperty(
				state,
				`{poseName}_{part.Name}`,
				weld,
				seconds or 0.75,
				{ C0 = composePartC0(state, part, original) },
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			)
		end
	end
end

local function emitSparklePop(state, name, count, speed)
	local root = state.root
	if not root or not root.Parent then
		return
	end

	local config = state.config or {}
	local attachment = Instance.new("Attachment")
	attachment.Name = name or "AliveIdleSparklePop"
	attachment.Position = Vector3.new(0, 1.45, -0.25)
	attachment:SetAttribute("AliveIdleAnimationObject", true)
	attachment.Parent = root

	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "AliveIdleSparkles"
	emitter.Color = ColorSequence.new(
		config.sparkleColorA or config.colorA or Color3.fromRGB(255, 255, 245),
		config.sparkleColorB or config.colorB or Color3.fromRGB(255, 176, 211)
	)
	emitter.LightEmission = state.variantName == "Base" and 0.42 or 0.58
	emitter.Rate = 0
	emitter.Lifetime = NumberRange.new(0.35, 0.85)
	emitter.Speed = speed or NumberRange.new(0.7, 1.8)
	emitter.SpreadAngle = Vector2.new(120, 120)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.15),
		NumberSequenceKeypoint.new(0.6, 0.1),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter:SetAttribute("AliveIdleAnimationObject", true)
	emitter.Parent = attachment
	emitter:Emit(count or 14)

	Debris:AddItem(attachment, 1.2)
end

local function addPlatformEffects(state, config)
	local vfxState = StrawberitaVFX.startPlatformVFX(state.model, state.variantName)
	state.variantVFXState = vfxState
	state.glowLight = vfxState and vfxState.glowLight
	state.glowBaseBrightness = config.platformLightBrightness or 0
end

local function startRootIdleLoop(state)
	task.spawn(function()
		local baseBounce = state.config.platformBounce or 0.18
		local bounce = math.clamp(baseBounce, 0.15, 0.3)
		if state.variantName == "Galaxy" then
			bounce = math.min(bounce + 0.035, 0.3)
		end

		local period = ROOT_IDLE_MIN_SECONDS + ((state.seed % 7) / 7) * (ROOT_IDLE_MAX_SECONDS - ROOT_IDLE_MIN_SECONDS)
		local sway = state.variantName == "Galaxy" and 0.055 or 0.04
		local tilt = state.variantName == "Galaxy" and math.rad(2.1) or math.rad(1.45)
		local direction = 1

		while activeByModel[state.model] == state do
			if state.happyHopping then
				waitWhileActive(state, 0.08)
			else
				local upCFrame = state.baseRootCFrame
					* CFrame.new(sway * direction, bounce, 0)
					* CFrame.Angles(0, math.rad(0.55) * direction, tilt * direction)
				tweenProperty(state, "RootIdle", state.root, period * 0.5, { CFrame = upCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				if not waitWhileActive(state, period * 0.5) then
					break
				end

				local downCFrame = state.baseRootCFrame
					* CFrame.new(-sway * 0.55 * direction, 0, 0)
					* CFrame.Angles(0, math.rad(-0.3) * direction, -tilt * 0.45 * direction)
				tweenProperty(state, "RootIdle", state.root, period * 0.5, { CFrame = downCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				if not waitWhileActive(state, period * 0.5) then
					break
				end

				direction *= -1
			end
		end
	end)
end

local function startArmSwayLoop(state)
	task.spawn(function()
		local direction = 1
		while activeByModel[state.model] == state do
			if not state.gestureActive then
				tweenPartGroup(state, state.leftArm, "LeftArmSway", ARM_SWAY_SECONDS, function(part, original, index)
					local handLift = string.find(part.Name, "Hand") and 0.025 or 0
					return original
						* CFrame.new(0, handLift, 0)
						* CFrame.Angles(math.rad(1.1) * direction, 0, math.rad(3.2 + index * 0.35) * direction)
				end)
				tweenPartGroup(state, state.rightArm, "RightArmSway", ARM_SWAY_SECONDS * 0.92, function(part, original, index)
					local handLift = string.find(part.Name, "Hand") and 0.018 or 0
					return original
						* CFrame.new(0, handLift, 0)
						* CFrame.Angles(math.rad(-0.8) * direction, 0, math.rad(-2.6 - index * 0.3) * direction)
				end)
				direction *= -1
			end
			waitWhileActive(state, ARM_SWAY_SECONDS)
		end
	end)
end

local function startHeadTurnLoop(state)
	task.spawn(function()
		local side = 1
		while activeByModel[state.model] == state do
			local pauseSeconds = 1.4 + ((os.clock() + state.seed * 0.83) % 2.3)
			if not waitWhileActive(state, pauseSeconds) then
				break
			end
			if state.gestureActive or state.happyHopping then
				continue
			end

			local yaw = (8 + ((state.seed + os.clock()) % 7)) * side
			local tilt = side * -1.4
			applyHeadPose(state, "HeadTurnIdle", yaw, tilt, 0.85)
			if not waitWhileActive(state, 0.95 + ((state.seed + os.clock()) % 0.7)) then
				break
			end

			applyHeadPose(state, "HeadTurnIdle", 0, 0, 0.72)
			if not waitWhileActive(state, 0.8) then
				break
			end

			side *= -1
		end
	end)
end

local function startWaveLoop(state)
	task.spawn(function()
		while activeByModel[state.model] == state do
			local waitSeconds = 4 + ((os.clock() + state.seed) % 4)
			if not waitWhileActive(state, waitSeconds) then
				break
			end
			if state.gestureActive then
				continue
			end

			state.gestureActive = true
			applyHeadPose(state, "HeadWaveLook", -9, 1.4, 0.28)
			if not waitWhileActive(state, 0.16) then
				return
			end
			for wave = 1, 3 do
				local waveDirection = wave % 2 == 0 and -1 or 1
				tweenPartGroup(state, state.rightArm, "RightArmWave", 0.18, function(part, original, index)
					local handBonus = string.find(part.Name, "Hand") and 0.08 or 0
					return original
						* CFrame.new(0, 0.16 + handBonus, -0.04)
						* CFrame.Angles(math.rad(-5 + index), 0, math.rad(-24 + waveDirection * 8))
				end)
				tweenPartGroup(state, state.leftArm, "LeftArmWaveCounter", 0.18, function(_, original)
					return original * CFrame.new(0, 0.05, 0) * CFrame.Angles(0, 0, math.rad(4))
				end)
				if not waitWhileActive(state, 0.2) then
					return
				end
			end
			restorePartGroup(state, state.rightArm, "RightArmWave", 0.22)
			restorePartGroup(state, state.leftArm, "LeftArmWaveCounter", 0.22)
			applyHeadPose(state, "HeadWaveLook", 0, 0, 0.45)
			waitWhileActive(state, 0.24)
			state.gestureActive = false
		end
	end)
end

local function startLeafWiggleLoop(state)
	task.spawn(function()
		local direction = 1
		while activeByModel[state.model] == state do
			local boosted = state.leafBoostUntil and os.clock() < state.leafBoostUntil
			local amount = boosted and math.rad(8.5) or math.rad(2.8)
			local lift = boosted and 0.05 or 0.015
			tweenPartGroup(state, state.leaves, "LeafWiggle", LEAF_WIGGLE_SECONDS * (boosted and 0.55 or 1), function(part, original, index)
				local isStem = part.Name == "StemBlock"
				local localAmount = isStem and amount * 0.65 or amount
				return original
					* CFrame.new(0, lift * math.sin(index), 0)
					* CFrame.Angles(localAmount * direction, math.rad(index % 2 == 0 and 1.2 or -1.2), localAmount * 0.55 * direction)
			end)

			direction *= -1
			waitWhileActive(state, LEAF_WIGGLE_SECONDS * (boosted and 0.55 or 1))
		end
	end)
end

local function startBlinkLoop(state)
	task.spawn(function()
		while activeByModel[state.model] == state do
			local waitSeconds = 3 + ((os.clock() + state.seed * 1.73) % 4)
			if not waitWhileActive(state, waitSeconds) then
				break
			end

			for _, part in ipairs(state.eyes) do
				local originalSize = state.originalSize[part]
				local originalC0 = state.originalC0[part]
				local weld = state.welds[part]
				local role = part:GetAttribute("StrawberitaRole")
				if originalSize and originalC0 and weld then
					if role == "EyeFrame" then
						tweenProperty(state, `BlinkSize_{part.Name}`, part, 0.08, {
							Size = Vector3.new(originalSize.X, math.max(0.08, originalSize.Y * 0.14), originalSize.Z),
						}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						tweenProperty(state, `BlinkC0_{part.Name}`, weld, 0.08, {
							C0 = composePartC0(state, part, originalC0, CFrame.new(0, -originalSize.Y * 0.08, 0)),
						}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					else
						tweenProperty(state, `BlinkTransparency_{part.Name}`, part, 0.08, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
				end
			end

			if not waitWhileActive(state, 0.12) then
				break
			end

			for _, part in ipairs(state.eyes) do
				local originalSize = state.originalSize[part]
				local originalTransparency = state.originalTransparency[part]
				local originalC0 = state.originalC0[part]
				local weld = state.welds[part]
				if originalSize then
					tweenProperty(state, `BlinkSize_{part.Name}`, part, 0.09, { Size = originalSize }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end
				if originalTransparency ~= nil then
					tweenProperty(state, `BlinkTransparency_{part.Name}`, part, 0.09, { Transparency = originalTransparency }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end
				if originalC0 and weld then
					tweenProperty(state, `BlinkC0_{part.Name}`, weld, 0.09, { C0 = composePartC0(state, part, originalC0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				end
			end
		end
	end)
end

local function startHappyHopLoop(state)
	task.spawn(function()
		while activeByModel[state.model] == state do
			local waitSeconds = 6 + ((os.clock() + state.seed * 2.1) % 6)
			if not waitWhileActive(state, waitSeconds) then
				break
			end
			if state.happyHopping then
				continue
			end

			state.happyHopping = true
			state.gestureActive = true
			state.leafBoostUntil = os.clock() + 0.75
			cancelTween(state, "RootIdle")
			emitSparklePop(state, "AliveIdleHappyHopSparkles", state.variantName == "Base" and 14 or 24, NumberRange.new(1.0, 2.4))

			tweenPartGroup(state, state.leftArm, "HappyHopLeftArm", 0.14, function(_, original)
				return original * CFrame.new(0, 0.16, -0.03) * CFrame.Angles(math.rad(-3), 0, math.rad(14))
			end)
			tweenPartGroup(state, state.rightArm, "HappyHopRightArm", 0.14, function(_, original)
				return original * CFrame.new(0, 0.2, -0.03) * CFrame.Angles(math.rad(-5), 0, math.rad(-18))
			end)
			tweenPartGroup(state, state.cheeks, "HappyHopCheeks", 0.12, function(part, original)
				return composePartC0(state, part, original, CFrame.new(0, 0.025, -0.04))
			end)
			tweenProperty(
				state,
				"RootHappyHop",
				state.root,
				0.16,
				{ CFrame = state.baseRootCFrame * CFrame.new(0, math.min((state.config.platformBounce or 0.2) + 0.24, 0.45), 0) * CFrame.Angles(0, math.rad(5), math.rad(3)) },
				Enum.EasingStyle.Back,
				Enum.EasingDirection.Out
			)

			if not waitWhileActive(state, 0.18) then
				break
			end

			tweenProperty(
				state,
				"RootHappyHop",
				state.root,
				0.22,
				{ CFrame = state.baseRootCFrame },
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			)
			restorePartGroup(state, state.leftArm, "HappyHopLeftArm", 0.2)
			restorePartGroup(state, state.rightArm, "HappyHopRightArm", 0.2)
			restorePartGroup(state, state.cheeks, "HappyHopCheeks", 0.18)

			if state.glowLight and state.glowBaseBrightness > 0 then
				tweenProperty(state, "HappyHopGlow", state.glowLight, 0.12, { Brightness = state.glowBaseBrightness * 1.45 }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				waitWhileActive(state, 0.12)
				tweenProperty(state, "HappyHopGlow", state.glowLight, 0.28, { Brightness = state.glowBaseBrightness }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			else
				waitWhileActive(state, 0.16)
			end

			state.gestureActive = false
			state.happyHopping = false
		end
	end)
end

local function stopState(model)
	local state = activeByModel[model]
	if not state then
		return
	end

	activeByModel[model] = nil
	if state.ancestryConnection then
		state.ancestryConnection:Disconnect()
	end
	for _, tween in pairs(state.tweensByKey or {}) do
		tween:Cancel()
	end

	if model and model.Parent and state.root and state.root.Parent then
		state.root.CFrame = state.baseRootCFrame
	end

	for part, weld in pairs(state.welds or {}) do
		if part and part.Parent then
			local originalC0 = state.originalC0[part]
			local originalSize = state.originalSize[part]
			local originalTransparency = state.originalTransparency[part]
			if weld and weld.Parent and originalC0 then
				weld.C0 = originalC0
			end
			if originalSize then
				part.Size = originalSize
			end
			if originalTransparency ~= nil then
				part.Transparency = originalTransparency
			end
		end
	end

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:GetAttribute("AliveIdleAnimationObject") == true then
			descendant:Destroy()
		end
	end

	StrawberitaVFX.cleanupVFX(model)
end

function StrawberitaAnimation.stopPlatformIdle(model)
	stopState(model)
end

function StrawberitaAnimation.startPlatformIdle(model, reward)
	if not model or not model:IsA("Model") then
		return false
	end
	if activeByModel[model] then
		return true
	end

	local root = model.PrimaryPart or model:FindFirstChild("Root") or model:FindFirstChildWhichIsA("BasePart", true)
	if not root or not root:IsA("BasePart") then
		return false
	end
	model.PrimaryPart = root
	printPlatformVersion()
	setPartsDisplaySafe(model, root)

	local variantName = StrawberitaVFX.normalizeVariantName(getVariantName(model, reward))
	local config = getEffectConfig(variantName)
	local seed = (model:GetAttribute("OwnerUserId") or 0) + (model:GetAttribute("DisplaySlotIndex") or 0) * 0.37

	local state = {
		model = model,
		root = root,
		baseRootCFrame = root.CFrame,
		config = config,
		variantName = variantName,
		seed = seed,
		tweensByKey = {},
		headYaw = 0,
		headTilt = 0,
		headTurnPivot = Vector3.new(0, 1.55, 0),
	}
	activeByModel[model] = state

	createAnimationWelds(state)
	addPlatformEffects(state, config)
	model:SetAttribute("PlatformIdleAnimation", "Active")
	model:SetAttribute("AliveIdleAnimation", "Active")
	model:SetAttribute("WaveIdle", "Active")
	model:SetAttribute("HeadTurnIdle", "Active")
	model:SetAttribute("StrawberitaAnimationVersion", StrawberitaAnimation.PlatformVersion)

	state.ancestryConnection = model.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			stopState(model)
		end
	end)

	startRootIdleLoop(state)
	startArmSwayLoop(state)
	startHeadTurnLoop(state)
	startWaveLoop(state)
	startLeafWiggleLoop(state)
	startBlinkLoop(state)
	startHappyHopLoop(state)

	return true
end

return StrawberitaAnimation
