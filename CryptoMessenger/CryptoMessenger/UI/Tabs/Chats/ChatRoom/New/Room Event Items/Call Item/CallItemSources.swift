import Foundation
import SwiftUI

protocol CallItemSourcesable {

    static var incomingCall: String { get }

    static var outcomingCall: String { get }

    static var incomingCallImage: Image { get }
    
    static var incomingCallUnanwseredImage: Image { get }
    
    static var outcomingCallUnanwseredImage: Image { get }

    static var outcomingCallImage: Image { get }

    static var phoneImage: String { get }
}

enum CallItemSources: CallItemSourcesable {

    static var incomingCall: String {
        R.string.localizable.callsIncomingCall()
    }

    static var outcomingCall: String {
        R.string.localizable.callsOutcomingCall()
    }

    static var incomingCallImage: Image {
        R.image.chat.calls.incomeAnswered.image
    }

    static var outcomingCallImage: Image {
        R.image.chat.calls.outcomeAnswered.image
    }
    
    static var incomingCallUnanwseredImage: Image {
        R.image.chat.calls.incomeUnanswered.image
    }

    static var outcomingCallUnanwseredImage: Image {
        R.image.chat.calls.outcomeUnanswered.image
    }

    static var phoneImage: String {
        "phone.circle.fill"
    }
}
