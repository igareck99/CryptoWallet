import Foundation

protocol Parsable {
	static func parse<T: Codable>(data: Data, to type: T.Type) -> T?
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
}
