public import SwiftUI

extension View {
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
        switch (division.flatMap { frame.intersects($0.frame) ? $0 : nil }, edge) {
        case (nil, _): EdgeInsets()
        case let (division?, _) where division.axis == .horizontal: EdgeInsets(top: max(0, division.frame.maxY - frame.minY), leading: 0, bottom: 0, trailing: 0)
        case let (division?, .trailing): EdgeInsets(top: 0, leading: max(0, division.frame.maxX - frame.minX), bottom: 0, trailing: 0)
        case let (division?, .leading): EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: max(0, frame.maxX - division.frame.minX))
        }
    }
}
