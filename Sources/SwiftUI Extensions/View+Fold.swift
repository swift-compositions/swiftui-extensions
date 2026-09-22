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
    @State private var settling: Task<Void, Never>?
    @State private var selection: PresentationDetent

    init(otherwise: PresentationDetent) {
        self.otherwise = otherwise
        _selection = State(initialValue: otherwise)
    }

    private var smaller: PresentationDetent { fold.map { .height($0) } ?? otherwise }

    func body(content: Content) -> some View {
        content
            // A first fold is taken at once, so the sheet moves with the content that brought it. A fold that
            // moves is taken once it holds still: while the sheet animates, content can report passing sizes,
            // and a detent set to one of those would start the animation over.
            .onPreferenceChange(FoldPreference.self) { value in
                MainActor.assumeIsolated {
                    settling?.cancel()
                    guard fold != nil, value != nil else { return move(to: value) }
                    settling = Task {
                        try? await Task.sleep(for: .milliseconds(120))
                        if !Task.isCancelled, value != fold { move(to: value) }
                    }
                }
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
