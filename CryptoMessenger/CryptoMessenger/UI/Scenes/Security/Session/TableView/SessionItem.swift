import UIKit

// MARK: - SessionItem

struct SessionItem {

    // MARK: - Internal Properties

    var device: DeviceConstants
    var loginMethod: String
    var time: String
    var place: String
}

// MARK: - DeviceConstants

enum DeviceConstants: Hashable {
    case iphone
    case android
}
