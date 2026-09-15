public import SwiftUI

extension View {
    /// Places the view on an accessory surface of the given shape.
    public func surface<S: Shape>(in shape: S, interactive: Bool = false) -> some View {
        modifier(Surface(shape: shape, interactive: interactive))
    }
}
