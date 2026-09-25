public import SwiftUI

public struct Surface<S: Shape>: ViewModifier {
    private var shape: S
    private var interactive: Bool

    public init(shape: S, interactive: Bool) {
        self.shape = shape
        self.interactive = interactive
    }
}

extension Surface {
    public func body(content: Content) -> some View {
        content.glassEffect(.regular.interactive(interactive), in: shape)
    }
}
