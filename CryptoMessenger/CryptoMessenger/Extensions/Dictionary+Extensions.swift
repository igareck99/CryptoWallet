import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral {

	// MARK: - Subscript

	subscript(_ eventKey: MXEventEventKey) -> Value? {
		get {
			guard let key = eventKey.rawValue as? Key else { return nil }
			return self[key]
		}
		set {
			guard let key = eventKey.rawValue as? Key else { return }
			self[key] = newValue
		}
	}
    
}


extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
