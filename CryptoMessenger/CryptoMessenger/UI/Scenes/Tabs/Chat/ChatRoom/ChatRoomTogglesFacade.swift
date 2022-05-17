import Foundation

protocol ChatRoomTogglesFacadeProtocol {
	var isCallAvailable: Bool { get }
	var isGroupChatAvailable: Bool { get }
	var isPersonalChatAvailable: Bool { get }
}

final class ChatRoomTogglesFacade {
	private let remoteConfigUseCase: RemoteConfigUseCaseProtocol

	init(remoteConfigUseCase: RemoteConfigUseCaseProtocol) {
		self.remoteConfigUseCase = remoteConfigUseCase
	}
}

extension ChatRoomTogglesFacade: ChatRoomTogglesFacadeProtocol {
	var isCallAvailable: Bool {
		let featureConfig = remoteConfigUseCase.remoteConfigModule(forKey: .calls)
		let feature = featureConfig?.features[RemoteConfigValues.Calls.p2pCalls.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}

	var isGroupChatAvailable: Bool {
		let featureConfig = remoteConfigUseCase.remoteConfigModule(forKey: .chat)
		let feature = featureConfig?.features[RemoteConfigValues.Chat.group.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}

	var isPersonalChatAvailable: Bool {
		let featureConfig = remoteConfigUseCase.remoteConfigModule(forKey: .wallet)
		let feature = featureConfig?.features[RemoteConfigValues.Chat.personal.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}
}
