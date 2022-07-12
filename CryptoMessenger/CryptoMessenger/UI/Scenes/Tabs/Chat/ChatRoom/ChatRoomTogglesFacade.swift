import Foundation

protocol ChatRoomTogglesFacadeProtocol {
	var isCallAvailable: Bool { get }
	var isGroupChatAvailable: Bool { get }
	var isPersonalChatAvailable: Bool { get }
}

final class ChatRoomTogglesFacade {
	private let remoteConfigUseCase: RemoteConfigFacade

	init(remoteConfigUseCase: RemoteConfigFacade) {
		self.remoteConfigUseCase = remoteConfigUseCase
	}
}

// MARK: - ChatRoomTogglesFacadeProtocol

extension ChatRoomTogglesFacade: ChatRoomTogglesFacadeProtocol {

	var isCallAvailable: Bool {
		remoteConfigUseCase.isP2PCallV1Available
	}

	var isVideoCallAvailable: Bool {
		remoteConfigUseCase.isP2PVideoCallsV1Available
	}

	var isGroupChatAvailable: Bool {
		remoteConfigUseCase.isGroupChatV1Available
	}

	var isPersonalChatAvailable: Bool {
		remoteConfigUseCase.isPersonalChatV1Available
	}
}
