local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotFruits = ReplicatedStorage:WaitForChild("BrainrotFruits")
local StrawberitaVoxelDataModule = BrainrotFruits.Models.Strawberita.StrawberitaVoxelData

local StrawberitaSinglePreviewV3 = {}

StrawberitaSinglePreviewV3.Version = "StrawberitaSingleCommonPreview_SourceScaleDetail_V5"
StrawberitaSinglePreviewV3.SOURCE_MODEL_SCALE = 1.0
StrawberitaSinglePreviewV3.PREVIEW_SCALE = 1.0
StrawberitaSinglePreviewV3.GAMEPLAY_FOLLOW_SCALE = 0.65
StrawberitaSinglePreviewV3.DefaultScale = StrawberitaSinglePreviewV3.PREVIEW_SCALE
StrawberitaSinglePreviewV3.DefaultPivot = CFrame.new(0, 3.2, 0)

local DEFAULT_FOLDER_NAME = "StrawberitaSinglePreview"
local DEFAULT_MODEL_NAME = "Common_Strawberita_SinglePreview"

local function loadVoxelData()
	local freshModule = StrawberitaVoxelDataModule:Clone()
	freshModule.Name = "StrawberitaVoxelData_SinglePreviewFresh"
	freshModule.Parent = script

	local ok, data = pcall(require, freshModule)
	freshModule:Destroy()

	if ok and type(data) == "table" and type(data.createSinglePreviewParts) == "function" then
		return data
	end

	if not ok then
		error(data, 2)
	end

	error("StrawberitaVoxelData is missing createSinglePreviewParts. Reconnect Rojo so the updated voxel data syncs into Studio.", 2)
end

local function scaled(vector, scale)
	return Vector3.new(vector.X * scale, vector.Y * scale, vector.Z * scale)
end

local function createRoot(model, pivot, scale)
	local root = Instance.new("Part")
	root.Name = "RootPart"
	root.Size = Vector3.new(0.8, 0.8, 0.8) * scale
	root.CFrame = pivot
	root.Transparency = 1
	root.Anchored = true
	root.CanCollide = false
	root.CanTouch = false
	root.CanQuery = false
	root.Massless = true
	root.TopSurface = Enum.SurfaceType.Smooth
	root.BottomSurface = Enum.SurfaceType.Smooth
	root:SetAttribute("BrainrotCharacterPart", true)
	root:SetAttribute("CharacterPartRole", "Root")
	root:SetAttribute("StrawberitaSinglePreviewPart", true)
	root.Parent = model
	model.PrimaryPart = root

	return root
end

local function setupPart(model, root, config, scale)
	local part = Instance.new(config.className or "Part")
	part.Name = config.name
	part.Size = scaled(config.size, scale)
	part.CFrame = root.CFrame * CFrame.new(scaled(config.offset, scale)) * (config.rotation or CFrame.new())
	part.Color = config.color
	part.Material = config.material or Enum.Material.SmoothPlastic
	part.Transparency = config.transparency or 0
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true

	if part:IsA("BasePart") then
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
	end

	part:SetAttribute("BrainrotCharacterPart", true)
	part:SetAttribute("CharacterPartRole", config.role or "Detail")
	part:SetAttribute("AnimationRole", config.animationRole or config.role or "Detail")
	part:SetAttribute("VariantColorRole", config.colorRole or "Accessory")
	part:SetAttribute("StrawberitaRole", config.role or "Detail")
	part:SetAttribute("StrawberitaSinglePreviewPart", true)
	part:SetAttribute("BaseColor", config.color)
	part:SetAttribute("BaseMaterial", part.Material.Name)
	part.Parent = model

	return part
end

local function getOrCreateFolder(parent, clearFirst)
	local existing = parent:FindFirstChild(DEFAULT_FOLDER_NAME)
	if existing and clearFirst ~= false then
		existing:Destroy()
		existing = nil
	end

	if existing then
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = DEFAULT_FOLDER_NAME
	folder.Parent = parent

	return folder
end

function StrawberitaSinglePreviewV3.spawn(options)
	options = options or {}

	local parent = options.parent or Workspace
	local scale = options.scale or StrawberitaSinglePreviewV3.DefaultScale
	local pivot = options.pivot or StrawberitaSinglePreviewV3.DefaultPivot
	local folder = getOrCreateFolder(parent, options.clearFirst)
	local voxelData = loadVoxelData()

	local model = Instance.new("Model")
	model.Name = options.name or DEFAULT_MODEL_NAME
	model:SetAttribute("CharacterId", "Strawberita")
	model:SetAttribute("VariantId", "Base")
	model:SetAttribute("VariantName", "Common")
	model:SetAttribute("Rarity", "Common")
	model:SetAttribute("ReferencePath", voxelData.ReferencePath)
	model:SetAttribute("BlueprintPath", voxelData.BlueprintPath)
	model:SetAttribute("StrawberitaVoxelDataVersion", voxelData.SinglePreviewVersion)
	model:SetAttribute("StrawberitaSinglePreviewVersion", StrawberitaSinglePreviewV3.Version)
	model:SetAttribute("SourceModelScale", StrawberitaSinglePreviewV3.SOURCE_MODEL_SCALE)
	model:SetAttribute("PreviewScale", scale)
	model:SetAttribute("GameplayFollowScale", StrawberitaSinglePreviewV3.GAMEPLAY_FOLLOW_SCALE)
	model:SetAttribute("EstimatedHeightStuds", (voxelData.SinglePreviewEstimatedHeightStuds or voxelData.EstimatedHeightStuds) * scale)
	model:SetAttribute("EstimatedWidthStuds", (voxelData.SinglePreviewEstimatedWidthStuds or 0) * scale)
	model:SetAttribute("EstimatedDepthStuds", (voxelData.SinglePreviewEstimatedDepthStuds or 0) * scale)

	local root = createRoot(model, pivot, scale)
	for _, definition in ipairs(voxelData.createSinglePreviewParts()) do
		setupPart(model, root, definition, scale)
	end

	model.Parent = folder
	model:PivotTo(pivot)

	return model
end

return StrawberitaSinglePreviewV3
