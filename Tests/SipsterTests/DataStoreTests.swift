import Testing
import Foundation
@testable import SipsterLib

@Suite("DataStore Tests")
@MainActor
struct DataStoreTests {

    private func makeTempStore() -> DataStore {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("test_drinks_\(UUID().uuidString).json")
        return DataStore(fileURL: fileURL)
    }

    @Test("Starts empty")
    func startsEmpty() {
        let store = makeTempStore()
        #expect(store.drinks.isEmpty)
    }

    @Test("Add drink")
    func addDrink() {
        let store = makeTempStore()
        store.addDrink(DrinkLog(amountML: 250))
        #expect(store.drinks.count == 1)
        #expect(store.drinks[0].amountML == 250)
    }

    @Test("Persists to disk")
    func persistsToDisk() {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("test_persist_\(UUID().uuidString).json")

        let store1 = DataStore(fileURL: fileURL)
        store1.addDrink(DrinkLog(amountML: 500))
        #expect(store1.drinks.count == 1)

        let store2 = DataStore(fileURL: fileURL)
        #expect(store2.drinks.count == 1)
        #expect(store2.drinks[0].amountML == 500)

        try? FileManager.default.removeItem(at: fileURL)
    }

    @Test("Today's drinks filters correctly")
    func todaysDrinks() {
        let store = makeTempStore()
        store.addDrink(DrinkLog(amountML: 250))

        var oldDrink = DrinkLog(amountML: 500)
        oldDrink.timestamp = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        store.addDrink(oldDrink)

        let today = store.todaysDrinks()
        #expect(today.count == 1)
        #expect(today[0].amountML == 250)
    }

    @Test("Drinks in range filters correctly")
    func drinksInRange() {
        let store = makeTempStore()
        let calendar = Calendar.current

        var d1 = DrinkLog(amountML: 100)
        d1.timestamp = calendar.date(byAdding: .day, value: -3, to: Date())!
        store.addDrink(d1)

        var d2 = DrinkLog(amountML: 200)
        d2.timestamp = calendar.date(byAdding: .day, value: -1, to: Date())!
        store.addDrink(d2)

        store.addDrink(DrinkLog(amountML: 300))

        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: calendar.startOfDay(for: Date()))!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date()))!

        let ranged = store.drinksInRange(from: twoDaysAgo, to: tomorrow)
        #expect(ranged.count == 2)
    }
}
