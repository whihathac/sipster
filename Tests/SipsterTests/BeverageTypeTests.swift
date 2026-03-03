import Testing
import Foundation
@testable import SipsterLib

@Suite("BeverageType Tests")
struct BeverageTypeTests {

    @Test("All cases exist")
    func allCases() {
        #expect(BeverageType.allCases.count == 6)
    }

    @Test("Caffeine values")
    func caffeineValues() {
        #expect(BeverageType.water.caffeineMG == 0)
        #expect(BeverageType.coffee.caffeineMG == 95)
        #expect(BeverageType.tea.caffeineMG == 47)
        #expect(BeverageType.espresso.caffeineMG == 63)
        #expect(BeverageType.energyDrink.caffeineMG == 80)
        #expect(BeverageType.soda.caffeineMG == 34)
    }

    @Test("isCaffeinated")
    func isCaffeinated() {
        #expect(!BeverageType.water.isCaffeinated)
        #expect(BeverageType.coffee.isCaffeinated)
        #expect(BeverageType.tea.isCaffeinated)
        #expect(BeverageType.espresso.isCaffeinated)
        #expect(BeverageType.energyDrink.isCaffeinated)
        #expect(BeverageType.soda.isCaffeinated)
    }

    @Test("Display names")
    func displayNames() {
        #expect(BeverageType.water.displayName == "Water")
        #expect(BeverageType.coffee.displayName == "Coffee")
        #expect(BeverageType.tea.displayName == "Tea")
        #expect(BeverageType.espresso.displayName == "Espresso")
        #expect(BeverageType.energyDrink.displayName == "Energy Drink")
        #expect(BeverageType.soda.displayName == "Soda")
    }

    @Test("Icons are non-empty")
    func icons() {
        for type in BeverageType.allCases {
            #expect(!type.icon.isEmpty)
        }
    }

    @Test("JSON round trip")
    func jsonRoundTrip() throws {
        for type in BeverageType.allCases {
            let data = try JSONEncoder().encode(type)
            let decoded = try JSONDecoder().decode(BeverageType.self, from: data)
            #expect(decoded == type)
        }
    }

    @Test("Raw values")
    func rawValues() {
        #expect(BeverageType.water.rawValue == "water")
        #expect(BeverageType.coffee.rawValue == "coffee")
        #expect(BeverageType.energyDrink.rawValue == "energyDrink")
    }
}
