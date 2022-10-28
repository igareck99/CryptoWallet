import SwiftUI

// MARK: - ChatComponentsFactoryProtocol

// swiftlint:disable: vertical_parameter_alignment

protocol ChatComponentsFactoryProtocol {
	func makeChatEventView(event: RoomMessage, viewModel: ChatRoomViewModel) -> AnyView

	func makeChatMessageEventView(
		showFile: Binding<Bool>,
		showMap: Binding<Bool>,
		showLocationTransition: Binding<Bool>,
		activateShowCard: Binding<Bool>,
		playingAudioId: Binding<String>,
		onSelectPhoto: GenericBlock<URL?>?,
		onContactButtonAction: @escaping (String, String?, URL?) -> Void,
		onFileTapHandler: @escaping VoidBlock,
		fileSheetPresenting: @escaping (URL?) -> AnyView?,
		message: RoomMessage
	) -> AnyView
}

// MARK: - ChatComponentsFactory

struct ChatComponentsFactory {

    // MARK: - Private Properties

	private enum Constants {
		static let rejectCallKey = "m.call.reject"
		static let hangupCallKey = "m.call.hangup"

		static let reasonKey = "reason"
		static let userHangupReasonKey = "user_hangup"
		static let inviteTimeoutReasonKey = "invite_timeout"
	}

	private let sources: ChatRoomSourcesable.Type

    // MARK: - Lifecycle

	init(
		sources: ChatRoomSourcesable.Type = ChatRoomResources.self
	) {
		self.sources = sources
	}
}

// MARK: - ChatComponentsFactory(ChatComponentsFactoryProtocol)

extension ChatComponentsFactory: ChatComponentsFactoryProtocol {

    // MARK: - Internal Methods

	func makeChatEventView(
		event: RoomMessage,
		viewModel: ChatRoomViewModel
	) -> AnyView {
        let displayName: String = (event.content["displayname"] as? String) ?? ""
		if event.eventType == "im.vector.modular.widgets" {
			return AnyView(
				ChatEventView(
					text: makeTextForGroupCall(event: event),
					foregroundColor: .white
				)
				.configureOuterShadow()
				.flippedUpsideDown()
				.onTapGesture {
					viewModel.joinGroupCall(event: event)
				}
			)
		}

        if viewModel.next(event)?.fullDate != event.fullDate {
            return AnyView(ChatEventView(
                text: event.fullDate,
                backgroundColor: Palette.lightGray().suColor
            ).configureInnerOuterShadow().flippedUpsideDown())
        }

		if event.eventType.contains("m.call.hangup") ||
			event.eventType.contains("m.call.reject") {
			let eventTitle = textForCallEventReason(eventType: event.eventType, content: event.content)
			return AnyView(
				CallEventView(
					eventTitle: eventTitle,
					eventDateTime: event.shortDate,
					isFromCurrentUser: event.isCurrentUser
				) {
					debugPrint("CALL TAPPED")
					viewModel.p2pVoiceCallPublisher.send()
				}
					.flippedUpsideDown()
					.shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
			)
		}

		if event.eventType == "m.room.encryption" {
			return AnyView(
				ChatEventView(
					text: sources.chatRoomViewSelfAvatarChange,
					foregroundColor: .white
				)
				.configureOuterShadow()
				.flippedUpsideDown()
			)
		}

		if event.eventType == "m.room.avatar" {
            print("avatar")
			return AnyView(
				ChatEventView(
					text: ("Аватар комнаты изменен"),
					foregroundColor: .white
				)
				.configureOuterShadow()
				.flippedUpsideDown()
			)
		}

		guard event.eventType == "m.room.member",
			  let membership = event.content["membership"] as? String else {
			return AnyView(EmptyView())
		}

		let text: String

		switch membership {
		case "join":
            // TODO: - Пока оставляю, не знаю надо оно или нет
//			let users = viewModel.roomUsers.filter { $0.displayname == displayName }
//			let avatarUrl = event.content["avatar_url"] as? String
//			let isContainsAvatarUrl = users.contains { $0.avatarUrl == avatarUrl }
			text = "\(displayName) \(sources.chatRoomViewJoined)"
		case "leave":
			text = "\(displayName) \(sources.chatRoomViewLeftTheRoom)"
		case "invite":
			text = "\(displayName) \(sources.chatRoomViewInvited)"
		default:
			return AnyView(EmptyView())
		}
		return AnyView(
			ChatEventView(text: text, foregroundColor: .white)
				.configureOuterShadow()
				.flippedUpsideDown()
		)
	}

