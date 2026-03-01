import Foundation
import Combine

@MainActor
public class DataStore: ObservableObject {
    @Published public var drinks: [DrinkLog] = []

    private let fileURL: URL

    public static let shared = DataStore()

    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = appSupport.appendingPathComponent("Sipster", isDirectory: true)

        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)

        fileURL = appDir.appendingPathComponent("drinks.json")
        load()
    }

    public init(fileURL: URL) {
        self.fileURL = fileURL
        load()
    }

    public func addDrink(_ drink: DrinkLog) {
        drinks.append(drink)
        save()
    }

    public func todaysDrinks() -> [DrinkLog] {
        let start = Calendar.current.startOfDay(for: Date())
        return drinks.filter { $0.timestamp >= start }
    }

    public func drinksInRange(from: Date, to: Date) -> [DrinkLog] {
        drinks.filter { $0.timestamp >= from && $0.timestamp < to }
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(drinks)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save drinks: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            drinks = try JSONDecoder().decode([DrinkLog].self, from: data)
        } catch {
            print("Failed to load drinks: \(error)")
        }
    }
}
