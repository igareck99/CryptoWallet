import Foundation

extension Bundle {

    var info: [String: Any] {
        guard let dict = infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }
    
    func object(for key: PlistKey) -> String {
        object(for: key.value)
    }

    func object(for key: String) -> String {
        // ket.value
        guard let string = object(forInfoDictionaryKey: key) as? String else {
            fatalError("\(key) not set in plist")
        }
        return string
    }
}

