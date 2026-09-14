// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "accessory",
    platforms: [.iOS(.v27)],
    products: [
        .library(name: "Accessory", targets: ["Accessory"]),
    ],
    targets: [
        .target(name: "Accessory", swiftSettings: [.defaultIsolation(MainActor.self)]),
        .testTarget(name: "Accessory Tests", dependencies: ["Accessory"], swiftSettings: [.defaultIsolation(MainActor.self)]),
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
