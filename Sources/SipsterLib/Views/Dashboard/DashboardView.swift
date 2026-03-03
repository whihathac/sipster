import SwiftUI

public struct DashboardView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var reminderManager: ReminderManager
    @EnvironmentObject var dataStore: DataStore

    @State private var selectedWeekOffset: Int = 0

    public init() {}

    private var currentWeekStart: Date {
        let today = Date()
        let start = today.startOfWeek
        return Calendar.current.date(byAdding: .weekOfYear, value: selectedWeekOffset, to: start) ?? start
    }

    private var weekDates: [Date] {
        currentWeekStart.daysInWeek()
    }

    private var weekLabel: String {
        let end = currentWeekStart.endOfWeek
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: currentWeekStart)) - \(formatter.string(from: end))"
    }

    private var todaysDrinks: [DrinkLog] {
        dataStore.todaysDrinks()
    }

    private var weekDrinks: [DrinkLog] {
        let start = Calendar.current.startOfDay(for: currentWeekStart)
        let end = Calendar.current.date(byAdding: .day, value: 7, to: start) ?? start
        return dataStore.drinksInRange(from: start, to: end)
    }

    private var weekRecords: [DayRecord] {
        weekDrinks.groupedByDay()
    }

    private var todayTotal: Int {
        todaysDrinks.reduce(0) { $0 + $1.amountML }
    }

    private var todayGlasses: Int {
        todaysDrinks.count
    }

    private var progress: Double {
        guard settings.dailyGoalML > 0 else { return 0 }
        return Double(todayTotal) / Double(settings.dailyGoalML)
    }

    private var todayCaffeine: Int {
        todaysDrinks.totalCaffeineMG()
    }

    public var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sipster Dashboard")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Stay hydrated, stay healthy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()

                Menu {
                    Section("Water") {
                        ForEach(DrinkSize.allCases) { size in
                            Button("\(size.displayName) (\(size.mlLabel))") {
                                reminderManager.logDrink(amountML: size.rawValue, source: .manual)
                            }
                        }
                    }
                    Section("Caffeine") {
                        ForEach(BeverageType.allCases.filter { $0.isCaffeinated }) { bev in
                            Button("\(bev.displayName) (\(settings.caffeineMG(for: bev))mg)") {
                                reminderManager.logDrink(
                                    amountML: settings.defaultGlassSizeML,
                                    source: .manual,
                                    beverageType: bev
                                )
                            }
                        }
                    }
                } label: {
                    Label("Log Drink", systemImage: "plus.circle.fill")
                }
                .menuStyle(.borderlessButton)
                .fixedSize()
            }
            .padding(.horizontal)

            // Top row: Ring | Stats | Drinks
            HStack(alignment: .top, spacing: 16) {
                // Column 1: Progress ring + caffeine
                VStack(spacing: 8) {
                    ProgressRingView(
                        progress: progress,
                        current: todayGlasses,
                        goal: settings.dailyGoalGlasses,
                        size: 150
                    )

                    Text("\(todayTotal)ml / \(settings.dailyGoalML)ml")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if todayCaffeine > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.caption2)
                                .foregroundStyle(.brown)
                            Text("\(todayCaffeine)mg caffeine")
                                .font(.caption)
                                .foregroundStyle(todayCaffeine > settings.dailyCaffeineLimitMG ? .red : .secondary)
                        }
                    }
                }
                .frame(width: 170)

                // Column 2: Stats
                WeeklyStatsView(
                    records: weekRecords,
                    allDrinks: dataStore.drinks,
                    goalGlasses: settings.dailyGoalGlasses,
                    goalML: settings.dailyGoalML,
                    caffeineLimitMG: settings.dailyCaffeineLimitMG,
                    compact: true
                )
                .frame(width: 180)

                // Column 3: Today's drinks
                DrinkListView(drinks: todaysDrinks)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)

            Divider()
                .padding(.horizontal)

            // Week navigation
            HStack {
                Button {
                    selectedWeekOffset -= 1
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.borderless)

                Spacer()
                Text(weekLabel)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()

                Button {
                    if selectedWeekOffset < 0 {
                        selectedWeekOffset += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderless)
                .disabled(selectedWeekOffset >= 0)

                if selectedWeekOffset != 0 {
                    Button("Today") {
                        selectedWeekOffset = 0
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            .padding(.horizontal)

            // Weekly chart
            WeeklyChartView(
                records: weekRecords,
                goal: settings.dailyGoalGlasses,
                weekDates: weekDates,
                caffeineLimitMG: settings.dailyCaffeineLimitMG
            )
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .frame(minWidth: 680, minHeight: 480)
    }
}
