import Testing
import Foundation
@testable import SipsterLib

@Suite("DrinkLog Array Tests")
struct DrinkLogArrayTests {

    private func makeDrink(amountML: Int, daysAgo: Int = 0, hour: Int = 12) -> DrinkLog {
        var log = DrinkLog(amountML: amountML)
        let calendar = Calendar.current
        let day = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
        var components = calendar.dateComponents([.year, .month, .day], from: day)
        components.hour = hour
        components.minute = 0
        log.timestamp = calendar.date(from: components)!
        return log
    }

    @Test("totalML sums correctly")
    func totalML() {
        let drinks = [
            DrinkLog(amountML: 150),
            DrinkLog(amountML: 250),
            DrinkLog(amountML: 500)
        ]
        #expect(drinks.totalML() == 900)
    }

    @Test("totalML empty array returns 0")
    func totalMLEmpty() {
        let drinks: [DrinkLog] = []
        #expect(drinks.totalML() == 0)
    }

    @Test("groupedByDay groups correctly")
    func groupedByDay() {
        let drinks = [
            makeDrink(amountML: 250, daysAgo: 0, hour: 9),
            makeDrink(amountML: 250, daysAgo: 0, hour: 14),
            makeDrink(amountML: 500, daysAgo: 1, hour: 10),
        ]

        let records = drinks.groupedByDay()
        #expect(records.count == 2)

        let todayRecord = records.first { Calendar.current.isDateInToday($0.date) }
        #expect(todayRecord?.totalML == 500)
        #expect(todayRecord?.drinkCount == 2)
    }

    @Test("streakDays counts consecutive goal-met days")
    func streakDays() {
        let drinks = [
            makeDrink(amountML: 1000, daysAgo: 0, hour: 9),
            makeDrink(amountML: 1000, daysAgo: 0, hour: 14),
            makeDrink(amountML: 1000, daysAgo: 1, hour: 9),
            makeDrink(amountML: 1000, daysAgo: 1, hour: 14),
            makeDrink(amountML: 500, daysAgo: 2, hour: 12),
        ]

        let streak = drinks.streakDays(goalML: 2000)
        #expect(streak == 2)
    }

    @Test("streakDays returns 0 when goal not met")
    func streakDaysZero() {
        let drinks = [
            makeDrink(amountML: 100, daysAgo: 0),
            makeDrink(amountML: 100, daysAgo: 1),
        ]
        #expect(drinks.streakDays(goalML: 2000) == 0)
    }

    @Test("streakDays returns 0 for empty array")
    func streakDaysEmpty() {
        let drinks: [DrinkLog] = []
        #expect(drinks.streakDays(goalML: 2000) == 0)
    }

    @Test("DayRecord properties compute correctly")
    func dayRecordProperties() {
        let drinks = [
            DrinkLog(amountML: 250),
            DrinkLog(amountML: 500),
        ]
        let record = DayRecord(date: Date(), drinks: drinks)

        #expect(record.totalML == 750)
        #expect(record.drinkCount == 2)
        #expect(record.glassCount == 3.0)
    }
}
