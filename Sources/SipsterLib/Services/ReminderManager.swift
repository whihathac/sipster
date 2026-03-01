import Foundation
import SwiftUI
import UserNotifications

@MainActor
public class ReminderManager: ObservableObject {
    @Published public var nextReminderTime: Date?
    @Published public var isOverlayVisible: Bool = false

    private var timer: Timer?
    private var overlayWindow: FloatingDropWindow?
    private var settings: UserSettings
    private var dataStore: DataStore?

    public init(settings: UserSettings = UserSettings()) {
        self.settings = settings
        NotificationHelper.requestPermission()
        NotificationHelper.setupCategories()
        scheduleNextReminder()
    }

    public func setDataStore(_ store: DataStore) {
        self.dataStore = store
    }

    public func updateSettings(_ settings: UserSettings) {
        self.settings = settings
        scheduleNextReminder()
    }

    // MARK: - Scheduling

    public func scheduleNextReminder() {
        timer?.invalidate()

        guard let nextTime = calculateNextReminderTime() else {
            nextReminderTime = nil
            return
        }
        nextReminderTime = nextTime

        let interval = nextTime.timeIntervalSinceNow
        guard interval > 0 else {
            fireReminder()
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.fireReminder()
            }
        }
    }

    private func calculateNextReminderTime() -> Date? {
        let now = Date()
        let intervalMinutes = settings.reminderIntervalMinutes

        if isActiveDay(now) && isWithinActiveHours(now) {
            let candidate = now.addingTimeInterval(Double(intervalMinutes * 60))
            if isWithinActiveHours(candidate) && isActiveDay(candidate) {
                return candidate
            }
        }

        return findNextActiveStart(from: now)
    }

    private func isActiveDay(_ date: Date) -> Bool {
        settings.activeDays.contains(date.weekdayIndex)
    }

    private func isWithinActiveHours(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let timeValue = hour * 60 + minute
        let startValue = settings.activeStartHour * 60 + settings.activeStartMinute
        let endValue = settings.activeEndHour * 60 + settings.activeEndMinute
        return timeValue >= startValue && timeValue < endValue
    }

    private func findNextActiveStart(from date: Date) -> Date? {
        let calendar = Calendar.current
        var checkDate = date

        for _ in 0..<14 {
            var components = calendar.dateComponents([.year, .month, .day], from: checkDate)
            components.hour = settings.activeStartHour
            components.minute = settings.activeStartMinute

            if let candidate = calendar.date(from: components),
               candidate > date,
               isActiveDay(candidate) {
                return candidate
            }

            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: checkDate) else { break }
            checkDate = calendar.startOfDay(for: nextDay)
        }

        return nil
    }

    // MARK: - Firing

    private func fireReminder() {
        showFloatingOverlay()
        NotificationHelper.sendReminderNotification()

        if settings.soundEnabled {
            SoundManager.playReminderSound()
        }
    }

    // MARK: - Overlay

    public func showFloatingOverlay() {
        dismissOverlay()

        let drinkAction: () -> Void = { [weak self] in
            Task { @MainActor [weak self] in
                self?.logDrink(source: .reminder)
                self?.dismissOverlay()
                self?.scheduleNextReminder()
            }
        }
        let dismissAction: () -> Void = { [weak self] in
            Task { @MainActor [weak self] in
                self?.dismissOverlay()
                self?.scheduleNextReminder()
            }
        }

        let swiftUIView = FloatingDropView(onDrink: drinkAction, onDismiss: dismissAction)
        let hostingView = NSHostingView(rootView: swiftUIView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 180, height: 180)

        let window = FloatingDropWindow(contentView: hostingView)
        window.orderFrontRegardless()

        overlayWindow = window
        isOverlayVisible = true
    }

    public func dismissOverlay() {
        overlayWindow?.close()
        overlayWindow = nil
        isOverlayVisible = false
    }

    // MARK: - Logging

    public func logDrink(amountML: Int? = nil, source: DrinkSource = .quickAdd) {
        let amount = amountML ?? settings.defaultGlassSizeML
        let log = DrinkLog(amountML: amount, source: source)
        dataStore?.addDrink(log)
    }

    // MARK: - Status

    public var timeUntilNextReminder: String {
        guard let next = nextReminderTime else { return "No reminders scheduled" }
        let interval = next.timeIntervalSinceNow
        if interval <= 0 { return "Now" }

        let minutes = Int(interval) / 60
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
