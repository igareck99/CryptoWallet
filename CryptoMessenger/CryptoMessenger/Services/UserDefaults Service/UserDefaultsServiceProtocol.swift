import Foundation

protocol UserDefaultsServiceProtocol: AnyObject {
	// Setters
	func set(_ data: Data, forKey key: UserDefaultsService.Keys)
	func set(_ bool: Bool, forKey key: UserDefaultsService.Keys)
	func set(_ integer: Int, forKey key: UserDefaultsService.Keys)
	func set(_ string: String?, forKey key: UserDefaultsService.Keys)
	func set(_ double: Double, forKey key: UserDefaultsService.Keys)
	func set(_ float: Float, forKey key: UserDefaultsService.Keys)

	// Getters
	func data(forKey key: UserDefaultsService.Keys) -> Data?
	func bool(forKey key: UserDefaultsService.Keys) -> Bool
	func integer(forKey key: UserDefaultsService.Keys) -> Int
	func string(forKey key: UserDefaultsService.Keys) -> String?
	func double(forKey key: UserDefaultsService.Keys) -> Double?
	func float(forKey key: UserDefaultsService.Keys) -> Float?

	// Delete
	func removeObject(forKey key: UserDefaultsService.Keys)

	// Subscripts
	subscript(key: UserDefaultsService.Keys) -> String? { get set }
	subscript(key: UserDefaultsService.Keys) -> Bool? { get set }
	subscript(key: UserDefaultsService.Keys) -> Int? { get set }
	subscript(key: UserDefaultsService.Keys) -> Double? { get set }
	subscript(key: UserDefaultsService.Keys) -> Float? { get set }
	subscript(key: UserDefaultsService.Keys) -> Data? { get set }
}
