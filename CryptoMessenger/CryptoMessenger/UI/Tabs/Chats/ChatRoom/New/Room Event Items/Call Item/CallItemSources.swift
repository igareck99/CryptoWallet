import Foundation
import SwiftUI

protocol CallItemSourcesable {

    static var incomingCall: String { get }

    static var outcomingCall: String { get }

    static var incomingCallImage: String { get }

    static var outcomingCallImage: String { get }

    static var phoneImage: String { get }
}

enum CallItemSources: CallItemSourcesable {

    static var incomingCall: String {
        R.string.localizable.callsIncomingCall()
    }

    static var outcomingCall: String {
        R.string.localizable.callsOutcomingCall()
    }

    static var incomingCallImage: String {
        "arrow.down.left"
    }

    static var outcomingCallImage: String {
        "arrow.up.right"
    }

    static var phoneImage: String {
        "phone.circle.fill"
    }
}
