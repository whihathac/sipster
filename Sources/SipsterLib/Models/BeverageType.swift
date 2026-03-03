import Foundation

public enum BeverageType: String, Codable, CaseIterable, Identifiable {
    case water
    case coffee
    case tea
    case espresso
    case energyDrink
    case soda

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .water: return "Water"
        case .coffee: return "Coffee"
        case .tea: return "Tea"
        case .espresso: return "Espresso"
        case .energyDrink: return "Energy Drink"
        case .soda: return "Soda"
        }
    }

    /// Caffeine content in mg per standard serving
    public var caffeineMG: Int {
        switch self {
        case .water: return 0
        case .coffee: return 95
        case .tea: return 47
        case .espresso: return 63
        case .energyDrink: return 80
        case .soda: return 34
        }
    }

    public var icon: String {
        switch self {
        case .water: return "drop.fill"
        case .coffee: return "cup.and.saucer.fill"
        case .tea: return "leaf.fill"
        case .espresso: return "cup.and.saucer.fill"
        case .energyDrink: return "bolt.fill"
        case .soda: return "bubbles.and.sparkles.fill"
        }
    }

    public var isCaffeinated: Bool {
        caffeineMG > 0
    }
}
