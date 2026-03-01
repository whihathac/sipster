import AppKit

public struct SoundManager {
    public static func playReminderSound() {
        NSSound(named: "Purr")?.play()
    }
}
