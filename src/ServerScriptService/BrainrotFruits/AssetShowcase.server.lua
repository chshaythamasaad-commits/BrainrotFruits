local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local SHOWCASE_NAMES = {
	"BrainrotCrate",
	"Catapult",
	"StrawberitaMascot",
	"BananitoBonkito",
	"AppleliniSlappelini",
}

local SHOWCASE_FOLDER_NAME = "AssetShowcase"
local ASSET_FOLDER_NAME = "BrainrotFruitAssets"
local START_POSITION = Vector3.new(-56, 8, -132)
local ITEM_SPACING = 28
local PLATFORM_SIZE = Vector3.new(146, 2, 30)

local function createPart(parent, name, size, cframe, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function addLabel(parent, text, position)
	local post = createPart(
		parent,
		`{text}LabelPost`,
		Vector3.new(0.35, 4, 0.35),
		CFrame.new(position + Vector3.new(0, 2, -8)),
		Color3.fromRGB(67, 43, 27),
		Enum.Material.Wood
	)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NameLabel"
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 180
	billboard.Size = UDim2.fromOffset(230, 58)
	billboard.StudsOffset = Vector3.new(0, 3.4, 0)
	billboard.Parent = post

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
	label.BackgroundTransparency = 0.18
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBlack
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 245)
	label.TextScaled = true
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0.3
	label.TextWrapped = true
	label.Size = UDim2.fromScale(1, 1)
	label.Parent = billboard
end

local function findAsset(name)
	local assetFolder = ServerStorage:FindFirstChild(ASSET_FOLDER_NAME)
	if assetFolder then
		local folderAsset = assetFolder:FindFirstChild(name)
		if folderAsset then
			return folderAsset
		end
	end

	return ServerStorage:FindFirstChild(name)
end

local function getModelSize(instance)
	if instance:IsA("Model") then
		local _, size = instance:GetBoundingBox()
		return size
	end

	if instance:IsA("BasePart") then
		return instance.Size
	end

	return Vector3.new(6, 6, 6)
end

local function anchorForDisplay(instance)
	for _, descendant in instance:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
		end
	end

	if instance:IsA("BasePart") then
		instance.Anchored = true
		instance.CanCollide = false
	end
end

local function pivotForDisplay(instance, position)
	local size = getModelSize(instance)
	local target = CFrame.new(position + Vector3.new(0, 1 + size.Y * 0.5, 0))

	if instance:IsA("Model") then
		instance:PivotTo(target)
	elseif instance:IsA("BasePart") then
		instance.CFrame = target
	end
end

local function buildShowcase()
	local existing = Workspace:FindFirstChild(SHOWCASE_FOLDER_NAME)
	if existing then
		existing:Destroy()
	end

	local showcase = Instance.new("Folder")
	showcase.Name = SHOWCASE_FOLDER_NAME
	showcase.Parent = Workspace

	createPart(
		showcase,
		"ShowcasePlatform",
		PLATFORM_SIZE,
		CFrame.new(START_POSITION + Vector3.new((#SHOWCASE_NAMES - 1) * ITEM_SPACING * 0.5, -1, 0)),
		Color3.fromRGB(255, 216, 96),
		Enum.Material.SmoothPlastic
	)

	for index, assetName in ipairs(SHOWCASE_NAMES) do
		local position = START_POSITION + Vector3.new((index - 1) * ITEM_SPACING, 0, 0)
		createPart(
			showcase,
			`{assetName}Pedestal`,
			Vector3.new(16, 1.2, 16),
			CFrame.new(position + Vector3.new(0, -0.1, 0)),
			Color3.fromRGB(255, 128, 77),
			Enum.Material.SmoothPlastic
		)
		addLabel(showcase, assetName, position)

		local asset = findAsset(assetName)
		if asset then
			local clone = asset:Clone()
			clone.Name = `{assetName}_Showcase`
			clone.Parent = showcase
			anchorForDisplay(clone)
			pivotForDisplay(clone, position)
			print(`[BrainrotFruits] Showcasing asset: {assetName}`)
		else
			warn(`[BrainrotFruits] Missing showcase asset in ServerStorage: {assetName}`)
			createPart(
				showcase,
				`Missing_{assetName}`,
				Vector3.new(8, 8, 8),
				CFrame.new(position + Vector3.new(0, 4, 0)),
				Color3.fromRGB(185, 50, 55),
				Enum.Material.ForceField
			)
		end
	end
end

buildShowcase()
