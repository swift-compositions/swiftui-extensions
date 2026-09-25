public import SwiftUI

public struct Division: Equatable, Sendable {
    public var frame: CGRect
    public var axis: Axis

    public init(frame: CGRect, axis: Axis) {
        self.frame = frame
        self.axis = axis
    }
}

extension Division {
    public static func simulated(in frame: CGRect, width: CGFloat = 40) -> Division {
        frame.width >= frame.height
            ? Division(frame: CGRect(x: frame.midX - width / 2, y: frame.minY, width: width, height: frame.height), axis: .vertical)
            : Division(frame: CGRect(x: frame.minX, y: frame.midY - width / 2, width: frame.width, height: width), axis: .horizontal)
    }
}

extension EnvironmentValues {
    @Entry public var division: Division?
}
