import SwiftUI

public struct MenuBarView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var reminderManager: ReminderManager
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings

    public init() {}

    private var todaysDrinks: [DrinkLog] {
        dataStore.todaysDrinks()
    }

    private var todayTotal: Int {
        todaysDrinks.reduce(0) { $0 + $1.amountML }
    }

    private var todayGlasses: Int {
        todaysDrinks.count
    }

    private var progress: Double {
        guard settings.dailyGoalML > 0 else { return 0 }
        return min(Double(todayTotal) / Double(settings.dailyGoalML), 1.0)
    }

    private var todayCaffeine: Int {
        todaysDrinks.totalCaffeineMG()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.cyan)
                Text("Sipster")
                    .font(.headline)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("Today: \(todayGlasses) / \(settings.dailyGoalGlasses) glasses")
                    .font(.subheadline)

                ProgressView(value: progress)
                    .tint(progress >= 1.0 ? .green : .blue)

                Text("\(todayTotal)ml of \(settings.dailyGoalML)ml")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.caption2)
                        .foregroundStyle(.brown)
                    Text("Caffeine: \(todayCaffeine)mg / \(settings.dailyCaffeineLimitMG)mg")
                        .font(.caption)
                        .foregroundStyle(todayCaffeine > settings.dailyCaffeineLimitMG ? .red : .secondary)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Label("Quick Add Water", systemImage: "drop.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    ForEach(DrinkSize.allCases) { size in
                        Button {
                            reminderManager.logDrink(amountML: size.rawValue, source: .quickAdd)
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: size.icon)
                                    .font(.title3)
                                Text(size.displayName)
                                    .font(.caption2)
                                Text(size.mlLabel)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("Log Caffeine")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    ForEach(BeverageType.allCases.filter { $0.isCaffeinated }) { bev in
                        Button {
                            reminderManager.logDrink(
                                amountML: settings.defaultGlassSizeML,
                                source: .quickAdd,
                                beverageType: bev
                            )
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: bev.icon)
                                    .font(.caption)
                                Text(bev.displayName)
                                    .font(.system(size: 9))
                                Text("\(settings.caffeineMG(for: bev))mg")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }

            Divider()

            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(.secondary)
                Text("Next: \(reminderManager.timeUntilNextReminder)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            HStack {
                Button {
                    openWindow(id: "dashboard")
                    NSApplication.shared.activate(ignoringOtherApps: true)
                } label: {
                    Label("Dashboard", systemImage: "chart.bar")
                }
                .buttonStyle(.borderless)

                Spacer()

                Button {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                    openSettings()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
                .buttonStyle(.borderless)
            }

            Divider()

            Button("Quit Sipster") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(width: 280)
    }
}
