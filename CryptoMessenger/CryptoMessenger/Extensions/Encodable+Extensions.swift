import Foundation

extension Encodable {
	var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        debugPrint("Encodable dictionary data: \(data)")

        if let jsonStr = String(data: data, encoding: .utf8) {
            debugPrint("Encodable dictionary string: \(jsonStr)")
        }

        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:]  }
        debugPrint("Encodable dictionary dict: \(dict)")
		return dict
	}
}
