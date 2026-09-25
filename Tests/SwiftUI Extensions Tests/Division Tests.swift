import SwiftUI_Extensions
import SwiftUI
import Testing

@Suite struct `Accessory division` {
    @Test func `a simulated fold runs along the longer side through the center`() {
        #expect(Division.simulated(in: CGRect(x: 0, y: 0, width: 800, height: 400), width: 40) == Division(frame: CGRect(x: 380, y: 0, width: 40, height: 400), axis: .vertical))
        #expect(Division.simulated(in: CGRect(x: 0, y: 0, width: 400, height: 800), width: 40) == Division(frame: CGRect(x: 0, y: 380, width: 400, height: 40), axis: .horizontal))
    }

    @Test func `the environment defaults to no division`() {
        #expect(EnvironmentValues().division == nil)
    }
}
