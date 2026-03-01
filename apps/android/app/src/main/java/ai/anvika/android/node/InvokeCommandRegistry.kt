package ai.anvika.android.node

import ai.anvika.android.protocol.AnvikaCalendarCommand
import ai.anvika.android.protocol.AnvikaCanvasA2UICommand
import ai.anvika.android.protocol.AnvikaCanvasCommand
import ai.anvika.android.protocol.AnvikaCameraCommand
import ai.anvika.android.protocol.AnvikaCapability
import ai.anvika.android.protocol.AnvikaContactsCommand
import ai.anvika.android.protocol.AnvikaDeviceCommand
import ai.anvika.android.protocol.AnvikaLocationCommand
import ai.anvika.android.protocol.AnvikaMotionCommand
import ai.anvika.android.protocol.AnvikaNotificationsCommand
import ai.anvika.android.protocol.AnvikaPhotosCommand
import ai.anvika.android.protocol.AnvikaScreenCommand
import ai.anvika.android.protocol.AnvikaSmsCommand
import ai.anvika.android.protocol.AnvikaSystemCommand

data class NodeRuntimeFlags(
  val cameraEnabled: Boolean,
  val locationEnabled: Boolean,
  val smsAvailable: Boolean,
  val voiceWakeEnabled: Boolean,
  val motionActivityAvailable: Boolean,
  val motionPedometerAvailable: Boolean,
  val debugBuild: Boolean,
)

enum class InvokeCommandAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  MotionActivityAvailable,
  MotionPedometerAvailable,
  DebugBuild,
}

enum class NodeCapabilityAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  VoiceWakeEnabled,
  MotionAvailable,
}

data class NodeCapabilitySpec(
  val name: String,
  val availability: NodeCapabilityAvailability = NodeCapabilityAvailability.Always,
)

data class InvokeCommandSpec(
  val name: String,
  val requiresForeground: Boolean = false,
  val availability: InvokeCommandAvailability = InvokeCommandAvailability.Always,
)

object InvokeCommandRegistry {
  val capabilityManifest: List<NodeCapabilitySpec> =
    listOf(
      NodeCapabilitySpec(name = AnvikaCapability.Canvas.rawValue),
      NodeCapabilitySpec(name = AnvikaCapability.Screen.rawValue),
      NodeCapabilitySpec(name = AnvikaCapability.Device.rawValue),
      NodeCapabilitySpec(name = AnvikaCapability.Notifications.rawValue),
      NodeCapabilitySpec(name = AnvikaCapability.System.rawValue),
      NodeCapabilitySpec(name = AnvikaCapability.AppUpdate.rawValue),
      NodeCapabilitySpec(
        name = AnvikaCapability.Camera.rawValue,
        availability = NodeCapabilityAvailability.CameraEnabled,
      ),
      NodeCapabilitySpec(
        name = AnvikaCapability.Sms.rawValue,
        availability = NodeCapabilityAvailability.SmsAvailable,
      ),
      NodeCapabilitySpec(
        name = AnvikaCapability.VoiceWake.rawValue,
        availability = NodeCapabilityAvailability.VoiceWakeEnabled,
      ),
      NodeCapabilitySpec(
        name = AnvikaCapability.Location.rawValue,
        availability = NodeCapabilityAvailability.LocationEnabled,
      ),
      NodeCapabilitySpec(name = AnvikaCapability.Photos.rawValue),
      NodeCapabilitySpec(name = AnvikaCapability.Contacts.rawValue),
      NodeCapabilitySpec(name = AnvikaCapability.Calendar.rawValue),
      NodeCapabilitySpec(
        name = AnvikaCapability.Motion.rawValue,
        availability = NodeCapabilityAvailability.MotionAvailable,
      ),
    )

  val all: List<InvokeCommandSpec> =
    listOf(
      InvokeCommandSpec(
        name = AnvikaCanvasCommand.Present.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaCanvasCommand.Hide.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaCanvasCommand.Navigate.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaCanvasCommand.Eval.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaCanvasCommand.Snapshot.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaCanvasA2UICommand.Push.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaCanvasA2UICommand.PushJSONL.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaCanvasA2UICommand.Reset.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaScreenCommand.Record.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = AnvikaSystemCommand.Notify.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaCameraCommand.List.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = AnvikaCameraCommand.Snap.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = AnvikaCameraCommand.Clip.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = AnvikaLocationCommand.Get.rawValue,
        availability = InvokeCommandAvailability.LocationEnabled,
      ),
      InvokeCommandSpec(
        name = AnvikaDeviceCommand.Status.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaDeviceCommand.Info.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaDeviceCommand.Permissions.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaDeviceCommand.Health.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaNotificationsCommand.List.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaNotificationsCommand.Actions.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaPhotosCommand.Latest.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaContactsCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaContactsCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaCalendarCommand.Events.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaCalendarCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = AnvikaMotionCommand.Activity.rawValue,
        availability = InvokeCommandAvailability.MotionActivityAvailable,
      ),
      InvokeCommandSpec(
        name = AnvikaMotionCommand.Pedometer.rawValue,
        availability = InvokeCommandAvailability.MotionPedometerAvailable,
      ),
      InvokeCommandSpec(
        name = AnvikaSmsCommand.Send.rawValue,
        availability = InvokeCommandAvailability.SmsAvailable,
      ),
      InvokeCommandSpec(
        name = "debug.logs",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(
        name = "debug.ed25519",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(name = "app.update"),
    )

  private val byNameInternal: Map<String, InvokeCommandSpec> = all.associateBy { it.name }

  fun find(command: String): InvokeCommandSpec? = byNameInternal[command]

  fun advertisedCapabilities(flags: NodeRuntimeFlags): List<String> {
    return capabilityManifest
      .filter { spec ->
        when (spec.availability) {
          NodeCapabilityAvailability.Always -> true
          NodeCapabilityAvailability.CameraEnabled -> flags.cameraEnabled
          NodeCapabilityAvailability.LocationEnabled -> flags.locationEnabled
          NodeCapabilityAvailability.SmsAvailable -> flags.smsAvailable
          NodeCapabilityAvailability.VoiceWakeEnabled -> flags.voiceWakeEnabled
          NodeCapabilityAvailability.MotionAvailable -> flags.motionActivityAvailable || flags.motionPedometerAvailable
        }
      }
      .map { it.name }
  }

  fun advertisedCommands(flags: NodeRuntimeFlags): List<String> {
    return all
      .filter { spec ->
        when (spec.availability) {
          InvokeCommandAvailability.Always -> true
          InvokeCommandAvailability.CameraEnabled -> flags.cameraEnabled
          InvokeCommandAvailability.LocationEnabled -> flags.locationEnabled
          InvokeCommandAvailability.SmsAvailable -> flags.smsAvailable
          InvokeCommandAvailability.MotionActivityAvailable -> flags.motionActivityAvailable
          InvokeCommandAvailability.MotionPedometerAvailable -> flags.motionPedometerAvailable
          InvokeCommandAvailability.DebugBuild -> flags.debugBuild
        }
      }
      .map { it.name }
  }
}
