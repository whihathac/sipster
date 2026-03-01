import AppKit
import SwiftUI

public class FloatingDropWindow: NSPanel {
    public init(contentView: NSView) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 180, height: 180),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.isMovableByWindowBackground = true
        self.hidesOnDeactivate = false
        self.contentView = contentView

        positionInCorner()
    }

    private func positionInCorner() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        let padding: CGFloat = 20
        let origin = NSPoint(
            x: screenFrame.maxX - self.frame.width - padding,
            y: screenFrame.minY + padding
        )
        self.setFrameOrigin(origin)
    }

    override public var canBecomeKey: Bool { true }
    override public var canBecomeMain: Bool { false }
}
