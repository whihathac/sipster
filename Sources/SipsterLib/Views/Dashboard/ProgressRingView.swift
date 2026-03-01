import SwiftUI

public struct ProgressRingView: View {
    public let progress: Double
    public let current: Int
    public let goal: Int
    public var size: CGFloat = 160

    public init(progress: Double, current: Int, goal: Int, size: CGFloat = 160) {
        self.progress = progress
        self.current = current
        self.goal = goal
        self.size = size
    }

    private var clampedProgress: Double {
        min(max(progress, 0), 1.0)
    }

    private var ringColor: Color {
        if progress >= 1.0 {
            return .green
        } else if progress >= 0.5 {
            return .blue
        } else {
            return .cyan
        }
    }

    private var lineWidth: CGFloat { size * 0.1 }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [ringColor.opacity(0.6), ringColor]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: clampedProgress)

            VStack(spacing: 2) {
                Text("\(current)")
                    .font(.system(size: size * 0.26, weight: .bold, design: .rounded))

                Text("of \(goal) glasses")
                    .font(.system(size: size * 0.08))
                    .foregroundStyle(.secondary)

                if progress >= 1.0 {
                    Text("Goal reached!")
                        .font(.system(size: size * 0.07))
                        .foregroundStyle(.green)
                        .fontWeight(.medium)
                }
            }
        }
        .frame(width: size, height: size)
    }
}
