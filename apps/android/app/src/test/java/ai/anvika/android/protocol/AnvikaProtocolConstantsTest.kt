package ai.anvika.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class AnvikaProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", AnvikaCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", AnvikaCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", AnvikaCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", AnvikaCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", AnvikaCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", AnvikaCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", AnvikaCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", AnvikaCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", AnvikaCapability.Canvas.rawValue)
    assertEquals("camera", AnvikaCapability.Camera.rawValue)
    assertEquals("screen", AnvikaCapability.Screen.rawValue)
    assertEquals("voiceWake", AnvikaCapability.VoiceWake.rawValue)
    assertEquals("location", AnvikaCapability.Location.rawValue)
    assertEquals("sms", AnvikaCapability.Sms.rawValue)
    assertEquals("device", AnvikaCapability.Device.rawValue)
    assertEquals("notifications", AnvikaCapability.Notifications.rawValue)
    assertEquals("system", AnvikaCapability.System.rawValue)
    assertEquals("appUpdate", AnvikaCapability.AppUpdate.rawValue)
    assertEquals("photos", AnvikaCapability.Photos.rawValue)
    assertEquals("contacts", AnvikaCapability.Contacts.rawValue)
    assertEquals("calendar", AnvikaCapability.Calendar.rawValue)
    assertEquals("motion", AnvikaCapability.Motion.rawValue)
  }

  @Test
  fun cameraCommandsUseStableStrings() {
    assertEquals("camera.list", AnvikaCameraCommand.List.rawValue)
    assertEquals("camera.snap", AnvikaCameraCommand.Snap.rawValue)
    assertEquals("camera.clip", AnvikaCameraCommand.Clip.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", AnvikaScreenCommand.Record.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", AnvikaNotificationsCommand.List.rawValue)
    assertEquals("notifications.actions", AnvikaNotificationsCommand.Actions.rawValue)
  }

  @Test
  fun deviceCommandsUseStableStrings() {
    assertEquals("device.status", AnvikaDeviceCommand.Status.rawValue)
    assertEquals("device.info", AnvikaDeviceCommand.Info.rawValue)
    assertEquals("device.permissions", AnvikaDeviceCommand.Permissions.rawValue)
    assertEquals("device.health", AnvikaDeviceCommand.Health.rawValue)
  }

  @Test
  fun systemCommandsUseStableStrings() {
    assertEquals("system.notify", AnvikaSystemCommand.Notify.rawValue)
  }

  @Test
  fun photosCommandsUseStableStrings() {
    assertEquals("photos.latest", AnvikaPhotosCommand.Latest.rawValue)
  }

  @Test
  fun contactsCommandsUseStableStrings() {
    assertEquals("contacts.search", AnvikaContactsCommand.Search.rawValue)
    assertEquals("contacts.add", AnvikaContactsCommand.Add.rawValue)
  }

  @Test
  fun calendarCommandsUseStableStrings() {
    assertEquals("calendar.events", AnvikaCalendarCommand.Events.rawValue)
    assertEquals("calendar.add", AnvikaCalendarCommand.Add.rawValue)
  }

  @Test
  fun motionCommandsUseStableStrings() {
    assertEquals("motion.activity", AnvikaMotionCommand.Activity.rawValue)
    assertEquals("motion.pedometer", AnvikaMotionCommand.Pedometer.rawValue)
  }
}
