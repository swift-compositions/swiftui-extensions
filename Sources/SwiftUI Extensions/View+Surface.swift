public import SwiftUI

extension View {
    public func surface<S: Shape>(in shape: S, interactive: Bool = false) -> some View {
        modifier(Surface(shape: shape, interactive: interactive))
    }
}
