package ai.anvika.android.node

import ai.anvika.android.protocol.AnvikaCalendarCommand
import ai.anvika.android.protocol.AnvikaCameraCommand
import ai.anvika.android.protocol.AnvikaCapability
import ai.anvika.android.protocol.AnvikaContactsCommand
import ai.anvika.android.protocol.AnvikaDeviceCommand
import ai.anvika.android.protocol.AnvikaLocationCommand
import ai.anvika.android.protocol.AnvikaMotionCommand
import ai.anvika.android.protocol.AnvikaNotificationsCommand
import ai.anvika.android.protocol.AnvikaPhotosCommand
import ai.anvika.android.protocol.AnvikaSmsCommand
import ai.anvika.android.protocol.AnvikaSystemCommand
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InvokeCommandRegistryTest {
  @Test
  fun advertisedCapabilities_respectsFeatureAvailability() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = false,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(capabilities.contains(AnvikaCapability.Canvas.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Screen.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Device.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Notifications.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.System.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.AppUpdate.rawValue))
    assertFalse(capabilities.contains(AnvikaCapability.Camera.rawValue))
    assertFalse(capabilities.contains(AnvikaCapability.Location.rawValue))
    assertFalse(capabilities.contains(AnvikaCapability.Sms.rawValue))
    assertFalse(capabilities.contains(AnvikaCapability.VoiceWake.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Photos.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Contacts.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Calendar.rawValue))
    assertFalse(capabilities.contains(AnvikaCapability.Motion.rawValue))
  }

  @Test
  fun advertisedCapabilities_includesFeatureCapabilitiesWhenEnabled() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        NodeRuntimeFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          voiceWakeEnabled = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = false,
        ),
      )

    assertTrue(capabilities.contains(AnvikaCapability.Canvas.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Screen.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Device.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Notifications.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.System.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.AppUpdate.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Camera.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Location.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Sms.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.VoiceWake.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Photos.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Contacts.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Calendar.rawValue))
    assertTrue(capabilities.contains(AnvikaCapability.Motion.rawValue))
  }

  @Test
  fun advertisedCommands_respectsFeatureAvailability() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = false,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertFalse(commands.contains(AnvikaCameraCommand.Snap.rawValue))
    assertFalse(commands.contains(AnvikaCameraCommand.Clip.rawValue))
    assertFalse(commands.contains(AnvikaCameraCommand.List.rawValue))
    assertFalse(commands.contains(AnvikaLocationCommand.Get.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Status.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Info.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Permissions.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Health.rawValue))
    assertTrue(commands.contains(AnvikaNotificationsCommand.List.rawValue))
    assertTrue(commands.contains(AnvikaNotificationsCommand.Actions.rawValue))
    assertTrue(commands.contains(AnvikaSystemCommand.Notify.rawValue))
    assertTrue(commands.contains(AnvikaPhotosCommand.Latest.rawValue))
    assertTrue(commands.contains(AnvikaContactsCommand.Search.rawValue))
    assertTrue(commands.contains(AnvikaContactsCommand.Add.rawValue))
    assertTrue(commands.contains(AnvikaCalendarCommand.Events.rawValue))
    assertTrue(commands.contains(AnvikaCalendarCommand.Add.rawValue))
    assertFalse(commands.contains(AnvikaMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(AnvikaMotionCommand.Pedometer.rawValue))
    assertFalse(commands.contains(AnvikaSmsCommand.Send.rawValue))
    assertFalse(commands.contains("debug.logs"))
    assertFalse(commands.contains("debug.ed25519"))
    assertTrue(commands.contains("app.update"))
  }

  @Test
  fun advertisedCommands_includesFeatureCommandsWhenEnabled() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = true,
        ),
      )

    assertTrue(commands.contains(AnvikaCameraCommand.Snap.rawValue))
    assertTrue(commands.contains(AnvikaCameraCommand.Clip.rawValue))
    assertTrue(commands.contains(AnvikaCameraCommand.List.rawValue))
    assertTrue(commands.contains(AnvikaLocationCommand.Get.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Status.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Info.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Permissions.rawValue))
    assertTrue(commands.contains(AnvikaDeviceCommand.Health.rawValue))
    assertTrue(commands.contains(AnvikaNotificationsCommand.List.rawValue))
    assertTrue(commands.contains(AnvikaNotificationsCommand.Actions.rawValue))
    assertTrue(commands.contains(AnvikaSystemCommand.Notify.rawValue))
    assertTrue(commands.contains(AnvikaPhotosCommand.Latest.rawValue))
    assertTrue(commands.contains(AnvikaContactsCommand.Search.rawValue))
    assertTrue(commands.contains(AnvikaContactsCommand.Add.rawValue))
    assertTrue(commands.contains(AnvikaCalendarCommand.Events.rawValue))
    assertTrue(commands.contains(AnvikaCalendarCommand.Add.rawValue))
    assertTrue(commands.contains(AnvikaMotionCommand.Activity.rawValue))
    assertTrue(commands.contains(AnvikaMotionCommand.Pedometer.rawValue))
    assertTrue(commands.contains(AnvikaSmsCommand.Send.rawValue))
    assertTrue(commands.contains("debug.logs"))
    assertTrue(commands.contains("debug.ed25519"))
    assertTrue(commands.contains("app.update"))
  }

  @Test
  fun advertisedCommands_onlyIncludesSupportedMotionCommands() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(commands.contains(AnvikaMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(AnvikaMotionCommand.Pedometer.rawValue))
  }
}
