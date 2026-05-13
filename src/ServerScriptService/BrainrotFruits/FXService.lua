local Debris = game:GetService("Debris")

local FXService = {}

function FXService.emitBurst(parent, position, color, name, amount)
	local holder = Instance.new("Part")
	holder.Name = name or "BurstFX"
	holder.Size = Vector3.new(0.2, 0.2, 0.2)
	holder.CFrame = CFrame.new(position)
	holder.Transparency = 1
	holder.Anchored = true
	holder.CanCollide = false
	holder.CanTouch = false
	holder.CanQuery = false
	holder.Parent = parent

	local attachment = Instance.new("Attachment")
	attachment.Parent = holder

	local emitter = Instance.new("ParticleEmitter")
	emitter.Color = ColorSequence.new(color)
	emitter.LightEmission = 0.45
	emitter.Lifetime = NumberRange.new(0.35, 0.85)
	emitter.Speed = NumberRange.new(10, 18)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Rate = 0
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.4),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Parent = attachment
	emitter:Emit(amount or 28)

	local light = Instance.new("PointLight")
	light.Color = color
	light.Brightness = 1.4
	light.Range = 10
	light.Parent = holder

	Debris:AddItem(holder, 1.5)
	return holder
end

return FXService
