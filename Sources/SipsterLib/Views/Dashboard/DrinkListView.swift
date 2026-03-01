import SwiftUI

public struct DrinkListView: View {
    public let drinks: [DrinkLog]

    public init(drinks: [DrinkLog]) {
        self.drinks = drinks
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Drinks")
                .font(.headline)

            if drinks.isEmpty {
                Text("No drinks logged yet today")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(drinks.sorted(by: { $0.timestamp > $1.timestamp })) { drink in
                            HStack {
                                Image(systemName: iconForSource(drink.source))
                                    .foregroundStyle(.cyan)
                                    .frame(width: 20)

                                Text(drink.timestamp.timeString)
                                    .font(.subheadline)

                                Spacer()

                                Text("\(drink.amountML)ml")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Text(labelForSource(drink.source))
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.blue.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
    }

    private func iconForSource(_ source: DrinkSource) -> String {
        switch source {
        case .reminder: return "bell.fill"
        case .quickAdd: return "plus.circle.fill"
        case .manual: return "hand.tap.fill"
        }
    }

    private func labelForSource(_ source: DrinkSource) -> String {
        switch source {
        case .reminder: return "Reminder"
        case .quickAdd: return "Quick"
        case .manual: return "Manual"
        }
    }
}
