import Foundation

extension Data {
    func withUnsafeBytes<Result>(_ apply: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result {
        return try withUnsafeBytes {
            try apply(UnsafeRawBufferPointer(start: $0, count: count))
        }
    }
}
