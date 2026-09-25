public import SwiftUI

extension View {
    public func observingDivision(simulated: Bool = CommandLine.arguments.contains("-folded")) -> some View {
        modifier(Observing(simulated: simulated))
    }

    public func division(_ division: Division?) -> some View {
        environment(\.division, division)
    }
}

private struct Observing: ViewModifier {
    var simulated: Bool
    @State private var division: Division?

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: { frame in
                division = simulated ? .simulated(in: frame) : nil
            }
            .environment(\.division, division)
    }
}
