import Foundation

public enum AnvikaCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum AnvikaCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum AnvikaCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum AnvikaCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct AnvikaCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: AnvikaCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: AnvikaCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: AnvikaCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: AnvikaCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct AnvikaCameraClipParams: Codable, Sendable, Equatable {
    public var facing: AnvikaCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: AnvikaCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: AnvikaCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: AnvikaCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
