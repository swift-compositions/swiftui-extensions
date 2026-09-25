public import SwiftUI

public struct Numbered<Content: View>: View {
    private let ordinal: String
    private let content: Content

    public init(_ ordinal: String, @ViewBuilder content: () -> Content) {
        self.ordinal = ordinal
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(verbatim: "\(ordinal).").monospacedDigit().foregroundStyle(.secondary)
            content
        }
    }
}
