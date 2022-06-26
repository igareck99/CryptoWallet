import Foundation
import MatrixSDK

enum P2PCallState: UInt {
	case createOffer
	case ringing
	case calling
	case createAnswer
	case connecting
	case connected
	case onHold
	case remotelyOnHold
	case inviteExpired
	case ended
	case answeredElseWhere
	case none

	static func state(from state: MXCallState) -> P2PCallState {
		switch state {
		case .fledgling, .waitLocalMedia, .createOffer:
			return .createOffer
		case .inviteSent, .ringing:
			return .ringing
		case .createAnswer:
			return .createAnswer
		case .connecting:
			return .connecting
		case .connected:
			return .connected
		case .onHold:
			return .onHold
		case .remotelyOnHold:
			return .remotelyOnHold
		case .ended:
			return .ended
		case .inviteExpired:
			return .inviteExpired
		case .answeredElseWhere:
			return .answeredElseWhere
		default:
			return .none
		}
	}
}

enum P2PCallType {
	case outcoming
	case incoming
	case none
}

struct P2PCall {

	let activeCallerName: String
	let activeCallState: P2PCallState

	let onHoldCallerName: String
	let onHoldCallState: P2PCallState

	let callType: P2PCallType
}
