import SwiftUI
import SipsterLib

@main
struct SipsterApp: App {
    @StateObject private var settings: UserSettings
    @StateObject private var reminderManager: ReminderManager
    @StateObject private var dataStore: DataStore

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(settings)
                .environmentObject(reminderManager)
                .environmentObject(dataStore)
        } label: {
            MenuBarIconView(fillLevel: menuBarFillLevel)
        }
        .menuBarExtraStyle(.window)

        Window("Sipster Dashboard", id: "dashboard") {
            DashboardView()
                .environmentObject(settings)
                .environmentObject(reminderManager)
                .environmentObject(dataStore)
        }
        .defaultSize(width: 720, height: 500)

        Settings {
            PreferencesView()
                .environmentObject(settings)
        }
    }

    private var menuBarFillLevel: Double {
        let todayTotal = dataStore.todaysDrinks().reduce(0) { $0 + $1.amountML }
        let goal = settings.dailyGoalML
        guard goal > 0 else { return 0 }
        return min(Double(todayTotal) / Double(goal), 1.0)
    }

    init() {
        let store = DataStore.shared
        let settings = UserSettings()
        let manager = ReminderManager(settings: settings)
        manager.setDataStore(store)
        _dataStore = StateObject(wrappedValue: store)
        _settings = StateObject(wrappedValue: settings)
        _reminderManager = StateObject(wrappedValue: manager)
    }
}
