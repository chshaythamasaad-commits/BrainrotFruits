local BlockStyle = {}

BlockStyle.Version = "CleanClassicSurfaces_NoJitter_V2"

local stats = {
	styledParts = 0,
	artificialStudsRemoved = 0,
	offsetFixes = 0,
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
	"VisibleStud",
	"Water",
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
	"LaunchPeninsula$",
	"LaunchPlaza",
	"LeftPlotLobe$",
	"PathGateBridge",
	"PathToPlot",
	"PlotBase",
	"RevealPlatformIsland$",
	"RevealZoneBase",
	"RightPlotLobe$",
	"SafeZoneGrass",
	"SafeZoneRing",
	"Slot%d+$",
	"Slot%d+StoneBase",
}

local function matchesAnyPattern(name, patterns)
	for _, pattern in ipairs(patterns) do
		if string.find(name, pattern) then
			return true
		end
	end

	return false
end

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

	return matchesAnyPattern(part.Name, SMOOTH_NAME_PATTERNS)
end

local function shouldUseClassicMaterial(part, options)
	if options and options.preserveMaterial then
		return false
	end
	if options and options.classicMaterial then
		return true
	end

	return matchesAnyPattern(part.Name, CLASSIC_SURFACE_NAME_PATTERNS)
end

function BlockStyle.resetStats()
	stats.styledParts = 0
	stats.artificialStudsRemoved = 0
	stats.offsetFixes = 0
end

function BlockStyle.getStats()
	return {
		styledParts = stats.styledParts,
		artificialStudsRemoved = stats.artificialStudsRemoved,
		offsetFixes = stats.offsetFixes,
	}
end

function BlockStyle.noteOffsetFix()
	stats.offsetFixes += 1
end

function BlockStyle.removeArtificialStuds(root)
	if not root then
		return 0
	end

	local toDestroy = {}
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant.Name == "StudGrid"
			or descendant.Name == "VisibleStud"
			or descendant.Name == "FakeStud"
			or descendant.Name == "FallbackStud"
			or descendant:GetAttribute("VisualStud") == true
			or descendant:GetAttribute("StudGridFallback") == true then
			table.insert(toDestroy, descendant)
		end
	end

	for _, instance in ipairs(toDestroy) do
		instance:Destroy()
	end

	stats.artificialStudsRemoved += #toDestroy
	return #toDestroy
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
