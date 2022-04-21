import Foundation
// swiftlint:disable all
protocol KeychainAttrRepresentable {
    var keychainAttrValue: CFString? { get }
}

// MARK: - KeychainItemAccessibility
enum KeychainItemAccessibility {
    /**
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
    */
    @available(iOS 4, *)
    case afterFirstUnlock
    
    /**
     The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
     
     After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, *)
    case afterFirstUnlockThisDeviceOnly
    
    /**
     The data in the keychain item can always be accessed regardless of whether the device is locked.
     
     This is not recommended for application use. Items with this attribute migrate to a new device when using encrypted backups.
     */
    @available(iOS 4, *)
    case always
    
    /**
     The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
     
     This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
     */
    @available(iOS 8, *)
    case whenPasscodeSetThisDeviceOnly
    
    /**
     The data in the keychain item can always be accessed regardless of whether the device is locked.
     
     This is not recommended for application use. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, *)
    case alwaysThisDeviceOnly
    
    /**
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
     
     This is the default value for keychain items added without explicitly setting an accessibility constant.
     */
    @available(iOS 4, *)
    case whenUnlocked
    
    /**
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     */
    @available(iOS 4, *)
    case whenUnlockedThisDeviceOnly
    
    static func accessibilityForAttributeValue(_ keychainAttrValue: CFString) -> KeychainItemAccessibility? {
        for (key, value) in keychainItemAccessibilityLookup {
            if value == keychainAttrValue {
                return key
            }
        }
        
        return nil
    }

	static let kAfterFirstUnlock: CFString = kSecAttrAccessibleAfterFirstUnlock
	static let kAfterFirstUnlockThisDeviceOnly: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
	static let kAlways: CFString = kSecAttrAccessibleAfterFirstUnlock
	static let kAlwaysThisDeviceOnly: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
	static let kWhenUnlocked: CFString = kSecAttrAccessibleWhenUnlocked
	static let kWhenUnlockedThisDeviceOnly: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
	static let kWhenPasscodeSetThisDeviceOnly: CFString = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
}

private let keychainItemAccessibilityLookup: [KeychainItemAccessibility: CFString] = {
    var lookup: [KeychainItemAccessibility: CFString] = [
        .afterFirstUnlock: 					kSecAttrAccessibleAfterFirstUnlock,
        .afterFirstUnlockThisDeviceOnly: 	kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
        .always: 							kSecAttrAccessibleAfterFirstUnlock,
		.alwaysThisDeviceOnly: 				kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
        .whenUnlocked: 						kSecAttrAccessibleWhenUnlocked,
        .whenUnlockedThisDeviceOnly: 		kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
		.whenPasscodeSetThisDeviceOnly: 	kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
    ]

    return lookup
}()

extension KeychainItemAccessibility: KeychainAttrRepresentable {
    var keychainAttrValue: CFString? {
        keychainItemAccessibilityLookup[self]
    }
}
