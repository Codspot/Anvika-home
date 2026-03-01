import Foundation

public enum AnvikaRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum AnvikaReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct AnvikaRemindersListParams: Codable, Sendable, Equatable {
    public var status: AnvikaReminderStatusFilter?
    public var limit: Int?

    public init(status: AnvikaReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct AnvikaRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct AnvikaReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct AnvikaRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [AnvikaReminderPayload]

    public init(reminders: [AnvikaReminderPayload]) {
        self.reminders = reminders
    }
}

public struct AnvikaRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: AnvikaReminderPayload

    public init(reminder: AnvikaReminderPayload) {
        self.reminder = reminder
    }
}
