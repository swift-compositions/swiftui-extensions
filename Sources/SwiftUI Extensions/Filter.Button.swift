#if canImport(SwiftUI)
    public import SwiftUI

    extension Filter {
        public struct Button<Menu: View>: View {
            @Binding private var isOn: Bool
            private let title: Text
            private let menu: Menu

            public init(isOn: Binding<Bool>, title: Text, @ViewBuilder menu: () -> Menu) {
                _isOn = isOn
                self.title = title
                self.menu = menu()
            }
        }
    }

    extension Filter.Button {
        public var body: some View {
            Toggle(isOn: $isOn) {
                Label {
                    title
                } icon: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
                .labelStyle(.iconOnly)
            }
            .toggleStyle(.button)
            .contextMenu { menu }
        }
    }

#endif
