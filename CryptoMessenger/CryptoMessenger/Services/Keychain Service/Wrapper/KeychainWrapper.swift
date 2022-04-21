import Foundation
// swiftlint:disable all
private let SecMatchLimit: String! = kSecMatchLimit as String
private let SecReturnData: String! = kSecReturnData as String
private let SecReturnPersistentRef: String! = kSecReturnPersistentRef as String
private let SecValueData: String! = kSecValueData as String
private let SecAttrAccessible: String! = kSecAttrAccessible as String
private let SecClass: String! = kSecClass as String
private let SecAttrService: String! = kSecAttrService as String
private let SecAttrGeneric: String! = kSecAttrGeneric as String
private let SecAttrAccount: String! = kSecAttrAccount as String
private let SecAttrAccessGroup: String! = kSecAttrAccessGroup as String
private let SecReturnAttributes: String = kSecReturnAttributes as String
private let SecAttrSynchronizable: String = kSecAttrSynchronizable as String

/// KeychainWrapper is a class to help make Keychain access in Swift more straightforward. It is designed to make accessing the Keychain services more like using NSUserDefaults, which is much more familiar to people.
final class KeychainWrapper {
    
    /// Default keychain wrapper access
    public static let standard = KeychainWrapper()
    
    /// ServiceName is used for the kSecAttrService property to uniquely identify this keychain accessor. If no service name is specified, KeychainWrapper will default to using the bundleIdentifier.
    private (set) public var serviceName: String
    
    /// AccessGroup is used for the kSecAttrAccessGroup property to identify which Keychain Access Group this entry belongs to. This allows you to use the KeychainWrapper with shared keychain access between different applications.
    private (set) public var accessGroup: String?
    
    private static let defaultServiceName: String = {
        return Bundle.main.bundleIdentifier ?? "SwiftKeychainWrapper"
    }()

    private convenience init() {
        self.init(serviceName: KeychainWrapper.defaultServiceName)
    }
    
