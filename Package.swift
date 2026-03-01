// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sipster",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-testing.git", branch: "main")
    ],
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
            dependencies: [
                "SipsterLib",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/SipsterTests"
        )
    ]
)
