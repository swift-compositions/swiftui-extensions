import Accessory
import SwiftUI
import Testing

@Suite struct `Accessory surface` {
    @Test func `constructs for any shape and reads the plain-surfaces argument by default`() {
        _ = Surface(shape: Capsule(), interactive: true)
        _ = Surface(shape: Circle(), interactive: false, plain: true)
        _ = Text("Accessory").surface(in: RoundedRectangle(cornerRadius: 12), interactive: true)
    }
}
