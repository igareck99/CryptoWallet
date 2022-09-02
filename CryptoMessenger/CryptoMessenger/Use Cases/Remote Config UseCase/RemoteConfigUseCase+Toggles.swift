import Foundation

protocol RemoteConfigToggles {

	// Wallet
	var isWalletV1Available: Bool { get }
	var isTransactionV1Available: Bool { get }

	// Calls
	var isP2PCallV1Available: Bool { get }
	var isP2PVideoCallsV1Available: Bool { get }

	// Chats
	var isGroupChatV1Available: Bool { get }
	var isPersonalChatV1Available: Bool { get }

    // Phrase
    var isPhraseV1Available: Bool { get }
}

extension RemoteConfigUseCase: RemoteConfigToggles {

	// MARK: - Wallet

	var isWalletV1Available: Bool {
		let featureConfig = remoteConfigModule(forKey: .wallet)
		let feature = featureConfig?.features[RemoteConfigValues.Wallet.auraTab.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}

	var isTransactionV1Available: Bool {
		let featureConfig = remoteConfigModule(forKey: .wallet)
		let feature = featureConfig?.features[RemoteConfigValues.Wallet.auraTransaction.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}

	// MARK: - Calls

	var isP2PCallV1Available: Bool {
		let featureConfig = remoteConfigModule(forKey: .calls)
		let feature = featureConfig?.features[RemoteConfigValues.Calls.p2pCalls.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}
	var isP2PVideoCallsV1Available: Bool {
		let featureConfig = remoteConfigModule(forKey: .calls)
		let feature = featureConfig?.features[RemoteConfigValues.Calls.p2pVideoCalls.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}

	// MARK: - Chats

	var isGroupChatV1Available: Bool {
		let featureConfig = remoteConfigModule(forKey: .chat)
		let feature = featureConfig?.features[RemoteConfigValues.Chat.group.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}

	var isPersonalChatV1Available: Bool {
		let featureConfig = remoteConfigModule(forKey: .chat)
		let feature = featureConfig?.features[RemoteConfigValues.Chat.personal.rawValue]
		let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}

    var isPhraseV1Available: Bool {
        let featureConfig = remoteConfigModule(forKey: .phrase)
        let feature = featureConfig?.features[RemoteConfigValues.Phrase.phrase.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }
}