    /// Create a custom instance of KeychainWrapper with a custom Service Name and optional custom access group.
    ///
    /// - parameter serviceName: The ServiceName for this instance. Used to uniquely identify all keys stored using this keychain wrapper instance.
    /// - parameter accessGroup: Optional unique AccessGroup for this instance. Use a matching AccessGroup between applications to allow shared keychain access.
    public init(serviceName: String, accessGroup: String? = nil) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }

    // MARK:- Public Methods
    
    /// Checks if keychain data exists for a specified key.
    ///
    /// - parameter forKey: The key to check for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: True if a value exists for the key. False otherwise.
    func hasValue(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        if let _ = data(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable) {
            return true
        } else {
            return false
        }
    }
    
    func accessibilityOfKey(_ key: String) -> KeychainItemAccessibility? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key)

        // Remove accessibility attribute
        keychainQueryDictionary.removeValue(forKey: SecAttrAccessible)
        
        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne

        // Specify we want SecAttrAccessible returned
        keychainQueryDictionary[SecReturnAttributes] = kCFBooleanTrue

        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)

        guard status == noErr, let resultsDictionary = result as? [String:AnyObject], let accessibilityAttrValue = resultsDictionary[SecAttrAccessible] as? String else {
            return nil
        }
    
        return KeychainItemAccessibility.accessibilityForAttributeValue(accessibilityAttrValue as CFString)
    }

    /// Get the keys of all keychain entries matching the current ServiceName and AccessGroup if one is set.
    func allKeys() -> Set<String> {
        var keychainQueryDictionary: [String:Any] = [
            SecClass: kSecClassGenericPassword,
            SecAttrService: serviceName,
            SecReturnAttributes: kCFBooleanTrue!,
            SecMatchLimit: kSecMatchLimitAll,
        ]

        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        }

        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)

        guard status == errSecSuccess else { return [] }

        var keys = Set<String>()
        if let results = result as? [[AnyHashable: Any]] {
            for attributes in results {
                if let accountData = attributes[SecAttrAccount] as? Data,
                    let key = String(data: accountData, encoding: String.Encoding.utf8) {
                    keys.insert(key)
                } else if let accountData = attributes[kSecAttrAccount] as? Data,
                    let key = String(data: accountData, encoding: String.Encoding.utf8) {
                    keys.insert(key)
                }
            }
        }
        return keys
    }
    
    // MARK: Public Getters
    
    func integer(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Int? {
        guard let numberValue = object(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable) as? NSNumber else {
            return nil
        }
        
        return numberValue.intValue
    }
    
    func float(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Float? {
        guard let numberValue = object(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable) as? NSNumber else {
            return nil
        }
        
        return numberValue.floatValue
    }
    
    func double(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Double? {
        guard let numberValue = object(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable) as? NSNumber else {
            return nil
        }
        
        return numberValue.doubleValue
    }
    
    func bool(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool? {
        guard let numberValue = object(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable) as? NSNumber else {
            return nil
        }
        
        return numberValue.boolValue
    }
    
    /// Returns a string value for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: The String associated with the key if it exists. If no data exists, or the data found cannot be encoded as a string, returns nil.
    func string(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> String? {
        guard let keychainData = data(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable) else {
            return nil
        }
        
        return String(data: keychainData, encoding: String.Encoding.utf8) as String?
    }
    
    /// Returns an object that conforms to NSCoding for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: The decoded object associated with the key if it exists. If no data exists, or the data found cannot be decoded, returns nil.
    func object(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> NSCoding? {
        guard
			let keychainData = data(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable),
			let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keychainData) as? NSCoding
		else { return nil }
        
		return object
    }

    
    /// Returns a Data object for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: The Data object associated with the key if it exists. If no data exists, returns nil.
    func data(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Data? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        
        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want Data/CFData returned
        keychainQueryDictionary[SecReturnData] = kCFBooleanTrue
        
        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)
        
        return status == noErr ? result as? Data : nil
    }
    
    
    /// Returns a persistent data reference object for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: The persistent data reference object associated with the key if it exists. If no data exists, returns nil.
    func dataRef(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Data? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        
        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want persistent Data/CFData reference returned
        keychainQueryDictionary[SecReturnPersistentRef] = kCFBooleanTrue
        
        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)
        
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Public Setters
    
    @discardableResult
	func set(_ value: Int, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
    }
    
    @discardableResult
	func set(_ value: Float, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
    }
    
    @discardableResult
	func set(_ value: Double, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
    }
    
    @discardableResult
	func set(_ value: Bool, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
    }

    /// Save a String value to the keychain associated with a specified key. If a String value already exists for the given key, the string will be overwritten with the new value.
    ///
    /// - parameter value: The String value to save.
    /// - parameter forKey: The key to save the String under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult
	func set(_ value: String, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        if let data = value.data(using: .utf8) {
            return set(data, forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        } else {
            return false
        }
    }

    /// Save an NSCoding compliant object to the keychain associated with a specified key. If an object already exists for the given key, the object will be overwritten with the new value.
    ///
    /// - parameter value: The NSCoding compliant object to save.
    /// - parameter forKey: The key to save the object under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult
	func set(_ value: NSCoding, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
		guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) else { return false }
        return set(data, forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
    }

    /// Save a Data object to the keychain associated with a specified key. If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - parameter value: The Data object to save.
    /// - parameter forKey: The key to save the object under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult
	func set(_ value: Data, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        var keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        
        keychainQueryDictionary[SecValueData] = value
        
		if let accessibility = accessibility?.keychainAttrValue {
            keychainQueryDictionary[SecAttrAccessible] = accessibility
        } else {
            // Assign default protection - Protect the keychain entry so it's only valid when the device is unlocked
			keychainQueryDictionary[SecAttrAccessible] = KeychainItemAccessibility.kWhenUnlocked
        }
        
        let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(value, forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        } else {
            return false
        }
    }
    
    /// Remove an object associated with a specified key. If re-using a key but with a different accessibility, first remove the previous key value using removeObjectForKey(:withAccessibility) using the same accessibilty it was saved with.
    ///
    /// - parameter forKey: The key value to remove data for.
    /// - parameter withAccessibility: Optional accessibility level to use when looking up the keychain item.
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: True if successful, false otherwise.
    @discardableResult
	func removeObject(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        let keychainQueryDictionary: [String:Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)

        // Delete
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)

        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    /// Remove all keychain data added through KeychainWrapper. This will only delete items matching the currnt ServiceName and AccessGroup if one is set.
    @discardableResult
	func removeAllKeys() -> Bool {
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: [String:Any] = [SecClass:kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[SecAttrService] = serviceName
        
        // Set the keychain access group if defined
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        }
        
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Remove all keychain data, including data not added through keychain wrapper.
    ///
    /// - Warning: This may remove custom keychain entries you did not add via SwiftKeychainWrapper.
    ///
    class func wipeKeychain() {
        deleteKeychainSecClass(kSecClassGenericPassword) // Generic password items
        deleteKeychainSecClass(kSecClassInternetPassword) // Internet password items
        deleteKeychainSecClass(kSecClassCertificate) // Certificate items
        deleteKeychainSecClass(kSecClassKey) // Cryptographic key items
        deleteKeychainSecClass(kSecClassIdentity) // Identity items
    }

    // MARK:- Private Methods
    
    /// Remove all items for a given Keychain Item Class
    ///
    ///
    @discardableResult
	private class func deleteKeychainSecClass(_ secClass: AnyObject) -> Bool {
        let query = [SecClass: secClass]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    /// Update existing data associated with a specified key name. The existing data will be overwritten by the new data.
    private func update(_ value: Data, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> Bool {
        var keychainQueryDictionary: [String:Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility, isSynchronizable: isSynchronizable)
        let updateDictionary = [SecValueData:value]
        
        // on update, only set accessibility if passed in
		if let accessibility = accessibility?.keychainAttrValue {
            keychainQueryDictionary[SecAttrAccessible] = accessibility
        }
        
        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)

        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }

    /// Setup the keychain query dictionary used to access the keychain on iOS for a specified key name. Takes into account the Service Name and Access Group if one is set.
    ///
    /// - parameter forKey: The key this query is for
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item. If none is provided, will default to .WhenUnlocked
    /// - parameter isSynchronizable: A bool that describes if the item should be synchronizable, to be synched with the iCloud. If none is provided, will default to false
    /// - returns: A dictionary with all the needed properties setup to access the keychain on iOS
    private func setupKeychainQueryDictionary(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil, isSynchronizable: Bool = false) -> [String:Any] {
        // Setup default access as generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: [String:Any] = [SecClass:kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[SecAttrService] = serviceName
        
        // Only set accessibiilty if its passed in, we don't want to default it here in case the user didn't want it set
		if let accessibility = accessibility?.keychainAttrValue {
            keychainQueryDictionary[SecAttrAccessible] = accessibility
        }
        
        // Set the keychain access group if defined
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        }
        
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = key.data(using: String.Encoding.utf8)
        
        keychainQueryDictionary[SecAttrGeneric] = encodedIdentifier
        
        keychainQueryDictionary[SecAttrAccount] = encodedIdentifier
        
        keychainQueryDictionary[SecAttrSynchronizable] = isSynchronizable ? kCFBooleanTrue : kCFBooleanFalse
        
        return keychainQueryDictionary
    }
}
