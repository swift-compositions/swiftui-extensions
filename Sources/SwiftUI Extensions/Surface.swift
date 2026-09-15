public import SwiftUI

/// The glass surface every bottom accessory sits on. Styling only: each
/// example owns placement, focus, and presentation state. Launching with
/// `-plain-surfaces` keeps the same view structure on a plain background for
/// baseline comparisons.
public struct Surface<S: Shape>: ViewModifier {
    private var shape: S
    private var interactive: Bool
    private var plain: Bool

    public init(shape: S, interactive: Bool, plain: Bool = CommandLine.arguments.contains("-plain-surfaces")) {
        self.shape = shape
        self.interactive = interactive
        self.plain = plain
    }
}

extension Surface {
    public func body(content: Content) -> some View {
        content
            .background(plain ? AnyShapeStyle(.background) : AnyShapeStyle(.clear), in: shape)
            .glassEffect(plain ? .identity : .regular.interactive(interactive), in: shape)
    }
}
