import SwiftUI_Extensions
import SwiftUI
import Testing

@Suite struct `Accessory division` {
    @Test func `a simulated fold runs along the longer side through the center`() {
        let book = Division.simulated(in: CGRect(x: 0, y: 0, width: 800, height: 400), width: 40)
        #expect(book.axis == .vertical)
        #expect(book.frame == CGRect(x: 380, y: 0, width: 40, height: 400))

        let tabletop = Division.simulated(in: CGRect(x: 0, y: 0, width: 400, height: 800), width: 40)
        #expect(tabletop.axis == .horizontal)
        #expect(tabletop.frame == CGRect(x: 0, y: 380, width: 400, height: 40))
    }

    @Test func `the modifiers construct and the environment defaults to no division`() {
        _ = Text("Accessory").displaced()
        _ = Text("Accessory").displaced(toward: .leading)
        _ = Text("Accessory").observingDivision(simulated: true)
        _ = Text("Accessory").division(.simulated(in: CGRect(x: 0, y: 0, width: 10, height: 20)))
        #expect(EnvironmentValues().division == nil)
    }
}