	private func textForCallEventReason(
		eventType: String,
		content: [String: Any]
	) -> String {

		if eventType == Constants.rejectCallKey {
			return sources.callDeclined
		}

		if eventType == Constants.hangupCallKey,
		   let reason = content[Constants.reasonKey] as? String,
		   reason == Constants.inviteTimeoutReasonKey {
			return sources.callMissed
		}
		return sources.callFinished
	}
}

// MARK: - ChatComponentsFactory

extension ChatComponentsFactory {

    // MARK: - Internal Methods

	func makeChatMessageEventView(
		showFile: Binding<Bool>,
		showMap: Binding<Bool>,
		showLocationTransition: Binding<Bool>,
		activateShowCard: Binding<Bool>,
		playingAudioId: Binding<String>,
		onSelectPhoto: GenericBlock<URL?>?,
		onContactButtonAction: @escaping (String, String?, URL?) -> Void,
		onFileTapHandler: @escaping VoidBlock,
		fileSheetPresenting: @escaping (URL?) -> AnyView?,
        message: RoomMessage
	) -> AnyView {
		switch message.type {
		case let .text(text):
			return AnyView(ChatTextView(
				isFromCurrentUser: message.isCurrentUser,
				shortDate: message.shortDate,
				text: text
			))
		case let .location(location):
			return AnyView(ChatMapView(
				date: message.shortDate,
				showMap: showMap,
				showLocationTransition: showLocationTransition,
				location: LocationData(lat: location.lat, long: location.long),
				isFromCurrentUser: message.isCurrentUser
			))
		case let .image(url):
			return AnyView(PhotoView(
				isFromCurrentUser: message.isCurrentUser,
				shortDate: message.shortDate,
				url: url) {
					onSelectPhoto?(url)
                })
        case let .contact(name, phone, url):
            return AnyView(ContactView(
                shortDate: message.shortDate,
                name: name,
                phone: phone,
                url: url,
                isFromCurrentUser: message.isCurrentUser,
                onButtonAction: { onContactButtonAction(name, phone, url) }
            ))
        case let .file(fileName, url):
            return AnyView(FileView(
                viewModel: FileViewModel(url: url),
                isFromCurrentUser: message.isCurrentUser,
                shortDate: message.shortDate,
                fileName: fileName,
                url: url,
                isShowFile: showFile,
                sheetPresenting: { fileSheetPresenting(url) },
                onTapHandler: onFileTapHandler))
        case let .audio(url):
            return AnyView(AudioView(
                messageId: message.id,
                shortDate: message.shortDate,
                audioDuration: message.audioDuration,
                isCurrentUser: message.isCurrentUser,
                isFromCurrentUser: message.isCurrentUser,
                activateShowCard: activateShowCard,
                playingAudioId: playingAudioId,
                audioViewModel: StateObject(
                    wrappedValue: AudioMessageViewModel(url: url, messageId: message.id)
                )
            ))
        case let .video(url):
            return AnyView(VideoView(isFromCurrentUser: message.isCurrentUser,
                                     shortDate: message.shortDate,
                                     viewModel: VideoViewModel(videoUrl: url, thumbnailUrl: message.videoThumbnail)))
        default:
            return AnyView(EmptyView())
		}
	}

	private func makeTextForGroupCall(event: RoomMessage) -> String {

		guard (event.content["type"] as? String) != nil,
			  (event.content["url"] as? String) != nil
		else { return sources.groupCallInactiveConference }

		return sources.groupCallActiveConference
	}

	private func makeReactionTextsItems(message: RoomMessage) -> [ReactionTextsItem] {

		let reactionTextsAndCount = message.reactions.reduce(into: [String: Int]()) { partialResult, reaction in
			if var count = partialResult[reaction.emoji] {
				count += 1
				partialResult[reaction.emoji] = count
			} else {
				partialResult[reaction.emoji] = 1
			}
		}

		let reactionTextsItems: [ReactionTextsItem] = message.reactions.compactMap { reaction in

			guard let emojiCount = reactionTextsAndCount[reaction.emoji] else { return nil }

			let emoji = ReactionTextItem(text: reaction.emoji)
			let count = ReactionTextItem(
				text: "\(emojiCount)",
				color: .cornflowerBlueApprox,
				font: .system(size: 11, weight: .medium)
			)
			let reactionTextsItem = ReactionTextsItem(texts: [emoji, count], backgroundColor: .sailApprox)
			return reactionTextsItem
		}
		return reactionTextsItems
	}
}
