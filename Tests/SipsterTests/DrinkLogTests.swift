import Testing
import Foundation
@testable import SipsterLib

@Suite("DrinkLog Tests")
struct DrinkLogTests {

    @Test("Create with defaults")
    func createWithDefaults() {
        let log = DrinkLog(amountML: 250)
        #expect(log.amountML == 250)
        #expect(log.source == .quickAdd)
        #expect(log.beverageType == .water)
        #expect(log.caffeineMG == 0)
    }

    @Test("Create with source")
    func createWithSource() {
        let log = DrinkLog(amountML: 500, source: .reminder)
        #expect(log.amountML == 500)
        #expect(log.source == .reminder)
        #expect(log.beverageType == .water)
    }

    @Test("Create with beverage type")
    func createWithBeverageType() {
        let log = DrinkLog(amountML: 250, source: .quickAdd, beverageType: .coffee)
        #expect(log.beverageType == .coffee)
        #expect(log.caffeineMG == 95)
    }

    @Test("JSON round trip")
    func jsonRoundTrip() throws {
        let original = DrinkLog(amountML: 150, source: .manual, beverageType: .espresso)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(DrinkLog.self, from: data)

        #expect(decoded.id == original.id)
        #expect(decoded.amountML == original.amountML)
        #expect(decoded.source == original.source)
        #expect(decoded.beverageType == original.beverageType)
        #expect(abs(decoded.timestamp.timeIntervalSince(original.timestamp)) < 1)
    }

    @Test("JSON backward compatibility - missing beverageType defaults to water")
    func jsonBackwardCompatibility() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        // Simulate old JSON without beverageType field
        let oldJSON = """
        {"id":"550E8400-E29B-41D4-A716-446655440000","timestamp":1000000,"amountML":250,"source":"quickAdd"}
        """
        let data = oldJSON.data(using: .utf8)!
        let decoded = try decoder.decode(DrinkLog.self, from: data)
        #expect(decoded.beverageType == .water)
        #expect(decoded.caffeineMG == 0)
        #expect(decoded.amountML == 250)
        #expect(decoded.source == .quickAdd)
    }

    @Test("Equatable")
    func equatable() {
        let log1 = DrinkLog(amountML: 250)
        let log2 = log1
        var log3 = log1
        log3.amountML = 500

        #expect(log1 == log2)
        #expect(log1 != log3)
    }

    @Test("DrinkSource raw values")
    func drinkSourceRawValues() {
        #expect(DrinkSource.reminder.rawValue == "reminder")
        #expect(DrinkSource.quickAdd.rawValue == "quickAdd")
        #expect(DrinkSource.manual.rawValue == "manual")
    }
}

@Suite("DrinkSize Tests")
struct DrinkSizeTests {

    @Test("Raw values")
    func rawValues() {
        #expect(DrinkSize.quickSip.rawValue == 50)
        #expect(DrinkSize.small.rawValue == 150)
        #expect(DrinkSize.medium.rawValue == 250)
        #expect(DrinkSize.large.rawValue == 500)
    }

    @Test("Display names")
    func displayNames() {
        #expect(DrinkSize.quickSip.displayName == "Quick Sip")
        #expect(DrinkSize.small.displayName == "Glass")
        #expect(DrinkSize.medium.displayName == "Cup")
        #expect(DrinkSize.large.displayName == "Bottle")
    }

    @Test("ML labels")
    func mlLabels() {
        #expect(DrinkSize.quickSip.mlLabel == "50ml")
        #expect(DrinkSize.small.mlLabel == "150ml")
        #expect(DrinkSize.medium.mlLabel == "250ml")
        #expect(DrinkSize.large.mlLabel == "500ml")
    }

    @Test("All cases count")
    func allCases() {
        #expect(DrinkSize.allCases.count == 4)
    }
}
