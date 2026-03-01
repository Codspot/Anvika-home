import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-anvika writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.anvika.mac"
let gatewayLaunchdLabel = "ai.anvika.gateway"
let onboardingVersionKey = "anvika.onboardingVersion"
let onboardingSeenKey = "anvika.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "anvika.pauseEnabled"
let iconAnimationsEnabledKey = "anvika.iconAnimationsEnabled"
let swabbleEnabledKey = "anvika.swabbleEnabled"
let swabbleTriggersKey = "anvika.swabbleTriggers"
let voiceWakeTriggerChimeKey = "anvika.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "anvika.voiceWakeSendChime"
let showDockIconKey = "anvika.showDockIcon"
let defaultVoiceWakeTriggers = ["anvika"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "anvika.voiceWakeMicID"
let voiceWakeMicNameKey = "anvika.voiceWakeMicName"
let voiceWakeLocaleKey = "anvika.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "anvika.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "anvika.voicePushToTalkEnabled"
let talkEnabledKey = "anvika.talkEnabled"
let iconOverrideKey = "anvika.iconOverride"
let connectionModeKey = "anvika.connectionMode"
let remoteTargetKey = "anvika.remoteTarget"
let remoteIdentityKey = "anvika.remoteIdentity"
let remoteProjectRootKey = "anvika.remoteProjectRoot"
let remoteCliPathKey = "anvika.remoteCliPath"
let canvasEnabledKey = "anvika.canvasEnabled"
let cameraEnabledKey = "anvika.cameraEnabled"
let systemRunPolicyKey = "anvika.systemRunPolicy"
let systemRunAllowlistKey = "anvika.systemRunAllowlist"
let systemRunEnabledKey = "anvika.systemRunEnabled"
let locationModeKey = "anvika.locationMode"
let locationPreciseKey = "anvika.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "anvika.peekabooBridgeEnabled"
let deepLinkKeyKey = "anvika.deepLinkKey"
let modelCatalogPathKey = "anvika.modelCatalogPath"
let modelCatalogReloadKey = "anvika.modelCatalogReload"
let cliInstallPromptedVersionKey = "anvika.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "anvika.heartbeatsEnabled"
let debugPaneEnabledKey = "anvika.debugPaneEnabled"
let debugFileLogEnabledKey = "anvika.debug.fileLogEnabled"
let appLogLevelKey = "anvika.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
