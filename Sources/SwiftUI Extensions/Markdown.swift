import Foundation
public import SwiftUI

public struct Markdown: View {
    private let blocks: [Block]

    public init(_ markdown: String) {
        let document = (try? AttributedString(markdown: markdown, options: .init(interpretedSyntax: .full))) ?? AttributedString(markdown)
        blocks = document.runs[\.presentationIntent].enumerated().map { offset, run in
            Block(id: offset, kinds: run.0?.components.map(\.kind) ?? [], text: AttributedString(document[run.1]))
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(blocks) { block in
                switch (block.header, block.ordinal) {
                case (let level?, _): Text(block.text).font(level == 1 ? .title.bold() : .title2.bold()).padding(.top, level == 1 ? 0 : 10)
                case (_, let ordinal?):
                    Numbered("\(ordinal)") { Text(block.text) }
                case (nil, nil): Text(block.text)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .textSelection(.enabled)
    }

    private struct Block: Identifiable {
        let id: Int
        let kinds: [PresentationIntent.Kind]
        let text: AttributedString

        var header: Int? { kinds.lazy.compactMap { if case .header(let level) = $0 { level } else { nil } }.first }
        var ordinal: Int? { kinds.lazy.compactMap { if case .listItem(let ordinal) = $0 { ordinal } else { nil } }.first }
    }
}
