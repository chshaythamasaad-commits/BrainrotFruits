local BlockStyle = {}

BlockStyle.Version = "StuddedBlockStyle_V1"

local SMOOTH_MATERIALS = {
	[Enum.Material.ForceField] = true,
	[Enum.Material.Glass] = true,
	[Enum.Material.Neon] = true,
}

local SMOOTH_NAME_PATTERNS = {
	"Attachment",
	"Arrow",
	"BaseClaimZone",
	"Billboard",
	"Board",
	"Cheek",
	"Eye",
	"Face",
	"Glow",
	"Hitbox",
	"Interact",
	"Label",
	"Marker",
	"Mouth",
	"Ocean",
	"Panel",
	"Sign",
	"Smile",
	"SpawnPad",
	"Sparkle",
	"Text",
	"Trigger",
	"Water",
	"Zone",
}

local function shouldStaySmooth(part, options)
	if options and options.forceStuds then
		return false
	end
	if options and options.smooth then
		return true
	end
	if part.Transparency >= 0.95 then
		return true
	end
	if part:IsA("Part") and part.Shape == Enum.PartType.Cylinder then
		return true
	end
	if SMOOTH_MATERIALS[part.Material] then
		return true
	end

	local name = part.Name
	for _, pattern in ipairs(SMOOTH_NAME_PATTERNS) do
		if string.find(name, pattern) then
			return true
		end
	end

	return false
end

function BlockStyle.applyStuddedStyle(part, options)
	if not part or not part:IsA("BasePart") then
		return part
	end

	if shouldStaySmooth(part, options) then
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		return part
	end

	part.TopSurface = (options and options.topSurface) or Enum.SurfaceType.Studs
	part.BottomSurface = (options and options.bottomSurface) or Enum.SurfaceType.Inlet
	part:SetAttribute("BlockStyleVersion", BlockStyle.Version)
	return part
end

function BlockStyle.applyModel(model, options)
	if not model then
		return model
	end

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			BlockStyle.applyStuddedStyle(descendant, options)
		end
	end

	return model
end

return BlockStyle
