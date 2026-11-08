#if canImport(SwiftUI)
    import CoreTransferable
    import Foundation
    import SwiftUI_Extensions
    import Testing
    import UniformTypeIdentifiers

    enum `Emblem Tests` {}

    extension `Emblem Tests` {
        @Suite struct `An emblem` {
            @Test func `exports its symbol as a PNG image`() async throws {
                let png = try await Emblem(systemName: "building.2").exported(as: .png)
                #expect(png.starts(with: [0x89, 0x50, 0x4E, 0x47]))
            }
        }
    }

#endif
