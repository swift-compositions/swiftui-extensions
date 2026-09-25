import SwiftUI_Extensions
import Foundation
import SwiftUI
import Testing
import PDFKit

@Suite struct `Paged PDF` {
    @Test func `renders blocks as a PDF document`() {
        #expect(["Memo"].pdf { Text(verbatim: $0) }.starts(with: Data("%PDF".utf8)))
    }

    @Test func `flows blocks onto A4 pages, never splitting a block`() throws {
        let document = try #require(PDFDocument(data: (1...60).pdf { Text(verbatim: "Paragraph \($0)").font(.title) }))
        #expect(document.pageCount > 1)
        #expect(try #require(document.page(at: 0)).bounds(for: .mediaBox).size == .a4)
        #expect((0..<document.pageCount).compactMap { document.page(at: $0)?.string }.joined(separator: "\n").components(separatedBy: "Paragraph ").count == 61)
    }
}
