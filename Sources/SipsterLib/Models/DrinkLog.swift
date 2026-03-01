import Foundation

public enum DrinkSource: String, Codable {
    case reminder
    case quickAdd
    case manual
}

public struct DrinkLog: Codable, Identifiable, Equatable {
    public var id: UUID
    public var timestamp: Date
    public var amountML: Int
    public var source: DrinkSource

    public init(amountML: Int, source: DrinkSource = .quickAdd) {
        self.id = UUID()
        self.timestamp = Date()
        self.amountML = amountML
        self.source = source
    }
}
