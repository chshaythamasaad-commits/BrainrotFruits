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
CatapultConfig.MaxHorizontalSpeed = 142
CatapultConfig.MinUpwardSpeed = 52
CatapultConfig.MaxUpwardSpeed = 86

CatapultConfig.LandingTimeoutSeconds = 7
CatapultConfig.RestingSpeed = 7
CatapultConfig.MaxValidDistance = 130
CatapultConfig.CrateLifetimeSeconds = 18
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
