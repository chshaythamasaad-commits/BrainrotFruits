local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local CharacterRegistry = require(script.Parent.CharacterRegistry)
local CharacterVariantService = require(script.Parent.CharacterVariantService)

local CharacterAnimationService = {}

CharacterAnimationService.Version = "CharacterCollectibleAnimation_V1"
CharacterAnimationService.IdleBehaviorVersion = "RosterUniqueIdle_V1"

local activeByModel = {}
local printedVersion = false

-- Tune animation speed/intensity here. Keep values small so many plot collectibles stay mobile-friendly.
local STYLE_SETTINGS = {
	CuteWave = { bounce = 0.2, sway = 0.04, period = 1.55 },
	BanditHatTip = { bounce = 0.14, sway = 0.07, period = 1.8 },
	CavemanBonk = { bounce = 0.13, sway = 0.035, period = 1.35 },
	RunnerFootTap = { bounce = 0.17, sway = 0.045, period = 1.05 },
	HeavyWobble = { bounce = 0.1, sway = 0.085, period = 2.05 },
	CoolShades = { bounce = 0.14, sway = 0.06, period = 1.75 },
}

local HEAD_ROLES = {
	Head = true,
	Face = true,
	EyeLeft = true,
	EyeRight = true,
	Eye = true,
	Cheek = true,
	Mouth = true,
	Hat = true,
	Leaf = true,
	Stem = true,
	Seed = true,
	Sunglasses = true,
}

local function markMap()
	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		map:SetAttribute("CharacterAnimationVersion", CharacterAnimationService.Version)
		map:SetAttribute("CharacterIdleBehaviorVersion", CharacterAnimationService.IdleBehaviorVersion)
		map:SetAttribute("StrawberitaAnimationVersion", "AliveIdle_V1")
		map:SetAttribute("StrawberitaIdleBehaviorVersion", "WaveHeadTurn_V1")
	end
end

local function printVersion()
	if not printedVersion then
		print("[BrainrotFruits] CharacterCollectibleAnimation_V1 active")
		print("[BrainrotFruits] Character unique idle animations active")
		print("[BrainrotFruits] Character landing intros active")
		print("[BrainrotFruits] StrawberitaHeadTurn_V1 active")
		print("[BrainrotFruits] StrawberitaWaveIdle_V1 active")
		printedVersion = true
	end
	markMap()
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
		TweenInfo.new(seconds, easingStyle or Enum.EasingStyle.Sine, easingDirection or Enum.EasingDirection.InOut),
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

local function getRoleParts(state, role)
	return state.partsByRole[role] or {}
end

local function composeHeadC0(state, part, baseC0, localOffset)
	if not state.headLookup or not state.headLookup[part] then
		return baseC0 * (localOffset or CFrame.new())
	end
	local pivot = state.headPivot or Vector3.new(0, 1.45, 0)
	return CFrame.new(pivot)
		* CFrame.Angles(0, state.headYaw or 0, state.headTilt or 0)
		* CFrame.new(-pivot)
		* baseC0
		* (localOffset or CFrame.new())
end

local function tweenPartGroup(state, role, poseName, seconds, getOffset)
	for index, part in ipairs(getRoleParts(state, role)) do
		local weld = state.welds[part]
		local original = state.originalC0[part]
		if weld and original then
			local offset = getOffset and getOffset(part, index) or CFrame.new()
			tweenProperty(
				state,
				`{poseName}_{part.Name}`,
				weld,
				seconds,
				{ C0 = composeHeadC0(state, part, original, offset) },
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			)
		end
	end
end

local function restoreRole(state, role, poseName, seconds)
	tweenPartGroup(state, role, poseName, seconds or 0.18, function()
		return CFrame.new()
	end)
end

local function setHeadPose(state, poseName, yawDegrees, tiltDegrees, seconds)
	state.headYaw = math.rad(math.clamp(yawDegrees or 0, -18, 18))
	state.headTilt = math.rad(math.clamp(tiltDegrees or 0, -5, 5))
	for part in pairs(state.headLookup or {}) do
		local weld = state.welds[part]
		local original = state.originalC0[part]
		if weld and original then
			tweenProperty(
				state,
				`{poseName}_{part.Name}`,
				weld,
				seconds or 0.55,
				{ C0 = composeHeadC0(state, part, original) },
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			)
		end
	end
