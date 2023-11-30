import SwiftUI

extension ViewsBaseFactory {
    @ViewBuilder
    static func makeContent(link: BaseContentLink) -> some View {
        switch link {
        case let .addSeed(coordinator):
            GeneratePhraseViewAssembly.make(coordinator: coordinator)
        case let .importKey(coordinator):
            ImportKeyViewAssembly.build(coordinator: coordinator)
        case let .showPhrase(seed,coordinator):
            WatchKeyViewAssembly.make(
                seed: seed,
                coordinator: coordinator
            )
        case let .transaction(
            filterIndex,
            tokenIndex,
            address,
            coordinator
        ):
            TransactionConfigurator.build(
                selectorFilterIndex: filterIndex,
                selectorTokenIndex: tokenIndex,
                address: address,
                coordinator: coordinator
            )
        case let .transfer(wallet, coordinator, receiverData):
            TransferConfigurator.build(
                wallet: wallet,
                coordinator: coordinator,
                receiverData: receiverData
            )
        case let .chooseReceiver(address, coordinator):
            ChooseReceiverAssembly.build(
                receiverData: address,
                coordinator: coordinator
            )
        case let .facilityApprove(transaction, coordinator):
            FacilityApproveConfigurator.build(
                transaction: transaction,
                coordinator: coordinator
            )
        case let .showTokenInfo(wallet):
            TokenInfoAssembly.build(wallet: wallet)
        case let .adressScanner(value: value):
            WalletAddressScannerAssembly.build(scannedCode: value)
        case let .chatRoom(room, coordinator):
            ChatRoomAssembly.build(
                room: room,
                coordinator: coordinator
            )
        case let .chatSettings(
            chatData,
            isLeaveChannel,
            room,
            coordinator
        ):
            ChatSettingsAssembly.build(room, coordinator)
        case let .channelSettings(
            room,
            isLeaveChannel,
            chatData,
            coordinator
        ):
            ChannelInfoAssembly.build(
                room: room,
                coordinator: coordinator,
                isLeaveChannel: isLeaveChannel,
                chatData: chatData
            )
        case let .chatMedia(room):
            ChannelMediaAssembly.build(room: room)
        case let .friendProfile(
            userId,
            roomId,
            coordinator
        ):
            FriendProfileAssembly.build(
                userId: userId,
                roomId: roomId,
                coordinator: coordinator
            )
        case let .adminList(chatData, coordinator):
            AdminsViewAssembly.build(
                chatData: chatData,
                coordinator: coordinator
            )
        case let .chatMembers(chatData, coordinator):
            MembersViewAssembly.build(
                chatData: chatData,
                coordinator: coordinator
            )
        case let .galleryPicker(
            sourceType: sourceType,
            galleryContent: galleryContent,
            onSelectImage: onSelectImage,
            onSelectVideo: onSelectVideo
        ):
            GalleryPickerAssembly.build(
                sourceType: sourceType,
                galleryContent: galleryContent,
                onSelectImage: onSelectImage,
                onSelectVideo: onSelectVideo
            )
        case let .documentPicker(
            onCancel,
            onDocumentsPicked
        ):
            DocumentPickerAssembly.build(
                onCancel: onCancel,
                onDocumentsPicked: onDocumentsPicked
            )
        case let .selectContacts(
            mode,
            chatData,
            contactsLimit,
            coordinator,
            onUsersSelected
        ):
            SelectContactAssembly.build(
                mode: mode,
                chatData: chatData,
                contactsLimit: contactsLimit,
                chatHistoryCoordinator: coordinator,
                onUsersSelected: { value in
                    onUsersSelected(value)
                }
            )
        case let .newChat(room: room, coordinator: coordinator):
            ChatViewAssembly.build(room, coordinator)
        case let .createChat(coordinator):
            ChatCreateAssembly.build(coordinator)
        case let .createContact(coordinator):
            CreateContactsAssembly.build(coordinator)
        case let .createChannel(coordinator, contacts):
            CreateChannelAssemby.make(coordinator: coordinator)
        case let .selectContact(coordinator):
            SelectContactAssembly.build(
                mode: .groupCreate,
                coordinator: coordinator,
                onUsersSelected: { _ in
                    // ???
                }
            )
        case let .createGroupChat(chatData, coordinator, contacts):
            ChatGroupAssembly.build(
                type: .groupChat,
                users: contacts,
                coordinator: coordinator
            )
        case .socialList:
            SocialListAssembly.build()
        case let .imageEditor(
            isShowing: isShowing,
            image: image,
            viewModel: viewModel
        ):
            ImageEditorAssembly.build(
                isShowing: isShowing,
                image: image,
                viewModel: viewModel
            )
        case let .profileDetail(coordinator, image):
            ProfileDetailAssembly.build(coordinator, image)
        case let .security(coordinator):
            SecurityAssembly.configuredView(coordinator)
        case let .notifications(coordinator):
            NotificationSettingsAssembly.build(coordinator)
        case .aboutApp(_):
            AboutAppAssembly.build()
        case let .pinCode(screenType):
            PinCodeAssembly.build(screenType: screenType) {}
        case let .sessions(coordinator):
            SessionAssembly.build(coordinator)
        case .blockList:
            BlockedListAssembly.build()
        case .chatHistory:
            // TODO: ?????
            EmptyView()
        }
    }
}
