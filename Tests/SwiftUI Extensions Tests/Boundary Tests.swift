import SwiftUI_Extensions
import Foundation
import SwiftUI
import Testing
import PDFKit

@Suite struct `Accessory division boundaries` {
    @Test func `a square frame divides vertically`() {
        #expect(Division.simulated(in: CGRect(x: 0, y: 0, width: 400, height: 400), width: 40) == Division(frame: CGRect(x: 180, y: 0, width: 40, height: 400), axis: .vertical))
    }

    @Test func `the division follows an offset frame`() {
        #expect(Division.simulated(in: CGRect(x: 100, y: 50, width: 800, height: 400), width: 40) == Division(frame: CGRect(x: 480, y: 50, width: 40, height: 400), axis: .vertical))
    }

    @Test func `a zero width division is a line through the center`() {
        #expect(Division.simulated(in: CGRect(x: 0, y: 0, width: 400, height: 800), width: 0) == Division(frame: CGRect(x: 0, y: 400, width: 400, height: 0), axis: .horizontal))
    }
}

@Suite struct `Paged PDF boundaries` {
    @Test func `one block renders one page`() throws {
        let document = try #require(PDFDocument(data: ["Memo"].pdf { Text(verbatim: $0) }))
        #expect(document.pageCount == 1)
    }

    @Test func `a block taller than the page gets a page of its own`() throws {
        let document = try #require(PDFDocument(data: [10, 2000, 10].pdf { Color.clear.frame(height: CGFloat($0)) }))
        #expect(document.pageCount == 3)
    }
}
