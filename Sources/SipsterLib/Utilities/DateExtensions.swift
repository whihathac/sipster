import Foundation

extension Date {
    public var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    public var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }

    public var endOfWeek: Date {
        Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek) ?? self
    }

    // Returns 1=Mon, 7=Sun
    public var weekdayIndex: Int {
        let wd = Calendar.current.component(.weekday, from: self)
        return wd == 1 ? 7 : wd - 1
    }

    public func daysInWeek() -> [Date] {
        let start = startOfWeek
        return (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: start)
        }
    }

    public var shortWeekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }

    public var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }

    public var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

extension Array where Element == DrinkLog {
    public func groupedByDay() -> [DayRecord] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: self) { log in
            calendar.startOfDay(for: log.timestamp)
        }
        return grouped.map { DayRecord(date: $0.key, drinks: $0.value) }
            .sorted { $0.date < $1.date }
    }

    public func totalML() -> Int {
        reduce(0) { $0 + $1.amountML }
    }

    public func totalCaffeineMG() -> Int {
        reduce(0) { $0 + $1.caffeineMG }
    }

    public func streakDays(goalML: Int) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let byDay = Dictionary(grouping: self) { log in
            calendar.startOfDay(for: log.timestamp)
        }

        var streak = 0
        var checkDate = today

        while true {
            let dayLogs = byDay[checkDate] ?? []
            let total = dayLogs.reduce(0) { $0 + $1.amountML }
            if total >= goalML {
                streak += 1
                guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = prev
            } else {
                // If we're checking today and it's not met yet, try starting from yesterday
                if checkDate == today && streak == 0 {
                    guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                    checkDate = prev
                    continue
                }
                break
            }
        }

        return streak
    }
}
