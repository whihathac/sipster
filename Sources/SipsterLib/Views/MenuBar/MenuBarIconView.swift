import SwiftUI

/// Menu bar icon showing a water drop that fills from the bottom based on daily progress.
/// Uses SF Symbols for reliable template-image rendering in the menu bar across all macOS versions.
public struct MenuBarIconView: View {
    public let fillLevel: Double

    public init(fillLevel: Double) {
        self.fillLevel = fillLevel
    }

    private var fill: CGFloat {
        CGFloat(min(max(fillLevel, 0), 1.0))
    }

    // Must match the font size so the mask height maps 1-to-1 with glyph height
    private let iconPt: CGFloat = 16

    public var body: some View {
        ZStack {
            // Faint outline = "empty capacity" container
            Image(systemName: "drop")
                .font(.system(size: iconPt, weight: .medium))
                .opacity(0.3)

            // Solid fill rises from the bottom as progress increases.
            // mask(alignment: .bottom) anchors the clipping rect to the bottom
            // of the glyph, so height = iconPt * fill exposes the right fraction.
            Image(systemName: "drop.fill")
                .font(.system(size: iconPt, weight: .medium))
                .mask(alignment: .bottom) {
                    Rectangle()
                        .frame(height: iconPt * fill)
                }
        }
        .frame(width: 20, height: 20)
    }
}
