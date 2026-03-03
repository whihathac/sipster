import Foundation
import SwiftUI

public final class UserSettings: ObservableObject {
    @AppStorage("reminderIntervalMinutes") public var reminderIntervalMinutes: Int = AppConstants.Defaults.reminderIntervalMinutes
    @AppStorage("activeDays") public var activeDaysRaw: String = "1,2,3,4,5"
    @AppStorage("activeStartHour") public var activeStartHour: Int = AppConstants.Defaults.activeStartHour
    @AppStorage("activeStartMinute") public var activeStartMinute: Int = 0
    @AppStorage("activeEndHour") public var activeEndHour: Int = AppConstants.Defaults.activeEndHour
    @AppStorage("activeEndMinute") public var activeEndMinute: Int = 0
    @AppStorage("dailyGoalGlasses") public var dailyGoalGlasses: Int = AppConstants.Defaults.dailyGoalGlasses
    @AppStorage("defaultGlassSizeML") public var defaultGlassSizeML: Int = AppConstants.Defaults.defaultGlassSizeML
    @AppStorage("soundEnabled") public var soundEnabled: Bool = true
    @AppStorage("launchAtLogin") public var launchAtLogin: Bool = false
    @AppStorage("overlayDrinkSizeML") public var overlayDrinkSizeML: Int = AppConstants.Defaults.defaultGlassSizeML
    @AppStorage("dailyCaffeineLimitMG") public var dailyCaffeineLimitMG: Int = AppConstants.Defaults.dailyCaffeineLimitMG
    @AppStorage("useGlassEffect") public var useGlassEffect: Bool = true
    @AppStorage("hasCompletedOnboarding") public var hasCompletedOnboarding: Bool = false

    // Custom caffeine amounts per beverage (mg per serving)
    @AppStorage("caffeineCoffeeMG") public var caffeineCoffeeMG: Int = 95
    @AppStorage("caffeineTeaMG") public var caffeineTeaMG: Int = 47
    @AppStorage("caffeineEspressoMG") public var caffeineEspressoMG: Int = 63
    @AppStorage("caffeineEnergyDrinkMG") public var caffeineEnergyDrinkMG: Int = 80
    @AppStorage("caffeineSodaMG") public var caffeineSodaMG: Int = 34

    public init() {}

    public func caffeineMG(for beverage: BeverageType) -> Int {
        switch beverage {
        case .water: return 0
        case .coffee: return caffeineCoffeeMG
        case .tea: return caffeineTeaMG
        case .espresso: return caffeineEspressoMG
        case .energyDrink: return caffeineEnergyDrinkMG
        case .soda: return caffeineSodaMG
        }
    }

    public var activeDays: Set<Int> {
        get {
            Set(activeDaysRaw.split(separator: ",").compactMap { Int($0) })
        }
        set {
            activeDaysRaw = newValue.sorted().map(String.init).joined(separator: ",")
        }
    }

    public var dailyGoalML: Int {
        dailyGoalGlasses * defaultGlassSizeML
    }

    public var activeStartDate: Date {
        get {
            var components = DateComponents()
            components.hour = activeStartHour
            components.minute = activeStartMinute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            activeStartHour = components.hour ?? 8
            activeStartMinute = components.minute ?? 0
        }
    }

    public var activeEndDate: Date {
        get {
            var components = DateComponents()
            components.hour = activeEndHour
            components.minute = activeEndMinute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            activeEndHour = components.hour ?? 20
            activeEndMinute = components.minute ?? 0
        }
    }
}
