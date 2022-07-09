import Foundation

protocol KeychainServiceProtocol: AnyObject {

	// MARK: - User Credentials

	var apiAccessToken: String? { get set }
	var apiRefreshToken: String? { get set }
	var apiUserId: String? { get set }
	var apiUserMatrixId: String? { get set }
	var apiUserPhoneNumber: String? { get set }
	var apiUserPinCode: String? { get set }
	var apiUserFalsePinCode: String? { get set }
	var isApiUserAuthenticated: Bool? { get set }

	// MARK: - Getters Wrappers

	func integer(forKey key: KeychainService.Keys) -> Int?

	func float(forKey key: KeychainService.Keys) -> Float?

	func double(forKey key: KeychainService.Keys) -> Double?

	func bool(forKey key: KeychainService.Keys) -> Bool?

	func string(forKey key: KeychainService.Keys) -> String?

	func data(forKey key: KeychainService.Keys) -> Data?

	// MARK: - Setters Wrappers

	@discardableResult
	func set(_ value: Int, forKey key: KeychainService.Keys) -> Bool

	@discardableResult
	func set(_ value: Float, forKey key: KeychainService.Keys) -> Bool

	@discardableResult
	func set(_ value: Double, forKey key: KeychainService.Keys) -> Bool

	@discardableResult
	func set(_ value: Bool, forKey key: KeychainService.Keys) -> Bool

	@discardableResult
	func set(_ value: String, forKey key: KeychainService.Keys) -> Bool

	@discardableResult
	func set(_ value: Data, forKey key: KeychainService.Keys) -> Bool

	// MARK: - Updaters Wrappers

	@discardableResult
	func removeObject(forKey key: KeychainService.Keys) -> Bool

	// MARK: - Getters

	func integer(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Int?

	func float(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Float?

	func double(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Double?

	func bool(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool?

	func string(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> String?

	func data(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Data?

	// MARK: - Setters

	@discardableResult
	func set(
		_ value: Int,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	@discardableResult
	func set(
		_ value: Float,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	@discardableResult
	func set(
		_ value: Double,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	@discardableResult
	func set(
		_ value: Bool,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	@discardableResult
	func set(
		_ value: Bool?,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	@discardableResult
	func set(
		_ value: String,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	@discardableResult
	func set(
		_ value: String?,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	@discardableResult
	func set(
		_ value: Data,
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	// MARK: - Updaters

	@discardableResult
	func removeObject(
		forKey key: KeychainService.Keys,
		withAccessibility accessibility: KeychainItemAccessibility?,
		isSynchronizable: Bool
	) -> Bool

	// MARK: - Subscripts

	subscript(key: KeychainService.Keys) -> String? { get set }

	subscript(key: KeychainService.Keys) -> Bool? { get set }

	subscript(key: KeychainService.Keys) -> Int? { get set }

	subscript(key: KeychainService.Keys) -> Double? { get set }

	subscript(key: KeychainService.Keys) -> Float? { get set }

	subscript(key: KeychainService.Keys) -> Data? { get set }
}
