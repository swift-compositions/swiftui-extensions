public import SwiftUI

extension View {
    /// Detents at `fold`, the height at which a sheet shows its content's first part and no more, while there is one,
    /// and otherwise at `otherwise`; and at large. The caller derives the fold from its state and from sizes that do
    /// not depend on the sheet's own height, so the sheet cannot chase itself, and the sheet's edge moves in the
    /// transaction of the change that moved the fold. The sheet rests on the smaller detent unless it was drawn to
    /// large. Interaction with the view behind the sheet is enabled up through the smaller detent.
    public func presentationDetents(fold: CGFloat?, otherwise: PresentationDetent = .medium) -> some View {
        modifier(FoldDetents(fold: fold, otherwise: otherwise))
    }
}

private struct FoldDetents: ViewModifier {
    let fold: CGFloat?
    let otherwise: PresentationDetent
    @State private var stand = Stand.smaller

    private var smaller: PresentationDetent { fold.map { .height($0.rounded(.up)) } ?? otherwise }

    func body(content: Content) -> some View {
        // The selection is where the sheet stands, read against the detents offered in the same update, so it is
        // never a detent the sheet no longer offers.
        content
            .presentationDetents([smaller, .large], selection: $stand[dynamicMember: \.[smaller]])
            .presentationBackgroundInteraction(.enabled(upThrough: smaller))
    }
}

/// Where a sheet stands: on its smaller detent, whatever that is now, or large.
private enum Stand: Hashable {
    case smaller, large

    subscript(smaller: PresentationDetent) -> PresentationDetent {
        get { self == .large ? .large : smaller }
        set { self = newValue == .large ? .large : .smaller }
    }
}
