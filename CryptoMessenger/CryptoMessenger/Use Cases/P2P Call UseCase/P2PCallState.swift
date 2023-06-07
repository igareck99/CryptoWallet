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

	// Имя звонящего
	let activeCallerName: String
	// Состояние активного звонка
	let activeCallState: P2PCallState
	// Имя звонящего на удержании
	let onHoldCallerName: String
	// Состояние звонка на удержании (поддерживаем только два входящих звонка одновременно)
	let onHoldCallState: P2PCallState
	// Тип активного звонка
	let callType: P2PCallType
	// Является ли активный звонок видеозвонком
	let isVideoCall: Bool
	// Ссылка на видеовью собеседника
	let interlocutorView: UIView?
	// Ссылка на видеовью себя
	let selfyView: UIView?
    // Id комната
    let roomId: String

    init(
        activeCallerName: String,
        activeCallState: P2PCallState,
        onHoldCallerName: String,
        onHoldCallState: P2PCallState,
        callType: P2PCallType,
        isVideoCall: Bool = false,
        interlocutorView: UIView? = nil,
        selfyView: UIView? = nil,
        roomId: String
    ) {
        self.activeCallerName = activeCallerName
        self.activeCallState = activeCallState
        self.onHoldCallerName = onHoldCallerName
        self.onHoldCallState = onHoldCallState
        self.callType = callType
        self.isVideoCall = isVideoCall
        self.interlocutorView = interlocutorView
        self.selfyView = selfyView
        self.roomId = roomId
    }
}
