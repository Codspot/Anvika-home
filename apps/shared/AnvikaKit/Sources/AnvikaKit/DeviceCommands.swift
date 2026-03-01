import Foundation

public enum AnvikaDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum AnvikaBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum AnvikaThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum AnvikaNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum AnvikaNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct AnvikaBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: AnvikaBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: AnvikaBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct AnvikaThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: AnvikaThermalState

    public init(state: AnvikaThermalState) {
        self.state = state
    }
}

public struct AnvikaStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct AnvikaNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: AnvikaNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [AnvikaNetworkInterfaceType]

    public init(
        status: AnvikaNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [AnvikaNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct AnvikaDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: AnvikaBatteryStatusPayload
    public var thermal: AnvikaThermalStatusPayload
    public var storage: AnvikaStorageStatusPayload
    public var network: AnvikaNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: AnvikaBatteryStatusPayload,
        thermal: AnvikaThermalStatusPayload,
        storage: AnvikaStorageStatusPayload,
        network: AnvikaNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct AnvikaDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
