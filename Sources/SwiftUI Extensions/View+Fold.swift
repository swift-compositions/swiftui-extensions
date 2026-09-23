public import SwiftUI

extension View {
    /// Declares the fold of the presentation this view is in: the height at which a sheet shows this content's
    /// first part and no more. The caller measures it from sizes that do not depend on the sheet's own height,
    /// such as a title's place within scroll content and the height of a bar, so the sheet cannot chase itself.
    public func presentationFold(_ height: CGFloat?) -> some View {
        preference(key: FoldPreference.self, value: height.map { $0.rounded(.up) })
    }

    /// Detents at the fold declared in the content, when it has one, and otherwise at `otherwise`; and at large.
    /// The sheet follows the fold as it moves and returns to `otherwise` when the fold goes, unless it was opened
    /// large. Interaction with the view behind the sheet is enabled up through the smaller detent.
    public func presentationDetents(fold otherwise: PresentationDetent = .medium) -> some View {
        modifier(FoldDetents(otherwise: otherwise))
    }
}

/// The height of the fold, in points from the top of the presentation.
private struct FoldPreference: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) { value = nextValue() ?? value }
}

private struct FoldDetents: ViewModifier {
    var otherwise: PresentationDetent
    @State private var fold: CGFloat?
    @State private var selection: PresentationDetent

    init(otherwise: PresentationDetent) {
        self.otherwise = otherwise
        _selection = State(initialValue: otherwise)
    }

    private var smaller: PresentationDetent { fold.map { .height($0) } ?? otherwise }

    func body(content: Content) -> some View {
        content
            // The fold is declared from sizes that do not depend on the sheet's height, so it changes only when
            // the content in view changes, and is taken as it comes. A preference callback runs outside the
            // transaction of the change that moved the fold, so this is where the detent's is opened. A passing
            // value seen here means the source measures something that follows the sheet: fix it there, never by
            // waiting.
            .onPreferenceChange(FoldPreference.self) { value in
                MainActor.assumeIsolated { move(to: value) }
            }
            .presentationDetents([smaller, .large], selection: $selection)
            .presentationBackgroundInteraction(.enabled(upThrough: smaller))
    }

    // The smaller detent is a new value each time the fold moves, so a sheet resting on it is moved to the
    // new value in the same update that offers it: a selection outside the offered detents is a fault.
    private func move(to value: CGFloat?) {
        let resting = selection == smaller
        withAnimation {
            fold = value
            if resting { selection = smaller }
        }
    }
}
