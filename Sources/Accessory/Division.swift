public import SwiftUI

/// A division reserved region: a strip that divides the container into two
/// usable regions, like the fold of a partially folded iPhone Duo. Frames are
/// in the global coordinate space so any accessory can compare its own frame.
/// `axis` is the direction the strip runs: vertical for the book pose, which
/// splits leading and trailing regions; horizontal for the tabletop pose,
/// which splits top and bottom regions.
public struct Division: Equatable, Sendable {
    public var frame: CGRect
    public var axis: Axis

    public init(frame: CGRect, axis: Axis) {
        self.frame = frame
        self.axis = axis
    }
}

extension Division {
    /// A simulated fold through the center of `frame`, along its longer side,
    /// for exercising displacement before the reserved-region API is available.
    public static func simulated(in frame: CGRect, width: CGFloat = 40) -> Division {
        if frame.width >= frame.height {
            return Division(frame: CGRect(x: frame.midX - width / 2, y: frame.minY, width: width, height: frame.height), axis: .vertical)
        }
        return Division(frame: CGRect(x: frame.minX, y: frame.midY - width / 2, width: frame.width, height: width), axis: .horizontal)
    }
}

extension EnvironmentValues {
    /// The active division of the container, if the device is partially folded.
    @Entry public var division: Division?
}
