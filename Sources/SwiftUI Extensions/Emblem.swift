public import CoreTransferable
import Foundation
import ImageIO
public import SwiftUI
import UniformTypeIdentifiers

public struct Emblem: Transferable {
    private let systemName: String
    private let tint: Color
    private let size: CGFloat

    public init(systemName: String, tint: Color = .accentColor, size: CGFloat = 120) {
        self.systemName = systemName
        self.tint = tint
        self.size = size
    }

    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { emblem in try await emblem.png() }
    }

    @MainActor private func png() throws -> Data {
        let renderer = ImageRenderer(
            content: Image(systemName: systemName)
                .font(.system(size: size * 0.53))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(tint, in: .rect(cornerRadius: size * 0.22))
        )
        renderer.scale = 3
        let data = NSMutableData()
        guard let image = renderer.cgImage,
              let destination = CGImageDestinationCreateWithData(data as CFMutableData, UTType.png.identifier as CFString, 1, nil)
        else { throw CocoaError(.fileWriteUnknown) }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else { throw CocoaError(.fileWriteUnknown) }
        return data as Data
    }
}
