import UserNotifications

public struct NotificationHelper {
    public static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            if granted {
                print("Notification permission granted")
            }
        }
    }

    public static func sendReminderNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to Hydrate!"
        content.body = "Take a moment to drink some water"
        content.sound = .default
        content.categoryIdentifier = "DRINK_REMINDER"

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    public static func sendMissedReminderNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder Missed"
        content.body = "You missed a hydration reminder. Remember to drink water!"
        content.sound = .default
        content.categoryIdentifier = "DRINK_REMINDER"

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    public static func setupCategories() {
        let drinkAction = UNNotificationAction(
            identifier: "DRINK_ACTION",
            title: "Log Drink",
            options: .foreground
        )
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Skip",
            options: .destructive
        )
        let category = UNNotificationCategory(
            identifier: "DRINK_REMINDER",
            actions: [drinkAction, dismissAction],
            intentIdentifiers: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
