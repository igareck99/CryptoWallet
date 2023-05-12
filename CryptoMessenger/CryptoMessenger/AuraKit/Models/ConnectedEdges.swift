import Foundation

struct ConnectedEdges: OptionSet {
    public let rawValue: Int

    public static let topEdge: Self = .init(rawValue: 1 << 0)
    public static let bottomEdge: Self = .init(rawValue: 1 << 1)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
