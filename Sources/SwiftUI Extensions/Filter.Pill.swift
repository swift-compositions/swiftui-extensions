#if canImport(SwiftUI)
    public import SwiftUI

    extension Filter {
        public struct Pill: View {
            private let label: Text
            private let summary: Text
            private let action: () -> Void

            public init(label: Text, summary: Text, action: @escaping () -> Void) {
                self.label = label
                self.summary = summary
                self.action = action
            }

            public static let source = "filter.options"
        }
    }

    extension Filter.Pill {
        public var body: some View {
            SwiftUI.Button(action: action) {
                VStack(alignment: .leading, spacing: 0) {
                    label.foregroundStyle(.primary)
                    HStack(spacing: 3) {
                        summary
                        Image(systemName: "chevron.down").imageScale(.small)
                    }
                    .foregroundStyle(.tint)
                }
                .font(.caption)
                .lineLimit(1)
            }
        }
    }

#endif
