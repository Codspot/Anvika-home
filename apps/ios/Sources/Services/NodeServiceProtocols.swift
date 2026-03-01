import CoreLocation
import Foundation
import AnvikaKit
import UIKit

typealias AnvikaCameraSnapResult = (format: String, base64: String, width: Int, height: Int)
typealias AnvikaCameraClipResult = (format: String, base64: String, durationMs: Int, hasAudio: Bool)

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: AnvikaCameraSnapParams) async throws -> AnvikaCameraSnapResult
    func clip(params: AnvikaCameraClipParams) async throws -> AnvikaCameraClipResult
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: AnvikaLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: AnvikaLocationGetParams,
        desiredAccuracy: AnvikaLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: AnvikaLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> AnvikaDeviceStatusPayload
    func info() -> AnvikaDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: AnvikaPhotosLatestParams) async throws -> AnvikaPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: AnvikaContactsSearchParams) async throws -> AnvikaContactsSearchPayload
    func add(params: AnvikaContactsAddParams) async throws -> AnvikaContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: AnvikaCalendarEventsParams) async throws -> AnvikaCalendarEventsPayload
    func add(params: AnvikaCalendarAddParams) async throws -> AnvikaCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: AnvikaRemindersListParams) async throws -> AnvikaRemindersListPayload
    func add(params: AnvikaRemindersAddParams) async throws -> AnvikaRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: AnvikaMotionActivityParams) async throws -> AnvikaMotionActivityPayload
    func pedometer(params: AnvikaPedometerParams) async throws -> AnvikaPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: AnvikaWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
