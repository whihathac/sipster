import Foundation

public enum DrinkSize: Int, CaseIterable, Identifiable {
    case quickSip = 50
    case small = 150
    case medium = 250
    case large = 500

    public var id: Int { rawValue }

    public var displayName: String {
        switch self {
        case .quickSip: return "Quick Sip"
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
        case .quickSip: return "drop.fill"
        case .small: return "wineglass.fill"
        case .medium: return "cup.and.saucer.fill"
        case .large: return "waterbottle.fill"
        }
    }
}
