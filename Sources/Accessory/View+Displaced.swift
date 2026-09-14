public import SwiftUI

extension View {
    /// Keeps the view out of the container's division by padding it into one
    /// region: past the fold toward `edge` for a vertical division, and into
    /// the bottom region for a horizontal one. The view keeps its outer frame
    /// so the padding never feeds back into the measurement. Scrolling content
    /// should not be displaced; only interactive accessories should.
    public func displaced(toward edge: HorizontalEdge = .trailing) -> some View {
        modifier(Displaced(edge: edge))
    }
}

private struct Displaced: ViewModifier {
    var edge: HorizontalEdge
    @Environment(\.division) private var division
    @State private var frame = CGRect.zero

    func body(content: Content) -> some View {
        content
            .padding(insets)
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: { frame = $0 }
    }

    private var insets: EdgeInsets {
        guard let division, frame.intersects(division.frame) else { return EdgeInsets() }
        if division.axis == .horizontal {
            return EdgeInsets(top: max(0, division.frame.maxY - frame.minY), leading: 0, bottom: 0, trailing: 0)
        }
        if edge == .trailing {
            return EdgeInsets(top: 0, leading: max(0, division.frame.maxX - frame.minX), bottom: 0, trailing: 0)
        }
        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: max(0, frame.maxX - division.frame.minX))
    }
}
