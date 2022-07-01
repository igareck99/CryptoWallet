import Foundation

protocol CallViewSourcesable {

	static var incomingCall: String { get }

	static var outcomingCall: String { get }

	static var connectionIsEsatblishing: String { get }

	static var connectionIsEsatblished: String { get }

	static var youHoldedCall: String { get }

	static var otherIsHoldedCall: String { get }

	static var callIsHoldedImage: UIImage? { get }

	static var userDoesNotRespond: String { get }

	static var callFinished: String { get }
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
}
