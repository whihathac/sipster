import Testing
@testable import SipsterLib

@Suite("UserSettings Tests")
@MainActor
struct UserSettingsTests {

    @Test("Default values")
    func defaultValues() {
        let settings = UserSettings()
        #expect(settings.reminderIntervalMinutes == AppConstants.Defaults.reminderIntervalMinutes)
        #expect(settings.dailyGoalGlasses == AppConstants.Defaults.dailyGoalGlasses)
        #expect(settings.defaultGlassSizeML == AppConstants.Defaults.defaultGlassSizeML)
        #expect(settings.activeStartHour == AppConstants.Defaults.activeStartHour)
        #expect(settings.activeEndHour == AppConstants.Defaults.activeEndHour)
    }

    @Test("Daily goal ML computed correctly")
    func dailyGoalML() {
        let settings = UserSettings()
        #expect(settings.dailyGoalML == settings.dailyGoalGlasses * settings.defaultGlassSizeML)
    }

    @Test("Active days parsing")
    func activeDaysParsing() {
        let settings = UserSettings()
        // Set a known raw value to test parsing independently of stored UserDefaults state
        settings.activeDaysRaw = "1,2,3,4,5"
        let days = settings.activeDays
        #expect(days.contains(1))  // Monday
        #expect(days.contains(5))  // Friday
        #expect(!days.contains(6)) // Saturday
        #expect(!days.contains(7)) // Sunday
    }

    @Test("Active days setter")
    func activeDaysSetter() {
        let settings = UserSettings()
        settings.activeDays = Set([1, 3, 5, 7])
        #expect(settings.activeDaysRaw == "1,3,5,7")
    }

    @Test("New settings defaults")
    func newSettingsDefaults() {
        let settings = UserSettings()
        #expect(settings.overlayDrinkSizeML == AppConstants.Defaults.defaultGlassSizeML)
        #expect(settings.dailyCaffeineLimitMG == AppConstants.Defaults.dailyCaffeineLimitMG)
        #expect(settings.useGlassEffect == true)
        #expect(settings.hasCompletedOnboarding == false)
    }

    @Test("Reminder intervals")
    func reminderIntervals() {
        #expect(ReminderInterval.fifteenMin.rawValue == 15)
        #expect(ReminderInterval.oneHour.rawValue == 60)
        #expect(ReminderInterval.twoHours.rawValue == 120)
        #expect(ReminderInterval.allCases.count == 6)
    }
}
