import Foundation
import MatrixSDK

// MARK: - LocationEvent

struct LocationEvent {

    // MARK: - Internal Properties
    let text: String = ""
    let location: Location
}

// MARK: - EditEvent (CustomEvent)

extension LocationEvent: CustomEvent {

    // MARK: - Internal Methods

    func encodeContent() throws -> [String: Any] {
        [
            "body": "" + text,
            "latitude": "\(location.lat)",
            "longitude": "\(location.long)",
            "msgtype": kMXMessageTypeLocation
        ]
    }
}
