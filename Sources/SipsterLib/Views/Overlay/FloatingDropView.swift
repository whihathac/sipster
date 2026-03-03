import SwiftUI

public struct FloatingDropView: View {
    public let overlayDrinkSizeML: Int
    public let useGlassEffect: Bool
    public let onDrink: (Int) -> Void
    public let onDismiss: () -> Void
    @State private var remainingSeconds: Int = AppConstants.overlayDurationSeconds
    @State private var timer: Timer?

    public init(
        overlayDrinkSizeML: Int,
        useGlassEffect: Bool,
        onDrink: @escaping (Int) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.overlayDrinkSizeML = overlayDrinkSizeML
        self.useGlassEffect = useGlassEffect
        self.onDrink = onDrink
        self.onDismiss = onDismiss
    }

    private var progress: Double {
        Double(remainingSeconds) / Double(AppConstants.overlayDurationSeconds)
    }

    private var timeString: String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    private var urgencyColor: Color {
        if remainingSeconds < 60 {
            return .red
        } else if remainingSeconds < 300 {
            return .orange
        } else {
            return .cyan
        }
    }

    public var body: some View {
        ZStack {
            // Background circle with glassmorphism or solid
            if useGlassEffect {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 160, height: 160)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: .cyan.opacity(0.3), radius: 12)
            } else {
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 160, height: 160)
            }

            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [.blue, urgencyColor],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)

            // Center content
            VStack(spacing: 6) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(urgencyColor)

                Text(timeString)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(.primary)

                Text("Tap to drink \(overlayDrinkSizeML)ml")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 180, height: 180)
        .contentShape(Circle())
        .onTapGesture {
            stopTimer()
            onDrink(overlayDrinkSizeML)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    stopTimer()
                    onDismiss()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
