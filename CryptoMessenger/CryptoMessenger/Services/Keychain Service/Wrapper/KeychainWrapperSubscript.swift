import Foundation
// swiftlint:disable all
#if canImport(CoreGraphics)
import CoreGraphics
#endif

extension KeychainWrapper {
        
    func remove(forKey key: Key) {
        removeObject(forKey: key.rawValue)
    }
}

// MARK: - Getters & Setters Subscripts

extension KeychainWrapper {
    
    subscript(key: Key) -> String? {
        get { return string(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    subscript(key: Key) -> Bool? {
        get { return bool(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    subscript(key: Key) -> Int? {
        get { return integer(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    subscript(key: Key) -> Double? {
        get { return double(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    subscript(key: Key) -> Float? {
        get { return float(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

    #if canImport(CoreGraphics)
    subscript(key: Key) -> CGFloat? {
        get { return cgFloat(forKey: key) }
        set {
            guard let cgValue = newValue else { return }
            let value = Float(cgValue)
            set(value, forKey: key.rawValue)
        }
    }
    #endif
    
    subscript(key: Key) -> Data? {
        get { return data(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }

}

// MARK: - Getters Methods

extension KeychainWrapper {
    
    func data(forKey key: Key) -> Data? {
        if let value = data(forKey: key.rawValue) {
            return value
        }
        return nil
    }

    func bool(forKey key: Key) -> Bool? {
        if let value = bool(forKey: key.rawValue) {
            return value
        }
        return nil
    }

    func integer(forKey key: Key) -> Int? {
        if let value = integer(forKey: key.rawValue) {
            return value
        }
        return nil
    }

    func float(forKey key: Key) -> Float? {
        if let value = float(forKey: key.rawValue) {
            return value
        }
        return nil
    }

    #if canImport(CoreGraphics)
    func cgFloat(forKey key: Key) -> CGFloat? {
        if let value = float(forKey: key) {
            return CGFloat(value)
        }
        return nil
    }
    #endif

    func double(forKey key: Key) -> Double? {
        if let value = double(forKey: key.rawValue) {
            return value
        }
        return nil
    }

    func string(forKey key: Key) -> String? {
        if let value = string(forKey: key.rawValue) {
            return value
        }
        return nil
    }
}

extension KeychainWrapper {
    
    struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {

        var rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        init(stringLiteral value: String) {
            self.rawValue = value
        }
    }
    
}