end

local function emitSparkles(state, name, count, offset, speed)
	local root = state.root
	if not root or not root.Parent then
		return
	end
	local config = state.variantConfig or {}
	local attachment = Instance.new("Attachment")
	attachment.Name = name or "CharacterAnimationSparkle"
	attachment.Position = offset or Vector3.new(0, 1.35, -0.25)
	attachment:SetAttribute("CharacterAnimationObject", true)
	attachment.Parent = root

	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "CharacterAnimationSparkles"
	emitter.Color = ColorSequence.new(
		config.sparkleColorA or Color3.fromRGB(255, 255, 245),
		config.sparkleColorB or Color3.fromRGB(255, 190, 220)
	)
	emitter.LightEmission = 0.55
	emitter.Rate = 0
	emitter.Lifetime = NumberRange.new(0.35, 0.9)
	emitter.Speed = speed or NumberRange.new(0.7, 1.8)
	emitter.SpreadAngle = Vector2.new(130, 130)
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.16),
		NumberSequenceKeypoint.new(0.62, 0.1),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter:SetAttribute("CharacterAnimationObject", true)
	emitter.Parent = attachment
	emitter:Emit(count or 14)

	Debris:AddItem(attachment, 1.25)
end

local function createShockRing(state, color)
	local root = state.root
	if not root or not root.Parent then
		return
	end

	local ring = Instance.new("Part")
	ring.Name = "CharacterAnimationShockRing"
	ring.Size = Vector3.new(2.2, 0.06, 2.2)
	ring.CFrame = state.baseRootCFrame * CFrame.new(0, -2.05, 0)
	ring.Color = color or Color3.fromRGB(255, 255, 245)
	ring.Material = Enum.Material.Neon
	ring.Transparency = 0.45
	ring.Anchored = true
	ring.CanCollide = false
	ring.CanTouch = false
	ring.CanQuery = false
	ring:SetAttribute("CharacterAnimationObject", true)
	ring.Parent = state.model

	TweenService:Create(ring, TweenInfo.new(0.48, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = Vector3.new(5.8, 0.04, 5.8),
		Transparency = 1,
	}):Play()
	Debris:AddItem(ring, 0.55)
end

