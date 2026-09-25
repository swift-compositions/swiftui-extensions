public import SwiftUI
public import Foundation
import CoreGraphics

extension CGSize {
    public static let a4 = CGSize(width: 595, height: 842)
}

extension Sequence {
    public func pdf<Block: View>(
        page: CGSize = .a4, margin: CGFloat = 56, spacing: CGFloat = 12,
        @ViewBuilder block: @escaping (Element) -> Block
    ) -> Data {
        let elements = Array(self)
        let width = page.width - 2 * margin
        let height = page.height - 2 * margin
        let heights = elements.map { element in
            var measured = CGFloat.zero
            ImageRenderer(content: block(element).frame(width: width, alignment: .leading).fixedSize(horizontal: false, vertical: true))
                .render { size, _ in measured = size.height }
            return measured
        }
        let pages = heights.indices.reduce(into: [(indices: [Int], height: CGFloat)]()) { pages, index in
            switch pages.last {
            case let last? where last.height + spacing + heights[index] <= height:
                pages[pages.endIndex - 1] = (last.indices + [index], last.height + spacing + heights[index])
            default:
                pages.append(([index], heights[index]))
            }
        }
        let data = NSMutableData()
        var box = CGRect(origin: .zero, size: page)
        guard let consumer = CGDataConsumer(data: data as CFMutableData),
              let context = unsafe CGContext(consumer: consumer, mediaBox: &box, nil)
        else { return Data() }
        for indices in pages.map(\.indices) {
            ImageRenderer(
                content: VStack(alignment: .leading, spacing: spacing) {
                    ForEach(indices, id: \.self) { block(elements[$0]) }
                }
                .padding(margin)
                .frame(width: page.width, height: page.height, alignment: .topLeading)
            )
            .render { _, render in
                context.beginPDFPage(nil)
                render(context)
                context.endPDFPage()
            }
        }
        context.closePDF()
        return data as Data
    }
}
