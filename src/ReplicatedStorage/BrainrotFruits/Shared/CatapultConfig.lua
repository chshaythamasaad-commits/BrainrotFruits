local CatapultConfig = {}

CatapultConfig.RemoteFolderName = "Remotes"

CatapultConfig.Remotes = {
	RequestLaunch = "RequestCatapultLaunch",
	LaunchResult = "CatapultLaunchResult",
	RequestReveal = "RequestCrateReveal",
	RevealResult = "CrateRevealResult",
	ReturnRunStatus = "ReturnRunStatus",
}

CatapultConfig.ChargeSeconds = 1.45
CatapultConfig.CooldownSeconds = 3.5
CatapultConfig.InteractRange = 18

CatapultConfig.MinPower = 0.18
CatapultConfig.MaxPower = 1
CatapultConfig.MinHorizontalSpeed = 72
CatapultConfig.MaxHorizontalSpeed = 285
CatapultConfig.MinUpwardSpeed = 52
CatapultConfig.MaxUpwardSpeed = 170

CatapultConfig.LandingTimeoutSeconds = 12
CatapultConfig.RestingSpeed = 7
CatapultConfig.MaxValidDistance = 560
CatapultConfig.CrateLifetimeSeconds = 25
CatapultConfig.ReturnRunWalkSpeed = 28
CatapultConfig.ReturnRunTimeoutSeconds = 45
CatapultConfig.SharedCatapultBusySeconds = 9

CatapultConfig.WorldFolderName = "BrainrotMap"
CatapultConfig.PlotsFolderName = "Plots"
CatapultConfig.SharedLaunchAreaName = "SharedLaunchArea"
CatapultConfig.CatapultName = "Catapult"
CatapultConfig.InteractZoneName = "InteractZone"
CatapultConfig.ActiveCratesFolderName = "ActiveCrates"
CatapultConfig.RevealedRewardsFolderName = "RevealedRewards"
CatapultConfig.ChaosHazardsFolderName = "ChaosHazards"

return CatapultConfig
