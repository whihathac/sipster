import SwiftUI

public struct PreferencesView: View {
    @EnvironmentObject var settings: UserSettings

    public init() {}

    public var body: some View {
        TabView {
            GeneralTab()
                .environmentObject(settings)
                .tabItem { Label("General", systemImage: "gear") }

            ScheduleTab()
                .environmentObject(settings)
                .tabItem { Label("Schedule", systemImage: "clock") }

            HelpTab()
                .tabItem { Label("Help", systemImage: "questionmark.circle") }

            AboutTab()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .frame(width: 450, height: 500)
    }
}

// MARK: - General Tab

public struct GeneralTab: View {
    @EnvironmentObject var settings: UserSettings
    @State private var launchAtLogin = LaunchAtLoginManager.isEnabled

    public init() {}

    public var body: some View {
        Form {
            Section("Daily Goal") {
                Stepper(
                    "Glasses per day: \(settings.dailyGoalGlasses)",
                    value: $settings.dailyGoalGlasses,
                    in: 1...20
                )

                Picker("Glass size", selection: $settings.defaultGlassSizeML) {
                    ForEach(DrinkSize.allCases) { size in
                        Text("\(size.mlLabel) (\(size.displayName))").tag(size.rawValue)
                    }
                }

                Text("Daily target: \(settings.dailyGoalML)ml")
                    .foregroundStyle(.secondary)
                    .font(.caption)

                Picker("Overlay drink size", selection: $settings.overlayDrinkSizeML) {
                    ForEach(DrinkSize.allCases) { size in
                        Text("\(size.mlLabel) (\(size.displayName))").tag(size.rawValue)
                    }
                }
            }

            Section("Caffeine") {
                Stepper(
                    "Daily limit: \(settings.dailyCaffeineLimitMG)mg",
                    value: $settings.dailyCaffeineLimitMG,
                    in: 100...800,
                    step: 50
                )

                Stepper("Coffee: \(settings.caffeineCoffeeMG)mg", value: $settings.caffeineCoffeeMG, in: 0...300, step: 5)
                Stepper("Tea: \(settings.caffeineTeaMG)mg", value: $settings.caffeineTeaMG, in: 0...200, step: 5)
                Stepper("Espresso: \(settings.caffeineEspressoMG)mg", value: $settings.caffeineEspressoMG, in: 0...200, step: 5)
                Stepper("Energy Drink: \(settings.caffeineEnergyDrinkMG)mg", value: $settings.caffeineEnergyDrinkMG, in: 0...300, step: 5)
                Stepper("Soda: \(settings.caffeineSodaMG)mg", value: $settings.caffeineSodaMG, in: 0...150, step: 5)
            }

            Section("App") {
                Toggle("Play reminder sound", isOn: $settings.soundEnabled)

                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        LaunchAtLoginManager.setEnabled(newValue)
                    }

                Toggle("Use glass effect overlay", isOn: $settings.useGlassEffect)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - Schedule Tab

public struct ScheduleTab: View {
    @EnvironmentObject var settings: UserSettings

    public init() {}

    private let weekdays: [(String, Int)] = [
        ("Mon", 1), ("Tue", 2), ("Wed", 3), ("Thu", 4),
        ("Fri", 5), ("Sat", 6), ("Sun", 7)
    ]

    public var body: some View {
        Form {
            Section("Reminder Interval") {
                Picker("Remind every", selection: $settings.reminderIntervalMinutes) {
                    ForEach(ReminderInterval.allCases) { interval in
                        Text(interval.displayName).tag(interval.rawValue)
                    }
                }
            }

            Section("Active Days") {
                HStack(spacing: 8) {
                    ForEach(weekdays, id: \.1) { name, day in
                        Toggle(name, isOn: Binding(
                            get: { settings.activeDays.contains(day) },
                            set: { isOn in
                                var days = settings.activeDays
                                if isOn {
                                    days.insert(day)
                                } else {
                                    days.remove(day)
                                }
                                settings.activeDays = days
                            }
                        ))
                        .toggleStyle(.button)
                        .buttonStyle(.bordered)
                    }
                }
            }

            Section("Active Hours") {
                DatePicker(
                    "Start time",
                    selection: Binding(
                        get: { settings.activeStartDate },
                        set: { settings.activeStartDate = $0 }
                    ),
                    displayedComponents: .hourAndMinute
                )

                DatePicker(
                    "End time",
                    selection: Binding(
                        get: { settings.activeEndDate },
                        set: { settings.activeEndDate = $0 }
                    ),
                    displayedComponents: .hourAndMinute
                )
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - About Tab

public struct AboutTab: View {
    public init() {}

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    public var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "drop.fill")
                .font(.system(size: 56))
                .foregroundStyle(.cyan)

            Text("Sipster")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Version \(appVersion) (\(buildNumber))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("A gentle water & caffeine tracker for your Mac menu bar.\nStay hydrated, stay healthy.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)

            Divider()
                .padding(.horizontal, 60)

            HStack(spacing: 4) {
                Text("Built with")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "swift")
                    .foregroundStyle(.orange)
                    .font(.caption)
                Text("SwiftUI")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 4) {
                Text("Made with coffee,")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\u{2764}\u{FE0F}")
                Text("and Claude Code")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Link("github.com/whihathac/sipster", destination: URL(string: "https://github.com/whihathac/sipster")!)
                .font(.caption2)
                .foregroundStyle(.tertiary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
