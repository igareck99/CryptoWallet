import Foundation

// MARK: - Base16 Data <-> String

public func base16Encode(_ data: Data, uppercase: Bool = true) -> String {
    return data.withUnsafeBytes {
        base16encode($0.baseAddress!, $0.count, uppercase)
    }
}

public func base16DecodeToData(_ string: String) -> Data? {
    return base16decode(string)?.withUnsafeBufferPointer(Data.init(buffer:))
}

// MARK: - Base16 [UInt8] <-> String

public func base16Encode(_ array: [UInt8], uppercase: Bool = true) -> String {
    return base16encode(array, array.count, uppercase)
}

public func base16Decode(_ string: String) -> [UInt8]? {
    return base16decode(string)
}

// MARK: extensions

extension String {
    // base16
    public var base16DecodedData: Data? {
        return base16DecodeToData(self)
    }
    
    public var base16EncodedString: String {
        return utf8CString.withUnsafeBufferPointer {
            base16encode($0.baseAddress!, $0.count - 1)
        }
    }
    
    public func base16DecodedString(_ encoding: String.Encoding = .utf8) -> String? {
        return base16DecodedData.flatMap {
            String(data: $0, encoding: .utf8)
        }
    }
}

extension Data {
    // base16
    public var base16EncodedString: String {
        return base16Encode(self)
    }
    
    public var base16EncodedData: Data {
        return base16EncodedString.dataUsingUTF8StringEncoding
    }
    
    public var base16DecodedData: Data? {
        return String(data: self, encoding: .utf8).flatMap(base16DecodeToData)
    }
}

// MARK: encode
private func base16encode(_ data: UnsafeRawPointer, _ length: Int, _ uppercase: Bool = true) -> String {
    let array = UnsafeBufferPointer.init(start: data.bindMemory(to: UInt8.self, capacity: length), count: length)
    return array.map { String(format: uppercase ? "%02X" : "%02x", $0) }.reduce("", +)
}

// MARK: decode
extension UnicodeScalar {
    fileprivate var hexToUInt8: UInt8? {
        switch self {
        case "0"..."9": return UInt8(value - UnicodeScalar("0").value)
        case "a"..."f": return UInt8(0xa) + UInt8(value - UnicodeScalar("a").value)
        case "A"..."F": return UInt8(0xa) + UInt8(value - UnicodeScalar("A").value)
        default:
            print("base16decode: Invalid hex character \(self)")
            return nil
        }
    }
}

private func base16decode(_ string: String) -> [UInt8]? {
    // validate length
    let lenght = string.utf8CString.count - 1
    if lenght % 2 != 0 {
        print("base16decode: String must contain even number of characters")
        return nil
    }
    var g = string.unicodeScalars.makeIterator()
    var buffer = Array<UInt8>(repeating: 0, count: lenght / 2)
    var index = 0
    while let msn = g.next() {
        if let msn = msn.hexToUInt8 {
            if let lsn = g.next()?.hexToUInt8 {
                buffer[index] = msn << 4 | lsn
            } else {
                return nil
            }
        } else {
            return nil
        }
        index += 1
    }
    return buffer
}
