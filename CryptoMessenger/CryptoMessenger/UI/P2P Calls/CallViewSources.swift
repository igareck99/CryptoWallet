import Foundation
import SwiftUI

protocol CallViewSourcesable {

	static var incomingCall: String { get }

	static var outcomingCall: String { get }

	static var connectionIsEsatblishing: String { get }

	static var connectionIsEsatblished: String { get }

	static var youHoldedCall: String { get }

	static var otherIsHoldedCall: String { get }

	static var userDoesNotRespond: String { get }

	static var callFinished: String { get }

	static var endToEndEncrypted: String { get }

	static var speaker: String { get }

	static var camera: String { get }

    static var sound: String { get }

    static var backButtonImgName: String { get }

    static var endCallImgName: String { get }

    static var answerCallImgName: String { get }

    static var videoEnabledImgName: String { get }

    static var videoDisabledImgName: String { get }

    static var speakerEnabledImgName: String { get }

    static var speakerDisabledImgName: String { get }

    static var micEnabledImgName: String { get }

    static var micDisabledImgName: String { get }
    
    static var titleColor: Color { get }
    
    static var background: Color { get }

//	static var changeInterlocutor: String { get }
//
//	static var turnOnSound: String { get }
//
//	static var turnOffSound: String { get }
//    
//    static var callIsHoldedImage: UIImage? { get }
//    
//    static var soundOnImage: UIImage? { get }
//    
//    static var soundOffImage: UIImage? { get }
//    
//    static var dynamicSoundOff: UIImage? { get }
//    
//    static var dynamicSoundOn: UIImage? { get }
//    
//    static var endCall: UIImage? { get }
}

enum CallViewSources: CallViewSourcesable {

	static var incomingCall: String {
		R.string.localizable.callsIncomingCall()
	}

	static var outcomingCall: String {
		R.string.localizable.callsOutcomingCall()
	}

	static var connectionIsEsatblishing: String {
		R.string.localizable.callsConnectionIsEsatblishing()
	}

	static var connectionIsEsatblished: String {
		R.string.localizable.callsConnectionIsEsatblished()
	}

	static var otherIsHoldedCall: String {
		R.string.localizable.callsYouAreBeingHolded()

	}

	static var youHoldedCall: String {
		R.string.localizable.callsYouAreHolding()
	}

	static var callIsHoldedImage: UIImage? {
		R.image.callList.holdCall.imageNamed
	}

	static var userDoesNotRespond: String {
		R.string.localizable.callsUserDoesNotRespond()
	}

	static var callFinished: String {
		R.string.localizable.callsCallFinished()
	}

	static var endToEndEncrypted: String {
		R.string.localizable.callsEndToEndEncrypted()
	}

	static var speaker: String {
		R.string.localizable.callsSpeaker()
	}

	static var camera: String {
		R.string.localizable.callsTurnOffSound()
	}

    static var sound: String {
        R.string.localizable.callsSound()
    }
    
    static var backButtonImgName: String {
        "chevron.left"
    }
    
    static var endCallImgName: String {
        "phone.down.fill"
    }
    
    static var answerCallImgName: String {
        "phone.fill"
    }

    static var videoEnabledImgName: String {
        "video"
    }

    static var videoDisabledImgName: String {
        "video.slash"
    }

    static var speakerEnabledImgName: String {
        "speaker.wave.2"
    }

    static var speakerDisabledImgName: String {
        "speaker.slash"
    }

    static var micEnabledImgName: String {
        "mic"
    }

    static var micDisabledImgName: String {
        "mic.slash"
    }

	static var changeInterlocutor: String {
		R.string.localizable.callsChangeInterlocutor()
	}

	static var turnOnSound: String {
		R.string.localizable.callsTurnOnSound()
	}

	static var turnOffSound: String {
		R.string.localizable.callsTurnOffSound()
	}
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var background: Color {
        .white 
    }

    static var soundOnImage: UIImage? {
        R.image.callScreen.soundOn()
    }

    static var soundOffImage: UIImage? {
        R.image.callScreen.soundOff()
    }

    static var dynamicSoundOff: UIImage? {
        R.image.callScreen.dynamicOff()
    }

    static var dynamicSoundOn: UIImage? {
        R.image.callScreen.dynamicOn()
    }

    static var endCall: UIImage? {
        R.image.callScreen.endCall()
    }
}
