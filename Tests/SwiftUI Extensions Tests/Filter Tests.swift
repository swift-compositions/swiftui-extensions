#if canImport(SwiftUI)
    import SwiftUI
    import SwiftUI_Extensions
    import Testing

    enum `Filter Tests` {}

    extension `Filter Tests` {
        @Suite struct `A filter` {
            @Test func `button and pill build, and the options zoom from one source`() {
                var on = true
                let isOn = Binding { on } set: { on = $0 }
                _ = Filter.Button(isOn: isOn, title: Text(verbatim: "Filter")) { SwiftUI.Button(String("Unread")) {} }.body
                _ = Filter.Pill(label: Text(verbatim: "Filtered by"), summary: Text(verbatim: "Unread")) {}.body
                #expect(Filter.Pill.source == "filter.options")
                isOn.wrappedValue.toggle()
                #expect(!on)
            }
        }
    }

#endif
