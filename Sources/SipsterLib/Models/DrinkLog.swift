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
    public var beverageType: BeverageType
    /// Caffeine in mg stored at log time (reflects user-configured amounts)
    public var caffeineMG: Int

    public init(amountML: Int, source: DrinkSource = .quickAdd, beverageType: BeverageType = .water, caffeineMG: Int? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.amountML = amountML
        self.source = source
        self.beverageType = beverageType
        self.caffeineMG = caffeineMG ?? beverageType.caffeineMG
    }

    // Custom Codable for backward compatibility with existing JSON (missing beverageType / caffeineMG)
    enum CodingKeys: String, CodingKey {
        case id, timestamp, amountML, source, beverageType, caffeineMG
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        amountML = try container.decode(Int.self, forKey: .amountML)
        source = try container.decode(DrinkSource.self, forKey: .source)
        beverageType = try container.decodeIfPresent(BeverageType.self, forKey: .beverageType) ?? .water
        caffeineMG = try container.decodeIfPresent(Int.self, forKey: .caffeineMG) ?? beverageType.caffeineMG
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(amountML, forKey: .amountML)
        try container.encode(source, forKey: .source)
        try container.encode(beverageType, forKey: .beverageType)
        try container.encode(caffeineMG, forKey: .caffeineMG)
    }
}
