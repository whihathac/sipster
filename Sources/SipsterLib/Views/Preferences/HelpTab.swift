import SwiftUI

public struct HelpTab: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                helpSection(
                    title: "Quick Add",
                    icon: "plus.circle.fill",
                    description: "Click the Sipster icon in the menu bar to quickly log water or caffeinated beverages. Choose from Quick Sip (50ml), Glass (150ml), Cup (250ml), or Bottle (500ml). Caffeine drinks like coffee, tea, and espresso are tracked separately."
                )

                helpSection(
                    title: "Floating Reminder",
                    icon: "drop.fill",
                    description: "A floating water drop overlay appears at your configured interval. Tap it to log a drink at your configured overlay size. The overlay uses a countdown timer — if it expires without interaction, you'll get a notification reminder. If you're away from your Mac, the reminder waits and shows when you return."
                )

                helpSection(
                    title: "Dashboard",
                    icon: "chart.bar.fill",
                    description: "Open the Dashboard from the menu bar to see your daily progress ring, weekly bar chart (toggle between water and caffeine views), hydration stats, and drink history. Navigate between weeks to review your history."
                )

                helpSection(
                    title: "Caffeine Tracking",
                    icon: "cup.and.saucer.fill",
                    description: "Sipster tracks your caffeine intake alongside water. Log coffee (95mg), tea (47mg), espresso (63mg), energy drinks (80mg), or soda (34mg). Set a daily caffeine limit in Settings to get warnings when you're over."
                )

                helpSection(
                    title: "Settings",
                    icon: "gear",
                    description: "Customize your daily goal, glass size, reminder interval, active hours and days, overlay drink size, caffeine limit, and glass effect appearance. Access Settings from the menu bar or press Cmd+Comma."
                )

                helpSection(
                    title: "Tips",
                    icon: "lightbulb.fill",
                    description: "Start with the default 1-hour reminder interval and adjust based on your preference. Use Quick Sip for small drinks between meals. The timer resets whenever you log a drink, so you won't get a reminder right after drinking."
                )
            }
            .padding()
        }
    }

    private func helpSection(title: String, icon: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.cyan)
                Text(title)
                    .font(.headline)
            }
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