local function prepareModel(state)
	state.welds = {}
	state.originalC0 = {}
	state.originalSize = {}
	state.originalTransparency = {}
	state.partsByRole = {}
	state.headLookup = {}

	for _, descendant in ipairs(state.model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = true
			descendant.Anchored = descendant == state.root

			if descendant ~= state.root then
				for _, child in ipairs(descendant:GetChildren()) do
					if (child:IsA("WeldConstraint") and child.Name == "BaseTemplateWeld")
						or (child:IsA("Weld") and child.Name == "CharacterAnimationWeld") then
						child:Destroy()
					end
				end

				local weld = Instance.new("Weld")
				weld.Name = "CharacterAnimationWeld"
				weld.Part0 = state.root
				weld.Part1 = descendant
				weld.C0 = state.root.CFrame:ToObjectSpace(descendant.CFrame)
				weld.C1 = CFrame.new()
				weld.Parent = descendant

				local role = descendant:GetAttribute("AnimationRole") or descendant:GetAttribute("CharacterPartRole") or "Detail"
				state.partsByRole[role] = state.partsByRole[role] or {}
				table.insert(state.partsByRole[role], descendant)
				if HEAD_ROLES[role] then
					state.headLookup[descendant] = true
				end

				state.welds[descendant] = weld
				state.originalC0[descendant] = weld.C0
				state.originalSize[descendant] = descendant.Size
				state.originalTransparency[descendant] = descendant.Transparency
			end
		end
	end
end

local function startBaseMotion(state)
	task.spawn(function()
		local style = STYLE_SETTINGS[state.animationStyle] or STYLE_SETTINGS.CuteWave
		local direction = 1
		while activeByModel[state.model] == state do
			if state.gestureActive then
				waitWhileActive(state, 0.08)
			else
				local upCFrame = state.baseRootCFrame
					* CFrame.new(style.sway * direction, style.bounce, 0)
					* CFrame.Angles(0, math.rad(0.65) * direction, math.rad(1.8) * direction)
				tweenProperty(state, "RootIdle", state.root, style.period * 0.5, { CFrame = upCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				if not waitWhileActive(state, style.period * 0.5) then
					break
				end

				local downCFrame = state.baseRootCFrame
					* CFrame.new(-style.sway * 0.45 * direction, 0, 0)
					* CFrame.Angles(0, math.rad(-0.35) * direction, math.rad(-0.8) * direction)
				tweenProperty(state, "RootIdle", state.root, style.period * 0.5, { CFrame = downCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				if not waitWhileActive(state, style.period * 0.5) then
					break
				end
				direction *= -1
			end
		end
	end)
end

local function startBlinkLoop(state)
	task.spawn(function()
		while activeByModel[state.model] == state do
			if not waitWhileActive(state, 3.2 + ((os.clock() + state.seed) % 3.3)) then
				break
			end
			for _, role in ipairs({ "Eye", "EyeLeft", "EyeRight" }) do
				for _, part in ipairs(getRoleParts(state, role)) do
					local originalSize = state.originalSize[part]
					if originalSize then
						tweenProperty(state, `Blink_{part.Name}`, part, 0.08, { Size = Vector3.new(originalSize.X, math.max(0.07, originalSize.Y * 0.16), originalSize.Z) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
				end
			end
			if not waitWhileActive(state, 0.11) then
				break
			end
			for _, role in ipairs({ "Eye", "EyeLeft", "EyeRight" }) do
				for _, part in ipairs(getRoleParts(state, role)) do
					local originalSize = state.originalSize[part]
					if originalSize then
						tweenProperty(state, `Blink_{part.Name}`, part, 0.09, { Size = originalSize }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					end
				end
			end
		end
	end)
end

local function startHeadLookLoop(state)
	task.spawn(function()
		local side = 1
		while activeByModel[state.model] == state do
			if not waitWhileActive(state, 1.8 + ((os.clock() + state.seed) % 2.4)) then
				break
			end
			if not state.gestureActive then
				setHeadPose(state, "HeadLook", side * (7 + (state.seed % 5)), side * -1.2, 0.8)
				waitWhileActive(state, 1.0)
				setHeadPose(state, "HeadLook", 0, 0, 0.65)
				side *= -1
			end
		end
	end)
end

local function startLeafLoop(state)
	task.spawn(function()
		local side = 1
		while activeByModel[state.model] == state do
			tweenPartGroup(state, "Leaf", "LeafWiggle", 1.1, function(_, index)
				return CFrame.Angles(math.rad(2.4) * side, math.rad((index % 2 == 0 and -1 or 1) * 1.4), math.rad(1.8) * side)
			end)
			tweenPartGroup(state, "Stem", "StemWiggle", 1.1, function()
				return CFrame.Angles(math.rad(1.4) * side, 0, math.rad(1.2) * side)
			end)
			side *= -1
			waitWhileActive(state, 1.1)
		end
	end)
end

local function friendlyWave(state)
	state.gestureActive = true
	setHeadPose(state, "WaveHeadLook", -9, 1.4, 0.24)
	waitWhileActive(state, 0.16)
	for wave = 1, 3 do
		local direction = wave % 2 == 0 and -1 or 1
		tweenPartGroup(state, "RightArm", "WaveRightArm", 0.18, function(part)
			local handBonus = part:GetAttribute("CharacterPartRole") == "Hand" and 0.08 or 0
			return CFrame.new(0, 0.16 + handBonus, -0.04) * CFrame.Angles(math.rad(-5), 0, math.rad(-24 + direction * 8))
		end)
		waitWhileActive(state, 0.2)
	end
	restoreRole(state, "RightArm", "WaveRightArm", 0.22)
	setHeadPose(state, "WaveHeadLook", 0, 0, 0.42)
	waitWhileActive(state, 0.26)
	state.gestureActive = false
end

local function banditHatTip(state)
	state.gestureActive = true
	setHeadPose(state, "BanditLook", 12, -1, 0.35)
	tweenPartGroup(state, "Hat", "HatTip", 0.22, function()
		return CFrame.new(0, -0.08, -0.05) * CFrame.Angles(math.rad(8), 0, math.rad(-7))
	end)
	tweenPartGroup(state, "RightArm", "HatTipArm", 0.22, function()
		return CFrame.new(0, 0.28, -0.05) * CFrame.Angles(math.rad(-10), 0, math.rad(-26))
	end)
	waitWhileActive(state, 0.55)
	restoreRole(state, "Hat", "HatTip", 0.24)
	restoreRole(state, "RightArm", "HatTipArm", 0.24)
	setHeadPose(state, "BanditLook", -9, 0.8, 0.35)
	waitWhileActive(state, 0.35)
	setHeadPose(state, "BanditLook", 0, 0, 0.35)
	state.gestureActive = false
end

local function cavemanBonk(state)
	state.gestureActive = true
	tweenPartGroup(state, "RightArm", "ClubRaise", 0.2, function()
		return CFrame.new(0, 0.3, -0.02) * CFrame.Angles(math.rad(-18), 0, math.rad(-32))
	end)
	tweenPartGroup(state, "Club", "ClubRaise", 0.2, function()
		return CFrame.new(0, 0.3, -0.02) * CFrame.Angles(math.rad(-20), 0, math.rad(-34))
	end)
	waitWhileActive(state, 0.28)
	tweenProperty(state, "CavemanStomp", state.root, 0.14, { CFrame = state.baseRootCFrame * CFrame.new(0, 0.18, 0) * CFrame.Angles(0, 0, math.rad(4)) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	waitWhileActive(state, 0.15)
	tweenProperty(state, "CavemanStomp", state.root, 0.16, { CFrame = state.baseRootCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	createShockRing(state, Color3.fromRGB(175, 120, 70))
	emitSparkles(state, "CavemanDustPuff", 10, Vector3.new(0, -1.55, 0), NumberRange.new(0.4, 1.0))
	restoreRole(state, "RightArm", "ClubRaise", 0.2)
	restoreRole(state, "Club", "ClubRaise", 0.2)
	waitWhileActive(state, 0.25)
	state.gestureActive = false
end

local function runnerFootTap(state)
	state.gestureActive = true
	for _ = 1, 4 do
		tweenPartGroup(state, "LeftFoot", "RunnerTap", 0.09, function()
			return CFrame.new(0, 0.09, -0.08) * CFrame.Angles(math.rad(-7), 0, 0)
		end)
		tweenPartGroup(state, "RightFoot", "RunnerTap", 0.09, function()
			return CFrame.new(0, -0.02, 0.06)
		end)
		waitWhileActive(state, 0.1)
		restoreRole(state, "LeftFoot", "RunnerTap", 0.08)
		restoreRole(state, "RightFoot", "RunnerTap", 0.08)
		waitWhileActive(state, 0.08)
	end
	tweenPartGroup(state, "RightArm", "HeadbandAdjust", 0.18, function()
		return CFrame.new(0, 0.22, -0.08) * CFrame.Angles(math.rad(-10), 0, math.rad(-22))
	end)
	emitSparkles(state, "RunnerSpeedDust", 10, Vector3.new(0, -1.55, 0.35), NumberRange.new(0.7, 1.4))
	waitWhileActive(state, 0.35)
	restoreRole(state, "RightArm", "HeadbandAdjust", 0.18)
	state.gestureActive = false
end

local function heavyWobble(state)
	state.gestureActive = true
	tweenProperty(state, "WatermelonWobble", state.root, 0.28, { CFrame = state.baseRootCFrame * CFrame.Angles(0, 0, math.rad(6)) }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	tweenPartGroup(state, "LeftArm", "FlexArm", 0.25, function()
		return CFrame.new(0, 0.12, 0) * CFrame.Angles(0, 0, math.rad(18))
	end)
	tweenPartGroup(state, "RightArm", "FlexArm", 0.25, function()
		return CFrame.new(0, 0.12, 0) * CFrame.Angles(0, 0, math.rad(-18))
	end)
	waitWhileActive(state, 0.34)
	tweenProperty(state, "WatermelonWobble", state.root, 0.28, { CFrame = state.baseRootCFrame * CFrame.Angles(0, 0, math.rad(-6)) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	createShockRing(state, Color3.fromRGB(88, 222, 105))
	waitWhileActive(state, 0.34)
	tweenProperty(state, "WatermelonWobble", state.root, 0.24, { CFrame = state.baseRootCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	restoreRole(state, "LeftArm", "FlexArm", 0.2)
	restoreRole(state, "RightArm", "FlexArm", 0.2)
	state.gestureActive = false
end

local function coolShades(state)
	state.gestureActive = true
	setHeadPose(state, "CoolNod", -8, 2, 0.28)
	tweenPartGroup(state, "Sunglasses", "AdjustShades", 0.18, function()
		return CFrame.new(0, 0.03, -0.04) * CFrame.Angles(math.rad(-3), 0, 0)
	end)
	tweenPartGroup(state, "RightArm", "AdjustShadesArm", 0.2, function()
		return CFrame.new(0, 0.28, -0.09) * CFrame.Angles(math.rad(-13), 0, math.rad(-24))
	end)
	waitWhileActive(state, 0.35)
	emitSparkles(state, "DrippoFlash", 18, Vector3.new(0, 1.45, -0.75), NumberRange.new(1.0, 2.5))
	restoreRole(state, "Sunglasses", "AdjustShades", 0.18)
	restoreRole(state, "RightArm", "AdjustShadesArm", 0.18)
	setHeadPose(state, "CoolNod", 0, 0, 0.36)
	waitWhileActive(state, 0.24)
	state.gestureActive = false
end

local GESTURES = {
	CuteWave = friendlyWave,
	BanditHatTip = banditHatTip,
	CavemanBonk = cavemanBonk,
	RunnerFootTap = runnerFootTap,
	HeavyWobble = heavyWobble,
	CoolShades = coolShades,
}

local function startGestureLoop(state)
	task.spawn(function()
		while activeByModel[state.model] == state do
			local waitSeconds = 4.4 + ((os.clock() + state.seed) % 4.2)
			if state.animationStyle == "RunnerFootTap" then
				waitSeconds = 2.6 + ((os.clock() + state.seed) % 2.5)
			elseif state.animationStyle == "HeavyWobble" then
				waitSeconds = 5.8 + ((os.clock() + state.seed) % 4)
			end
			if not waitWhileActive(state, waitSeconds) then
				break
			end
			if not state.gestureActive then
				local gesture = GESTURES[state.animationStyle] or friendlyWave
				gesture(state)
			end
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
	if state.root and state.root.Parent then
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
		if descendant:GetAttribute("CharacterAnimationObject") == true then
			descendant:Destroy()
		end
	end
	CharacterVariantService.cleanupVFX(model)
end

function CharacterAnimationService.stopIdle(model)
	stopState(model)
end

function CharacterAnimationService.startIdle(model, reward)
	if not model or not model:IsA("Model") then
		return false
	end
	if activeByModel[model] then
		return true
	end

	local root = model.PrimaryPart or model:FindFirstChild("Root") or model:FindFirstChildWhichIsA("BasePart", true)
	if not root then
		return false
	end

	printVersion()
	model.PrimaryPart = root
	local character = CharacterRegistry.getCharacter((reward and reward.characterId) or model:GetAttribute("CharacterId") or "Strawberita")
	local variantId = CharacterRegistry.normalizeVariantId((reward and (reward.variantName or reward.variant)) or model:GetAttribute("VariantName"))
	local variantConfig = CharacterVariantService.getConfig(character.Id, variantId)
	local state = {
		model = model,
		root = root,
		baseRootCFrame = root.CFrame,
		characterId = character.Id,
		animationStyle = character.AnimationStyle,
		variantId = variantId,
		variantConfig = variantConfig,
		seed = (model:GetAttribute("OwnerUserId") or 0) + (model:GetAttribute("DisplaySlotIndex") or 0) * 0.37,
		tweensByKey = {},
		headYaw = 0,
		headTilt = 0,
		headPivot = Vector3.new(0, 1.45, 0),
	}
	activeByModel[model] = state

	prepareModel(state)
	CharacterVariantService.startPlatformVFX(model, character.Id, variantId)
	model:SetAttribute("AliveIdleAnimation", "Active")
	model:SetAttribute("CharacterIdleAnimation", "Active")
	model:SetAttribute("CharacterAnimationVersion", CharacterAnimationService.Version)
	if character.Id == "Strawberita" then
		model:SetAttribute("WaveIdle", "Active")
		model:SetAttribute("HeadTurnIdle", "Active")
		model:SetAttribute("StrawberitaAnimationVersion", "AliveIdle_V1")
	end

	state.ancestryConnection = model.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			stopState(model)
		end
	end)

	startBaseMotion(state)
	startHeadLookLoop(state)
	startLeafLoop(state)
	startBlinkLoop(state)
	startGestureLoop(state)
	return true
end

function CharacterAnimationService.playIntro(model, reward)
	if not model or not model:IsA("Model") then
		return false
	end
	if not activeByModel[model] then
		CharacterAnimationService.startIdle(model, reward)
	end
	local state = activeByModel[model]
	if not state then
		return false
	end

	local characterId = state.characterId
	state.gestureActive = true
	cancelTween(state, "RootIdle")
	if characterId == "CoconuttoBonkini" then
		tweenProperty(state, "IntroDrop", state.root, 0.12, { CFrame = state.baseRootCFrame * CFrame.new(0, 0.35, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		waitWhileActive(state, 0.12)
		tweenProperty(state, "IntroDrop", state.root, 0.18, { CFrame = state.baseRootCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		createShockRing(state, Color3.fromRGB(175, 120, 70))
		emitSparkles(state, "CoconuttoIntroDust", 16, Vector3.new(0, -1.45, 0), NumberRange.new(0.5, 1.4))
		cavemanBonk(state)
	elseif characterId == "WatermeloniWobblino" then
		tweenProperty(state, "IntroWatermelonDrop", state.root, 0.22, { CFrame = state.baseRootCFrame * CFrame.new(0, 0.42, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		waitWhileActive(state, 0.22)
		tweenProperty(state, "IntroWatermelonDrop", state.root, 0.22, { CFrame = state.baseRootCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		createShockRing(state, Color3.fromRGB(88, 222, 105))
		heavyWobble(state)
	elseif characterId == "LemonaldoSprintini" then
		runnerFootTap(state)
		emitSparkles(state, "LemonaldoIntroSpeed", 18, Vector3.new(0, -1.45, 0.35), NumberRange.new(1.0, 2.2))
	elseif characterId == "BananaBandito" or characterId == "BananitoBandito" then
		tweenProperty(state, "IntroStumble", state.root, 0.2, { CFrame = state.baseRootCFrame * CFrame.new(-0.18, 0.12, 0) * CFrame.Angles(0, 0, math.rad(-6)) }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		waitWhileActive(state, 0.2)
		banditHatTip(state)
	elseif characterId == "DragonfruttoDrippo" then
		coolShades(state)
	else
		tweenProperty(state, "IntroPop", state.root, 0.16, { CFrame = state.baseRootCFrame * CFrame.new(0, 0.38, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		waitWhileActive(state, 0.16)
		tweenProperty(state, "IntroPop", state.root, 0.2, { CFrame = state.baseRootCFrame }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		emitSparkles(state, "StrawberitaIntroSparkles", 18)
		friendlyWave(state)
	end
	state.gestureActive = false
	return true
end

printVersion()

return CharacterAnimationService
