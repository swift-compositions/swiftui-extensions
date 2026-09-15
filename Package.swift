// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swiftui-extensions",
    platforms: [.iOS(.v27)],
    products: [
        .library(name: "SwiftUI Extensions", targets: ["SwiftUI Extensions"]),
    ],
    targets: [
        .target(name: "SwiftUI Extensions", swiftSettings: [.defaultIsolation(MainActor.self)]),
        .testTarget(name: "SwiftUI Extensions Tests", dependencies: ["SwiftUI Extensions"], swiftSettings: [.defaultIsolation(MainActor.self)]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
