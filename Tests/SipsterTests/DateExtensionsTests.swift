import Testing
import Foundation
@testable import SipsterLib

@Suite("Date Extensions Tests")
struct DateExtensionsTests {

    @Test("startOfDay strips time")
    func startOfDayStripsTime() {
        var components = DateComponents()
        components.year = 2024
        components.month = 6
        components.day = 15
        components.hour = 14
        components.minute = 30
        let date = Calendar.current.date(from: components)!
        let start = date.startOfDay

        let result = Calendar.current.dateComponents([.hour, .minute, .second], from: start)
        #expect(result.hour == 0)
        #expect(result.minute == 0)
        #expect(result.second == 0)
    }

    @Test("weekdayIndex")
    func weekdayIndex() {
        // Monday: 2024-06-10
        var mondayComponents = DateComponents()
        mondayComponents.year = 2024
        mondayComponents.month = 6
        mondayComponents.day = 10
        mondayComponents.hour = 12
        let monday = Calendar.current.date(from: mondayComponents)!
        #expect(monday.weekdayIndex == 1)

        // Sunday: 2024-06-16
        var sundayComponents = DateComponents()
        sundayComponents.year = 2024
        sundayComponents.month = 6
        sundayComponents.day = 16
        sundayComponents.hour = 12
        let sunday = Calendar.current.date(from: sundayComponents)!
        #expect(sunday.weekdayIndex == 7)

        // Wednesday: 2024-06-12
        var wedComponents = DateComponents()
        wedComponents.year = 2024
        wedComponents.month = 6
        wedComponents.day = 12
        wedComponents.hour = 12
        let wednesday = Calendar.current.date(from: wedComponents)!
        #expect(wednesday.weekdayIndex == 3)
    }

    @Test("daysInWeek returns 7")
    func daysInWeekReturns7() {
        let days = Date().daysInWeek()
        #expect(days.count == 7)
        #expect(days[0].weekdayIndex == 1) // Monday
    }

    @Test("startOfWeek is Monday")
    func startOfWeekIsMonday() {
        let start = Date().startOfWeek
        #expect(start.weekdayIndex == 1)
    }

    @Test("endOfWeek is 6 days after startOfWeek")
    func endOfWeek() {
        let start = Date().startOfWeek
        let end = Date().endOfWeek
        let diff = Calendar.current.dateComponents([.day], from: start, to: end).day
        #expect(diff == 6)
    }
}
