local CatapultConfig = {}

CatapultConfig.RemoteFolderName = "Remotes"

CatapultConfig.Remotes = {
	RequestLaunch = "RequestCatapultLaunch",
	LaunchResult = "CatapultLaunchResult",
	RequestReveal = "RequestCrateReveal",
	RevealResult = "CrateRevealResult",
}

CatapultConfig.ChargeSeconds = 1.45
CatapultConfig.CooldownSeconds = 3.5
CatapultConfig.InteractRange = 18

CatapultConfig.MinPower = 0.18
CatapultConfig.MaxPower = 1
CatapultConfig.MinHorizontalSpeed = 72
CatapultConfig.MaxHorizontalSpeed = 142
CatapultConfig.MinUpwardSpeed = 52
CatapultConfig.MaxUpwardSpeed = 86

CatapultConfig.LandingTimeoutSeconds = 7
CatapultConfig.RestingSpeed = 7
CatapultConfig.MaxValidDistance = 130
CatapultConfig.CrateLifetimeSeconds = 18

CatapultConfig.WorldFolderName = "BrainrotFruitsTest"
CatapultConfig.TestAreaFolderName = "TestArea"
CatapultConfig.CatapultName = "Catapult"
CatapultConfig.InteractZoneName = "InteractZone"
CatapultConfig.ActiveCratesFolderName = "ActiveCrates"

return CatapultConfig
