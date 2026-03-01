import SwiftUI

public struct FloatingDropView: View {
    public let onDrink: () -> Void
    public let onDismiss: () -> Void
    @State private var remainingSeconds: Int = AppConstants.overlayDurationSeconds
    @State private var timer: Timer?

    public init(onDrink: @escaping () -> Void, onDismiss: @escaping () -> Void) {
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
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 160, height: 160)

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

            VStack(spacing: 8) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(urgencyColor)

                Text(timeString)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(.primary)

                Text("Tap to drink")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 180, height: 180)
        .contentShape(Circle())
        .onTapGesture {
            stopTimer()
            onDrink()
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
