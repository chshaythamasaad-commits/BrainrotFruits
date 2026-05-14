local BlockStyle = {}

BlockStyle.Version = "StuddedBlockStyle_VISIBLE_V2"

local DEFAULT_STUD_HEIGHT = 0.12
local DEFAULT_STUD_SIZE = 0.42
local DEFAULT_STUD_SPACING = 4.6
local DEFAULT_MAX_STUDS_PER_PART = 120

local stats = {
	styledParts = 0,
	gridFallbackParts = 0,
	gridStuds = 0,
}

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
	"LandingZone",
	"Label",
	"Marker",
	"Mouth",
	"Ocean",
	"Panel",
	"Sign",
	"Smile",
	"SpawnPad",
	"Sparkle",
	"StudGrid",
	"Text",
	"Trigger",
	"Water",
}

local STUD_GRID_NAME_PATTERNS = {
	"BaseFrame",
	"BackLobe$",
	"CenterPath",
	"CenterShowcaseWalkRing",
	"CollectorBase",
	"CoreGrass$",
	"DisplayPedestal",
	"ExtendedLaunchCauseway$",
	"Foundation",
	"GrassInterior",
	"HubStonePlaza",
	"HubToLaunchPath",
	"LaneFloor",
	"LaneProgressStrip",
	"LaunchPlaza",
	"LaunchPeninsula$",
	"LeftPlotLobe$",
	"LaunchPlazaInset",
	"PathGateBridge",
	"PathToPlot",
	"PlotBase",
	"Porch",
	"RevealZoneBase",
	"RevealPlatformIsland$",
	"RightPlotLobe$",
	"SafeZoneGrass",
	"SafeZoneRing",
	"ShowcasePedestal",
	"Slot%d+$",
	"Slot%d+StoneBase",
}

local CLASSIC_SURFACE_NAME_PATTERNS = {
	"BackLobe$",
	"CenterPath",
	"CenterShowcaseWalkRing",
	"CoreGrass$",
	"ExtendedLaunchCauseway$",
	"GrassInterior",
	"HubStonePlaza",
	"HubToLaunchPath",
	"LaneFloor",
	"LaunchPlaza",
	"LaunchPeninsula$",
	"LeftPlotLobe$",
	"PathGateBridge",
	"PathToPlot",
	"PlotBase",
	"RevealZoneBase",
	"RevealPlatformIsland$",
	"RightPlotLobe$",
	"SafeZoneGrass",
	"SafeZoneRing",
	"Slot%d+$",
	"Slot%d+StoneBase",
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

local function shouldUseClassicMaterial(part, options)
	if options and options.preserveMaterial then
		return false
	end
	if options and options.classicMaterial then
		return true
	end

	local name = part.Name
	for _, pattern in ipairs(CLASSIC_SURFACE_NAME_PATTERNS) do
		if string.find(name, pattern) then
			return true
		end
	end

	return false
end

local function shouldUseStudGrid(part, options)
	if options and options.studGrid == false then
		return false
	end
	if options and options.studGrid == true then
		return true
	end
	if not (options and options.allowStudGrid) then
		return false
	end
	if not part:IsA("Part") or part.Shape ~= Enum.PartType.Block then
		return false
	end
	if part.Size.X < 4 or part.Size.Z < 4 or part.Size.Y <= 0 then
		return false
	end

	local name = part.Name
	for _, pattern in ipairs(STUD_GRID_NAME_PATTERNS) do
		if string.find(name, pattern) then
			return true
		end
	end

	return false
end

local function getStudCount(length, spacing, maxAxisCount)
	local count = math.floor(length / spacing) + 1
	return math.clamp(count, 2, maxAxisCount)
end

local function lerpColor(color, target, alpha)
	return Color3.new(
		color.R + (target.R - color.R) * alpha,
		color.G + (target.G - color.G) * alpha,
		color.B + (target.B - color.B) * alpha
	)
end

local function addStudGrid(part, options)
	if part:FindFirstChild("StudGrid") then
		return false
	end

	local spacing = (options and options.studSpacing) or DEFAULT_STUD_SPACING
	local maxStuds = (options and options.maxStudsPerPart) or DEFAULT_MAX_STUDS_PER_PART
	local studSize = (options and options.studSize) or DEFAULT_STUD_SIZE
	local studHeight = (options and options.studHeight) or DEFAULT_STUD_HEIGHT
	local xCount = getStudCount(part.Size.X, spacing, 18)
	local zCount = getStudCount(part.Size.Z, spacing, 18)

	while xCount * zCount > maxStuds do
		if xCount >= zCount and xCount > 2 then
			xCount -= 1
		elseif zCount > 2 then
			zCount -= 1
		else
			break
		end
	end

	local folder = Instance.new("Folder")
	folder.Name = "StudGrid"
	folder.Parent = part

	local xInset = math.min(1.15, part.Size.X * 0.14)
	local zInset = math.min(1.15, part.Size.Z * 0.14)
	local usableX = math.max(part.Size.X - xInset * 2, 0.1)
	local usableZ = math.max(part.Size.Z - zInset * 2, 0.1)
	local topY = part.Size.Y / 2 + studHeight / 2 + 0.018
	local studColor = lerpColor(part.Color, Color3.fromRGB(255, 255, 255), 0.16)
	local created = 0

	for xIndex = 1, xCount do
		local xAlpha = xCount == 1 and 0.5 or (xIndex - 1) / (xCount - 1)
		local localX = -usableX / 2 + usableX * xAlpha

		for zIndex = 1, zCount do
			local zAlpha = zCount == 1 and 0.5 or (zIndex - 1) / (zCount - 1)
			local localZ = -usableZ / 2 + usableZ * zAlpha

			local stud = Instance.new("Part")
			stud.Name = "VisibleStud"
			stud.Size = Vector3.new(studSize, studHeight, studSize)
			stud.CFrame = part.CFrame * CFrame.new(localX, topY, localZ)
			stud.Color = studColor
			stud.Material = Enum.Material.Plastic
			stud.Anchored = true
			stud.CanCollide = false
			stud.CanTouch = false
			stud.CanQuery = false
			stud.TopSurface = Enum.SurfaceType.Smooth
			stud.BottomSurface = Enum.SurfaceType.Smooth
			stud:SetAttribute("BlockStyleVersion", BlockStyle.Version)
			stud:SetAttribute("VisualStud", true)
			stud.Parent = folder
			created += 1
		end
	end

	if created > 0 then
		part:SetAttribute("StudGridFallback", true)
		part:SetAttribute("StudGridCount", created)
		stats.gridFallbackParts += 1
		stats.gridStuds += created
		return true
	end

	folder:Destroy()
	return false
end

function BlockStyle.resetStats()
	stats.styledParts = 0
	stats.gridFallbackParts = 0
	stats.gridStuds = 0
end

function BlockStyle.getStats()
	return {
		styledParts = stats.styledParts,
		gridFallbackParts = stats.gridFallbackParts,
		gridStuds = stats.gridStuds,
	}
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

	if shouldUseClassicMaterial(part, options) then
		part.Material = Enum.Material.Plastic
	end

	part.TopSurface = (options and options.topSurface) or Enum.SurfaceType.Studs
	part.BottomSurface = (options and options.bottomSurface) or Enum.SurfaceType.Inlet
	part:SetAttribute("BlockStyleVersion", BlockStyle.Version)
	stats.styledParts += 1

	if shouldUseStudGrid(part, options) then
		addStudGrid(part, options)
	end

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
