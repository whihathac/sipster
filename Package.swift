// swift-tools-version: 5.9
import PackageDescription

// Swift Testing (import Testing) ships inside Xcode 16+ / Swift 6+.
// No external package dependency is needed — and swift-testing 6.x uses
// .unsafeFlags in its own targets, which SPM blocks for remote packages anyway.

let package = Package(
    name: "Sipster",
    platforms: [.macOS(.v14)],
    targets: [
        .target(
            name: "SipsterLib",
            path: "Sources/SipsterLib"
        ),
        .executableTarget(
            name: "Sipster",
            dependencies: ["SipsterLib"],
            path: "Sources/Sipster",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        ),
        .testTarget(
            name: "SipsterTests",
            dependencies: ["SipsterLib"],
            path: "Tests/SipsterTests"
        )
    ]
)
