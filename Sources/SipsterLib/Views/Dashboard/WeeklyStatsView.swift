import SwiftUI

public struct WeeklyStatsView: View {
    public let records: [DayRecord]
    public let allDrinks: [DrinkLog]
    public let goalGlasses: Int
    public let goalML: Int
    public let caffeineLimitMG: Int
    public var compact: Bool = false

    public init(records: [DayRecord], allDrinks: [DrinkLog], goalGlasses: Int, goalML: Int, caffeineLimitMG: Int = 400, compact: Bool = false) {
        self.records = records
        self.allDrinks = allDrinks
        self.goalGlasses = goalGlasses
        self.goalML = goalML
        self.caffeineLimitMG = caffeineLimitMG
        self.compact = compact
    }

    private var weekAverage: Double {
        let daysWithData = records.filter { $0.drinkCount > 0 }
        guard !daysWithData.isEmpty else { return 0 }
        let totalGlasses = daysWithData.reduce(0.0) { $0 + $1.glassCount }
        return totalGlasses / Double(daysWithData.count)
    }

    private var bestDay: DayRecord? {
        records.max(by: { $0.totalML < $1.totalML })
    }

    private var daysMetGoal: Int {
        records.filter { $0.totalML >= goalML }.count
    }

    private var streak: Int {
        allDrinks.streakDays(goalML: goalML)
    }

    private var weekAvgCaffeine: Int {
        let daysWithData = records.filter { $0.drinkCount > 0 }
        guard !daysWithData.isEmpty else { return 0 }
        let totalCaffeine = daysWithData.reduce(0) { $0 + $1.totalCaffeineMG }
        return totalCaffeine / daysWithData.count
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: compact ? 6 : 12) {
            if !compact {
                Text("Stats")
                    .font(.headline)
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: compact ? 6 : 12) {
                StatCard(
                    title: "Avg / Day",
                    value: String(format: "%.1f", weekAverage),
                    subtitle: "glasses",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue,
                    compact: compact
                )

                StatCard(
                    title: "Best Day",
                    value: bestDay.map { String(format: "%.0f", $0.glassCount) } ?? "0",
                    subtitle: bestDay?.date.shortWeekday ?? "-",
                    icon: "trophy",
                    color: .yellow,
                    compact: compact
                )

                StatCard(
                    title: "Goal Met",
                    value: "\(daysMetGoal)/7",
                    subtitle: "days",
                    icon: "checkmark.circle",
                    color: .green,
                    compact: compact
                )

                StatCard(
                    title: "Streak",
                    value: "\(streak)",
                    subtitle: streak == 1 ? "day" : "days",
                    icon: "flame",
                    color: .orange,
                    compact: compact
                )

                StatCard(
                    title: "Avg Caffeine",
                    value: "\(weekAvgCaffeine)",
                    subtitle: "mg/day",
                    icon: "cup.and.saucer.fill",
                    color: .brown,
                    compact: compact
                )
            }
        }
    }
}

public struct StatCard: View {
    public let title: String
    public let value: String
    public let subtitle: String
    public let icon: String
    public let color: Color
    public var compact: Bool = false

    public init(title: String, value: String, subtitle: String, icon: String, color: Color, compact: Bool = false) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.compact = compact
    }

    public var body: some View {
        VStack(spacing: compact ? 3 : 6) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(compact ? .caption2 : .caption)
                Text(title)
                    .font(compact ? .caption2 : .caption)
                    .foregroundStyle(.secondary)
            }

            Text(value)
                .font(compact ? .body : .title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)

            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(compact ? 6 : 12)
        .background(.quaternary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: compact ? 6 : 10))
    }
}
