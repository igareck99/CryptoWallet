import Foundation

// MARK: - LocationEvent

struct LocationEvent {

    // MARK: - Internal Properties
    let text: String = ""
    let location: LocationData
}

// MARK: - EditEvent (CustomEvent)

extension LocationEvent: CustomEvent {

    // MARK: - Internal Methods

    func encodeContent() -> [String: Any] {
        [
            "body": "" + text,
            "latitude": "\(location.lat)",
            "longitude": "\(location.long)",
            "msgtype": kMXMessageTypeLocation
        ]
    }
}
