import Foundation

protocol Parsable {
	static func parse<T: Codable>(data: Data, to type: T.Type) -> T?

    static func parse<T: Codable>(dictionary: [String: Any], to type: T.Type) -> T?
}

enum Parser { }

// MARK: - Parsable

extension Parser: Parsable {
	static func parse<T: Codable>(data: Data, to type: T.Type) -> T? {
		do {
			return try JSONDecoder().decode(type.self, from: data)
		} catch {
			debugPrint("Parse error of type: \(String(describing: type)) error: \(error.localizedDescription)")
		}
		return nil
	}

    static func parse<T: Codable>(dictionary: [String: Any], to type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch {
            debugPrint("Parse error of type: \(String(describing: type)) error: \(error.localizedDescription)")
        }
        return nil
    }
}
