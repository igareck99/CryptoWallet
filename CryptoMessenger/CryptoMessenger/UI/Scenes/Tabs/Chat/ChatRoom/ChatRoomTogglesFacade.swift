import Foundation

protocol ChatRoomTogglesFacadeProtocol {
	var isCallAvailable: Bool { get }
	var isVideoCallAvailable: Bool { get }
	var isGroupChatAvailable: Bool { get }
	var isPersonalChatAvailable: Bool { get }
    var isChatGroupMenuAvailable: Bool { get }
    var isChatDirectMenuAvailable: Bool { get }
	var isGroupCallsAvailable: Bool { get }
    var isAnyFilesAvailable: Bool { get }
    var isVideoMessageAvailable: Bool { get }
    var isReactionsAvailable: Bool { get }
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

    var isChatGroupMenuAvailable: Bool {
        remoteConfigUseCase.isChatGroupMenuAvailable
    }
    
    var isChatDirectMenuAvailable: Bool {
        remoteConfigUseCase.isChatDirectMenuAvailable
    }

	var isGroupCallsAvailable: Bool {
		remoteConfigUseCase.isGroupCallsV1Available
	}

    var isAnyFilesAvailable: Bool {
        remoteConfigUseCase.isAnyFilesAvailable
    }

    var isVideoMessageAvailable: Bool {
        remoteConfigUseCase.isVideoMessageAvailable
    }

    var isReactionsAvailable: Bool {
        remoteConfigUseCase.isReactionsAvailable
    }
}
