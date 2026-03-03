import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0

    public init() {}

    private let pages: [(title: String, description: String, icon: String)] = [
        (
            "Welcome to Sipster",
            "Your gentle hydration companion for macOS.\nSipster lives in your menu bar and reminds you to drink water throughout the day.",
            "drop.fill"
        ),
        (
            "Quick Add Drinks",
            "Click the menu bar icon to quickly log water or caffeinated beverages.\nChoose from Quick Sip (50ml), Glass (150ml), Cup (250ml), or Bottle (500ml).",
            "plus.circle.fill"
        ),
        (
            "Smart Reminders",
            "A floating water drop appears at your configured interval.\nTap it to log a drink, or let it auto-dismiss.\nIf you're away, the reminder waits for your return.",
            "bell.fill"
        ),
        (
            "Track Your Progress",
            "Open the Dashboard to see your daily progress ring, weekly charts, caffeine intake, and hydration streak.\nCustomize everything in Settings.",
            "chart.bar.fill"
        ),
    ]

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Page content
            VStack(spacing: 16) {
                Image(systemName: pages[currentPage].icon)
                    .font(.system(size: 60))
                    .foregroundStyle(.cyan)

                Text(pages[currentPage].title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(pages[currentPage].description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
            }

            Spacer()

            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.cyan : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }

            // Navigation buttons
            HStack {
                if currentPage > 0 {
                    Button("Back") {
                        withAnimation { currentPage -= 1 }
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()

                if currentPage < pages.count - 1 {
                    Button("Next") {
                        withAnimation { currentPage += 1 }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Get Started") {
                        settings.hasCompletedOnboarding = true
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .frame(width: 500, height: 400)
    }
}
