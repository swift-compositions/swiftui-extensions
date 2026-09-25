public import SwiftUI
public import Foundation
import CoreGraphics

extension ImageRenderer {
    public var pdf: Data {
        let data = NSMutableData()
        render { size, render in
            var box = CGRect(origin: .zero, size: size)
            guard let consumer = CGDataConsumer(data: data as CFMutableData),
                  let context = unsafe CGContext(consumer: consumer, mediaBox: &box, nil)
            else { return }
            context.beginPDFPage(nil)
            render(context)
            context.endPDFPage()
            context.closePDF()
        }
        return data as Data
    }
}
