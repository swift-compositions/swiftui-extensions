import SwiftUI_Extensions
import Foundation
import SwiftUI
import Testing

@Suite struct `Image renderer PDF` {
    @Test func `renders a view as a one-page PDF document`() {
        #expect(ImageRenderer(content: Text(verbatim: "Memo")).pdf.starts(with: Data("%PDF".utf8)))
    }
}
