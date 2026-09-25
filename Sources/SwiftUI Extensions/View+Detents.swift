public import SwiftUI

extension View {
    public func presentationDetents(resting: CGFloat?, otherwise: PresentationDetent = .medium, pinned: Bool = false) -> some View {
        modifier(RestingDetents(resting: resting, otherwise: otherwise, pinned: pinned))
    }
}

private struct RestingDetents: ViewModifier {
    let resting: CGFloat?
    let otherwise: PresentationDetent
    let pinned: Bool
    @State private var stand = Stand.smaller

    private var smaller: PresentationDetent { resting.map { .height($0.rounded(.up)) } ?? otherwise }

    func body(content: Content) -> some View {
        content
            .presentationDetents(pinned && stand == .smaller ? [smaller] : [smaller, .large], selection: $stand[dynamicMember: \.[smaller]])
            .presentationBackgroundInteraction(.enabled(upThrough: smaller))
    }
}

private enum Stand: Hashable {
    case smaller, large

    subscript(smaller: PresentationDetent) -> PresentationDetent {
        get { self == .large ? .large : smaller }
        set { self = newValue == .large ? .large : .smaller }
    }
}
