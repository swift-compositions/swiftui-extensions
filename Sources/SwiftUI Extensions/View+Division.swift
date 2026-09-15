public import SwiftUI

extension View {
    /// Publishes the container's active division to the environment. Today
    /// the only source is the `-folded` launch argument, which simulates a
    /// fold through the center of this view; with the iOS 27.1 SDK this is
    /// where `reservedRegion(.division)` is read from the geometry proxy.
    public func observingDivision(simulated: Bool = CommandLine.arguments.contains("-folded")) -> some View {
        modifier(Observing(simulated: simulated))
    }

    /// Sets the division for the view hierarchy below, for previews and tests.
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
