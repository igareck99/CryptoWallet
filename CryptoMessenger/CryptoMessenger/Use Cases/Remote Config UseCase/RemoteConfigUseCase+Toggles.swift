import Foundation

// MARK: - RemoteConfigToggles

protocol RemoteConfigToggles {


	// Wallet
	var isWalletV1Available: Bool { get }
	var isTransactionV1Available: Bool { get }
	var isWalletV1NetType: Bool { get }

    // Calls
    var isP2PCallV1Available: Bool { get }
    var isP2PVideoCallsV1Available: Bool { get }
    var isGroupCallsV1Available: Bool { get }

    // Chats
    var isGroupChatV1Available: Bool { get }
    var isPersonalChatV1Available: Bool { get }

    // Phrase
    var isPhraseV1Available: Bool { get }

    // ChatMenu

    var isChatGroupMenuAvailable: Bool { get }
    var isChatDirectMenuAvailable: Bool { get }

    // ChatMenuFeatures

    var isChatMenuNotificationsAvailable: Bool { get }
    var isChatMenuSearchAvailable: Bool { get }
    var isChatMenuTranslateAvailable: Bool { get }
    var isChatMenuShareChatAvailable: Bool { get }
    var isChatMenuShareContactAvailable: Bool { get }
    var isChatMenuMediaAvailable: Bool { get }
    var isChatMenuBackgroundAvailable: Bool { get }
    var isChatMenuBlockUserAvailable: Bool { get }
    var isChatMenuClearHistoryAvailable: Bool { get }
    var isChatMenuEditAvailable: Bool { get }
    var isChatMenuUsersAvailable: Bool { get }
    var isChatMenuBlackListAvailable: Bool { get }

    // ChatMessageActions

    var isReactionsAvailable: Bool { get }

    // Files

    var isAnyFilesAvailable: Bool { get }
    var isVideoMessageAvailable: Bool { get }

    // Tech toggles

    var isRoomsTimerAvailable: Bool { get }

    // SecurityToggles

    var isPrivacyV1Available: Bool { get }

    // Notification Toggles

    var isV1NotificationMessages: Bool { get }
    var isV1NotificationGroup: Bool { get }
    var isV1NotificationSettings: Bool { get }
    var isV1NotificationsReset: Bool { get }
}

// MARK: - RemoteConfigUseCase(RemoteConfigToggles)

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

	var isWalletV1NetType: Bool {
		let featureConfig = remoteConfigModule(forKey: .wallet)
		let feature = featureConfig?.features[RemoteConfigValues.Wallet.netType.rawValue]
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

	var isGroupCallsV1Available: Bool {
		isFeatureAvailable(
			module: .calls,
			feature: RemoteConfigValues.Calls.groupCalls.rawValue,
			version: RemoteConfigValues.Version.v1_0
		)
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

    // MARK: - Chats Menu

    var isChatGroupMenuAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenu)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenu.chatGroupMenu.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatDirectMenuAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenu)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenu.chatDirectMenu.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    // MARK: - Chats Menu Features

    var isChatMenuNotificationsAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.notifications.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuSearchAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.search.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuTranslateAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.translate.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuShareChatAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.shareChat.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuShareContactAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.shareContact.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuMediaAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.media.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuBackgroundAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.background.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuBlockUserAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.blockUser.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuClearHistoryAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.clearHistory.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuEditAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.edit.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuUsersAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.users.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

    var isChatMenuBlackListAvailable: Bool {
        let featureConfig = remoteConfigModule(forKey: .chatMenuFeatures)
        let feature = featureConfig?.features[RemoteConfigValues.ChatMenuFeature.blackList.rawValue]
        let isVersionEnabled = feature?.versions[RemoteConfigValues.Version.v1_0.rawValue]
        let isFeatureEnabled = feature?.enabled
        return isVersionEnabled == true && isFeatureEnabled == true
    }

	// Tech toggles

	var isRoomsTimerAvailable: Bool {
		isFeatureAvailable(
			module: .techToggles,
			feature: RemoteConfigValues.TechToggles.chatListTimer.rawValue,
			version: RemoteConfigValues.Version.v1_0
		)
	}

    var isAnyFilesAvailable: Bool {
        return isFeatureAvailable(module: .chatMessage,
                                  feature: RemoteConfigValues.ChatMessage.files.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

    var isVideoMessageAvailable: Bool {
        return isFeatureAvailable(module: .chatMessage,
                                  feature: RemoteConfigValues.ChatMessage.videoMessage.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

    var isReactionsAvailable: Bool {
        return isFeatureAvailable(module: .chatMessageActions,
                                  feature: RemoteConfigValues.ChatMessageActions.reactions.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

    // SecurityToggles

    var isPrivacyV1Available: Bool {
        return isFeatureAvailable(module: .security,
                                  feature: RemoteConfigValues.Security.privacy.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

    // Notification Toggles

    var isV1NotificationMessages: Bool {
        return isFeatureAvailable(module: .notification,
                                  feature: RemoteConfigValues.Notification.p2pChats.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

    var isV1NotificationGroup: Bool {
        return isFeatureAvailable(module: .notification,
                                  feature: RemoteConfigValues.Notification.groupChats.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

    var isV1NotificationSettings: Bool {
        return isFeatureAvailable(module: .notification,
                                  feature: RemoteConfigValues.Notification.settings.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

    var isV1NotificationsReset: Bool {
        return isFeatureAvailable(module: .notification,
                                  feature: RemoteConfigValues.Notification.resetSettings.rawValue,
                                  version: RemoteConfigValues.Version.v1_0)
    }

	// MARK: - Private

	private func isFeatureAvailable(
		module: RemoteConfigValues,
		feature: String,
		version: RemoteConfigValues.Version
	) -> Bool {
		let featureConfig = remoteConfigModule(forKey: module)
		let feature = featureConfig?.features[feature]
		let isVersionEnabled = feature?.versions[version.rawValue]
		let isFeatureEnabled = feature?.enabled
		return isVersionEnabled == true && isFeatureEnabled == true
	}
}
