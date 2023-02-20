import Foundation

protocol RawInitializable: RawRepresentable where RawValue == String {
    init(_ rawValue: String)
}

extension RawInitializable {
    init(_ raw: String) {
        guard let value = Self(rawValue: raw) else {
            fatalError("Failed to init from \(raw)")
        }
        self = value
    }
}
