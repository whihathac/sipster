import Foundation

public enum DrinkSize: Int, CaseIterable, Identifiable {
    case small = 150
    case medium = 250
    case large = 500

    public var id: Int { rawValue }

    public var displayName: String {
        switch self {
        case .small: return "Glass"
        case .medium: return "Cup"
        case .large: return "Bottle"
        }
    }

    public var mlLabel: String {
        "\(rawValue)ml"
    }

    public var icon: String {
        switch self {
        case .small: return "cup.and.saucer.fill"
        case .medium: return "mug.fill"
        case .large: return "waterbottle.fill"
        }
    }
}
