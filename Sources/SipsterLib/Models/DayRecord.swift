import Foundation

public struct DayRecord: Identifiable {
    public let date: Date
    public let drinks: [DrinkLog]

    public var id: Date { date }
    public var totalML: Int { drinks.reduce(0) { $0 + $1.amountML } }
    public var glassCount: Double { Double(totalML) / 250.0 }
    public var drinkCount: Int { drinks.count }
    public var totalCaffeineMG: Int { drinks.reduce(0) { $0 + $1.caffeineMG } }

    public init(date: Date, drinks: [DrinkLog]) {
        self.date = date
        self.drinks = drinks
    }
}
