import Foundation

// MARK: - private

extension String {
    /// Data never nil
    internal var dataUsingUTF8StringEncoding: Data {
        return utf8CString.withUnsafeBufferPointer {
            return Data($0.dropLast().map { UInt8.init($0) })
        }
    }
    
    /// Array<UInt8>
    internal var arrayUsingUTF8StringEncoding: [UInt8] {
        return utf8CString.withUnsafeBufferPointer {
            return $0.dropLast().map { UInt8.init($0) }
        }
    }
}
