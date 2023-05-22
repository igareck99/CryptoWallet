import Foundation

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

	static var changeInterlocutor: String { get }

	static var turnOnSound: String { get }

	static var turnOffSound: String { get }
    
    static var callIsHoldedImage: UIImage? { get }
    
    static var soundOnImage: UIImage? { get }
    
    static var soundOffImage: UIImage? { get }
    
    static var dynamicSoundOff: UIImage? { get }
    
    static var dynamicSoundOn: UIImage? { get }
    
    static var endCall: UIImage? { get }
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

	static var changeInterlocutor: String {
		R.string.localizable.callsChangeInterlocutor()
	}

	static var turnOnSound: String {
		R.string.localizable.callsTurnOnSound()
	}

	static var turnOffSound: String {
		R.string.localizable.callsTurnOffSound()
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
