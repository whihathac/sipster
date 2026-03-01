import Foundation

public enum AppConstants {
    public static let appName = "Sipster"
    public static let bundleIdentifier = "com.sipster.app"
    public static let overlayDurationSeconds = 15 * 60

    public enum Defaults {
        public static let reminderIntervalMinutes = 60
        public static let dailyGoalGlasses = 8
        public static let defaultGlassSizeML = 250
        public static let activeStartHour = 8
        public static let activeEndHour = 20
    }
}

public enum ReminderInterval: Int, CaseIterable, Identifiable {
    case fifteenMin = 15
    case thirtyMin = 30
    case fortyFiveMin = 45
    case oneHour = 60
    case ninetyMin = 90
    case twoHours = 120

    public var id: Int { rawValue }

    public var displayName: String {
        switch self {
        case .fifteenMin: return "15 minutes"
        case .thirtyMin: return "30 minutes"
        case .fortyFiveMin: return "45 minutes"
        case .oneHour: return "1 hour"
        case .ninetyMin: return "1.5 hours"
        case .twoHours: return "2 hours"
        }
    }
}
